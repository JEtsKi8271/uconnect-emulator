/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.NavigableMap;
import edu.emory.mathcs.backport.java.util.NavigableSet;
import edu.emory.mathcs.backport.java.util.concurrent.ConcurrentMap;
import java.util.Set;
import java.util.SortedMap;

public interface ConcurrentNavigableMap
extends ConcurrentMap,
NavigableMap {
    @Override
    public NavigableMap subMap(Object var1, boolean var2, Object var3, boolean var4);

    @Override
    public NavigableMap headMap(Object var1, boolean var2);

    @Override
    public NavigableMap tailMap(Object var1, boolean var2);

    @Override
    public SortedMap subMap(Object var1, Object var2);

    @Override
    public SortedMap headMap(Object var1);

    @Override
    public SortedMap tailMap(Object var1);

    @Override
    public NavigableMap descendingMap();

    @Override
    public NavigableSet navigableKeySet();

    @Override
    public Set keySet();

    @Override
    public NavigableSet descendingKeySet();
}

