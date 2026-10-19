/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.NavigableSet;
import java.util.Map;
import java.util.SortedMap;

public interface NavigableMap
extends SortedMap {
    public Map.Entry lowerEntry(Object var1);

    public Object lowerKey(Object var1);

    public Map.Entry floorEntry(Object var1);

    public Object floorKey(Object var1);

    public Map.Entry ceilingEntry(Object var1);

    public Object ceilingKey(Object var1);

    public Map.Entry higherEntry(Object var1);

    public Object higherKey(Object var1);

    public Map.Entry firstEntry();

    public Map.Entry lastEntry();

    public Map.Entry pollFirstEntry();

    public Map.Entry pollLastEntry();

    public NavigableMap descendingMap();

    public NavigableSet navigableKeySet();

    public NavigableSet descendingKeySet();

    public NavigableMap subMap(Object var1, boolean var2, Object var3, boolean var4);

    public NavigableMap headMap(Object var1, boolean var2);

    public NavigableMap tailMap(Object var1, boolean var2);

    public SortedMap subMap(Object var1, Object var2);

    public SortedMap headMap(Object var1);

    public SortedMap tailMap(Object var1);
}

