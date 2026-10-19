/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractQueue;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingDeque;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import edu.emory.mathcs.backport.java.util.concurrent.locks.ReentrantLock;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class LinkedBlockingDeque
extends AbstractQueue
implements BlockingDeque,
Serializable {
    private static final long serialVersionUID = -387911632671998426L;
    private transient Node first;
    private transient Node last;
    private transient int count;
    private final int capacity;
    private final ReentrantLock lock = new ReentrantLock();
    private final Condition notEmpty = this.lock.newCondition();
    private final Condition notFull = this.lock.newCondition();

    public LinkedBlockingDeque() {
        this(Integer.MAX_VALUE);
    }

    public LinkedBlockingDeque(int n2) {
        if (n2 <= 0) {
            throw new IllegalArgumentException();
        }
        this.capacity = n2;
    }

    public LinkedBlockingDeque(Collection collection) {
        this(Integer.MAX_VALUE);
        for (Object e2 : collection) {
            this.add(e2);
        }
    }

    private boolean linkFirst(Object object) {
        Node node;
        if (this.count >= this.capacity) {
            return false;
        }
        ++this.count;
        Node node2 = this.first;
        this.first = node = new Node(object, null, node2);
        if (this.last == null) {
            this.last = node;
        } else {
            node2.prev = node;
        }
        this.notEmpty.signal();
        return true;
    }

    private boolean linkLast(Object object) {
        Node node;
        if (this.count >= this.capacity) {
            return false;
        }
        ++this.count;
        Node node2 = this.last;
        this.last = node = new Node(object, node2, null);
        if (this.first == null) {
            this.first = node;
        } else {
            node2.next = node;
        }
        this.notEmpty.signal();
        return true;
    }

    private Object unlinkFirst() {
        Node node;
        Node node2 = this.first;
        if (node2 == null) {
            return null;
        }
        this.first = node = node2.next;
        if (node == null) {
            this.last = null;
        } else {
            node.prev = null;
        }
        --this.count;
        this.notFull.signal();
        return node2.item;
    }

    private Object unlinkLast() {
        Node node;
        Node node2 = this.last;
        if (node2 == null) {
            return null;
        }
        this.last = node = node2.prev;
        if (node == null) {
            this.first = null;
        } else {
            node.next = null;
        }
        --this.count;
        this.notFull.signal();
        return node2.item;
    }

    private void unlink(Node node) {
        Node node2 = node.prev;
        Node node3 = node.next;
        if (node2 == null) {
            if (node3 == null) {
                this.last = null;
                this.first = null;
            } else {
                node3.prev = null;
                this.first = node3;
            }
        } else if (node3 == null) {
            node2.next = null;
            this.last = node2;
        } else {
            node2.next = node3;
            node3.prev = node2;
        }
        --this.count;
        this.notFull.signalAll();
    }

    @Override
    public void addFirst(Object object) {
        if (!this.offerFirst(object)) {
            throw new IllegalStateException("Deque full");
        }
    }

    @Override
    public void addLast(Object object) {
        if (!this.offerLast(object)) {
            throw new IllegalStateException("Deque full");
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean offerFirst(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        this.lock.lock();
        try {
            boolean bl2 = this.linkFirst(object);
            return bl2;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean offerLast(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        this.lock.lock();
        try {
            boolean bl2 = this.linkLast(object);
            return bl2;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void putFirst(Object object) throws InterruptedException {
        if (object == null) {
            throw new NullPointerException();
        }
        this.lock.lock();
        try {
            while (!this.linkFirst(object)) {
                this.notFull.await();
            }
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void putLast(Object object) throws InterruptedException {
        if (object == null) {
            throw new NullPointerException();
        }
        this.lock.lock();
        try {
            while (!this.linkLast(object)) {
                this.notFull.await();
            }
        }
        finally {
            this.lock.unlock();
        }
    }

    @Override
    public boolean offerFirst(Object object, long l2, TimeUnit timeUnit) throws InterruptedException {
        if (object == null) {
            throw new NullPointerException();
        }
        long l3 = timeUnit.toNanos(l2);
        long l4 = Utils.nanoTime() + l3;
        this.lock.lockInterruptibly();
        try {
            while (true) {
                if (this.linkFirst(object)) {
                    boolean bl2 = true;
                    return bl2;
                }
                if (l3 <= 0L) {
                    boolean bl3 = false;
                    return bl3;
                }
                this.notFull.await(l3, TimeUnit.NANOSECONDS);
                l3 = l4 - Utils.nanoTime();
            }
        }
        finally {
            this.lock.unlock();
        }
    }

    @Override
    public boolean offerLast(Object object, long l2, TimeUnit timeUnit) throws InterruptedException {
        if (object == null) {
            throw new NullPointerException();
        }
        long l3 = timeUnit.toNanos(l2);
        long l4 = Utils.nanoTime() + l3;
        this.lock.lockInterruptibly();
        try {
            while (true) {
                if (this.linkLast(object)) {
                    boolean bl2 = true;
                    return bl2;
                }
                if (l3 <= 0L) {
                    boolean bl3 = false;
                    return bl3;
                }
                this.notFull.await(l3, TimeUnit.NANOSECONDS);
                l3 = l4 - Utils.nanoTime();
            }
        }
        finally {
            this.lock.unlock();
        }
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

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object pollFirst() {
        this.lock.lock();
        try {
            Object object = this.unlinkFirst();
            return object;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object pollLast() {
        this.lock.lock();
        try {
            Object object = this.unlinkLast();
            return object;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object takeFirst() throws InterruptedException {
        this.lock.lock();
        try {
            Object object;
            while ((object = this.unlinkFirst()) == null) {
                this.notEmpty.await();
            }
            Object object2 = object;
            return object2;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object takeLast() throws InterruptedException {
        this.lock.lock();
        try {
            Object object;
            while ((object = this.unlinkLast()) == null) {
                this.notEmpty.await();
            }
            Object object2 = object;
            return object2;
        }
        finally {
            this.lock.unlock();
        }
    }

    @Override
    public Object pollFirst(long l2, TimeUnit timeUnit) throws InterruptedException {
        long l3 = timeUnit.toNanos(l2);
        long l4 = Utils.nanoTime() + l3;
        this.lock.lockInterruptibly();
        try {
            while (true) {
                Object object;
                if ((object = this.unlinkFirst()) != null) {
                    Object object2 = object;
                    return object2;
                }
                if (l3 <= 0L) {
                    Object var9_7 = null;
                    return var9_7;
                }
                this.notEmpty.await(l3, TimeUnit.NANOSECONDS);
                l3 = l4 - Utils.nanoTime();
            }
        }
        finally {
            this.lock.unlock();
        }
    }

    @Override
    public Object pollLast(long l2, TimeUnit timeUnit) throws InterruptedException {
        long l3 = timeUnit.toNanos(l2);
        long l4 = Utils.nanoTime() + l3;
        this.lock.lockInterruptibly();
        try {
            while (true) {
                Object object;
                if ((object = this.unlinkLast()) != null) {
                    Object object2 = object;
                    return object2;
                }
                if (l3 <= 0L) {
                    Object var9_7 = null;
                    return var9_7;
                }
                this.notEmpty.await(l3, TimeUnit.NANOSECONDS);
                l3 = l4 - Utils.nanoTime();
            }
        }
        finally {
            this.lock.unlock();
        }
    }

    @Override
    public Object getFirst() {
        Object object = this.peekFirst();
        if (object == null) {
            throw new NoSuchElementException();
        }
        return object;
    }

    @Override
    public Object getLast() {
        Object object = this.peekLast();
        if (object == null) {
            throw new NoSuchElementException();
        }
        return object;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object peekFirst() {
        this.lock.lock();
        try {
            Object object = this.first == null ? null : this.first.item;
            return object;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object peekLast() {
        this.lock.lock();
        try {
            Object object = this.last == null ? null : this.last.item;
            return object;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean removeFirstOccurrence(Object object) {
        if (object == null) {
            return false;
        }
        this.lock.lock();
        try {
            Node node = this.first;
            while (node != null) {
                if (object.equals(node.item)) {
                    this.unlink(node);
                    boolean bl2 = true;
                    return bl2;
                }
                node = node.next;
            }
            boolean bl3 = false;
            return bl3;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean removeLastOccurrence(Object object) {
        if (object == null) {
            return false;
        }
        this.lock.lock();
        try {
            Node node = this.last;
            while (node != null) {
                if (object.equals(node.item)) {
                    this.unlink(node);
                    boolean bl2 = true;
                    return bl2;
                }
                node = node.prev;
            }
            boolean bl3 = false;
            return bl3;
        }
        finally {
            this.lock.unlock();
        }
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
    public void put(Object object) throws InterruptedException {
        this.putLast(object);
    }

    @Override
    public boolean offer(Object object, long l2, TimeUnit timeUnit) throws InterruptedException {
        return this.offerLast(object, l2, timeUnit);
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
    public Object take() throws InterruptedException {
        return this.takeFirst();
    }

    @Override
    public Object poll(long l2, TimeUnit timeUnit) throws InterruptedException {
        return this.pollFirst(l2, timeUnit);
    }

    @Override
    public Object element() {
        return this.getFirst();
    }

    @Override
    public Object peek() {
        return this.peekFirst();
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public int remainingCapacity() {
        this.lock.lock();
        try {
            int n2 = this.capacity - this.count;
            return n2;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public int drainTo(Collection collection) {
        if (collection == null) {
            throw new NullPointerException();
        }
        if (collection == this) {
            throw new IllegalArgumentException();
        }
        this.lock.lock();
        try {
            Node node = this.first;
            while (node != null) {
                collection.add(node.item);
                node = node.next;
            }
            int n2 = this.count;
            this.count = 0;
            this.last = null;
            this.first = null;
            this.notFull.signalAll();
            int n3 = n2;
            return n3;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public int drainTo(Collection collection, int n2) {
        if (collection == null) {
            throw new NullPointerException();
        }
        if (collection == this) {
            throw new IllegalArgumentException();
        }
        this.lock.lock();
        try {
            int n3;
            for (n3 = 0; n3 < n2 && this.first != null; ++n3) {
                collection.add(this.first.item);
                this.first.prev = null;
                this.first = this.first.next;
                --this.count;
            }
            if (this.first == null) {
                this.last = null;
            }
            this.notFull.signalAll();
            int n4 = n3;
            return n4;
        }
        finally {
            this.lock.unlock();
        }
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
    public boolean remove(Object object) {
        return this.removeFirstOccurrence(object);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public int size() {
        this.lock.lock();
        try {
            int n2 = this.count;
            return n2;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean contains(Object object) {
        if (object == null) {
            return false;
        }
        this.lock.lock();
        try {
            Node node = this.first;
            while (node != null) {
                if (object.equals(node.item)) {
                    boolean bl2 = true;
                    return bl2;
                }
                node = node.next;
            }
            boolean bl3 = false;
            return bl3;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    boolean removeNode(Node node) {
        this.lock.lock();
        try {
            Node node2 = this.first;
            while (node2 != null) {
                if (node2 == node) {
                    this.unlink(node2);
                    boolean bl2 = true;
                    return bl2;
                }
                node2 = node2.next;
            }
            boolean bl3 = false;
            return bl3;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object[] toArray() {
        this.lock.lock();
        try {
            Object[] objectArray = new Object[this.count];
            int n2 = 0;
            Object object = this.first;
            while (object != null) {
                objectArray[n2++] = object.item;
                object = object.next;
            }
            object = objectArray;
            return object;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object[] toArray(Object[] objectArray) {
        this.lock.lock();
        try {
            if (objectArray.length < this.count) {
                objectArray = (Object[])Array.newInstance(objectArray.getClass().getComponentType(), this.count);
            }
            int n2 = 0;
            Object[] objectArray2 = this.first;
            while (objectArray2 != null) {
                objectArray[n2++] = objectArray2.item;
                objectArray2 = objectArray2.next;
            }
            if (objectArray.length > n2) {
                objectArray[n2] = null;
            }
            objectArray2 = objectArray;
            return objectArray2;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public String toString() {
        this.lock.lock();
        try {
            String string = super.toString();
            return string;
        }
        finally {
            this.lock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void clear() {
        this.lock.lock();
        try {
            this.last = null;
            this.first = null;
            this.count = 0;
            this.notFull.signalAll();
        }
        finally {
            this.lock.unlock();
        }
    }

    @Override
    public Iterator iterator() {
        return new Itr();
    }

    @Override
    public Iterator descendingIterator() {
        return new DescendingItr();
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        this.lock.lock();
        try {
            objectOutputStream.defaultWriteObject();
            Node node = this.first;
            while (node != null) {
                objectOutputStream.writeObject(node.item);
                node = node.next;
            }
            objectOutputStream.writeObject(null);
        }
        finally {
            this.lock.unlock();
        }
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        Object object;
        objectInputStream.defaultReadObject();
        this.count = 0;
        this.first = null;
        this.last = null;
        while ((object = objectInputStream.readObject()) != null) {
            this.add(object);
        }
    }

    private class DescendingItr
    extends AbstractItr {
        private DescendingItr() {
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        void advance() {
            ReentrantLock reentrantLock = LinkedBlockingDeque.this.lock;
            reentrantLock.lock();
            try {
                this.next = this.next == null ? LinkedBlockingDeque.this.last : this.next.prev;
                this.nextItem = this.next == null ? null : this.next.item;
            }
            finally {
                reentrantLock.unlock();
            }
        }
    }

    private class Itr
    extends AbstractItr {
        private Itr() {
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        void advance() {
            ReentrantLock reentrantLock = LinkedBlockingDeque.this.lock;
            reentrantLock.lock();
            try {
                this.next = this.next == null ? LinkedBlockingDeque.this.first : this.next.next;
                this.nextItem = this.next == null ? null : this.next.item;
            }
            finally {
                reentrantLock.unlock();
            }
        }
    }

    private abstract class AbstractItr
    implements Iterator {
        Node next;
        Object nextItem;
        private Node lastRet;

        AbstractItr() {
            this.advance();
        }

        abstract void advance();

        @Override
        public boolean hasNext() {
            return this.next != null;
        }

        public Object next() {
            if (this.next == null) {
                throw new NoSuchElementException();
            }
            this.lastRet = this.next;
            Object object = this.nextItem;
            this.advance();
            return object;
        }

        @Override
        public void remove() {
            Node node = this.lastRet;
            if (node == null) {
                throw new IllegalStateException();
            }
            this.lastRet = null;
            LinkedBlockingDeque.this.removeNode(node);
        }
    }

    static final class Node {
        Object item;
        Node prev;
        Node next;

        Node(Object object, Node node, Node node2) {
            this.item = object;
            this.prev = node;
            this.next = node2;
        }
    }
}

