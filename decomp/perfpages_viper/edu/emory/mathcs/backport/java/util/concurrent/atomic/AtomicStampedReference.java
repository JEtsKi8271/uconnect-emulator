/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.atomic;

import edu.emory.mathcs.backport.java.util.concurrent.atomic.AtomicReference;

public class AtomicStampedReference {
    private final AtomicReference atomicRef;

    public AtomicStampedReference(Object object, int n2) {
        this.atomicRef = new AtomicReference(new ReferenceIntegerPair(object, n2));
    }

    public Object getReference() {
        return this.getPair().reference;
    }

    public int getStamp() {
        return this.getPair().integer;
    }

    public Object get(int[] nArray) {
        ReferenceIntegerPair referenceIntegerPair = this.getPair();
        nArray[0] = referenceIntegerPair.integer;
        return referenceIntegerPair.reference;
    }

    public boolean weakCompareAndSet(Object object, Object object2, int n2, int n3) {
        ReferenceIntegerPair referenceIntegerPair = this.getPair();
        return object == referenceIntegerPair.reference && n2 == referenceIntegerPair.integer && (object2 == referenceIntegerPair.reference && n3 == referenceIntegerPair.integer || this.atomicRef.weakCompareAndSet(referenceIntegerPair, new ReferenceIntegerPair(object2, n3)));
    }

    public boolean compareAndSet(Object object, Object object2, int n2, int n3) {
        ReferenceIntegerPair referenceIntegerPair = this.getPair();
        return object == referenceIntegerPair.reference && n2 == referenceIntegerPair.integer && (object2 == referenceIntegerPair.reference && n3 == referenceIntegerPair.integer || this.atomicRef.compareAndSet(referenceIntegerPair, new ReferenceIntegerPair(object2, n3)));
    }

    public void set(Object object, int n2) {
        ReferenceIntegerPair referenceIntegerPair = this.getPair();
        if (object != referenceIntegerPair.reference || n2 != referenceIntegerPair.integer) {
            this.atomicRef.set(new ReferenceIntegerPair(object, n2));
        }
    }

    public boolean attemptStamp(Object object, int n2) {
        ReferenceIntegerPair referenceIntegerPair = this.getPair();
        return object == referenceIntegerPair.reference && (n2 == referenceIntegerPair.integer || this.atomicRef.compareAndSet(referenceIntegerPair, new ReferenceIntegerPair(object, n2)));
    }

    private ReferenceIntegerPair getPair() {
        return (ReferenceIntegerPair)this.atomicRef.get();
    }

    private static class ReferenceIntegerPair {
        private final Object reference;
        private final int integer;

        ReferenceIntegerPair(Object object, int n2) {
            this.reference = object;
            this.integer = n2;
        }
    }
}

