/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.Deque;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import java.util.Iterator;

public interface BlockingDeque
extends BlockingQueue,
Deque {
    @Override
    public void addFirst(Object var1);

    @Override
    public void addLast(Object var1);

    @Override
    public boolean offerFirst(Object var1);

    @Override
    public boolean offerLast(Object var1);

    public void putFirst(Object var1) throws InterruptedException;

    public void putLast(Object var1) throws InterruptedException;

    public boolean offerFirst(Object var1, long var2, TimeUnit var4) throws InterruptedException;

    public boolean offerLast(Object var1, long var2, TimeUnit var4) throws InterruptedException;

    public Object takeFirst() throws InterruptedException;

    public Object takeLast() throws InterruptedException;

    public Object pollFirst(long var1, TimeUnit var3) throws InterruptedException;

    public Object pollLast(long var1, TimeUnit var3) throws InterruptedException;

    @Override
    public boolean removeFirstOccurrence(Object var1);

    @Override
    public boolean removeLastOccurrence(Object var1);

    @Override
    public boolean add(Object var1);

    @Override
    public boolean offer(Object var1);

    @Override
    public void put(Object var1) throws InterruptedException;

    @Override
    public boolean offer(Object var1, long var2, TimeUnit var4) throws InterruptedException;

    @Override
    public Object remove();

    @Override
    public Object poll();

    @Override
    public Object take() throws InterruptedException;

    @Override
    public Object poll(long var1, TimeUnit var3) throws InterruptedException;

    @Override
    public Object element();

    @Override
    public Object peek();

    @Override
    public boolean remove(Object var1);

    @Override
    public boolean contains(Object var1);

    @Override
    public int size();

    @Override
    public Iterator iterator();

    @Override
    public void push(Object var1);
}

