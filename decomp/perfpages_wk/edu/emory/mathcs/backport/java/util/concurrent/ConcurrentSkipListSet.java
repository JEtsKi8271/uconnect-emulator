/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractSet;
import edu.emory.mathcs.backport.java.util.NavigableSet;
import edu.emory.mathcs.backport.java.util.concurrent.ConcurrentNavigableMap;
import edu.emory.mathcs.backport.java.util.concurrent.ConcurrentSkipListMap;
import java.io.Serializable;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;

public class ConcurrentSkipListSet
extends AbstractSet
implements NavigableSet,
Cloneable,
Serializable {
    private static final long serialVersionUID = -2479143111061671589L;
    private final ConcurrentNavigableMap m;

    public ConcurrentSkipListSet() {
        this.m = new ConcurrentSkipListMap();
    }

    public ConcurrentSkipListSet(Comparator comparator) {
        this.m = new ConcurrentSkipListMap(comparator);
    }

    public ConcurrentSkipListSet(Collection collection) {
        this.m = new ConcurrentSkipListMap();
        this.addAll(collection);
    }

    public ConcurrentSkipListSet(SortedSet sortedSet) {
        this.m = new ConcurrentSkipListMap(sortedSet.comparator());
        this.addAll(sortedSet);
    }

    ConcurrentSkipListSet(ConcurrentNavigableMap concurrentNavigableMap) {
        this.m = concurrentNavigableMap;
    }

    public Object clone() {
        if (this.getClass() != ConcurrentSkipListSet.class) {
            throw new UnsupportedOperationException("Can't clone subclasses");
        }
        return new ConcurrentSkipListSet(new ConcurrentSkipListMap(this.m));
    }

    @Override
    public int size() {
        return this.m.size();
    }

    @Override
    public boolean isEmpty() {
        return this.m.isEmpty();
    }

    @Override
    public boolean contains(Object object) {
        return this.m.containsKey(object);
    }

    @Override
    public boolean add(Object object) {
        return this.m.putIfAbsent(object, Boolean.TRUE) == null;
    }

    @Override
    public boolean remove(Object object) {
        return this.m.remove(object, Boolean.TRUE);
    }

    @Override
    public void clear() {
        this.m.clear();
    }

    @Override
    public Iterator iterator() {
        return this.m.navigableKeySet().iterator();
    }

    @Override
    public Iterator descendingIterator() {
        return this.m.descendingKeySet().iterator();
    }

    @Override
    public boolean equals(Object object) {
        if (object == this) {
            return true;
        }
        if (!(object instanceof Set)) {
            return false;
        }
        Collection collection = (Collection)object;
        try {
            return this.containsAll(collection) && collection.containsAll(this);
        }
        catch (ClassCastException classCastException) {
            return false;
        }
        catch (NullPointerException nullPointerException) {
            return false;
        }
    }

    @Override
    public boolean removeAll(Collection collection) {
        boolean bl2 = false;
        Iterator iterator = collection.iterator();
        while (iterator.hasNext()) {
            if (!this.remove(iterator.next())) continue;
            bl2 = true;
        }
        return bl2;
    }

    @Override
    public Object lower(Object object) {
        return this.m.lowerKey(object);
    }

    @Override
    public Object floor(Object object) {
        return this.m.floorKey(object);
    }

    @Override
    public Object ceiling(Object object) {
        return this.m.ceilingKey(object);
    }

    @Override
    public Object higher(Object object) {
        return this.m.higherKey(object);
    }

    @Override
    public Object pollFirst() {
        Map.Entry entry = this.m.pollFirstEntry();
        return entry == null ? null : entry.getKey();
    }

    @Override
    public Object pollLast() {
        Map.Entry entry = this.m.pollLastEntry();
        return entry == null ? null : entry.getKey();
    }

    public Comparator comparator() {
        return this.m.comparator();
    }

    public Object first() {
        return this.m.firstKey();
    }

    public Object last() {
        return this.m.lastKey();
    }

    @Override
    public NavigableSet subSet(Object object, boolean bl2, Object object2, boolean bl3) {
        return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.subMap(object, bl2, object2, bl3));
    }

    @Override
    public NavigableSet headSet(Object object, boolean bl2) {
        return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.headMap(object, bl2));
    }

    @Override
    public NavigableSet tailSet(Object object, boolean bl2) {
        return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.tailMap(object, bl2));
    }

    @Override
    public SortedSet subSet(Object object, Object object2) {
        return this.subSet(object, true, object2, false);
    }

    @Override
    public SortedSet headSet(Object object) {
        return this.headSet(object, false);
    }

    @Override
    public SortedSet tailSet(Object object) {
        return this.tailSet(object, true);
    }

    @Override
    public NavigableSet descendingSet() {
        return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.descendingMap());
    }
}

