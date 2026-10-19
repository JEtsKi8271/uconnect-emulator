/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.atomic;

import edu.emory.mathcs.backport.java.util.concurrent.atomic.AtomicReference;

public class AtomicMarkableReference {
    private final AtomicReference atomicRef;

    public AtomicMarkableReference(Object object, boolean bl2) {
        this.atomicRef = new AtomicReference(new ReferenceBooleanPair(object, bl2));
    }

    private ReferenceBooleanPair getPair() {
        return (ReferenceBooleanPair)this.atomicRef.get();
    }

    public Object getReference() {
        return this.getPair().reference;
    }

    public boolean isMarked() {
        return this.getPair().bit;
    }

    public Object get(boolean[] blArray) {
        ReferenceBooleanPair referenceBooleanPair = this.getPair();
        blArray[0] = referenceBooleanPair.bit;
        return referenceBooleanPair.reference;
    }

    public boolean weakCompareAndSet(Object object, Object object2, boolean bl2, boolean bl3) {
        ReferenceBooleanPair referenceBooleanPair = this.getPair();
        return object == referenceBooleanPair.reference && bl2 == referenceBooleanPair.bit && (object2 == referenceBooleanPair.reference && bl3 == referenceBooleanPair.bit || this.atomicRef.weakCompareAndSet(referenceBooleanPair, new ReferenceBooleanPair(object2, bl3)));
    }

    public boolean compareAndSet(Object object, Object object2, boolean bl2, boolean bl3) {
        ReferenceBooleanPair referenceBooleanPair = this.getPair();
        return object == referenceBooleanPair.reference && bl2 == referenceBooleanPair.bit && (object2 == referenceBooleanPair.reference && bl3 == referenceBooleanPair.bit || this.atomicRef.compareAndSet(referenceBooleanPair, new ReferenceBooleanPair(object2, bl3)));
    }

    public void set(Object object, boolean bl2) {
        ReferenceBooleanPair referenceBooleanPair = this.getPair();
        if (object != referenceBooleanPair.reference || bl2 != referenceBooleanPair.bit) {
            this.atomicRef.set(new ReferenceBooleanPair(object, bl2));
        }
    }

    public boolean attemptMark(Object object, boolean bl2) {
        ReferenceBooleanPair referenceBooleanPair = this.getPair();
        return object == referenceBooleanPair.reference && (bl2 == referenceBooleanPair.bit || this.atomicRef.compareAndSet(referenceBooleanPair, new ReferenceBooleanPair(object, bl2)));
    }

    private static class ReferenceBooleanPair {
        private final Object reference;
        private final boolean bit;

        ReferenceBooleanPair(Object object, boolean bl2) {
            this.reference = object;
            this.bit = bl2;
        }
    }
}

