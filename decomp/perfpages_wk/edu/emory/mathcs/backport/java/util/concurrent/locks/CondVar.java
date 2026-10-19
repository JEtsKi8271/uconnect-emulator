/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.locks;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Lock;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

class CondVar
implements Condition,
Serializable {
    protected final ExclusiveLock lock;

    CondVar(ExclusiveLock exclusiveLock) {
        this.lock = exclusiveLock;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void awaitUninterruptibly() {
        int n2 = this.lock.getHoldCount();
        if (n2 == 0) {
            throw new IllegalMonitorStateException();
        }
        boolean bl2 = Thread.interrupted();
        try {
            CondVar condVar = this;
            synchronized (condVar) {
                for (int i2 = n2; i2 > 0; --i2) {
                    this.lock.unlock();
                }
                try {
                    this.wait();
                }
                catch (InterruptedException interruptedException) {
                    bl2 = true;
                }
            }
        }
        finally {
            for (int i3 = n2; i3 > 0; --i3) {
                this.lock.lock();
            }
            if (bl2) {
                Thread.currentThread().interrupt();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void await() throws InterruptedException {
        int n2 = this.lock.getHoldCount();
        if (n2 == 0) {
            throw new IllegalMonitorStateException();
        }
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        try {
            CondVar condVar = this;
            synchronized (condVar) {
                for (int i2 = n2; i2 > 0; --i2) {
                    this.lock.unlock();
                }
                try {
                    this.wait();
                }
                catch (InterruptedException interruptedException) {
                    this.notify();
                    throw interruptedException;
                }
            }
        }
        finally {
            for (int i3 = n2; i3 > 0; --i3) {
                this.lock.lock();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean await(long l2, TimeUnit timeUnit) throws InterruptedException {
        int n2 = this.lock.getHoldCount();
        if (n2 == 0) {
            throw new IllegalMonitorStateException();
        }
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        long l3 = timeUnit.toNanos(l2);
        boolean bl2 = false;
        try {
            CondVar condVar = this;
            synchronized (condVar) {
                for (int i2 = n2; i2 > 0; --i2) {
                    this.lock.unlock();
                }
                try {
                    if (l3 > 0L) {
                        long l4 = Utils.nanoTime();
                        TimeUnit.NANOSECONDS.timedWait(this, l3);
                        bl2 = Utils.nanoTime() - l4 < l3;
                    }
                }
                catch (InterruptedException interruptedException) {
                    this.notify();
                    throw interruptedException;
                }
            }
        }
        finally {
            for (int i3 = n2; i3 > 0; --i3) {
                this.lock.lock();
            }
        }
        return bl2;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean awaitUntil(Date date) throws InterruptedException {
        if (date == null) {
            throw new NullPointerException();
        }
        int n2 = this.lock.getHoldCount();
        if (n2 == 0) {
            throw new IllegalMonitorStateException();
        }
        long l2 = date.getTime();
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        boolean bl2 = false;
        try {
            CondVar condVar = this;
            synchronized (condVar) {
                for (int i2 = n2; i2 > 0; --i2) {
                    this.lock.unlock();
                }
                try {
                    long l3 = System.currentTimeMillis();
                    long l4 = l2 - l3;
                    if (l4 > 0L) {
                        this.wait(l4);
                        bl2 = System.currentTimeMillis() - l3 < l4;
                    }
                }
                catch (InterruptedException interruptedException) {
                    this.notify();
                    throw interruptedException;
                }
            }
        }
        finally {
            for (int i3 = n2; i3 > 0; --i3) {
                this.lock.lock();
            }
        }
        return bl2;
    }

    @Override
    public synchronized void signal() {
        if (!this.lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        this.notify();
    }

    @Override
    public synchronized void signalAll() {
        if (!this.lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        this.notifyAll();
    }

    protected ExclusiveLock getLock() {
        return this.lock;
    }

    protected boolean hasWaiters() {
        throw new UnsupportedOperationException("Use FAIR version");
    }

    protected int getWaitQueueLength() {
        throw new UnsupportedOperationException("Use FAIR version");
    }

    protected Collection getWaitingThreads() {
        throw new UnsupportedOperationException("Use FAIR version");
    }

    static interface ExclusiveLock
    extends Lock {
        public boolean isHeldByCurrentThread();

        public int getHoldCount();
    }
}

