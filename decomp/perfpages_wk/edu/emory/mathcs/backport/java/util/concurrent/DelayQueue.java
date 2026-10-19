/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractQueue;
import edu.emory.mathcs.backport.java.util.PriorityQueue;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.Delayed;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class DelayQueue
extends AbstractQueue
implements BlockingQueue {
    private final transient Object lock = new Object();
    private final PriorityQueue q = new PriorityQueue();

    public DelayQueue() {
    }

    public DelayQueue(Collection collection) {
        this.addAll(collection);
    }

    @Override
    public boolean add(Object object) {
        return this.offer(object);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean offer(Object object) {
        Object object2 = this.lock;
        synchronized (object2) {
            Object object3 = this.q.peek();
            this.q.offer(object);
            if (object3 == null || ((Delayed)object).compareTo(object3) < 0) {
                this.lock.notifyAll();
            }
            return true;
        }
    }

    @Override
    public void put(Object object) {
        this.offer(object);
    }

    @Override
    public boolean offer(Object object, long l2, TimeUnit timeUnit) {
        return this.offer(object);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object poll() {
        Object object = this.lock;
        synchronized (object) {
            Object object2 = this.q.peek();
            if (object2 == null || ((Delayed)object2).getDelay(TimeUnit.NANOSECONDS) > 0L) {
                return null;
            }
            Object object3 = this.q.poll();
            assert (object3 != null);
            if (this.q.size() != 0) {
                this.lock.notifyAll();
            }
            return object3;
        }
    }

    @Override
    public Object take() throws InterruptedException {
        Object object = this.lock;
        synchronized (object) {
            while (true) {
                Object object2;
                if ((object2 = this.q.peek()) == null) {
                    this.lock.wait();
                    continue;
                }
                long l2 = ((Delayed)object2).getDelay(TimeUnit.NANOSECONDS);
                if (l2 <= 0L) break;
                TimeUnit.NANOSECONDS.timedWait(this.lock, l2);
            }
            Object object3 = this.q.poll();
            assert (object3 != null);
            if (this.q.size() != 0) {
                this.lock.notifyAll();
            }
            return object3;
        }
    }

    @Override
    public Object poll(long l2, TimeUnit timeUnit) throws InterruptedException {
        long l3 = timeUnit.toNanos(l2);
        long l4 = Utils.nanoTime() + l3;
        Object object = this.lock;
        synchronized (object) {
            while (true) {
                Object object2;
                if ((object2 = this.q.peek()) == null) {
                    if (l3 <= 0L) {
                        return null;
                    }
                    TimeUnit.NANOSECONDS.timedWait(this.lock, l3);
                    l3 = l4 - Utils.nanoTime();
                    continue;
                }
                long l5 = ((Delayed)object2).getDelay(TimeUnit.NANOSECONDS);
                if (l5 <= 0L) break;
                if (l3 <= 0L) {
                    return null;
                }
                if (l5 > l3) {
                    l5 = l3;
                }
                TimeUnit.NANOSECONDS.timedWait(this.lock, l5);
                l3 = l4 - Utils.nanoTime();
            }
            Object object3 = this.q.poll();
            assert (object3 != null);
            if (this.q.size() != 0) {
                this.lock.notifyAll();
            }
            return object3;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object peek() {
        Object object = this.lock;
        synchronized (object) {
            return this.q.peek();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public int size() {
        Object object = this.lock;
        synchronized (object) {
            return this.q.size();
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
        Object object = this.lock;
        synchronized (object) {
            Object object2;
            int n2 = 0;
            while ((object2 = this.q.peek()) != null && ((Delayed)object2).getDelay(TimeUnit.NANOSECONDS) <= 0L) {
                collection.add(this.q.poll());
                ++n2;
            }
            if (n2 > 0) {
                this.lock.notifyAll();
            }
            return n2;
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
        if (n2 <= 0) {
            return 0;
        }
        Object object = this.lock;
        synchronized (object) {
            Object object2;
            int n3;
            for (n3 = 0; n3 < n2 && (object2 = this.q.peek()) != null && ((Delayed)object2).getDelay(TimeUnit.NANOSECONDS) <= 0L; ++n3) {
                collection.add(this.q.poll());
            }
            if (n3 > 0) {
                this.lock.notifyAll();
            }
            return n3;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void clear() {
        Object object = this.lock;
        synchronized (object) {
            this.q.clear();
        }
    }

    @Override
    public int remainingCapacity() {
        return Integer.MAX_VALUE;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object[] toArray() {
        Object object = this.lock;
        synchronized (object) {
            return this.q.toArray();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object[] toArray(Object[] objectArray) {
        Object object = this.lock;
        synchronized (object) {
            return this.q.toArray(objectArray);
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean remove(Object object) {
        Object object2 = this.lock;
        synchronized (object2) {
            return this.q.remove(object);
        }
    }

    @Override
    public Iterator iterator() {
        return new Itr(this.toArray());
    }

    private class Itr
    implements Iterator {
        final Object[] array;
        int cursor;
        int lastRet = -1;

        Itr(Object[] objectArray) {
            this.array = objectArray;
        }

        @Override
        public boolean hasNext() {
            return this.cursor < this.array.length;
        }

        public Object next() {
            if (this.cursor >= this.array.length) {
                throw new NoSuchElementException();
            }
            this.lastRet = this.cursor;
            return this.array[this.cursor++];
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void remove() {
            if (this.lastRet < 0) {
                throw new IllegalStateException();
            }
            Object object = this.array[this.lastRet];
            this.lastRet = -1;
            Object object2 = DelayQueue.this.lock;
            synchronized (object2) {
                Iterator iterator = DelayQueue.this.q.iterator();
                while (iterator.hasNext()) {
                    if (iterator.next() != object) continue;
                    iterator.remove();
                    return;
                }
            }
        }
    }
}

