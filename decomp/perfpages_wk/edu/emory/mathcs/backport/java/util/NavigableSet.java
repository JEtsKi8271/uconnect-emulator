/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import java.util.Iterator;
import java.util.SortedSet;

public interface NavigableSet
extends SortedSet {
    public Object lower(Object var1);

    public Object floor(Object var1);

    public Object ceiling(Object var1);

    public Object higher(Object var1);

    public Object pollFirst();

    public Object pollLast();

    @Override
    public Iterator iterator();

    public NavigableSet descendingSet();

    public Iterator descendingIterator();

    public NavigableSet subSet(Object var1, boolean var2, Object var3, boolean var4);

    public NavigableSet headSet(Object var1, boolean var2);

    public NavigableSet tailSet(Object var1, boolean var2);

    public SortedSet subSet(Object var1, Object var2);

    public SortedSet headSet(Object var1);

    public SortedSet tailSet(Object var1);
}

