/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.atomic;

import java.io.Serializable;

public class AtomicInteger
extends Number
implements Serializable {
    private static final long serialVersionUID = 6214790243416807050L;
    private volatile int value;

    public AtomicInteger(int n2) {
        this.value = n2;
    }

    public AtomicInteger() {
    }

    public final int get() {
        return this.value;
    }

    public final synchronized void set(int n2) {
        this.value = n2;
    }

    public final synchronized void lazySet(int n2) {
        this.value = n2;
    }

    public final synchronized int getAndSet(int n2) {
        int n3 = this.value;
        this.value = n2;
        return n3;
    }

    public final synchronized boolean compareAndSet(int n2, int n3) {
        if (this.value == n2) {
            this.value = n3;
            return true;
        }
        return false;
    }

    public final synchronized boolean weakCompareAndSet(int n2, int n3) {
        if (this.value == n2) {
            this.value = n3;
            return true;
        }
        return false;
    }

    public final synchronized int getAndIncrement() {
        return this.value++;
    }

    public final synchronized int getAndDecrement() {
        return this.value--;
    }

    public final synchronized int getAndAdd(int n2) {
        int n3 = this.value;
        this.value += n2;
        return n3;
    }

    public final synchronized int incrementAndGet() {
        return ++this.value;
    }

    public final synchronized int decrementAndGet() {
        return --this.value;
    }

    public final synchronized int addAndGet(int n2) {
        return this.value += n2;
    }

    public String toString() {
        return Integer.toString(this.get());
    }

    @Override
    public int intValue() {
        return this.get();
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

