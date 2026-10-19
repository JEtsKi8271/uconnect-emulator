/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.locks;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import java.util.Date;

public interface Condition {
    public void await() throws InterruptedException;

    public void awaitUninterruptibly();

    public boolean await(long var1, TimeUnit var3) throws InterruptedException;

    public boolean awaitUntil(Date var1) throws InterruptedException;

    public void signal();

    public void signalAll();
}

