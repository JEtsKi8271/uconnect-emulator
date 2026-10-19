/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.Queue;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import java.util.Collection;

public interface BlockingQueue
extends Queue {
    @Override
    public boolean add(Object var1);

    @Override
    public boolean offer(Object var1);

    public void put(Object var1) throws InterruptedException;

    public boolean offer(Object var1, long var2, TimeUnit var4) throws InterruptedException;

    public Object take() throws InterruptedException;

    public Object poll(long var1, TimeUnit var3) throws InterruptedException;

    public int remainingCapacity();

    @Override
    public boolean remove(Object var1);

    @Override
    public boolean contains(Object var1);

    public int drainTo(Collection var1);

    public int drainTo(Collection var1, int var2);
}

