/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.Deque;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.util.AbstractSequentialList;
import java.util.Collection;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;

public class LinkedList
extends AbstractSequentialList
implements List,
Deque,
Cloneable,
Serializable {
    private static final long serialVersionUID = 876323262645176354L;
    private transient int size = 0;
    private transient int modCount;
    private transient Entry head;

    public LinkedList() {
        Entry entry;
        entry.next = entry.prev = (entry = new Entry(null));
        this.head = entry;
    }

    public LinkedList(Collection collection) {
        this();
        this.addAll(collection);
    }

    @Override
    public int size() {
        return this.size;
    }

    @Override
    public boolean isEmpty() {
        return this.size == 0;
    }

    @Override
    public boolean contains(Object object) {
        return this.findFirst(object) != null;
    }

    private Entry getAt(int n2) {
        int n3 = this.size;
        if (n2 < 0 || n2 >= n3) {
            throw new ArrayIndexOutOfBoundsException("Index: " + n2 + "; Size: " + n3);
        }
        if (n2 < n3 >> 1) {
            Entry entry = this.head.next;
            while (n2 > 0) {
                entry = entry.next;
                --n2;
            }
            return entry;
        }
        Entry entry = this.head.prev;
        for (n2 = n3 - n2 - 1; n2 > 0; --n2) {
            entry = entry.prev;
        }
        return entry;
    }

    private Entry findFirst(Object object) {
        if (object == null) {
            Entry entry = this.head.next;
            while (entry != this.head) {
                if (entry.val == null) {
                    return entry;
                }
                entry = entry.next;
            }
        } else {
            Entry entry = this.head.next;
            while (entry != this.head) {
                if (object.equals(entry.val)) {
                    return entry;
                }
                entry = entry.next;
            }
        }
        return null;
    }

    private Entry findLast(Object object) {
        if (object == null) {
            Entry entry = this.head.prev;
            while (entry != this.head) {
                if (entry.val == null) {
                    return entry;
                }
                entry = entry.prev;
            }
        } else {
            Entry entry = this.head.prev;
            while (entry != this.head) {
                if (object.equals(entry.val)) {
                    return entry;
                }
                entry = entry.prev;
            }
        }
        return null;
    }

    @Override
    public int indexOf(Object object) {
        int n2 = 0;
        if (object == null) {
            Entry entry = this.head.next;
            while (entry != this.head) {
                if (entry.val == null) {
                    return n2;
                }
                entry = entry.next;
                ++n2;
            }
        } else {
            Entry entry = this.head.next;
            while (entry != this.head) {
                if (object.equals(entry.val)) {
                    return n2;
                }
                entry = entry.next;
                ++n2;
            }
        }
        return -1;
    }

    @Override
    public int lastIndexOf(Object object) {
        int n2 = this.size - 1;
        if (object == null) {
            Entry entry = this.head.prev;
            while (entry != this.head) {
                if (entry.val == null) {
                    return n2;
                }
                entry = entry.prev;
                --n2;
            }
        } else {
            Entry entry = this.head.prev;
            while (entry != this.head) {
                if (object.equals(entry.val)) {
                    return n2;
                }
                entry = entry.prev;
                --n2;
            }
        }
        return -1;
    }

    @Override
    public Object[] toArray() {
        Object[] objectArray = new Object[this.size];
        int n2 = 0;
        Entry entry = this.head.next;
        while (entry != this.head) {
            objectArray[n2++] = entry.val;
            entry = entry.next;
        }
        return objectArray;
    }

    @Override
    public Object[] toArray(Object[] objectArray) {
        int n2 = this.size;
        if (objectArray.length < n2) {
            objectArray = (Object[])Array.newInstance(objectArray.getClass().getComponentType(), n2);
        }
        int n3 = 0;
        Entry entry = this.head.next;
        while (entry != this.head) {
            objectArray[n3++] = entry.val;
            entry = entry.next;
        }
        if (n3 < objectArray.length) {
            objectArray[n3++] = null;
        }
        return objectArray;
    }

    @Override
    public boolean add(Object object) {
        this.insertBefore(this.head, object);
        return true;
    }

    private void insertAfter(Entry entry, Object object) {
        ++this.modCount;
        Entry entry2 = entry.next;
        Entry entry3 = new Entry(object);
        entry3.prev = entry;
        entry3.next = entry2;
        entry.next = entry3;
        entry2.prev = entry3;
        ++this.size;
    }

    private void insertBefore(Entry entry, Object object) {
        ++this.modCount;
        Entry entry2 = entry.prev;
        Entry entry3 = new Entry(object);
        entry3.prev = entry2;
        entry3.next = entry;
        entry2.next = entry3;
        entry.prev = entry3;
        ++this.size;
    }

    private Object remove(Entry entry) {
        if (entry == this.head) {
            throw new NoSuchElementException();
        }
        ++this.modCount;
        Entry entry2 = entry.next;
        Entry entry3 = entry.prev;
        entry3.next = entry2;
        entry2.prev = entry3;
        --this.size;
        return entry.val;
    }

    @Override
    public boolean remove(Object object) {
        Entry entry = this.findFirst(object);
        if (entry == null) {
            return false;
        }
        this.remove(entry);
        return true;
    }

    @Override
    public boolean addAll(Collection collection) {
        return this.insertAllBefore(this.head, collection);
    }

    @Override
    public boolean addAll(int n2, Collection collection) {
        return this.insertAllBefore(n2 == this.size ? this.head : this.getAt(n2), collection);
    }

    private boolean insertAllBefore(Entry entry, Collection collection) {
        Entry entry2;
        Entry entry3;
        Iterator iterator = collection.iterator();
        if (!iterator.hasNext()) {
            return false;
        }
        ++this.modCount;
        Entry entry4 = entry3 = new Entry(iterator.next());
        Entry entry5 = entry3;
        int n2 = 1;
        while (iterator.hasNext()) {
            entry4.next = entry5 = new Entry(iterator.next());
            entry5.prev = entry4;
            entry4 = entry5;
            ++n2;
        }
        entry3.prev = entry2 = entry.prev;
        entry5.next = entry;
        entry2.next = entry3;
        entry.prev = entry5;
        this.size += n2;
        return true;
    }

    @Override
    public void clear() {
        ++this.modCount;
        this.head.next = this.head.prev = this.head;
        this.size = 0;
    }

    @Override
    public Object get(int n2) {
        return this.getAt((int)n2).val;
    }

    @Override
    public Object set(int n2, Object object) {
        Entry entry = this.getAt(n2);
        Object object2 = entry.val;
        entry.val = object;
        return object2;
    }

    @Override
    public void add(int n2, Object object) {
        if (n2 == this.size) {
            this.insertBefore(this.head, object);
        } else {
            this.insertBefore(n2 == this.size ? this.head : this.getAt(n2), object);
        }
    }

    @Override
    public Object remove(int n2) {
        return this.remove(this.getAt(n2));
    }

    @Override
    public ListIterator listIterator() {
        return new Itr();
    }

    @Override
    public ListIterator listIterator(int n2) {
        return new Itr(n2 == this.size ? this.head : this.getAt(n2), n2);
    }

    @Override
    public void addFirst(Object object) {
        this.insertAfter(this.head, object);
    }

    @Override
    public void addLast(Object object) {
        this.insertBefore(this.head, object);
    }

    @Override
    public boolean offerFirst(Object object) {
        this.insertAfter(this.head, object);
        return true;
    }

    @Override
    public boolean offerLast(Object object) {
        this.insertBefore(this.head, object);
        return true;
    }

    @Override
    public Object removeFirst() {
        return this.remove(this.head.next);
    }

    @Override
    public Object removeLast() {
        return this.remove(this.head.prev);
    }

    @Override
    public Object pollFirst() {
        return this.size == 0 ? null : this.remove(this.head.next);
    }

    @Override
    public Object pollLast() {
        return this.size == 0 ? null : this.remove(this.head.prev);
    }

    @Override
    public Object getFirst() {
        if (this.size == 0) {
            throw new NoSuchElementException();
        }
        return this.head.next.val;
    }

    @Override
    public Object getLast() {
        if (this.size == 0) {
            throw new NoSuchElementException();
        }
        return this.head.prev.val;
    }

    @Override
    public Object peekFirst() {
        return this.size == 0 ? null : this.head.next.val;
    }

    @Override
    public Object peekLast() {
        return this.size == 0 ? null : this.head.prev.val;
    }

    @Override
    public boolean removeFirstOccurrence(Object object) {
        Entry entry = this.findFirst(object);
        if (entry == null) {
            return false;
        }
        this.remove(entry);
        return true;
    }

    @Override
    public boolean removeLastOccurrence(Object object) {
        Entry entry = this.findLast(object);
        if (entry == null) {
            return false;
        }
        this.remove(entry);
        return true;
    }

    @Override
    public boolean offer(Object object) {
        return this.add(object);
    }

    @Override
    public Object remove() {
        return this.removeFirst();
    }

    @Override
    public Object poll() {
        return this.pollFirst();
    }

    @Override
    public Object element() {
        return this.getFirst();
    }

    @Override
    public Object peek() {
        return this.peekFirst();
    }

    @Override
    public void push(Object object) {
        this.addFirst(object);
    }

    @Override
    public Object pop() {
        return this.removeFirst();
    }

    @Override
    public Iterator descendingIterator() {
        return new DescItr();
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        objectOutputStream.writeInt(this.size);
        Entry entry = this.head.next;
        while (entry != this.head) {
            objectOutputStream.writeObject(entry.val);
            entry = entry.next;
        }
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        Entry entry;
        objectInputStream.defaultReadObject();
        int n2 = objectInputStream.readInt();
        entry.next = entry.prev = (entry = new Entry(null));
        for (int i2 = 0; i2 < n2; ++i2) {
            this.insertBefore(entry, objectInputStream.readObject());
        }
        this.size = n2;
        this.head = entry;
    }

    public Object clone() {
        Entry entry;
        LinkedList linkedList = null;
        try {
            linkedList = (LinkedList)super.clone();
        }
        catch (CloneNotSupportedException cloneNotSupportedException) {
            throw new InternalError();
        }
        entry.next = entry.prev = (entry = new Entry(null));
        linkedList.head = entry;
        linkedList.addAll((Collection)this);
        return linkedList;
    }

    private class DescItr
    implements ListIterator {
        int expectedModCount;
        int idx;
        Entry cursor;
        Entry lastRet;

        DescItr(Entry entry, int n2) {
            this.cursor = entry;
            this.idx = n2;
            this.expectedModCount = LinkedList.this.modCount;
        }

        DescItr() {
            this(((LinkedList)linkedList).head.prev, 0);
        }

        @Override
        public boolean hasNext() {
            return this.cursor != LinkedList.this.head;
        }

        @Override
        public int nextIndex() {
            return this.idx;
        }

        @Override
        public boolean hasPrevious() {
            return this.cursor.next != LinkedList.this.head;
        }

        @Override
        public int previousIndex() {
            return this.idx - 1;
        }

        @Override
        public Object next() {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            if (this.cursor == LinkedList.this.head) {
                throw new NoSuchElementException();
            }
            this.lastRet = this.cursor;
            this.cursor = this.cursor.prev;
            ++this.idx;
            return this.lastRet.val;
        }

        public Object previous() {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            if (this.cursor.next == LinkedList.this.head) {
                throw new NoSuchElementException();
            }
            this.lastRet = this.cursor = this.cursor.next;
            --this.idx;
            return this.lastRet;
        }

        public void add(Object object) {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            LinkedList.this.insertAfter(this.cursor, object);
            this.lastRet = null;
            ++this.idx;
            ++this.expectedModCount;
        }

        public void set(Object object) {
            if (this.lastRet == null) {
                throw new IllegalStateException();
            }
            this.lastRet.val = object;
        }

        @Override
        public void remove() {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            if (this.lastRet == null) {
                throw new IllegalStateException();
            }
            if (this.lastRet.next == this.cursor) {
                --this.idx;
            } else {
                this.cursor = this.lastRet.next;
            }
            LinkedList.this.remove(this.lastRet);
            this.lastRet = null;
            ++this.expectedModCount;
        }
    }

    private class Itr
    implements ListIterator {
        int expectedModCount;
        int idx;
        Entry cursor;
        Entry lastRet;

        Itr(Entry entry, int n2) {
            this.cursor = entry;
            this.idx = n2;
            this.expectedModCount = LinkedList.this.modCount;
        }

        Itr() {
            this(((LinkedList)linkedList).head.next, 0);
        }

        @Override
        public boolean hasNext() {
            return this.cursor != LinkedList.this.head;
        }

        @Override
        public int nextIndex() {
            return this.idx;
        }

        @Override
        public boolean hasPrevious() {
            return this.cursor.prev != LinkedList.this.head;
        }

        @Override
        public int previousIndex() {
            return this.idx - 1;
        }

        @Override
        public Object next() {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            if (this.cursor == LinkedList.this.head) {
                throw new NoSuchElementException();
            }
            this.lastRet = this.cursor;
            this.cursor = this.cursor.next;
            ++this.idx;
            return this.lastRet.val;
        }

        public Object previous() {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            if (this.cursor.prev == LinkedList.this.head) {
                throw new NoSuchElementException();
            }
            this.lastRet = this.cursor = this.cursor.prev;
            --this.idx;
            return this.lastRet.val;
        }

        public void add(Object object) {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            LinkedList.this.insertBefore(this.cursor, object);
            this.lastRet = null;
            ++this.idx;
            ++this.expectedModCount;
        }

        public void set(Object object) {
            if (this.lastRet == null) {
                throw new IllegalStateException();
            }
            this.lastRet.val = object;
        }

        @Override
        public void remove() {
            if (this.expectedModCount != LinkedList.this.modCount) {
                throw new ConcurrentModificationException();
            }
            if (this.lastRet == null) {
                throw new IllegalStateException();
            }
            if (this.lastRet.next == this.cursor) {
                --this.idx;
            } else {
                this.cursor = this.lastRet.next;
            }
            LinkedList.this.remove(this.lastRet);
            this.lastRet = null;
            ++this.expectedModCount;
        }
    }

    private static class Entry {
        Entry prev;
        Entry next;
        Object val;

        Entry(Object object) {
            this.val = object;
        }
    }
}

