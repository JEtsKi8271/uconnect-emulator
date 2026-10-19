/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.TimeoutException;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;

public class Exchanger {
    private final Object lock = new Object();
    private Object item;
    private int arrivalCount;

    private Object doExchange(Object object, boolean bl2, long l2) throws InterruptedException, TimeoutException {
        Object object2 = this.lock;
        synchronized (object2) {
            int n2;
            long l3;
            long l4 = l3 = bl2 ? Utils.nanoTime() + l2 : 0L;
            while (this.arrivalCount == 2) {
                if (!bl2) {
                    this.lock.wait();
                    continue;
                }
                if (l2 > 0L) {
                    TimeUnit.NANOSECONDS.timedWait(this.lock, l2);
                    l2 = l3 - Utils.nanoTime();
                    continue;
                }
                throw new TimeoutException();
            }
            if ((n2 = ++this.arrivalCount) == 2) {
                Object object3 = this.item;
                this.item = object;
                this.lock.notifyAll();
                return object3;
            }
            this.item = object;
            InterruptedException interruptedException = null;
            try {
                while (this.arrivalCount != 2) {
                    if (!bl2) {
                        this.lock.wait();
                        continue;
                    }
                    if (l2 > 0L) {
                        TimeUnit.NANOSECONDS.timedWait(this.lock, l2);
                        l2 = l3 - Utils.nanoTime();
                        continue;
                    }
                    break;
                }
            }
            catch (InterruptedException interruptedException2) {
                interruptedException = interruptedException2;
            }
            Object object4 = this.item;
            this.item = null;
            n2 = this.arrivalCount;
            this.arrivalCount = 0;
            this.lock.notifyAll();
            if (n2 == 2) {
                if (interruptedException != null) {
                    Thread.currentThread().interrupt();
                }
                return object4;
            }
            if (interruptedException != null) {
                throw interruptedException;
            }
            throw new TimeoutException();
        }
    }

    public Object exchange(Object object) throws InterruptedException {
        try {
            return this.doExchange(object, false, 0L);
        }
        catch (TimeoutException timeoutException) {
            throw new Error(timeoutException);
        }
    }

    public Object exchange(Object object, long l2, TimeUnit timeUnit) throws InterruptedException, TimeoutException {
        return this.doExchange(object, true, timeUnit.toNanos(l2));
    }
}

