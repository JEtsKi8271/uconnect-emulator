/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.Future;

public interface RunnableFuture
extends Runnable,
Future {
    @Override
    public void run();
}

