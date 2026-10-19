/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.AbstractMap;
import edu.emory.mathcs.backport.java.util.NavigableMap;
import edu.emory.mathcs.backport.java.util.NavigableSet;
import edu.emory.mathcs.backport.java.util.TreeMap;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.AbstractSet;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.SortedSet;

public class TreeSet
extends AbstractSet
implements NavigableSet,
Cloneable,
Serializable {
    private static final long serialVersionUID = -2479143000061671589L;
    private static final Object PRESENT = new Object();
    private transient NavigableMap map;

    public TreeSet() {
        this.map = new TreeMap();
    }

    public TreeSet(Comparator comparator) {
        this.map = new TreeMap(comparator);
    }

    public TreeSet(Collection collection) {
        this.map = new TreeMap();
        this.addAll(collection);
    }

    public TreeSet(SortedSet sortedSet) {
        this.map = new TreeMap(sortedSet.comparator());
        this.addAll((Collection)sortedSet);
    }

    private TreeSet(NavigableMap navigableMap) {
        this.map = navigableMap;
    }

    @Override
    public Object lower(Object object) {
        return this.map.lowerKey(object);
    }

    @Override
    public Object floor(Object object) {
        return this.map.floorKey(object);
    }

    @Override
    public Object ceiling(Object object) {
        return this.map.ceilingKey(object);
    }

    @Override
    public Object higher(Object object) {
        return this.map.higherKey(object);
    }

    @Override
    public Object pollFirst() {
        Map.Entry entry = this.map.pollFirstEntry();
        return entry != null ? entry.getKey() : null;
    }

    @Override
    public Object pollLast() {
        Map.Entry entry = this.map.pollLastEntry();
        return entry != null ? entry.getKey() : null;
    }

    @Override
    public Iterator iterator() {
        return this.map.keySet().iterator();
    }

    @Override
    public Iterator descendingIterator() {
        return this.map.descendingKeySet().iterator();
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
    public NavigableSet subSet(Object object, boolean bl2, Object object2, boolean bl3) {
        return new TreeSet(this.map.subMap(object, bl2, object2, bl3));
    }

    @Override
    public NavigableSet headSet(Object object, boolean bl2) {
        return new TreeSet(this.map.headMap(object, bl2));
    }

    @Override
    public NavigableSet tailSet(Object object, boolean bl2) {
        return new TreeSet(this.map.tailMap(object, bl2));
    }

    @Override
    public NavigableSet descendingSet() {
        return new TreeSet(this.map.descendingMap());
    }

    public Comparator comparator() {
        return this.map.comparator();
    }

    public Object first() {
        return this.map.firstKey();
    }

    public Object last() {
        return this.map.lastKey();
    }

    @Override
    public int size() {
        return this.map.size();
    }

    @Override
    public boolean isEmpty() {
        return this.map.isEmpty();
    }

    @Override
    public boolean contains(Object object) {
        return this.map.containsKey(object);
    }

    @Override
    public Object[] toArray() {
        return this.map.keySet().toArray();
    }

    @Override
    public Object[] toArray(Object[] objectArray) {
        return this.map.keySet().toArray(objectArray);
    }

    @Override
    public boolean add(Object object) {
        return this.map.put(object, PRESENT) == null;
    }

    @Override
    public boolean remove(Object object) {
        return this.map.remove(object) != null;
    }

    @Override
    public boolean addAll(Collection collection) {
        if (this.map.size() == 0 && collection.size() > 0 && collection instanceof SortedSet && this.map instanceof TreeMap && TreeSet.eq(((SortedSet)collection).comparator(), this.comparator())) {
            ((TreeMap)this.map).buildFromSorted(new MapIterator(collection.iterator()), collection.size());
            return true;
        }
        return super.addAll(collection);
    }

    @Override
    public void clear() {
        this.map.clear();
    }

    public Object clone() {
        TreeSet treeSet;
        try {
            treeSet = (TreeSet)super.clone();
        }
        catch (CloneNotSupportedException cloneNotSupportedException) {
            throw new InternalError();
        }
        treeSet.map = new TreeMap(this.map);
        return treeSet;
    }

    private static boolean eq(Object object, Object object2) {
        return object == null ? object2 == null : object.equals(object2);
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        objectOutputStream.writeObject(this.map.comparator());
        objectOutputStream.writeInt(this.map.size());
        Iterator iterator = this.map.keySet().iterator();
        while (iterator.hasNext()) {
            objectOutputStream.writeObject(iterator.next());
        }
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        objectInputStream.defaultReadObject();
        Comparator comparator = (Comparator)objectInputStream.readObject();
        TreeMap treeMap = new TreeMap(comparator);
        int n2 = objectInputStream.readInt();
        try {
            treeMap.buildFromSorted(new IOIterator(objectInputStream, n2), n2);
            this.map = treeMap;
        }
        catch (TreeMap.IteratorIOException iteratorIOException) {
            throw iteratorIOException.getException();
        }
        catch (TreeMap.IteratorNoClassException iteratorNoClassException) {
            throw iteratorNoClassException.getException();
        }
    }

    static class IOIterator
    extends TreeMap.IOIterator {
        IOIterator(ObjectInputStream objectInputStream, int n2) {
            super(objectInputStream, n2);
        }

        @Override
        public Object next() {
            if (this.remaining <= 0) {
                throw new NoSuchElementException();
            }
            --this.remaining;
            try {
                return new AbstractMap.SimpleImmutableEntry(this.ois.readObject(), PRESENT);
            }
            catch (IOException iOException) {
                throw new TreeMap.IteratorIOException(iOException);
            }
            catch (ClassNotFoundException classNotFoundException) {
                throw new TreeMap.IteratorNoClassException(classNotFoundException);
            }
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }

    private static class MapIterator
    implements Iterator {
        final Iterator itr;

        MapIterator(Iterator iterator) {
            this.itr = iterator;
        }

        @Override
        public boolean hasNext() {
            return this.itr.hasNext();
        }

        public Object next() {
            return new AbstractMap.SimpleImmutableEntry(this.itr.next(), PRESENT);
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }
}

