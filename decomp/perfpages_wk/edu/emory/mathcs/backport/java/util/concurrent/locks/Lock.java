/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.locks;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;

public interface Lock {
    public void lock();

    public void lockInterruptibly() throws InterruptedException;

    public boolean tryLock();

    public boolean tryLock(long var1, TimeUnit var3) throws InterruptedException;

    public void unlock();

    public Condition newCondition();
}

