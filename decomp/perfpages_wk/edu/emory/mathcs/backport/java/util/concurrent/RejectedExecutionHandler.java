/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.ThreadPoolExecutor;

public interface RejectedExecutionHandler {
    public void rejectedExecution(Runnable var1, ThreadPoolExecutor var2);
}

