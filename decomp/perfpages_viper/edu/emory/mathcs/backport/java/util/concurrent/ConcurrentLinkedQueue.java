/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractQueue;
import edu.emory.mathcs.backport.java.util.Queue;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class ConcurrentLinkedQueue
extends AbstractQueue
implements Queue,
Serializable {
    private static final long serialVersionUID = 196745693267521676L;
    private final Object headLock = new SerializableLock();
    private final Object tailLock = new SerializableLock();
    private volatile transient Node head;
    private volatile transient Node tail = this.head = new Node(null, null);

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private boolean casTail(Node node, Node node2) {
        Object object = this.tailLock;
        synchronized (object) {
            if (this.tail == node) {
                this.tail = node2;
                return true;
            }
            return false;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private boolean casHead(Node node, Node node2) {
        Object object = this.headLock;
        synchronized (object) {
            if (this.head == node) {
                this.head = node2;
                return true;
            }
            return false;
        }
    }

    public ConcurrentLinkedQueue() {
    }

    public ConcurrentLinkedQueue(Collection collection) {
        Iterator iterator = collection.iterator();
        while (iterator.hasNext()) {
            this.add(iterator.next());
        }
    }

    @Override
    public boolean add(Object object) {
        return this.offer(object);
    }

    @Override
    public boolean offer(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        Node node = new Node(object, null);
        while (true) {
            Node node2 = this.tail;
            Node node3 = node2.getNext();
            if (node2 != this.tail) continue;
            if (node3 == null) {
                if (!node2.casNext(node3, node)) continue;
                this.casTail(node2, node);
                return true;
            }
            this.casTail(node2, node3);
        }
    }

    @Override
    public Object poll() {
        Object object;
        Node node;
        while (true) {
            Node node2 = this.head;
            Node node3 = this.tail;
            node = node2.getNext();
            if (node2 != this.head) continue;
            if (node2 == node3) {
                if (node == null) {
                    return null;
                }
                this.casTail(node3, node);
                continue;
            }
            if (this.casHead(node2, node) && (object = node.getItem()) != null) break;
        }
        node.setItem(null);
        return object;
    }

    @Override
    public Object peek() {
        while (true) {
            Node node = this.head;
            Node node2 = this.tail;
            Node node3 = node.getNext();
            if (node != this.head) continue;
            if (node == node2) {
                if (node3 == null) {
                    return null;
                }
                this.casTail(node2, node3);
                continue;
            }
            Object object = node3.getItem();
            if (object != null) {
                return object;
            }
            this.casHead(node, node3);
        }
    }

    Node first() {
        while (true) {
            Node node = this.head;
            Node node2 = this.tail;
            Node node3 = node.getNext();
            if (node != this.head) continue;
            if (node == node2) {
                if (node3 == null) {
                    return null;
                }
                this.casTail(node2, node3);
                continue;
            }
            if (node3.getItem() != null) {
                return node3;
            }
            this.casHead(node, node3);
        }
    }

    @Override
    public boolean isEmpty() {
        return this.first() == null;
    }

    @Override
    public int size() {
        int n2 = 0;
        for (Node node = this.first(); node != null && (node.getItem() == null || ++n2 != Integer.MAX_VALUE); node = node.getNext()) {
        }
        return n2;
    }

    @Override
    public boolean contains(Object object) {
        if (object == null) {
            return false;
        }
        for (Node node = this.first(); node != null; node = node.getNext()) {
            Object object2 = node.getItem();
            if (object2 == null || !object.equals(object2)) continue;
            return true;
        }
        return false;
    }

    @Override
    public boolean remove(Object object) {
        if (object == null) {
            return false;
        }
        for (Node node = this.first(); node != null; node = node.getNext()) {
            Object object2 = node.getItem();
            if (object2 == null || !object.equals(object2) || !node.casItem(object2, null)) continue;
            return true;
        }
        return false;
    }

    @Override
    public Iterator iterator() {
        return new Itr();
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        for (Node node = this.first(); node != null; node = node.getNext()) {
            Object object = node.getItem();
            if (object == null) continue;
            objectOutputStream.writeObject(object);
        }
        objectOutputStream.writeObject(null);
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        Object object;
        objectInputStream.defaultReadObject();
        this.tail = this.head = new Node(null, null);
        while ((object = objectInputStream.readObject()) != null) {
            this.offer(object);
        }
    }

    private static class SerializableLock
    implements Serializable {
        private SerializableLock() {
        }
    }

    private class Itr
    implements Iterator {
        private Node nextNode;
        private Object nextItem;
        private Node lastRet;

        Itr() {
            this.advance();
        }

        private Object advance() {
            Node node;
            this.lastRet = this.nextNode;
            Object object = this.nextItem;
            Node node2 = node = this.nextNode == null ? ConcurrentLinkedQueue.this.first() : this.nextNode.getNext();
            while (true) {
                if (node == null) {
                    this.nextNode = null;
                    this.nextItem = null;
                    return object;
                }
                Object object2 = node.getItem();
                if (object2 != null) {
                    this.nextNode = node;
                    this.nextItem = object2;
                    return object;
                }
                node = node.getNext();
            }
        }

        @Override
        public boolean hasNext() {
            return this.nextNode != null;
        }

        public Object next() {
            if (this.nextNode == null) {
                throw new NoSuchElementException();
            }
            return this.advance();
        }

        @Override
        public void remove() {
            Node node = this.lastRet;
            if (node == null) {
                throw new IllegalStateException();
            }
            node.setItem(null);
            this.lastRet = null;
        }
    }

    private static class Node {
        private volatile Object item;
        private volatile Node next;

        Node(Object object) {
            this.item = object;
        }

        Node(Object object, Node node) {
            this.item = object;
            this.next = node;
        }

        Object getItem() {
            return this.item;
        }

        synchronized boolean casItem(Object object, Object object2) {
            if (this.item == object) {
                this.item = object2;
                return true;
            }
            return false;
        }

        synchronized void setItem(Object object) {
            this.item = object;
        }

        Node getNext() {
            return this.next;
        }

        synchronized boolean casNext(Node node, Node node2) {
            if (this.next == node) {
                this.next = node2;
                return true;
            }
            return false;
        }

        synchronized void setNext(Node node) {
            this.next = node;
        }
    }
}

