/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.ExecutionException;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.TimeoutException;

public interface Future {
    public boolean cancel(boolean var1);

    public boolean isCancelled();

    public boolean isDone();

    public Object get() throws InterruptedException, ExecutionException;

    public Object get(long var1, TimeUnit var3) throws InterruptedException, ExecutionException, TimeoutException;
}

