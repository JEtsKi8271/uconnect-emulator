/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.locks;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.FIFOWaitQueue;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.WaitQueue;
import edu.emory.mathcs.backport.java.util.concurrent.locks.CondVar;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

class FIFOCondVar
extends CondVar
implements Condition,
Serializable {
    private static final WaitQueue.QueuedSync sync = new WaitQueue.QueuedSync(){

        @Override
        public boolean recheck(WaitQueue.WaitNode waitNode) {
            return false;
        }

        @Override
        public void takeOver(WaitQueue.WaitNode waitNode) {
        }
    };
    private final WaitQueue wq = new FIFOWaitQueue();

    FIFOCondVar(CondVar.ExclusiveLock exclusiveLock) {
        super(exclusiveLock);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void awaitUninterruptibly() {
        int n2;
        int n3 = this.lock.getHoldCount();
        if (n3 == 0) {
            throw new IllegalMonitorStateException();
        }
        WaitQueue.WaitNode waitNode = new WaitQueue.WaitNode();
        this.wq.insert(waitNode);
        for (n2 = n3; n2 > 0; --n2) {
            this.lock.unlock();
        }
        try {
            waitNode.doWaitUninterruptibly(sync);
        }
        finally {
            for (n2 = n3; n2 > 0; --n2) {
                this.lock.lock();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void await() throws InterruptedException {
        int n2;
        int n3 = this.lock.getHoldCount();
        if (n3 == 0) {
            throw new IllegalMonitorStateException();
        }
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        WaitQueue.WaitNode waitNode = new WaitQueue.WaitNode();
        this.wq.insert(waitNode);
        for (n2 = n3; n2 > 0; --n2) {
            this.lock.unlock();
        }
        try {
            waitNode.doWait(sync);
        }
        finally {
            for (n2 = n3; n2 > 0; --n2) {
                this.lock.lock();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean await(long l2, TimeUnit timeUnit) throws InterruptedException {
        int n2;
        int n3 = this.lock.getHoldCount();
        if (n3 == 0) {
            throw new IllegalMonitorStateException();
        }
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        long l3 = timeUnit.toNanos(l2);
        WaitQueue.WaitNode waitNode = new WaitQueue.WaitNode();
        this.wq.insert(waitNode);
        boolean bl2 = false;
        for (n2 = n3; n2 > 0; --n2) {
            this.lock.unlock();
        }
        try {
            bl2 = waitNode.doTimedWait(sync, l3);
        }
        finally {
            for (n2 = n3; n2 > 0; --n2) {
                this.lock.lock();
            }
        }
        return bl2;
    }

    @Override
    public boolean awaitUntil(Date date) throws InterruptedException {
        if (date == null) {
            throw new NullPointerException();
        }
        long l2 = date.getTime();
        long l3 = System.currentTimeMillis();
        long l4 = l2 - l3;
        return this.await(l4, TimeUnit.MILLISECONDS);
    }

    @Override
    public void signal() {
        WaitQueue.WaitNode waitNode;
        if (!this.lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        do {
            if ((waitNode = this.wq.extract()) != null) continue;
            return;
        } while (!waitNode.signal(sync));
    }

    @Override
    public void signalAll() {
        if (!this.lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        WaitQueue.WaitNode waitNode;
        while ((waitNode = this.wq.extract()) != null) {
            waitNode.signal(sync);
        }
        return;
    }

    @Override
    protected boolean hasWaiters() {
        if (!this.lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        return this.wq.hasNodes();
    }

    @Override
    protected int getWaitQueueLength() {
        if (!this.lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        return this.wq.getLength();
    }

    @Override
    protected Collection getWaitingThreads() {
        if (!this.lock.isHeldByCurrentThread()) {
            throw new IllegalMonitorStateException();
        }
        return this.wq.getWaitingThreads();
    }
}

