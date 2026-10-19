/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.ExecutionException;
import edu.emory.mathcs.backport.java.util.concurrent.Executor;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.TimeoutException;
import java.util.Collection;
import java.util.List;

public interface ExecutorService
extends Executor {
    public void shutdown();

    public List shutdownNow();

    public boolean isShutdown();

    public boolean isTerminated();

    public boolean awaitTermination(long var1, TimeUnit var3) throws InterruptedException;

    public Future submit(Callable var1);

    public Future submit(Runnable var1, Object var2);

    public Future submit(Runnable var1);

    public List invokeAll(Collection var1) throws InterruptedException;

    public List invokeAll(Collection var1, long var2, TimeUnit var4) throws InterruptedException;

    public Object invokeAny(Collection var1) throws InterruptedException, ExecutionException;

    public Object invokeAny(Collection var1, long var2, TimeUnit var4) throws InterruptedException, ExecutionException, TimeoutException;
}

