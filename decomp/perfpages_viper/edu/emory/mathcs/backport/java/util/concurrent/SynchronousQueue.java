/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractQueue;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.locks.ReentrantLock;
import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class SynchronousQueue
extends AbstractQueue
implements BlockingQueue,
Serializable {
    private static final long serialVersionUID = -3223113410248163686L;
    private final ReentrantLock qlock;
    private final WaitQueue waitingProducers;
    private final WaitQueue waitingConsumers;

    public SynchronousQueue() {
        this(false);
    }

    public SynchronousQueue(boolean bl2) {
        if (bl2) {
            this.qlock = new ReentrantLock(true);
            this.waitingProducers = new FifoWaitQueue();
            this.waitingConsumers = new FifoWaitQueue();
        } else {
            this.qlock = new ReentrantLock();
            this.waitingProducers = new LifoWaitQueue();
            this.waitingConsumers = new LifoWaitQueue();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void unlinkCancelledConsumer(Node node) {
        if (this.waitingConsumers.shouldUnlink(node)) {
            this.qlock.lock();
            try {
                if (this.waitingConsumers.shouldUnlink(node)) {
                    this.waitingConsumers.unlink(node);
                }
            }
            finally {
                this.qlock.unlock();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void unlinkCancelledProducer(Node node) {
        if (this.waitingProducers.shouldUnlink(node)) {
            this.qlock.lock();
            try {
                if (this.waitingProducers.shouldUnlink(node)) {
                    this.waitingProducers.unlink(node);
                }
            }
            finally {
                this.qlock.unlock();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void put(Object object) throws InterruptedException {
        Node node;
        if (object == null) {
            throw new NullPointerException();
        }
        ReentrantLock reentrantLock = this.qlock;
        do {
            boolean bl2;
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            reentrantLock.lock();
            try {
                node = this.waitingConsumers.deq();
                bl2 = node == null;
                if (bl2) {
                    node = this.waitingProducers.enq(object);
                }
            }
            finally {
                reentrantLock.unlock();
            }
            if (!bl2) continue;
            try {
                node.waitForTake();
                return;
            }
            catch (InterruptedException interruptedException) {
                this.unlinkCancelledProducer(node);
                throw interruptedException;
            }
        } while (!node.setItem(object));
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean offer(Object object, long l2, TimeUnit timeUnit) throws InterruptedException {
        Node node;
        if (object == null) {
            throw new NullPointerException();
        }
        long l3 = timeUnit.toNanos(l2);
        ReentrantLock reentrantLock = this.qlock;
        do {
            boolean bl2;
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            reentrantLock.lock();
            try {
                node = this.waitingConsumers.deq();
                bl2 = node == null;
                if (bl2) {
                    node = this.waitingProducers.enq(object);
                }
            }
            finally {
                reentrantLock.unlock();
            }
            if (!bl2) continue;
            try {
                boolean bl3 = node.waitForTake(l3);
                if (!bl3) {
                    this.unlinkCancelledProducer(node);
                }
                return bl3;
            }
            catch (InterruptedException interruptedException) {
                this.unlinkCancelledProducer(node);
                throw interruptedException;
            }
        } while (!node.setItem(object));
        return true;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object take() throws InterruptedException {
        Node node;
        Object object;
        ReentrantLock reentrantLock = this.qlock;
        do {
            boolean bl2;
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            reentrantLock.lock();
            try {
                node = this.waitingProducers.deq();
                bl2 = node == null;
                if (bl2) {
                    node = this.waitingConsumers.enq(null);
                }
            }
            finally {
                reentrantLock.unlock();
            }
            if (!bl2) continue;
            try {
                object = node.waitForPut();
                return object;
            }
            catch (InterruptedException interruptedException) {
                this.unlinkCancelledConsumer(node);
                throw interruptedException;
            }
        } while ((object = node.getItem()) == null);
        return object;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object poll(long l2, TimeUnit timeUnit) throws InterruptedException {
        Node node;
        Object object;
        long l3 = timeUnit.toNanos(l2);
        ReentrantLock reentrantLock = this.qlock;
        do {
            boolean bl2;
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            reentrantLock.lock();
            try {
                node = this.waitingProducers.deq();
                bl2 = node == null;
                if (bl2) {
                    node = this.waitingConsumers.enq(null);
                }
            }
            finally {
                reentrantLock.unlock();
            }
            if (!bl2) continue;
            try {
                object = node.waitForPut(l3);
                if (object == null) {
                    this.unlinkCancelledConsumer(node);
                }
                return object;
            }
            catch (InterruptedException interruptedException) {
                this.unlinkCancelledConsumer(node);
                throw interruptedException;
            }
        } while ((object = node.getItem()) == null);
        return object;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean offer(Object object) {
        Node node;
        if (object == null) {
            throw new NullPointerException();
        }
        ReentrantLock reentrantLock = this.qlock;
        do {
            reentrantLock.lock();
            try {
                node = this.waitingConsumers.deq();
            }
            finally {
                reentrantLock.unlock();
            }
            if (node != null) continue;
            return false;
        } while (!node.setItem(object));
        return true;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object poll() {
        Node node;
        Object object;
        ReentrantLock reentrantLock = this.qlock;
        do {
            reentrantLock.lock();
            try {
                node = this.waitingProducers.deq();
            }
            finally {
                reentrantLock.unlock();
            }
            if (node != null) continue;
            return null;
        } while ((object = node.getItem()) == null);
        return object;
    }

    @Override
    public boolean isEmpty() {
        return true;
    }

    @Override
    public int size() {
        return 0;
    }

    @Override
    public int remainingCapacity() {
        return 0;
    }

    @Override
    public void clear() {
    }

    @Override
    public boolean contains(Object object) {
        return false;
    }

    @Override
    public boolean remove(Object object) {
        return false;
    }

    public boolean containsAll(Collection collection) {
        return collection.isEmpty();
    }

    public boolean removeAll(Collection collection) {
        return false;
    }

    public boolean retainAll(Collection collection) {
        return false;
    }

    @Override
    public Object peek() {
        return null;
    }

    @Override
    public Iterator iterator() {
        return new EmptyIterator();
    }

    @Override
    public Object[] toArray() {
        return new Object[0];
    }

    @Override
    public Object[] toArray(Object[] objectArray) {
        if (objectArray.length > 0) {
            objectArray[0] = null;
        }
        return objectArray;
    }

    @Override
    public int drainTo(Collection collection) {
        Object object;
        if (collection == null) {
            throw new NullPointerException();
        }
        if (collection == this) {
            throw new IllegalArgumentException();
        }
        int n2 = 0;
        while ((object = this.poll()) != null) {
            collection.add(object);
            ++n2;
        }
        return n2;
    }

    @Override
    public int drainTo(Collection collection, int n2) {
        Object object;
        int n3;
        if (collection == null) {
            throw new NullPointerException();
        }
        if (collection == this) {
            throw new IllegalArgumentException();
        }
        for (n3 = 0; n3 < n2 && (object = this.poll()) != null; ++n3) {
            collection.add(object);
        }
        return n3;
    }

    static class EmptyIterator
    implements Iterator {
        EmptyIterator() {
        }

        @Override
        public boolean hasNext() {
            return false;
        }

        public Object next() {
            throw new NoSuchElementException();
        }

        @Override
        public void remove() {
            throw new IllegalStateException();
        }
    }

    static final class Node
    implements Serializable {
        private static final long serialVersionUID = -3223113410248163686L;
        private static final int ACK = 1;
        private static final int CANCEL = -1;
        int state = 0;
        Object item;
        Node next;

        Node(Object object) {
            this.item = object;
        }

        Node(Object object, Node node) {
            this.item = object;
            this.next = node;
        }

        private Object extract() {
            Object object = this.item;
            this.item = null;
            return object;
        }

        private void checkCancellationOnInterrupt(InterruptedException interruptedException) throws InterruptedException {
            if (this.state == 0) {
                this.state = -1;
                this.notify();
                throw interruptedException;
            }
            Thread.currentThread().interrupt();
        }

        synchronized boolean setItem(Object object) {
            if (this.state != 0) {
                return false;
            }
            this.item = object;
            this.state = 1;
            this.notify();
            return true;
        }

        synchronized Object getItem() {
            if (this.state != 0) {
                return null;
            }
            this.state = 1;
            this.notify();
            return this.extract();
        }

        synchronized void waitForTake() throws InterruptedException {
            try {
                while (this.state == 0) {
                    this.wait();
                }
            }
            catch (InterruptedException interruptedException) {
                this.checkCancellationOnInterrupt(interruptedException);
            }
        }

        synchronized Object waitForPut() throws InterruptedException {
            try {
                while (this.state == 0) {
                    this.wait();
                }
            }
            catch (InterruptedException interruptedException) {
                this.checkCancellationOnInterrupt(interruptedException);
            }
            return this.extract();
        }

        private boolean attempt(long l2) throws InterruptedException {
            if (this.state != 0) {
                return true;
            }
            if (l2 <= 0L) {
                this.state = -1;
                this.notify();
                return false;
            }
            long l3 = Utils.nanoTime() + l2;
            do {
                TimeUnit.NANOSECONDS.timedWait(this, l2);
                if (this.state == 0) continue;
                return true;
            } while ((l2 = l3 - Utils.nanoTime()) > 0L);
            this.state = -1;
            this.notify();
            return false;
        }

        synchronized boolean waitForTake(long l2) throws InterruptedException {
            try {
                if (!this.attempt(l2)) {
                    return false;
                }
            }
            catch (InterruptedException interruptedException) {
                this.checkCancellationOnInterrupt(interruptedException);
            }
            return true;
        }

        synchronized Object waitForPut(long l2) throws InterruptedException {
            try {
                if (!this.attempt(l2)) {
                    return null;
                }
            }
            catch (InterruptedException interruptedException) {
                this.checkCancellationOnInterrupt(interruptedException);
            }
            return this.extract();
        }
    }

    static final class LifoWaitQueue
    extends WaitQueue
    implements Serializable {
        private static final long serialVersionUID = -3633113410248163686L;
        private transient Node head;

        LifoWaitQueue() {
        }

        @Override
        Node enq(Object object) {
            this.head = new Node(object, this.head);
            return this.head;
        }

        @Override
        Node deq() {
            Node node = this.head;
            if (node != null) {
                this.head = node.next;
                node.next = null;
            }
            return node;
        }

        @Override
        boolean shouldUnlink(Node node) {
            return node == this.head || node.next != null;
        }

        @Override
        void unlink(Node node) {
            Node node2 = this.head;
            Node node3 = null;
            while (node2 != null) {
                if (node2 == node) {
                    Node node4 = node2.next;
                    if (node3 == null) {
                        this.head = node4;
                        break;
                    }
                    node3.next = node4;
                    break;
                }
                node3 = node2;
                node2 = node2.next;
            }
        }
    }

    static final class FifoWaitQueue
    extends WaitQueue
    implements Serializable {
        private static final long serialVersionUID = -3623113410248163686L;
        private transient Node head;
        private transient Node last;

        FifoWaitQueue() {
        }

        @Override
        Node enq(Object object) {
            Node node = new Node(object);
            this.last = this.last == null ? (this.head = node) : (this.last.next = node);
            return node;
        }

        @Override
        Node deq() {
            Node node = this.head;
            if (node != null) {
                this.head = node.next;
                if (this.head == null) {
                    this.last = null;
                }
                node.next = null;
            }
            return node;
        }

        @Override
        boolean shouldUnlink(Node node) {
            return node == this.last || node.next != null;
        }

        @Override
        void unlink(Node node) {
            Node node2 = this.head;
            Node node3 = null;
            while (node2 != null) {
                if (node2 == node) {
                    Node node4 = node2.next;
                    if (node3 == null) {
                        this.head = node4;
                    } else {
                        node3.next = node4;
                    }
                    if (this.last != node) break;
                    this.last = node3;
                    break;
                }
                node3 = node2;
                node2 = node2.next;
            }
        }
    }

    static abstract class WaitQueue
    implements Serializable {
        WaitQueue() {
        }

        abstract Node enq(Object var1);

        abstract Node deq();

        abstract void unlink(Node var1);

        abstract boolean shouldUnlink(Node var1);
    }
}

