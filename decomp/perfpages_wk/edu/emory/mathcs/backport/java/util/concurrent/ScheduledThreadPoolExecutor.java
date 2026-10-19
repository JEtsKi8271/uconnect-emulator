/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractQueue;
import edu.emory.mathcs.backport.java.util.Arrays;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.Delayed;
import edu.emory.mathcs.backport.java.util.concurrent.Executors;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import edu.emory.mathcs.backport.java.util.concurrent.FutureTask;
import edu.emory.mathcs.backport.java.util.concurrent.RejectedExecutionHandler;
import edu.emory.mathcs.backport.java.util.concurrent.RunnableScheduledFuture;
import edu.emory.mathcs.backport.java.util.concurrent.ScheduledExecutorService;
import edu.emory.mathcs.backport.java.util.concurrent.ScheduledFuture;
import edu.emory.mathcs.backport.java.util.concurrent.ThreadFactory;
import edu.emory.mathcs.backport.java.util.concurrent.ThreadPoolExecutor;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.atomic.AtomicLong;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import edu.emory.mathcs.backport.java.util.concurrent.locks.ReentrantLock;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;

public class ScheduledThreadPoolExecutor
extends ThreadPoolExecutor
implements ScheduledExecutorService {
    private volatile boolean continueExistingPeriodicTasksAfterShutdown;
    private volatile boolean executeExistingDelayedTasksAfterShutdown = true;
    private volatile boolean removeOnCancel = false;
    private static final AtomicLong sequencer = new AtomicLong(0L);

    final long now() {
        return Utils.nanoTime();
    }

    boolean canRunInCurrentRunState(boolean bl2) {
        return this.isRunningOrShutdown(bl2 ? this.continueExistingPeriodicTasksAfterShutdown : this.executeExistingDelayedTasksAfterShutdown);
    }

    private void delayedExecute(RunnableScheduledFuture runnableScheduledFuture) {
        if (this.isShutdown()) {
            this.reject(runnableScheduledFuture);
        } else {
            super.getQueue().add(runnableScheduledFuture);
            if (this.isShutdown() && !this.canRunInCurrentRunState(runnableScheduledFuture.isPeriodic()) && this.remove(runnableScheduledFuture)) {
                runnableScheduledFuture.cancel(false);
            } else {
                this.prestartCoreThread();
            }
        }
    }

    void reExecutePeriodic(RunnableScheduledFuture runnableScheduledFuture) {
        if (this.canRunInCurrentRunState(true)) {
            super.getQueue().add(runnableScheduledFuture);
            if (!this.canRunInCurrentRunState(true) && this.remove(runnableScheduledFuture)) {
                runnableScheduledFuture.cancel(false);
            } else {
                this.prestartCoreThread();
            }
        }
    }

    @Override
    void onShutdown() {
        BlockingQueue blockingQueue = super.getQueue();
        boolean bl2 = this.getExecuteExistingDelayedTasksAfterShutdownPolicy();
        boolean bl3 = this.getContinueExistingPeriodicTasksAfterShutdownPolicy();
        if (!bl2 && !bl3) {
            blockingQueue.clear();
        } else {
            Object[] objectArray = blockingQueue.toArray();
            for (int i2 = 0; i2 < objectArray.length; ++i2) {
                RunnableScheduledFuture runnableScheduledFuture;
                Object object = objectArray[i2];
                if (!(object instanceof RunnableScheduledFuture) || !(!(runnableScheduledFuture = (RunnableScheduledFuture)object).isPeriodic() ? !bl2 : !bl3) && !runnableScheduledFuture.isCancelled() || !blockingQueue.remove(runnableScheduledFuture)) continue;
                runnableScheduledFuture.cancel(false);
            }
        }
        this.tryTerminate();
    }

    protected RunnableScheduledFuture decorateTask(Runnable runnable, RunnableScheduledFuture runnableScheduledFuture) {
        return runnableScheduledFuture;
    }

    protected RunnableScheduledFuture decorateTask(Callable callable, RunnableScheduledFuture runnableScheduledFuture) {
        return runnableScheduledFuture;
    }

    public ScheduledThreadPoolExecutor(int n2) {
        super(n2, Integer.MAX_VALUE, 0L, TimeUnit.NANOSECONDS, new DelayedWorkQueue());
    }

    public ScheduledThreadPoolExecutor(int n2, ThreadFactory threadFactory) {
        super(n2, Integer.MAX_VALUE, 0L, TimeUnit.NANOSECONDS, (BlockingQueue)new DelayedWorkQueue(), threadFactory);
    }

    public ScheduledThreadPoolExecutor(int n2, RejectedExecutionHandler rejectedExecutionHandler) {
        super(n2, Integer.MAX_VALUE, 0L, TimeUnit.NANOSECONDS, (BlockingQueue)new DelayedWorkQueue(), rejectedExecutionHandler);
    }

    public ScheduledThreadPoolExecutor(int n2, ThreadFactory threadFactory, RejectedExecutionHandler rejectedExecutionHandler) {
        super(n2, Integer.MAX_VALUE, 0L, TimeUnit.NANOSECONDS, new DelayedWorkQueue(), threadFactory, rejectedExecutionHandler);
    }

    @Override
    public ScheduledFuture schedule(Runnable runnable, long l2, TimeUnit timeUnit) {
        if (runnable == null || timeUnit == null) {
            throw new NullPointerException();
        }
        if (l2 < 0L) {
            l2 = 0L;
        }
        long l3 = this.now() + timeUnit.toNanos(l2);
        RunnableScheduledFuture runnableScheduledFuture = this.decorateTask(runnable, (RunnableScheduledFuture)new ScheduledFutureTask(runnable, null, l3));
        this.delayedExecute(runnableScheduledFuture);
        return runnableScheduledFuture;
    }

    @Override
    public ScheduledFuture schedule(Callable callable, long l2, TimeUnit timeUnit) {
        if (callable == null || timeUnit == null) {
            throw new NullPointerException();
        }
        if (l2 < 0L) {
            l2 = 0L;
        }
        long l3 = this.now() + timeUnit.toNanos(l2);
        RunnableScheduledFuture runnableScheduledFuture = this.decorateTask(callable, (RunnableScheduledFuture)new ScheduledFutureTask(callable, l3));
        this.delayedExecute(runnableScheduledFuture);
        return runnableScheduledFuture;
    }

    @Override
    public ScheduledFuture scheduleAtFixedRate(Runnable runnable, long l2, long l3, TimeUnit timeUnit) {
        if (runnable == null || timeUnit == null) {
            throw new NullPointerException();
        }
        if (l3 <= 0L) {
            throw new IllegalArgumentException();
        }
        if (l2 < 0L) {
            l2 = 0L;
        }
        long l4 = this.now() + timeUnit.toNanos(l2);
        RunnableScheduledFuture runnableScheduledFuture = this.decorateTask(runnable, (RunnableScheduledFuture)new ScheduledFutureTask(runnable, null, l4, timeUnit.toNanos(l3)));
        this.delayedExecute(runnableScheduledFuture);
        return runnableScheduledFuture;
    }

    @Override
    public ScheduledFuture scheduleWithFixedDelay(Runnable runnable, long l2, long l3, TimeUnit timeUnit) {
        if (runnable == null || timeUnit == null) {
            throw new NullPointerException();
        }
        if (l3 <= 0L) {
            throw new IllegalArgumentException();
        }
        if (l2 < 0L) {
            l2 = 0L;
        }
        long l4 = this.now() + timeUnit.toNanos(l2);
        RunnableScheduledFuture runnableScheduledFuture = this.decorateTask(runnable, (RunnableScheduledFuture)new ScheduledFutureTask(runnable, null, l4, timeUnit.toNanos(-l3)));
        this.delayedExecute(runnableScheduledFuture);
        return runnableScheduledFuture;
    }

    @Override
    public void execute(Runnable runnable) {
        this.schedule(runnable, 0L, TimeUnit.NANOSECONDS);
    }

    @Override
    public Future submit(Runnable runnable) {
        return this.schedule(runnable, 0L, TimeUnit.NANOSECONDS);
    }

    @Override
    public Future submit(Runnable runnable, Object object) {
        return this.schedule(Executors.callable(runnable, object), 0L, TimeUnit.NANOSECONDS);
    }

    @Override
    public Future submit(Callable callable) {
        return this.schedule(callable, 0L, TimeUnit.NANOSECONDS);
    }

    public void setContinueExistingPeriodicTasksAfterShutdownPolicy(boolean bl2) {
        this.continueExistingPeriodicTasksAfterShutdown = bl2;
        if (!bl2 && this.isShutdown()) {
            this.onShutdown();
        }
    }

    public boolean getContinueExistingPeriodicTasksAfterShutdownPolicy() {
        return this.continueExistingPeriodicTasksAfterShutdown;
    }

    public void setExecuteExistingDelayedTasksAfterShutdownPolicy(boolean bl2) {
        this.executeExistingDelayedTasksAfterShutdown = bl2;
        if (!bl2 && this.isShutdown()) {
            this.onShutdown();
        }
    }

    public boolean getExecuteExistingDelayedTasksAfterShutdownPolicy() {
        return this.executeExistingDelayedTasksAfterShutdown;
    }

    public void setRemoveOnCancelPolicy(boolean bl2) {
        this.removeOnCancel = bl2;
    }

    public boolean getRemoveOnCancelPolicy() {
        return this.removeOnCancel;
    }

    @Override
    public void shutdown() {
        super.shutdown();
    }

    @Override
    public List shutdownNow() {
        return super.shutdownNow();
    }

    @Override
    public BlockingQueue getQueue() {
        return super.getQueue();
    }

    static class DelayedWorkQueue
    extends AbstractQueue
    implements BlockingQueue {
        private static final int INITIAL_CAPACITY = 64;
        private transient RunnableScheduledFuture[] queue = new RunnableScheduledFuture[64];
        private final transient ReentrantLock lock = new ReentrantLock();
        private final transient Condition available = this.lock.newCondition();
        private int size = 0;

        DelayedWorkQueue() {
        }

        private void setIndex(Object object, int n2) {
            if (object instanceof ScheduledFutureTask) {
                ((ScheduledFutureTask)object).heapIndex = n2;
            }
        }

        private void siftUp(int n2, RunnableScheduledFuture runnableScheduledFuture) {
            int n3;
            RunnableScheduledFuture runnableScheduledFuture2;
            while (n2 > 0 && runnableScheduledFuture.compareTo(runnableScheduledFuture2 = this.queue[n3 = n2 - 1 >>> 1]) < 0) {
                this.queue[n2] = runnableScheduledFuture2;
                this.setIndex(runnableScheduledFuture2, n2);
                n2 = n3;
            }
            this.queue[n2] = runnableScheduledFuture;
            this.setIndex(runnableScheduledFuture, n2);
        }

        private void siftDown(int n2, RunnableScheduledFuture runnableScheduledFuture) {
            int n3 = this.size >>> 1;
            while (n2 < n3) {
                int n4 = (n2 << 1) + 1;
                RunnableScheduledFuture runnableScheduledFuture2 = this.queue[n4];
                int n5 = n4 + 1;
                if (n5 < this.size && runnableScheduledFuture2.compareTo(this.queue[n5]) > 0) {
                    n4 = n5;
                    runnableScheduledFuture2 = this.queue[n4];
                }
                if (runnableScheduledFuture.compareTo(runnableScheduledFuture2) <= 0) break;
                this.queue[n2] = runnableScheduledFuture2;
                this.setIndex(runnableScheduledFuture2, n2);
                n2 = n4;
            }
            this.queue[n2] = runnableScheduledFuture;
            this.setIndex(runnableScheduledFuture, n2);
        }

        private RunnableScheduledFuture finishPoll(RunnableScheduledFuture runnableScheduledFuture) {
            int n2 = --this.size;
            RunnableScheduledFuture runnableScheduledFuture2 = this.queue[n2];
            this.queue[n2] = null;
            if (n2 != 0) {
                this.siftDown(0, runnableScheduledFuture2);
                this.available.signalAll();
            }
            this.setIndex(runnableScheduledFuture, -1);
            return runnableScheduledFuture;
        }

        private void grow() {
            int n2 = this.queue.length;
            int n3 = n2 + (n2 >> 1);
            if (n3 < 0) {
                n3 = Integer.MAX_VALUE;
            }
            RunnableScheduledFuture[] runnableScheduledFutureArray = new RunnableScheduledFuture[n3];
            System.arraycopy(this.queue, 0, runnableScheduledFutureArray, 0, this.queue.length);
            this.queue = runnableScheduledFutureArray;
        }

        private int indexOf(Object object) {
            if (object != null) {
                for (int i2 = 0; i2 < this.size; ++i2) {
                    if (!object.equals(this.queue[i2])) continue;
                    return i2;
                }
            }
            return -1;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean remove(Object object) {
            boolean bl2;
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                int n2 = object instanceof ScheduledFutureTask ? ((ScheduledFutureTask)object).heapIndex : this.indexOf(object);
                bl2 = n2 >= 0 && n2 < this.size && this.queue[n2] == object;
                if (bl2) {
                    this.setIndex(object, -1);
                    int n3 = --this.size;
                    RunnableScheduledFuture runnableScheduledFuture = this.queue[n3];
                    this.queue[n3] = null;
                    if (n3 != n2) {
                        this.siftDown(n2, runnableScheduledFuture);
                        if (this.queue[n2] == runnableScheduledFuture) {
                            this.siftUp(n2, runnableScheduledFuture);
                        }
                    }
                }
            }
            finally {
                reentrantLock.unlock();
            }
            return bl2;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public int size() {
            int n2;
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                n2 = this.size;
            }
            finally {
                reentrantLock.unlock();
            }
            return n2;
        }

        @Override
        public boolean isEmpty() {
            return this.size() == 0;
        }

        @Override
        public int remainingCapacity() {
            return Integer.MAX_VALUE;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public Object peek() {
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                RunnableScheduledFuture runnableScheduledFuture = this.queue[0];
                return runnableScheduledFuture;
            }
            finally {
                reentrantLock.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean offer(Object object) {
            if (object == null) {
                throw new NullPointerException();
            }
            RunnableScheduledFuture runnableScheduledFuture = (RunnableScheduledFuture)object;
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                boolean bl2;
                int n2 = this.size;
                if (n2 >= this.queue.length) {
                    this.grow();
                }
                this.size = n2 + 1;
                if (n2 == 0) {
                    bl2 = true;
                    this.queue[0] = runnableScheduledFuture;
                    this.setIndex(runnableScheduledFuture, 0);
                } else {
                    bl2 = runnableScheduledFuture.compareTo(this.queue[0]) < 0;
                    this.siftUp(n2, runnableScheduledFuture);
                }
                if (bl2) {
                    this.available.signalAll();
                }
            }
            finally {
                reentrantLock.unlock();
            }
            return true;
        }

        @Override
        public void put(Object object) {
            this.offer(object);
        }

        public boolean add(Runnable runnable) {
            return this.offer(runnable);
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
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                RunnableScheduledFuture runnableScheduledFuture = this.queue[0];
                if (runnableScheduledFuture == null || runnableScheduledFuture.getDelay(TimeUnit.NANOSECONDS) > 0L) {
                    Object var3_3 = null;
                    return var3_3;
                }
                RunnableScheduledFuture runnableScheduledFuture2 = this.finishPoll(runnableScheduledFuture);
                return runnableScheduledFuture2;
            }
            finally {
                reentrantLock.unlock();
            }
        }

        @Override
        public Object take() throws InterruptedException {
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lockInterruptibly();
            try {
                while (true) {
                    RunnableScheduledFuture runnableScheduledFuture;
                    if ((runnableScheduledFuture = this.queue[0]) == null) {
                        this.available.await();
                        continue;
                    }
                    long l2 = runnableScheduledFuture.getDelay(TimeUnit.NANOSECONDS);
                    if (l2 > 0L) {
                        this.available.await(l2, TimeUnit.NANOSECONDS);
                        continue;
                    }
                    RunnableScheduledFuture runnableScheduledFuture2 = this.finishPoll(runnableScheduledFuture);
                    return runnableScheduledFuture2;
                }
            }
            finally {
                reentrantLock.unlock();
            }
        }

        @Override
        public Object poll(long l2, TimeUnit timeUnit) throws InterruptedException {
            long l3 = timeUnit.toNanos(l2);
            long l4 = Utils.nanoTime() + l3;
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lockInterruptibly();
            try {
                while (true) {
                    RunnableScheduledFuture runnableScheduledFuture;
                    if ((runnableScheduledFuture = this.queue[0]) == null) {
                        if (l3 <= 0L) {
                            Object var10_8 = null;
                            return var10_8;
                        }
                        this.available.await(l3, TimeUnit.NANOSECONDS);
                        l3 = l4 - Utils.nanoTime();
                        continue;
                    }
                    long l5 = runnableScheduledFuture.getDelay(TimeUnit.NANOSECONDS);
                    if (l5 > 0L) {
                        if (l3 <= 0L) {
                            Object var12_9 = null;
                            return var12_9;
                        }
                        if (l5 > l3) {
                            l5 = l3;
                        }
                        this.available.await(l5, TimeUnit.NANOSECONDS);
                        l3 = l4 - Utils.nanoTime();
                        continue;
                    }
                    RunnableScheduledFuture runnableScheduledFuture2 = this.finishPoll(runnableScheduledFuture);
                    return runnableScheduledFuture2;
                }
            }
            finally {
                reentrantLock.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void clear() {
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                for (int i2 = 0; i2 < this.size; ++i2) {
                    RunnableScheduledFuture runnableScheduledFuture = this.queue[i2];
                    if (runnableScheduledFuture == null) continue;
                    this.queue[i2] = null;
                    this.setIndex(runnableScheduledFuture, -1);
                }
                this.size = 0;
            }
            finally {
                reentrantLock.unlock();
            }
        }

        private RunnableScheduledFuture pollExpired() {
            RunnableScheduledFuture runnableScheduledFuture = this.queue[0];
            if (runnableScheduledFuture == null || runnableScheduledFuture.getDelay(TimeUnit.NANOSECONDS) > 0L) {
                return null;
            }
            this.setIndex(runnableScheduledFuture, -1);
            int n2 = --this.size;
            RunnableScheduledFuture runnableScheduledFuture2 = this.queue[n2];
            this.queue[n2] = null;
            if (n2 != 0) {
                this.siftDown(0, runnableScheduledFuture2);
            }
            return runnableScheduledFuture;
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
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                RunnableScheduledFuture runnableScheduledFuture;
                int n2 = 0;
                while ((runnableScheduledFuture = this.pollExpired()) != null) {
                    collection.add(runnableScheduledFuture);
                    ++n2;
                }
                if (n2 > 0) {
                    this.available.signalAll();
                }
                int n3 = n2;
                return n3;
            }
            finally {
                reentrantLock.unlock();
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
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                RunnableScheduledFuture runnableScheduledFuture;
                int n3;
                for (n3 = 0; n3 < n2 && (runnableScheduledFuture = this.pollExpired()) != null; ++n3) {
                    collection.add(runnableScheduledFuture);
                }
                if (n3 > 0) {
                    this.available.signalAll();
                }
                int n4 = n3;
                return n4;
            }
            finally {
                reentrantLock.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public Object[] toArray() {
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                Object[] objectArray = Arrays.copyOf(this.queue, this.size);
                return objectArray;
            }
            finally {
                reentrantLock.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public Object[] toArray(Object[] objectArray) {
            ReentrantLock reentrantLock = this.lock;
            reentrantLock.lock();
            try {
                if (objectArray.length < this.size) {
                    Object[] objectArray2 = Arrays.copyOf(this.queue, this.size, objectArray.getClass());
                    return objectArray2;
                }
                System.arraycopy(this.queue, 0, objectArray, 0, this.size);
                if (objectArray.length > this.size) {
                    objectArray[this.size] = null;
                }
                Object[] objectArray3 = objectArray;
                return objectArray3;
            }
            finally {
                reentrantLock.unlock();
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
                return (Runnable)this.array[this.cursor++];
            }

            @Override
            public void remove() {
                if (this.lastRet < 0) {
                    throw new IllegalStateException();
                }
                DelayedWorkQueue.this.remove(this.array[this.lastRet]);
                this.lastRet = -1;
            }
        }
    }

    private class ScheduledFutureTask
    extends FutureTask
    implements RunnableScheduledFuture {
        private final long sequenceNumber;
        private long time;
        private final long period;
        int heapIndex;

        ScheduledFutureTask(Runnable runnable, Object object, long l2) {
            super(runnable, object);
            this.time = l2;
            this.period = 0L;
            this.sequenceNumber = sequencer.getAndIncrement();
        }

        ScheduledFutureTask(Runnable runnable, Object object, long l2, long l3) {
            super(runnable, object);
            this.time = l2;
            this.period = l3;
            this.sequenceNumber = sequencer.getAndIncrement();
        }

        ScheduledFutureTask(Callable callable, long l2) {
            super(callable);
            this.time = l2;
            this.period = 0L;
            this.sequenceNumber = sequencer.getAndIncrement();
        }

        @Override
        public long getDelay(TimeUnit timeUnit) {
            long l2 = timeUnit.convert(this.time - ScheduledThreadPoolExecutor.this.now(), TimeUnit.NANOSECONDS);
            return l2;
        }

        public int compareTo(Object object) {
            Delayed delayed = (Delayed)object;
            if (delayed == this) {
                return 0;
            }
            if (delayed instanceof ScheduledFutureTask) {
                ScheduledFutureTask scheduledFutureTask = (ScheduledFutureTask)object;
                long l2 = this.time - scheduledFutureTask.time;
                if (l2 < 0L) {
                    return -1;
                }
                if (l2 > 0L) {
                    return 1;
                }
                if (this.sequenceNumber < scheduledFutureTask.sequenceNumber) {
                    return -1;
                }
                return 1;
            }
            long l3 = this.getDelay(TimeUnit.NANOSECONDS) - delayed.getDelay(TimeUnit.NANOSECONDS);
            return l3 == 0L ? 0 : (l3 < 0L ? -1 : 1);
        }

        @Override
        public boolean isPeriodic() {
            return this.period != 0L;
        }

        private void setNextRunTime() {
            long l2 = this.period;
            this.time = l2 > 0L ? (this.time += l2) : ScheduledThreadPoolExecutor.this.now() - l2;
        }

        @Override
        public boolean cancel(boolean bl2) {
            boolean bl3 = super.cancel(bl2);
            if (bl3 && ScheduledThreadPoolExecutor.this.removeOnCancel && this.heapIndex >= 0) {
                ScheduledThreadPoolExecutor.this.remove(this);
            }
            return bl3;
        }

        @Override
        public void run() {
            boolean bl2 = this.isPeriodic();
            if (!ScheduledThreadPoolExecutor.this.canRunInCurrentRunState(bl2)) {
                this.cancel(false);
            } else if (!bl2) {
                ScheduledFutureTask.super.run();
            } else if (ScheduledFutureTask.super.runAndReset()) {
                this.setNextRunTime();
                ScheduledThreadPoolExecutor.this.reExecutePeriodic(this);
            }
        }
    }
}

