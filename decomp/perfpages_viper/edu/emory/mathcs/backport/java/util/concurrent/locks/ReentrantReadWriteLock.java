/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.locks;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.locks.CondVar;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Lock;
import edu.emory.mathcs.backport.java.util.concurrent.locks.ReadWriteLock;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.HashMap;

public class ReentrantReadWriteLock
implements ReadWriteLock,
Serializable {
    private static final long serialVersionUID = -3463448656717690166L;
    final ReadLock readerLock_ = new ReadLock(this);
    final WriteLock writerLock_ = new WriteLock(this);
    final Sync sync = new NonfairSync();

    @Override
    public Lock writeLock() {
        return this.writerLock_;
    }

    @Override
    public Lock readLock() {
        return this.readerLock_;
    }

    public final boolean isFair() {
        return false;
    }

    protected Thread getOwner() {
        return this.sync.getOwner();
    }

    public int getReadLockCount() {
        return this.sync.getReadLockCount();
    }

    public boolean isWriteLocked() {
        return this.sync.isWriteLocked();
    }

    public boolean isWriteLockedByCurrentThread() {
        return this.sync.isWriteLockedByCurrentThread();
    }

    public int getWriteHoldCount() {
        return this.sync.getWriteHoldCount();
    }

    public int getReadHoldCount() {
        return this.sync.getReadHoldCount();
    }

    public final boolean hasQueuedThreads() {
        return this.sync.hasQueuedThreads();
    }

    public final int getQueueLength() {
        return this.sync.getQueueLength();
    }

    public String toString() {
        return super.toString() + "[Write locks = " + this.getWriteHoldCount() + ", Read locks = " + this.getReadLockCount() + "]";
    }

    public static class WriteLock
    implements Lock,
    CondVar.ExclusiveLock,
    Serializable {
        private static final long serialVersionUID = -4992448646407690164L;
        final ReentrantReadWriteLock lock;

        protected WriteLock(ReentrantReadWriteLock reentrantReadWriteLock) {
            if (reentrantReadWriteLock == null) {
                throw new NullPointerException();
            }
            this.lock = reentrantReadWriteLock;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void lock() {
            WriteLock writeLock = this;
            synchronized (writeLock) {
                if (this.lock.sync.startWriteFromNewWriter()) {
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
                    } while (!this.lock.sync.startWriteFromWaitingWriter());
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
        public void lockInterruptibly() throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            InterruptedException interruptedException = null;
            WriteLock writeLock = this;
            synchronized (writeLock) {
                if (!this.lock.sync.startWriteFromNewWriter()) {
                    try {
                        do {
                            this.wait();
                        } while (!this.lock.sync.startWriteFromWaitingWriter());
                        return;
                    }
                    catch (InterruptedException interruptedException2) {
                        this.lock.sync.cancelledWaitingWriter();
                        this.notify();
                        interruptedException = interruptedException2;
                    }
                }
            }
            if (interruptedException != null) {
                this.lock.readerLock_.signalWaiters();
                throw interruptedException;
            }
        }

        @Override
        public boolean tryLock() {
            return this.lock.sync.startWrite();
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean tryLock(long l2, TimeUnit timeUnit) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            InterruptedException interruptedException = null;
            long l3 = timeUnit.toNanos(l2);
            WriteLock writeLock = this;
            synchronized (writeLock) {
                block10: {
                    if (l3 <= 0L) {
                        return this.lock.sync.startWrite();
                    }
                    if (this.lock.sync.startWriteFromNewWriter()) {
                        return true;
                    }
                    long l4 = Utils.nanoTime() + l3;
                    do {
                        try {
                            TimeUnit.NANOSECONDS.timedWait(this, l3);
                        }
                        catch (InterruptedException interruptedException2) {
                            this.lock.sync.cancelledWaitingWriter();
                            this.notify();
                            interruptedException = interruptedException2;
                            break block10;
                        }
                        if (!this.lock.sync.startWriteFromWaitingWriter()) continue;
                        return true;
                    } while ((l3 = l4 - Utils.nanoTime()) > 0L);
                    this.lock.sync.cancelledWaitingWriter();
                    this.notify();
                }
            }
            this.lock.readerLock_.signalWaiters();
            if (interruptedException != null) {
                throw interruptedException;
            }
            return false;
        }

        @Override
        public void unlock() {
            switch (this.lock.sync.endWrite()) {
                case 0: {
                    return;
                }
                case 1: {
                    this.lock.readerLock_.signalWaiters();
                    return;
                }
                case 2: {
                    this.lock.writerLock_.signalWaiters();
                    return;
                }
            }
        }

        @Override
        public Condition newCondition() {
            return new CondVar(this);
        }

        synchronized void signalWaiters() {
            this.notify();
        }

        public String toString() {
            Thread thread = this.lock.getOwner();
            return super.toString() + (thread == null ? "[Unlocked]" : "[Locked by thread " + thread.getName() + "]");
        }

        @Override
        public boolean isHeldByCurrentThread() {
            return this.lock.sync.isWriteLockedByCurrentThread();
        }

        @Override
        public int getHoldCount() {
            return this.lock.sync.getWriteHoldCount();
        }
    }

    public static class ReadLock
    implements Lock,
    Serializable {
        private static final long serialVersionUID = -5992448646407690164L;
        final ReentrantReadWriteLock lock;

        protected ReadLock(ReentrantReadWriteLock reentrantReadWriteLock) {
            if (reentrantReadWriteLock == null) {
                throw new NullPointerException();
            }
            this.lock = reentrantReadWriteLock;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void lock() {
            ReadLock readLock = this;
            synchronized (readLock) {
                if (this.lock.sync.startReadFromNewReader()) {
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
                    } while (!this.lock.sync.startReadFromWaitingReader());
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
        public void lockInterruptibly() throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            InterruptedException interruptedException = null;
            ReadLock readLock = this;
            synchronized (readLock) {
                if (!this.lock.sync.startReadFromNewReader()) {
                    try {
                        do {
                            this.wait();
                        } while (!this.lock.sync.startReadFromWaitingReader());
                        return;
                    }
                    catch (InterruptedException interruptedException2) {
                        this.lock.sync.cancelledWaitingReader();
                        interruptedException = interruptedException2;
                    }
                }
            }
            if (interruptedException != null) {
                this.lock.writerLock_.signalWaiters();
                throw interruptedException;
            }
        }

        @Override
        public boolean tryLock() {
            return this.lock.sync.startRead();
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean tryLock(long l2, TimeUnit timeUnit) throws InterruptedException {
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            InterruptedException interruptedException = null;
            long l3 = timeUnit.toNanos(l2);
            ReadLock readLock = this;
            synchronized (readLock) {
                block10: {
                    if (l3 <= 0L) {
                        return this.lock.sync.startRead();
                    }
                    if (this.lock.sync.startReadFromNewReader()) {
                        return true;
                    }
                    long l4 = Utils.nanoTime() + l3;
                    do {
                        try {
                            TimeUnit.NANOSECONDS.timedWait(this, l3);
                        }
                        catch (InterruptedException interruptedException2) {
                            this.lock.sync.cancelledWaitingReader();
                            interruptedException = interruptedException2;
                            break block10;
                        }
                        if (!this.lock.sync.startReadFromWaitingReader()) continue;
                        return true;
                    } while ((l3 = l4 - Utils.nanoTime()) > 0L);
                    this.lock.sync.cancelledWaitingReader();
                }
            }
            this.lock.writerLock_.signalWaiters();
            if (interruptedException != null) {
                throw interruptedException;
            }
            return false;
        }

        @Override
        public void unlock() {
            switch (this.lock.sync.endRead()) {
                case 0: {
                    return;
                }
                case 1: {
                    this.lock.readerLock_.signalWaiters();
                    return;
                }
                case 2: {
                    this.lock.writerLock_.signalWaiters();
                    return;
                }
            }
        }

        @Override
        public Condition newCondition() {
            throw new UnsupportedOperationException();
        }

        synchronized void signalWaiters() {
            this.notifyAll();
        }

        public String toString() {
            int n2 = this.lock.getReadLockCount();
            return super.toString() + "[Read locks = " + n2 + "]";
        }
    }

    private static class NonfairSync
    extends Sync {
        NonfairSync() {
        }
    }

    private static abstract class Sync
    implements Serializable {
        private static final int NONE = 0;
        private static final int READER = 1;
        private static final int WRITER = 2;
        transient int activeReaders_ = 0;
        transient Thread activeWriter_ = null;
        transient int waitingReaders_ = 0;
        transient int waitingWriters_ = 0;
        transient int writeHolds_ = 0;
        transient HashMap readers_ = new HashMap();
        static final Integer IONE = new Integer(1);

        Sync() {
        }

        synchronized boolean startReadFromNewReader() {
            boolean bl2 = this.startRead();
            if (!bl2) {
                ++this.waitingReaders_;
            }
            return bl2;
        }

        synchronized boolean startWriteFromNewWriter() {
            boolean bl2 = this.startWrite();
            if (!bl2) {
                ++this.waitingWriters_;
            }
            return bl2;
        }

        synchronized boolean startReadFromWaitingReader() {
            boolean bl2 = this.startRead();
            if (bl2) {
                --this.waitingReaders_;
            }
            return bl2;
        }

        synchronized boolean startWriteFromWaitingWriter() {
            boolean bl2 = this.startWrite();
            if (bl2) {
                --this.waitingWriters_;
            }
            return bl2;
        }

        synchronized void cancelledWaitingReader() {
            --this.waitingReaders_;
        }

        synchronized void cancelledWaitingWriter() {
            --this.waitingWriters_;
        }

        boolean allowReader() {
            return this.activeWriter_ == null && this.waitingWriters_ == 0 || this.activeWriter_ == Thread.currentThread();
        }

        synchronized boolean startRead() {
            Thread thread = Thread.currentThread();
            Object v2 = this.readers_.get(thread);
            if (v2 != null) {
                this.readers_.put(thread, new Integer((Integer)v2 + 1));
                ++this.activeReaders_;
                return true;
            }
            if (this.allowReader()) {
                this.readers_.put(thread, IONE);
                ++this.activeReaders_;
                return true;
            }
            return false;
        }

        synchronized boolean startWrite() {
            if (this.activeWriter_ == Thread.currentThread()) {
                ++this.writeHolds_;
                return true;
            }
            if (this.writeHolds_ == 0) {
                if (this.activeReaders_ == 0 || this.readers_.size() == 1 && this.readers_.get(Thread.currentThread()) != null) {
                    this.activeWriter_ = Thread.currentThread();
                    this.writeHolds_ = 1;
                    return true;
                }
                return false;
            }
            return false;
        }

        synchronized int endRead() {
            Thread thread = Thread.currentThread();
            Object v2 = this.readers_.get(thread);
            if (v2 == null) {
                throw new IllegalMonitorStateException();
            }
            --this.activeReaders_;
            if (v2 != IONE) {
                int n2 = (Integer)v2 - 1;
                Integer n3 = n2 == 1 ? IONE : new Integer(n2);
                this.readers_.put(thread, n3);
                return 0;
            }
            this.readers_.remove(thread);
            if (this.writeHolds_ > 0) {
                return 0;
            }
            if (this.activeReaders_ == 0 && this.waitingWriters_ > 0) {
                return 2;
            }
            return 0;
        }

        synchronized int endWrite() {
            if (this.activeWriter_ != Thread.currentThread()) {
                throw new IllegalMonitorStateException();
            }
            --this.writeHolds_;
            if (this.writeHolds_ > 0) {
                return 0;
            }
            this.activeWriter_ = null;
            if (this.waitingReaders_ > 0 && this.allowReader()) {
                return 1;
            }
            if (this.waitingWriters_ > 0) {
                return 2;
            }
            return 0;
        }

        synchronized Thread getOwner() {
            return this.activeWriter_;
        }

        synchronized int getReadLockCount() {
            return this.activeReaders_;
        }

        synchronized boolean isWriteLocked() {
            return this.activeWriter_ != null;
        }

        synchronized boolean isWriteLockedByCurrentThread() {
            return this.activeWriter_ == Thread.currentThread();
        }

        synchronized int getWriteHoldCount() {
            return this.isWriteLockedByCurrentThread() ? this.writeHolds_ : 0;
        }

        synchronized int getReadHoldCount() {
            if (this.activeReaders_ == 0) {
                return 0;
            }
            Thread thread = Thread.currentThread();
            Integer n2 = (Integer)this.readers_.get(thread);
            return n2 == null ? 0 : n2;
        }

        final synchronized boolean hasQueuedThreads() {
            return this.waitingWriters_ > 0 || this.waitingReaders_ > 0;
        }

        final synchronized int getQueueLength() {
            return this.waitingWriters_ + this.waitingReaders_;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
            objectInputStream.defaultReadObject();
            Sync sync = this;
            synchronized (sync) {
                this.readers_ = new HashMap();
            }
        }
    }
}

