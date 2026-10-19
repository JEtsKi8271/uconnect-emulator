/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.atomic;

import java.io.Serializable;

public class AtomicLongArray
implements Serializable {
    private static final long serialVersionUID = -2308431214976778248L;
    private final long[] array;

    public AtomicLongArray(int n2) {
        this.array = new long[n2];
    }

    public AtomicLongArray(long[] lArray) {
        if (lArray == null) {
            throw new NullPointerException();
        }
        int n2 = lArray.length;
        this.array = new long[n2];
        System.arraycopy(lArray, 0, this.array, 0, lArray.length);
    }

    public final int length() {
        return this.array.length;
    }

    public final synchronized long get(int n2) {
        return this.array[n2];
    }

    public final synchronized void set(int n2, long l2) {
        this.array[n2] = l2;
    }

    public final synchronized void lazySet(int n2, long l2) {
        this.array[n2] = l2;
    }

    public final synchronized long getAndSet(int n2, long l2) {
        long l3 = this.array[n2];
        this.array[n2] = l2;
        return l3;
    }

    public final synchronized boolean compareAndSet(int n2, long l2, long l3) {
        if (this.array[n2] == l2) {
            this.array[n2] = l3;
            return true;
        }
        return false;
    }

    public final synchronized boolean weakCompareAndSet(int n2, long l2, long l3) {
        if (this.array[n2] == l2) {
            this.array[n2] = l3;
            return true;
        }
        return false;
    }

    public final synchronized long getAndIncrement(int n2) {
        int n3 = n2;
        long l2 = this.array[n3];
        this.array[n3] = l2 + 1L;
        return l2;
    }

    public final synchronized long getAndDecrement(int n2) {
        int n3 = n2;
        long l2 = this.array[n3];
        this.array[n3] = l2 - 1L;
        return l2;
    }

    public final synchronized long getAndAdd(int n2, long l2) {
        long l3 = this.array[n2];
        int n3 = n2;
        this.array[n3] = this.array[n3] + l2;
        return l3;
    }

    public final synchronized long incrementAndGet(int n2) {
        int n3 = n2;
        long l2 = this.array[n3] + 1L;
        this.array[n3] = l2;
        return l2;
    }

    public final synchronized long decrementAndGet(int n2) {
        int n3 = n2;
        long l2 = this.array[n3] - 1L;
        this.array[n3] = l2;
        return l2;
    }

    public synchronized long addAndGet(int n2, long l2) {
        int n3 = n2;
        long l3 = this.array[n3] + l2;
        this.array[n3] = l3;
        return l3;
    }

    public synchronized String toString() {
        if (this.array.length == 0) {
            return "[]";
        }
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append('[');
        stringBuffer.append(this.array[0]);
        for (int i2 = 1; i2 < this.array.length; ++i2) {
            stringBuffer.append(", ");
            stringBuffer.append(this.array[i2]);
        }
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

