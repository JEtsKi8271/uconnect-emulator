/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.Queue;
import java.util.Iterator;

public interface Deque
extends Queue {
    public void addFirst(Object var1);

    public void addLast(Object var1);

    public boolean offerFirst(Object var1);

    public boolean offerLast(Object var1);

    public Object removeFirst();

    public Object removeLast();

    public Object pollFirst();

    public Object pollLast();

    public Object getFirst();

    public Object getLast();

    public Object peekFirst();

    public Object peekLast();

    public boolean removeFirstOccurrence(Object var1);

    public boolean removeLastOccurrence(Object var1);

    @Override
    public boolean add(Object var1);

    @Override
    public boolean offer(Object var1);

    @Override
    public Object remove();

    @Override
    public Object poll();

    @Override
    public Object element();

    @Override
    public Object peek();

    public void push(Object var1);

    public Object pop();

    @Override
    public boolean remove(Object var1);

    @Override
    public boolean contains(Object var1);

    @Override
    public int size();

    @Override
    public Iterator iterator();

    public Iterator descendingIterator();
}

