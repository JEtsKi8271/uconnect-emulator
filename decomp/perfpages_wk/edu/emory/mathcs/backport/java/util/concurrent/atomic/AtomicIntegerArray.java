/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.atomic;

import java.io.Serializable;

public class AtomicIntegerArray
implements Serializable {
    private static final long serialVersionUID = 2862133569453604235L;
    private final int[] array;

    public AtomicIntegerArray(int n2) {
        this.array = new int[n2];
    }

    public AtomicIntegerArray(int[] nArray) {
        if (nArray == null) {
            throw new NullPointerException();
        }
        int n2 = nArray.length;
        this.array = new int[n2];
        System.arraycopy(nArray, 0, this.array, 0, nArray.length);
    }

    public final int length() {
        return this.array.length;
    }

    public final synchronized int get(int n2) {
        return this.array[n2];
    }

    public final synchronized void set(int n2, int n3) {
        this.array[n2] = n3;
    }

    public final synchronized void lazySet(int n2, int n3) {
        this.array[n2] = n3;
    }

    public final synchronized int getAndSet(int n2, int n3) {
        int n4 = this.array[n2];
        this.array[n2] = n3;
        return n4;
    }

    public final synchronized boolean compareAndSet(int n2, int n3, int n4) {
        if (this.array[n2] == n3) {
            this.array[n2] = n4;
            return true;
        }
        return false;
    }

    public final synchronized boolean weakCompareAndSet(int n2, int n3, int n4) {
        if (this.array[n2] == n3) {
            this.array[n2] = n4;
            return true;
        }
        return false;
    }

    public final synchronized int getAndIncrement(int n2) {
        int n3 = n2;
        int n4 = this.array[n3];
        this.array[n3] = n4 + 1;
        return n4;
    }

    public final synchronized int getAndDecrement(int n2) {
        int n3 = n2;
        int n4 = this.array[n3];
        this.array[n3] = n4 - 1;
        return n4;
    }

    public final synchronized int getAndAdd(int n2, int n3) {
        int n4 = this.array[n2];
        int n5 = n2;
        this.array[n5] = this.array[n5] + n3;
        return n4;
    }

    public final synchronized int incrementAndGet(int n2) {
        int n3 = n2;
        int n4 = this.array[n3] + 1;
        this.array[n3] = n4;
        return n4;
    }

    public final synchronized int decrementAndGet(int n2) {
        int n3 = n2;
        int n4 = this.array[n3] - 1;
        this.array[n3] = n4;
        return n4;
    }

    public final synchronized int addAndGet(int n2, int n3) {
        int n4 = n2;
        int n5 = this.array[n4] + n3;
        this.array[n4] = n5;
        return n5;
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

