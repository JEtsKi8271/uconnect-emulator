/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.atomic;

import java.io.Serializable;

public class AtomicBoolean
implements Serializable {
    private static final long serialVersionUID = 4654671469794556979L;
    private volatile int value;

    public AtomicBoolean(boolean bl2) {
        this.value = bl2 ? 1 : 0;
    }

    public AtomicBoolean() {
    }

    public final boolean get() {
        return this.value != 0;
    }

    public final synchronized boolean compareAndSet(boolean bl2, boolean bl3) {
        if (bl2 == (this.value != 0)) {
            this.value = bl3 ? 1 : 0;
            return true;
        }
        return false;
    }

    public synchronized boolean weakCompareAndSet(boolean bl2, boolean bl3) {
        if (bl2 == (this.value != 0)) {
            this.value = bl3 ? 1 : 0;
            return true;
        }
        return false;
    }

    public final synchronized void set(boolean bl2) {
        this.value = bl2 ? 1 : 0;
    }

    public final synchronized void lazySet(boolean bl2) {
        this.value = bl2 ? 1 : 0;
    }

    public final synchronized boolean getAndSet(boolean bl2) {
        int n2 = this.value;
        this.value = bl2 ? 1 : 0;
        return n2 != 0;
    }

    public String toString() {
        return Boolean.toString(this.get());
    }
}

