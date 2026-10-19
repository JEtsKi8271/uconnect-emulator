/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;

public class CountDownLatch {
    private int count_;

    public CountDownLatch(int n2) {
        if (n2 < 0) {
            throw new IllegalArgumentException("count < 0");
        }
        this.count_ = n2;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void await() throws InterruptedException {
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        CountDownLatch countDownLatch = this;
        synchronized (countDownLatch) {
            while (this.count_ > 0) {
                this.wait();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public boolean await(long l2, TimeUnit timeUnit) throws InterruptedException {
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        long l3 = timeUnit.toNanos(l2);
        CountDownLatch countDownLatch = this;
        synchronized (countDownLatch) {
            if (this.count_ <= 0) {
                return true;
            }
            if (l3 <= 0L) {
                return false;
            }
            long l4 = Utils.nanoTime() + l3;
            do {
                TimeUnit.NANOSECONDS.timedWait(this, l3);
                if (this.count_ > 0) continue;
                return true;
            } while ((l3 = l4 - Utils.nanoTime()) > 0L);
            return false;
        }
    }

    public synchronized void countDown() {
        if (this.count_ == 0) {
            return;
        }
        if (--this.count_ == 0) {
            this.notifyAll();
        }
    }

    public long getCount() {
        return this.count_;
    }

    public String toString() {
        return super.toString() + "[Count = " + this.getCount() + "]";
    }
}

