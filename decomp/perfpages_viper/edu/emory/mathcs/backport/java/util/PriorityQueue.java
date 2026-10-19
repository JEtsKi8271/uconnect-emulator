/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.AbstractQueue;
import edu.emory.mathcs.backport.java.util.Arrays;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.SortedSet;

public class PriorityQueue
extends AbstractQueue
implements Serializable {
    private static final long serialVersionUID = -7720805057305804111L;
    private static final int DEFAULT_INIT_CAPACITY = 11;
    private transient Object[] buffer;
    private int size;
    private final Comparator comparator;
    private transient int modCount;

    public PriorityQueue() {
        this(11, null);
    }

    public PriorityQueue(int n2) {
        this(n2, null);
    }

    public PriorityQueue(Comparator comparator) {
        this(11, comparator);
    }

    public PriorityQueue(int n2, Comparator comparator) {
        if (n2 < 1) {
            throw new IllegalArgumentException();
        }
        this.buffer = new Object[n2];
        this.comparator = comparator;
    }

    public PriorityQueue(PriorityQueue priorityQueue) {
        this((Collection)priorityQueue);
    }

    public PriorityQueue(SortedSet sortedSet) {
        this((Collection)sortedSet);
    }

    public PriorityQueue(Collection collection) {
        int n2 = collection.size();
        if ((n2 += this.size / 10) < 0) {
            n2 = Integer.MAX_VALUE;
        } else if (n2 == 0) {
            n2 = 1;
        }
        this.buffer = new Object[n2];
        if (collection instanceof PriorityQueue) {
            PriorityQueue priorityQueue = (PriorityQueue)collection;
            this.comparator = priorityQueue.comparator;
            this.size = priorityQueue.size;
            System.arraycopy(priorityQueue.buffer, 0, this.buffer, 0, this.size);
        } else if (collection instanceof SortedSet) {
            SortedSet sortedSet = (SortedSet)collection;
            this.comparator = sortedSet.comparator();
            Iterator iterator = sortedSet.iterator();
            while (iterator.hasNext()) {
                this.buffer[this.size++] = iterator.next();
            }
        } else {
            this.comparator = null;
            Iterator iterator = collection.iterator();
            while (iterator.hasNext()) {
                this.buffer[this.size++] = iterator.next();
            }
            for (int i2 = this.size / 2; i2 >= 0; --i2) {
                this.percolateDown(i2, this.buffer[i2]);
            }
        }
    }

    @Override
    public Iterator iterator() {
        return new Itr();
    }

    public Comparator comparator() {
        return this.comparator;
    }

    @Override
    public boolean offer(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        if (this.size == this.buffer.length) {
            int n2 = this.buffer.length * 2;
            if (n2 < this.buffer.length) {
                if (this.buffer.length == Integer.MAX_VALUE) {
                    throw new OutOfMemoryError();
                }
                n2 = Integer.MAX_VALUE;
            }
            Object[] objectArray = new Object[n2];
            System.arraycopy(this.buffer, 0, objectArray, 0, this.size);
            this.buffer = objectArray;
        }
        ++this.modCount;
        this.percolateUp(this.size++, object);
        return true;
    }

    @Override
    public Object peek() {
        return this.size == 0 ? null : this.buffer[0];
    }

    @Override
    public Object poll() {
        if (this.size == 0) {
            return null;
        }
        ++this.modCount;
        Object object = this.buffer[0];
        --this.size;
        this.percolateDown(0, this.buffer[this.size]);
        this.buffer[this.size] = null;
        return object;
    }

    @Override
    public int size() {
        return this.size;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private int percolateDown(int n2, Object object) {
        try {
            if (this.comparator != null) {
                int n3;
                while ((n3 = (n2 << 1) + 1) < this.size) {
                    if (n3 + 1 < this.size && this.comparator.compare(this.buffer[n3], this.buffer[n3 + 1]) > 0) {
                        ++n3;
                    }
                    if (this.comparator.compare(object, this.buffer[n3]) > 0) {
                        this.buffer[n2] = this.buffer[n3];
                        n2 = n3;
                        continue;
                    }
                    break;
                }
            } else {
                int n4;
                Comparable comparable = (Comparable)object;
                while ((n4 = (n2 << 1) + 1) < this.size) {
                    if (n4 + 1 < this.size && ((Comparable)this.buffer[n4]).compareTo(this.buffer[n4 + 1]) > 0) {
                        ++n4;
                    }
                    if (comparable.compareTo(this.buffer[n4]) > 0) {
                        this.buffer[n2] = this.buffer[n4];
                        n2 = n4;
                        continue;
                    }
                    break;
                }
            }
            int n5 = n2;
            return n5;
        }
        finally {
            this.buffer[n2] = object;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private int percolateUp(int n2, Object object) {
        try {
            int n3;
            if (this.comparator != null) {
                int n4;
                while (n2 > 0 && this.comparator.compare(object, this.buffer[n4 = n2 - 1 >>> 1]) < 0) {
                    this.buffer[n2] = this.buffer[n4];
                    n2 = n4;
                }
                n4 = n2;
                return n4;
            }
            Comparable comparable = (Comparable)object;
            while (n2 > 0 && comparable.compareTo(this.buffer[n3 = n2 - 1 >>> 1]) < 0) {
                this.buffer[n2] = this.buffer[n3];
                n2 = n3;
            }
            n3 = n2;
            return n3;
        }
        finally {
            this.buffer[n2] = object;
        }
    }

    @Override
    public boolean add(Object object) {
        return this.offer(object);
    }

    @Override
    public Object remove() {
        if (this.size == 0) {
            throw new NoSuchElementException();
        }
        Object object = this.buffer[0];
        ++this.modCount;
        --this.size;
        this.percolateDown(0, this.buffer[this.size]);
        this.buffer[this.size] = null;
        return object;
    }

    @Override
    public Object element() {
        if (this.size == 0) {
            throw new NoSuchElementException();
        }
        return this.buffer[0];
    }

    @Override
    public boolean isEmpty() {
        return this.size == 0;
    }

    @Override
    public boolean contains(Object object) {
        for (int i2 = 0; i2 < this.size; ++i2) {
            if (!object.equals(this.buffer[i2])) continue;
            return true;
        }
        return false;
    }

    @Override
    public Object[] toArray() {
        return Arrays.copyOf(this.buffer, this.size, Object[].class);
    }

    @Override
    public Object[] toArray(Object[] objectArray) {
        if (objectArray.length < this.size) {
            return Arrays.copyOf(this.buffer, this.size, objectArray.getClass());
        }
        System.arraycopy(this.buffer, 0, objectArray, 0, this.size);
        if (objectArray.length > this.size) {
            objectArray[this.size] = null;
        }
        return objectArray;
    }

    @Override
    public boolean remove(Object object) {
        if (object == null) {
            return false;
        }
        if (this.comparator != null) {
            for (int i2 = 0; i2 < this.size; ++i2) {
                if (this.comparator.compare(this.buffer[i2], object) != 0) continue;
                this.removeAt(i2);
                return true;
            }
        } else {
            for (int i3 = 0; i3 < this.size; ++i3) {
                if (((Comparable)this.buffer[i3]).compareTo(object) != 0) continue;
                this.removeAt(i3);
                return true;
            }
        }
        return false;
    }

    private Object removeAt(int n2) {
        assert (n2 < this.size);
        ++this.modCount;
        --this.size;
        Object object = this.buffer[this.size];
        this.buffer[this.size] = null;
        int n3 = this.percolateDown(n2, object);
        if (n3 != n2) {
            return null;
        }
        n3 = this.percolateUp(n2, object);
        return n3 < n2 ? object : null;
    }

    @Override
    public void clear() {
        ++this.modCount;
        Arrays.fill(this.buffer, 0, this.size, null);
        this.size = 0;
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        objectOutputStream.writeInt(this.buffer.length);
        for (int i2 = 0; i2 < this.size; ++i2) {
            objectOutputStream.writeObject(this.buffer[i2]);
        }
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        objectInputStream.defaultReadObject();
        this.buffer = new Object[objectInputStream.readInt()];
        for (int i2 = 0; i2 < this.size; ++i2) {
            this.buffer[i2] = objectInputStream.readObject();
        }
    }

    private class Itr
    implements Iterator {
        int cursor = 0;
        List percolatedElems;
        int cursorPercolated = 0;
        int expectedModCount = PriorityQueue.access$000(PriorityQueue.this);
        int lastRet;
        Object lastRetPercolated;

        Itr() {
        }

        @Override
        public boolean hasNext() {
            return this.cursor < PriorityQueue.this.size || this.percolatedElems != null;
        }

        public Object next() {
            this.checkForComodification();
            if (this.cursor < PriorityQueue.this.size) {
                this.lastRet = this.cursor++;
                return PriorityQueue.this.buffer[this.lastRet];
            }
            if (this.percolatedElems != null) {
                this.lastRet = -1;
                this.lastRetPercolated = this.percolatedElems.remove(this.percolatedElems.size() - 1);
                if (this.percolatedElems.isEmpty()) {
                    this.percolatedElems = null;
                }
                return this.lastRetPercolated;
            }
            throw new NoSuchElementException();
        }

        @Override
        public void remove() {
            if (this.lastRet >= 0) {
                Object object = PriorityQueue.this.removeAt(this.lastRet);
                this.lastRet = -1;
                if (object == null) {
                    --this.cursor;
                } else {
                    if (this.percolatedElems == null) {
                        this.percolatedElems = new ArrayList();
                    }
                    this.percolatedElems.add(object);
                }
            } else if (this.lastRetPercolated != null) {
                PriorityQueue.this.remove(this.lastRetPercolated);
                this.lastRetPercolated = null;
            } else {
                throw new IllegalStateException();
            }
            this.expectedModCount = PriorityQueue.this.modCount;
        }

        private void checkForComodification() {
            if (this.expectedModCount != PriorityQueue.this.modCount) {
                throw new ConcurrentModificationException();
            }
        }
    }
}

