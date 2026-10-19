/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.concurrency;

import com.sprint.gskills.concurrency.GSkillsThreadFactory;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.FutureTask;
import edu.emory.mathcs.backport.java.util.concurrent.LinkedBlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.RunnableFuture;
import edu.emory.mathcs.backport.java.util.concurrent.ThreadFactory;
import edu.emory.mathcs.backport.java.util.concurrent.ThreadPoolExecutor;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;

public class GSkillsThreadPoolExecutor
extends ThreadPoolExecutor {
    private static int threadCount = 0;
    private static final GSkillsThreadPoolExecutor INSTANCE = new GSkillsThreadPoolExecutor(5, 25, 0L, TimeUnit.MILLISECONDS, (BlockingQueue)new LinkedBlockingQueue(), new GSkillsThreadFactory());

    protected static GSkillsThreadPoolExecutor getInstance() {
        return INSTANCE;
    }

    private GSkillsThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue workQueue, ThreadFactory threadFactory) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue, threadFactory);
    }

    protected synchronized void beforeExecute(Thread t2, Runnable r2) {
        ++threadCount;
        t2.setName(r2.toString());
        super.beforeExecute(t2, r2);
    }

    protected synchronized void afterExecute(Runnable r2, Throwable t2) {
        --threadCount;
        Thread.currentThread().setName("");
        super.afterExecute(r2, t2);
    }

    protected RunnableFuture newTaskFor(final Runnable runnable, Object c2) {
        return new FutureTask(runnable, c2){

            public String toString() {
                return runnable.toString();
            }
        };
    }

    protected RunnableFuture newTaskFor(final Callable callable) {
        return new FutureTask(callable){

            public String toString() {
                return callable.toString();
            }
        };
    }

    public int getCalculatedTaskCount() {
        return threadCount;
    }
}

