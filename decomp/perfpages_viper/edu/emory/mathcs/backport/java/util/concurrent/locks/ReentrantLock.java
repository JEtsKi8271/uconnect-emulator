/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.locks;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.FIFOWaitQueue;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.WaitQueue;
import edu.emory.mathcs.backport.java.util.concurrent.locks.CondVar;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import edu.emory.mathcs.backport.java.util.concurrent.locks.FIFOCondVar;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Lock;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.Collection;

public class ReentrantLock
implements Lock,
Serializable,
CondVar.ExclusiveLock {
    private static final long serialVersionUID = 7373984872572414699L;
    private final Sync sync;

    public ReentrantLock() {
        this.sync = new NonfairSync();
    }

    public ReentrantLock(boolean bl2) {
        this.sync = bl2 ? new FairSync() : new NonfairSync();
    }

    @Override
    public void lock() {
        this.sync.lock();
    }

    @Override
    public void lockInterruptibly() throws InterruptedException {
        this.sync.lockInterruptibly();
    }

    @Override
    public boolean tryLock() {
        return this.sync.tryLock();
    }

    @Override
    public boolean tryLock(long l2, TimeUnit timeUnit) throws InterruptedException {
        return this.sync.tryLock(timeUnit.toNanos(l2));
    }

    @Override
    public void unlock() {
        this.sync.unlock();
    }

    @Override
    public Condition newCondition() {
        return this.isFair() ? new FIFOCondVar(this) : new CondVar(this);
    }

    @Override
    public int getHoldCount() {
        return this.sync.getHoldCount();
    }

    @Override
    public boolean isHeldByCurrentThread() {
        return this.sync.isHeldByCurrentThread();
    }

    public boolean isLocked() {
        return this.sync.isLocked();
    }

    public final boolean isFair() {
        return this.sync.isFair();
    }

    protected Thread getOwner() {
        return this.sync.getOwner();
    }

    public final boolean hasQueuedThreads() {
        return this.sync.hasQueuedThreads();
    }

    public final boolean hasQueuedThread(Thread thread) {
        return this.sync.isQueued(thread);
    }

    public final int getQueueLength() {
        return this.sync.getQueueLength();
    }

    protected Collection getQueuedThreads() {
        return this.sync.getQueuedThreads();
    }

    public boolean hasWaiters(Condition condition) {
        return this.asCondVar(condition).hasWaiters();
    }

    public int getWaitQueueLength(Condition condition) {
        return this.asCondVar(condition).getWaitQueueLength();
    }

    protected Collection getWaitingThreads(Condition condition) {
        return this.asCondVar(condition).getWaitingThreads();
    }

    public String toString() {
        Thread thread = this.getOwner();
        return super.toString() + (thread == null ? "[Unlocked]" : "[Locked by thread " + thread.getName() + "]");
    }

    private CondVar asCondVar(Condition condition) {
        if (condition == null) {
            throw new NullPointerException();
        }
        if (!(condition instanceof CondVar)) {
            throw new IllegalArgumentException("not owner");
        }
        CondVar condVar = (CondVar)condition;
        if (condVar.lock != this) {
            throw new IllegalArgumentException("not owner");
        }
        return condVar;
    }

    static final class FairSync
    extends Sync
    implements WaitQueue.QueuedSync {
        private static final long serialVersionUID = -3000897897090466540L;
        private transient WaitQueue wq_ = new FIFOWaitQueue();

        FairSync() {
        }

        @Override
        public synchronized boolean recheck(WaitQueue.WaitNode waitNode) {
            Thread thread = Thread.currentThread();
            if (this.owner_ == null) {
                this.owner_ = thread;
                this.holds_ = 1;
                return true;
            }
            if (thread == this.owner_) {
                this.incHolds();
                return true;
            }
            this.wq_.insert(waitNode);
            return false;
        }

        @Override
        public synchronized void takeOver(WaitQueue.WaitNode waitNode) {
            this.owner_ = waitNode.getOwner();
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void lock() {
            Thread thread = Thread.currentThread();
            Object object = this;
            synchronized (object) {
                if (this.owner_ == null) {
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return;
                }
                if (thread == this.owner_) {
                    this.incHolds();
                    return;
                }
            }
            object = new WaitQueue.WaitNode();
            ((WaitQueue.WaitNode)object).doWaitUninterruptibly(this);
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void lockInterruptibly() throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            Thread thread = Thread.currentThread();
            Object object = this;
            synchronized (object) {
                if (this.owner_ == null) {
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return;
                }
                if (thread == this.owner_) {
                    this.incHolds();
                    return;
                }
            }
            object = new WaitQueue.WaitNode();
            ((WaitQueue.WaitNode)object).doWait(this);
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean tryLock(long l2) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            Thread thread = Thread.currentThread();
            Object object = this;
            synchronized (object) {
                if (this.owner_ == null) {
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return true;
                }
                if (thread == this.owner_) {
                    this.incHolds();
                    return true;
                }
            }
            object = new WaitQueue.WaitNode();
            return ((WaitQueue.WaitNode)object).doTimedWait(this, l2);
        }

        protected synchronized WaitQueue.WaitNode getSignallee(Thread thread) {
            if (thread != this.owner_) {
                throw new IllegalMonitorStateException("Not owner");
            }
            if (this.holds_ >= 2) {
                --this.holds_;
                return null;
            }
            WaitQueue.WaitNode waitNode = this.wq_.extract();
            if (waitNode == null) {
                this.owner_ = null;
                this.holds_ = 0;
            }
            return waitNode;
        }

        @Override
        public void unlock() {
            WaitQueue.WaitNode waitNode;
            Thread thread = Thread.currentThread();
            do {
                if ((waitNode = this.getSignallee(thread)) != null) continue;
                return;
            } while (!waitNode.signal(this));
        }

        @Override
        public final boolean isFair() {
            return true;
        }

        @Override
        public synchronized boolean hasQueuedThreads() {
            return this.wq_.hasNodes();
        }

        @Override
        public synchronized int getQueueLength() {
            return this.wq_.getLength();
        }

        @Override
        public synchronized Collection getQueuedThreads() {
            return this.wq_.getWaitingThreads();
        }

        @Override
        public synchronized boolean isQueued(Thread thread) {
            return this.wq_.isWaiting(thread);
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
            objectInputStream.defaultReadObject();
            FairSync fairSync = this;
            synchronized (fairSync) {
                this.wq_ = new FIFOWaitQueue();
            }
        }
    }

    static final class NonfairSync
    extends Sync {
        private static final long serialVersionUID = 7316153563782823691L;

        NonfairSync() {
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void lock() {
            Thread thread = Thread.currentThread();
            NonfairSync nonfairSync = this;
            synchronized (nonfairSync) {
                if (this.owner_ == null) {
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return;
                }
                if (thread == this.owner_) {
                    this.incHolds();
                    return;
                }
                boolean bl2 = Thread.interrupted();
                try {
                    do {
                        try {
                            this.wait();
                        }
                        catch (InterruptedException interruptedException) {
                            bl2 = true;
                        }
                    } while (this.owner_ != null);
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return;
                }
                finally {
                    if (bl2) {
                        Thread.currentThread().interrupt();
                    }
                }
            }
        }

        @Override
        public void lockInterruptibly() throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            Thread thread = Thread.currentThread();
            NonfairSync nonfairSync = this;
            synchronized (nonfairSync) {
                if (this.owner_ == null) {
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return;
                }
                if (thread == this.owner_) {
                    this.incHolds();
                    return;
                }
                try {
                    do {
                        this.wait();
                    } while (this.owner_ != null);
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return;
                }
                catch (InterruptedException interruptedException) {
                    if (this.owner_ == null) {
                        this.notify();
                    }
                    throw interruptedException;
                }
            }
        }

        @Override
        public boolean tryLock(long l2) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            Thread thread = Thread.currentThread();
            NonfairSync nonfairSync = this;
            synchronized (nonfairSync) {
                if (this.owner_ == null) {
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return true;
                }
                if (thread == this.owner_) {
                    this.incHolds();
                    return true;
                }
                if (l2 <= 0L) {
                    return false;
                }
                long l3 = Utils.nanoTime() + l2;
                try {
                    do {
                        TimeUnit.NANOSECONDS.timedWait(this, l2);
                        if (thread == this.owner_) {
                            this.incHolds();
                            return true;
                        }
                        if (this.owner_ != null) continue;
                        this.owner_ = thread;
                        this.holds_ = 1;
                        return true;
                    } while ((l2 = l3 - Utils.nanoTime()) > 0L);
                    return false;
                }
                catch (InterruptedException interruptedException) {
                    if (this.owner_ == null) {
                        this.notify();
                    }
                    throw interruptedException;
                }
            }
        }

        @Override
        public synchronized void unlock() {
            if (Thread.currentThread() != this.owner_) {
                throw new IllegalMonitorStateException("Not owner");
            }
            if (--this.holds_ == 0) {
                this.owner_ = null;
                this.notify();
            }
        }

        @Override
        public final boolean isFair() {
            return false;
        }
    }

    static abstract class Sync
    implements Serializable {
        private static final long serialVersionUID = -5179523762034025860L;
        protected transient Thread owner_ = null;
        protected transient int holds_ = 0;

        protected Sync() {
        }

        public abstract void lock();

        public abstract void lockInterruptibly() throws InterruptedException;

        final void incHolds() {
            int n2;
            if ((n2 = ++this.holds_) < 0) {
                throw new Error("Maximum lock count exceeded");
            }
            this.holds_ = n2;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public boolean tryLock() {
            Thread thread = Thread.currentThread();
            Sync sync = this;
            synchronized (sync) {
                if (this.owner_ == null) {
                    this.owner_ = thread;
                    this.holds_ = 1;
                    return true;
                }
                if (thread == this.owner_) {
                    this.incHolds();
                    return true;
                }
            }
            return false;
        }

        public abstract boolean tryLock(long var1) throws InterruptedException;

        public abstract void unlock();

        public synchronized int getHoldCount() {
            return this.isHeldByCurrentThread() ? this.holds_ : 0;
        }

        public synchronized boolean isHeldByCurrentThread() {
            return this.holds_ > 0 && Thread.currentThread() == this.owner_;
        }

        public synchronized boolean isLocked() {
            return this.owner_ != null;
        }

        public abstract boolean isFair();

        protected synchronized Thread getOwner() {
            return this.owner_;
        }

        public boolean hasQueuedThreads() {
            throw new UnsupportedOperationException("Use FAIR version");
        }

        public int getQueueLength() {
            throw new UnsupportedOperationException("Use FAIR version");
        }

        public Collection getQueuedThreads() {
            throw new UnsupportedOperationException("Use FAIR version");
        }

        public boolean isQueued(Thread thread) {
            throw new UnsupportedOperationException("Use FAIR version");
        }
    }
}

