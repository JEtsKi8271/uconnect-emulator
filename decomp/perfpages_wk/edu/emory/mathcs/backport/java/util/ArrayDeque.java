/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.AbstractCollection;
import edu.emory.mathcs.backport.java.util.Arrays;
import edu.emory.mathcs.backport.java.util.Deque;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.util.Collection;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class ArrayDeque
extends AbstractCollection
implements Deque,
Cloneable,
Serializable {
    private transient Object[] elements;
    private transient int head;
    private transient int tail;
    private static final int MIN_INITIAL_CAPACITY = 8;
    private static final long serialVersionUID = 2340985798034038923L;

    private void allocateElements(int n2) {
        int n3 = 8;
        if (n2 >= n3) {
            n3 = n2;
            n3 |= n3 >>> 1;
            n3 |= n3 >>> 2;
            n3 |= n3 >>> 4;
            n3 |= n3 >>> 8;
            n3 |= n3 >>> 16;
            if (++n3 < 0) {
                n3 >>>= 1;
            }
        }
        this.elements = new Object[n3];
    }

    private void doubleCapacity() {
        assert (this.head == this.tail);
        int n2 = this.head;
        int n3 = this.elements.length;
        int n4 = n3 - n2;
        int n5 = n3 << 1;
        if (n5 < 0) {
            throw new IllegalStateException("Sorry, deque too big");
        }
        Object[] objectArray = new Object[n5];
        System.arraycopy(this.elements, n2, objectArray, 0, n4);
        System.arraycopy(this.elements, 0, objectArray, n4, n2);
        this.elements = objectArray;
        this.head = 0;
        this.tail = n3;
    }

    private Object[] copyElements(Object[] objectArray) {
        if (this.head < this.tail) {
            System.arraycopy(this.elements, this.head, objectArray, 0, this.size());
        } else if (this.head > this.tail) {
            int n2 = this.elements.length - this.head;
            System.arraycopy(this.elements, this.head, objectArray, 0, n2);
            System.arraycopy(this.elements, 0, objectArray, n2, this.tail);
        }
        return objectArray;
    }

    public ArrayDeque() {
        this.elements = new Object[16];
    }

    public ArrayDeque(int n2) {
        this.allocateElements(n2);
    }

    public ArrayDeque(Collection collection) {
        this.allocateElements(collection.size());
        this.addAll(collection);
    }

    @Override
    public void addFirst(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        this.head = this.head - 1 & this.elements.length - 1;
        this.elements[this.head] = object;
        if (this.head == this.tail) {
            this.doubleCapacity();
        }
    }

    @Override
    public void addLast(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        this.elements[this.tail] = object;
        this.tail = this.tail + 1 & this.elements.length - 1;
        if (this.tail == this.head) {
            this.doubleCapacity();
        }
    }

    @Override
    public boolean offerFirst(Object object) {
        this.addFirst(object);
        return true;
    }

    @Override
    public boolean offerLast(Object object) {
        this.addLast(object);
        return true;
    }

    @Override
    public Object removeFirst() {
        Object object = this.pollFirst();
        if (object == null) {
            throw new NoSuchElementException();
        }
        return object;
    }

    @Override
    public Object removeLast() {
        Object object = this.pollLast();
        if (object == null) {
            throw new NoSuchElementException();
        }
        return object;
    }

    @Override
    public Object pollFirst() {
        int n2 = this.head;
        Object object = this.elements[n2];
        if (object == null) {
            return null;
        }
        this.elements[n2] = null;
        this.head = n2 + 1 & this.elements.length - 1;
        return object;
    }

    @Override
    public Object pollLast() {
        int n2 = this.tail - 1 & this.elements.length - 1;
        Object object = this.elements[n2];
        if (object == null) {
            return null;
        }
        this.elements[n2] = null;
        this.tail = n2;
        return object;
    }

    @Override
    public Object getFirst() {
        Object object = this.elements[this.head];
        if (object == null) {
            throw new NoSuchElementException();
        }
        return object;
    }

    @Override
    public Object getLast() {
        Object object = this.elements[this.tail - 1 & this.elements.length - 1];
        if (object == null) {
            throw new NoSuchElementException();
        }
        return object;
    }

    @Override
    public Object peekFirst() {
        return this.elements[this.head];
    }

    @Override
    public Object peekLast() {
        return this.elements[this.tail - 1 & this.elements.length - 1];
    }

    @Override
    public boolean removeFirstOccurrence(Object object) {
        Object object2;
        if (object == null) {
            return false;
        }
        int n2 = this.elements.length - 1;
        int n3 = this.head;
        while ((object2 = this.elements[n3]) != null) {
            if (object.equals(object2)) {
                this.delete(n3);
                return true;
            }
            n3 = n3 + 1 & n2;
        }
        return false;
    }

    @Override
    public boolean removeLastOccurrence(Object object) {
        Object object2;
        if (object == null) {
            return false;
        }
        int n2 = this.elements.length - 1;
        int n3 = this.tail - 1 & n2;
        while ((object2 = this.elements[n3]) != null) {
            if (object.equals(object2)) {
                this.delete(n3);
                return true;
            }
            n3 = n3 - 1 & n2;
        }
        return false;
    }

    @Override
    public boolean add(Object object) {
        this.addLast(object);
        return true;
    }

    @Override
    public boolean offer(Object object) {
        return this.offerLast(object);
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

    private void checkInvariants() {
        assert (this.elements[this.tail] == null);
        assert (this.head != this.tail ? this.elements[this.head] != null && this.elements[this.tail - 1 & this.elements.length - 1] != null : this.elements[this.head] == null);
        assert (this.elements[this.head - 1 & this.elements.length - 1] == null);
    }

    private boolean delete(int n2) {
        this.checkInvariants();
        Object[] objectArray = this.elements;
        int n3 = objectArray.length - 1;
        int n4 = this.head;
        int n5 = this.tail;
        int n6 = n2 - n4 & n3;
        int n7 = n5 - n2 & n3;
        if (n6 >= (n5 - n4 & n3)) {
            throw new ConcurrentModificationException();
        }
        if (n6 < n7) {
            if (n4 <= n2) {
                System.arraycopy(objectArray, n4, objectArray, n4 + 1, n6);
            } else {
                System.arraycopy(objectArray, 0, objectArray, 1, n2);
                objectArray[0] = objectArray[n3];
                System.arraycopy(objectArray, n4, objectArray, n4 + 1, n3 - n4);
            }
            objectArray[n4] = null;
            this.head = n4 + 1 & n3;
            return false;
        }
        if (n2 < n5) {
            System.arraycopy(objectArray, n2 + 1, objectArray, n2, n7);
            this.tail = n5 - 1;
        } else {
            System.arraycopy(objectArray, n2 + 1, objectArray, n2, n3 - n2);
            objectArray[n3] = objectArray[0];
            System.arraycopy(objectArray, 1, objectArray, 0, n5);
            this.tail = n5 - 1 & n3;
        }
        return true;
    }

    @Override
    public int size() {
        return this.tail - this.head & this.elements.length - 1;
    }

    @Override
    public boolean isEmpty() {
        return this.head == this.tail;
    }

    @Override
    public Iterator iterator() {
        return new DeqIterator();
    }

    @Override
    public Iterator descendingIterator() {
        return new DescendingIterator();
    }

    @Override
    public boolean contains(Object object) {
        Object object2;
        if (object == null) {
            return false;
        }
        int n2 = this.elements.length - 1;
        int n3 = this.head;
        while ((object2 = this.elements[n3]) != null) {
            if (object.equals(object2)) {
                return true;
            }
            n3 = n3 + 1 & n2;
        }
        return false;
    }

    @Override
    public boolean remove(Object object) {
        return this.removeFirstOccurrence(object);
    }

    @Override
    public void clear() {
        int n2 = this.head;
        int n3 = this.tail;
        if (n2 != n3) {
            this.tail = 0;
            this.head = 0;
            int n4 = n2;
            int n5 = this.elements.length - 1;
            do {
                this.elements[n4] = null;
            } while ((n4 = n4 + 1 & n5) != n3);
        }
    }

    @Override
    public Object[] toArray() {
        return this.copyElements(new Object[this.size()]);
    }

    @Override
    public Object[] toArray(Object[] objectArray) {
        int n2 = this.size();
        if (objectArray.length < n2) {
            objectArray = (Object[])Array.newInstance(objectArray.getClass().getComponentType(), n2);
        }
        this.copyElements(objectArray);
        if (objectArray.length > n2) {
            objectArray[n2] = null;
        }
        return objectArray;
    }

    public Object clone() {
        try {
            ArrayDeque arrayDeque = (ArrayDeque)super.clone();
            arrayDeque.elements = Arrays.copyOf(this.elements, this.elements.length);
            return arrayDeque;
        }
        catch (CloneNotSupportedException cloneNotSupportedException) {
            throw new AssertionError();
        }
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        objectOutputStream.writeInt(this.size());
        int n2 = this.elements.length - 1;
        int n3 = this.head;
        while (n3 != this.tail) {
            objectOutputStream.writeObject(this.elements[n3]);
            n3 = n3 + 1 & n2;
        }
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        objectInputStream.defaultReadObject();
        int n2 = objectInputStream.readInt();
        this.allocateElements(n2);
        this.head = 0;
        this.tail = n2;
        for (int i2 = 0; i2 < n2; ++i2) {
            this.elements[i2] = objectInputStream.readObject();
        }
    }

    private class DescendingIterator
    implements Iterator {
        private int cursor;
        private int fence;
        private int lastRet;

        private DescendingIterator() {
            this.cursor = ArrayDeque.this.tail;
            this.fence = ArrayDeque.this.head;
            this.lastRet = -1;
        }

        @Override
        public boolean hasNext() {
            return this.cursor != this.fence;
        }

        public Object next() {
            if (this.cursor == this.fence) {
                throw new NoSuchElementException();
            }
            this.cursor = this.cursor - 1 & ArrayDeque.this.elements.length - 1;
            Object object = ArrayDeque.this.elements[this.cursor];
            if (ArrayDeque.this.head != this.fence || object == null) {
                throw new ConcurrentModificationException();
            }
            this.lastRet = this.cursor;
            return object;
        }

        @Override
        public void remove() {
            if (this.lastRet < 0) {
                throw new IllegalStateException();
            }
            if (!ArrayDeque.this.delete(this.lastRet)) {
                this.cursor = this.cursor + 1 & ArrayDeque.this.elements.length - 1;
                this.fence = ArrayDeque.this.head;
            }
            this.lastRet = -1;
        }
    }

    private class DeqIterator
    implements Iterator {
        private int cursor;
        private int fence;
        private int lastRet;

        private DeqIterator() {
            this.cursor = ArrayDeque.this.head;
            this.fence = ArrayDeque.this.tail;
            this.lastRet = -1;
        }

        @Override
        public boolean hasNext() {
            return this.cursor != this.fence;
        }

        public Object next() {
            if (this.cursor == this.fence) {
                throw new NoSuchElementException();
            }
            Object object = ArrayDeque.this.elements[this.cursor];
            if (ArrayDeque.this.tail != this.fence || object == null) {
                throw new ConcurrentModificationException();
            }
            this.lastRet = this.cursor;
            this.cursor = this.cursor + 1 & ArrayDeque.this.elements.length - 1;
            return object;
        }

        @Override
        public void remove() {
            if (this.lastRet < 0) {
                throw new IllegalStateException();
            }
            if (ArrayDeque.this.delete(this.lastRet)) {
                this.cursor = this.cursor - 1 & ArrayDeque.this.elements.length - 1;
                this.fence = ArrayDeque.this.tail;
            }
            this.lastRet = -1;
        }
    }
}

