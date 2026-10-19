/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.ExecutorService;
import edu.emory.mathcs.backport.java.util.concurrent.ScheduledFuture;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;

public interface ScheduledExecutorService
extends ExecutorService {
    public ScheduledFuture schedule(Runnable var1, long var2, TimeUnit var4);

    public ScheduledFuture schedule(Callable var1, long var2, TimeUnit var4);

    public ScheduledFuture scheduleAtFixedRate(Runnable var1, long var2, long var4, TimeUnit var6);

    public ScheduledFuture scheduleWithFixedDelay(Runnable var1, long var2, long var4, TimeUnit var6);
}

