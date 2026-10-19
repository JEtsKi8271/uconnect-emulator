/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.locks;

import edu.emory.mathcs.backport.java.util.concurrent.locks.Lock;

public interface ReadWriteLock {
    public Lock readLock();

    public Lock writeLock();
}

