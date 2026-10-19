/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;

public interface CompletionService {
    public Future submit(Callable var1);

    public Future submit(Runnable var1, Object var2);

    public Future take() throws InterruptedException;

    public Future poll();

    public Future poll(long var1, TimeUnit var3) throws InterruptedException;
}

