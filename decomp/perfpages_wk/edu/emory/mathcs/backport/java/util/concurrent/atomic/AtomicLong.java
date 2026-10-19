/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.atomic;

import java.io.Serializable;

public class AtomicLong
extends Number
implements Serializable {
    private static final long serialVersionUID = 1927816293512124184L;
    private volatile long value;

    public AtomicLong(long l2) {
        this.value = l2;
    }

    public AtomicLong() {
    }

    public final long get() {
        return this.value;
    }

    public final synchronized void set(long l2) {
        this.value = l2;
    }

    public final synchronized void lazySet(long l2) {
        this.value = l2;
    }

    public final synchronized long getAndSet(long l2) {
        long l3 = this.value;
        this.value = l2;
        return l3;
    }

    public final synchronized boolean compareAndSet(long l2, long l3) {
        if (this.value == l2) {
            this.value = l3;
            return true;
        }
        return false;
    }

    public final synchronized boolean weakCompareAndSet(long l2, long l3) {
        if (this.value == l2) {
            this.value = l3;
            return true;
        }
        return false;
    }

    public final synchronized long getAndIncrement() {
        return this.value++;
    }

    public final synchronized long getAndDecrement() {
        return this.value--;
    }

    public final synchronized long getAndAdd(long l2) {
        long l3 = this.value;
        this.value += l2;
        return l3;
    }

    public final synchronized long incrementAndGet() {
        return ++this.value;
    }

    public final synchronized long decrementAndGet() {
        return --this.value;
    }

    public final synchronized long addAndGet(long l2) {
        return this.value += l2;
    }

    public String toString() {
        return Long.toString(this.get());
    }

    @Override
    public int intValue() {
        return (int)this.get();
    }

    @Override
    public long longValue() {
        return this.get();
    }

    @Override
    public float floatValue() {
        return this.get();
    }

    @Override
    public double doubleValue() {
        return this.get();
    }
}

