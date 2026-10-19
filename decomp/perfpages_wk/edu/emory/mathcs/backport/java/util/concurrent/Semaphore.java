/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.FIFOWaitQueue;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.WaitQueue;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.Collection;

public class Semaphore
implements Serializable {
    private static final long serialVersionUID = -3222578661600680210L;
    private final Sync sync;

    public Semaphore(int n2) {
        this.sync = new NonfairSync(n2);
    }

    public Semaphore(int n2, boolean bl2) {
        this.sync = bl2 ? new FairSync(n2) : new NonfairSync(n2);
    }

    public void acquire() throws InterruptedException {
        this.sync.acquire(1);
    }

    public void acquireUninterruptibly() {
        this.sync.acquireUninterruptibly(1);
    }

    public boolean tryAcquire() {
        return this.sync.attempt(1);
    }

    public boolean tryAcquire(long l2, TimeUnit timeUnit) throws InterruptedException {
        return this.sync.attempt(1, timeUnit.toNanos(l2));
    }

    public void release() {
        this.sync.release(1);
    }

    public void acquire(int n2) throws InterruptedException {
        if (n2 < 0) {
            throw new IllegalArgumentException();
        }
        this.sync.acquire(n2);
    }

    public void acquireUninterruptibly(int n2) {
        this.sync.acquireUninterruptibly(n2);
    }

    public boolean tryAcquire(int n2) {
        if (n2 < 0) {
            throw new IllegalArgumentException();
        }
        return this.sync.attempt(n2);
    }

    public boolean tryAcquire(int n2, long l2, TimeUnit timeUnit) throws InterruptedException {
        if (n2 < 0) {
            throw new IllegalArgumentException();
        }
        return this.sync.attempt(n2, timeUnit.toNanos(l2));
    }

    public void release(int n2) {
        if (n2 < 0) {
            throw new IllegalArgumentException();
        }
        this.sync.release(n2);
    }

    public int availablePermits() {
        return this.sync.getPermits();
    }

    public int drainPermits() {
        return this.sync.drain();
    }

    protected void reducePermits(int n2) {
        if (n2 < 0) {
            throw new IllegalArgumentException();
        }
        this.sync.reduce(n2);
    }

    public boolean isFair() {
        return this.sync instanceof FairSync;
    }

    public final boolean hasQueuedThreads() {
        return this.sync.hasQueuedThreads();
    }

    public final int getQueueLength() {
        return this.sync.getQueueLength();
    }

    protected Collection getQueuedThreads() {
        return this.sync.getQueuedThreads();
    }

    public String toString() {
        return super.toString() + "[Permits = " + this.sync.getPermits() + "]";
    }

    static final class FairSync
    extends Sync
    implements WaitQueue.QueuedSync {
        private static final long serialVersionUID = 2014338818796000944L;
        private transient WaitQueue wq_ = new FIFOWaitQueue();

        FairSync(int n2) {
            super(n2);
        }

        @Override
        public void acquireUninterruptibly(int n2) {
            if (this.precheck(n2)) {
                return;
            }
            Node node = new Node(n2);
            node.doWaitUninterruptibly(this);
        }

        @Override
        public void acquire(int n2) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            if (this.precheck(n2)) {
                return;
            }
            Node node = new Node(n2);
            node.doWait(this);
        }

        @Override
        public boolean attempt(int n2, long l2) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            if (this.precheck(n2)) {
                return true;
            }
            if (l2 <= 0L) {
                return false;
            }
            Node node = new Node(n2);
            return node.doTimedWait(this, l2);
        }

        protected synchronized boolean precheck(int n2) {
            boolean bl2;
            boolean bl3 = bl2 = this.permits_ >= n2;
            if (bl2) {
                this.permits_ -= n2;
            }
            return bl2;
        }

        @Override
        public synchronized boolean recheck(WaitQueue.WaitNode waitNode) {
            boolean bl2;
            Node node = (Node)waitNode;
            boolean bl3 = bl2 = this.permits_ >= node.requests;
            if (bl2) {
                this.permits_ -= node.requests;
            } else {
                this.wq_.insert(waitNode);
            }
            return bl2;
        }

        @Override
        public void takeOver(WaitQueue.WaitNode waitNode) {
        }

        protected synchronized Node getSignallee(int n2) {
            Node node = (Node)this.wq_.extract();
            this.permits_ += n2;
            if (node == null) {
                return null;
            }
            if (node.requests > this.permits_) {
                this.wq_.putBack(node);
                return null;
            }
            this.permits_ -= node.requests;
            return node;
        }

        @Override
        public void release(int n2) {
            if (n2 < 0) {
                throw new IllegalArgumentException("Negative argument");
            }
            Node node;
            while ((node = this.getSignallee(n2)) != null) {
                if (node.signal(this)) {
                    return;
                }
                n2 = node.requests;
            }
            return;
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

        static final class Node
        extends WaitQueue.WaitNode {
            final int requests;

            Node(int n2) {
                this.requests = n2;
            }
        }
    }

    static final class NonfairSync
    extends Sync {
        private static final long serialVersionUID = -2694183684443567898L;

        protected NonfairSync(int n2) {
            super(n2);
        }

        private static void checkAgainstMultiacquire(int n2) {
            if (n2 != 1) {
                throw new UnsupportedOperationException("Atomic multi-acquire supported only in FAIR semaphores");
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void acquireUninterruptibly(int n2) {
            if (n2 == 0) {
                return;
            }
            NonfairSync.checkAgainstMultiacquire(n2);
            NonfairSync nonfairSync = this;
            synchronized (nonfairSync) {
                if (this.permits_ > 0) {
                    --this.permits_;
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
                    } while (this.permits_ <= 0);
                    --this.permits_;
                    return;
                }
                finally {
                    if (bl2) {
                        Thread.currentThread().interrupt();
                    }
                }
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void acquire(int n2) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            if (n2 == 0) {
                return;
            }
            NonfairSync.checkAgainstMultiacquire(n2);
            NonfairSync nonfairSync = this;
            synchronized (nonfairSync) {
                while (this.permits_ <= 0) {
                    try {
                        this.wait();
                    }
                    catch (InterruptedException interruptedException) {
                        this.notify();
                        throw interruptedException;
                    }
                }
                --this.permits_;
            }
        }

        @Override
        public boolean attempt(int n2, long l2) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            if (n2 == 0) {
                return true;
            }
            NonfairSync.checkAgainstMultiacquire(n2);
            NonfairSync nonfairSync = this;
            synchronized (nonfairSync) {
                if (this.permits_ > 0) {
                    --this.permits_;
                    return true;
                }
                if (l2 <= 0L) {
                    return false;
                }
                try {
                    long l3 = Utils.nanoTime() + l2;
                    do {
                        TimeUnit.NANOSECONDS.timedWait(this, l2);
                        if (this.permits_ <= 0) continue;
                        --this.permits_;
                        return true;
                    } while ((l2 = l3 - Utils.nanoTime()) > 0L);
                    return false;
                }
                catch (InterruptedException interruptedException) {
                    this.notify();
                    throw interruptedException;
                }
            }
        }

        @Override
        public synchronized void release(int n2) {
            if (n2 < 0) {
                throw new IllegalArgumentException("Negative argument");
            }
            this.permits_ += n2;
            for (int i2 = 0; i2 < n2; ++i2) {
                this.notify();
            }
        }

        @Override
        public boolean hasQueuedThreads() {
            throw new UnsupportedOperationException("Use FAIR version");
        }

        @Override
        public int getQueueLength() {
            throw new UnsupportedOperationException("Use FAIR version");
        }

        @Override
        public Collection getQueuedThreads() {
            throw new UnsupportedOperationException("Use FAIR version");
        }
    }

    static abstract class Sync
    implements Serializable {
        private static final long serialVersionUID = 1192457210091910933L;
        int permits_;

        protected Sync(int n2) {
            this.permits_ = n2;
        }

        abstract void acquireUninterruptibly(int var1);

        abstract void acquire(int var1) throws InterruptedException;

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public boolean attempt(int n2) {
            Sync sync = this;
            synchronized (sync) {
                if (this.permits_ >= n2) {
                    this.permits_ -= n2;
                    return true;
                }
                return false;
            }
        }

        abstract boolean attempt(int var1, long var2) throws InterruptedException;

        abstract void release(int var1);

        public synchronized int getPermits() {
            return this.permits_;
        }

        public synchronized int drain() {
            int n2 = this.permits_;
            this.permits_ = 0;
            return n2;
        }

        public synchronized void reduce(int n2) {
            this.permits_ -= n2;
        }

        abstract boolean hasQueuedThreads();

        abstract int getQueueLength();

        abstract Collection getQueuedThreads();
    }
}

