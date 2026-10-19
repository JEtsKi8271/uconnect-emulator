/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.concurrent.AbstractExecutorService;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.Executors;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import edu.emory.mathcs.backport.java.util.concurrent.RejectedExecutionException;
import edu.emory.mathcs.backport.java.util.concurrent.RejectedExecutionHandler;
import edu.emory.mathcs.backport.java.util.concurrent.ThreadFactory;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.atomic.AtomicInteger;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.Utils;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import edu.emory.mathcs.backport.java.util.concurrent.locks.ReentrantLock;
import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

public class ThreadPoolExecutor
extends AbstractExecutorService {
    private final AtomicInteger ctl = new AtomicInteger(ThreadPoolExecutor.ctlOf(-536870912, 0));
    private static final int COUNT_BITS = 29;
    private static final int CAPACITY = 0x1FFFFFFF;
    private static final int RUNNING = -536870912;
    private static final int SHUTDOWN = 0;
    private static final int STOP = 0x20000000;
    private static final int TIDYING = 0x40000000;
    private static final int TERMINATED = 0x60000000;
    private final BlockingQueue workQueue;
    private final ReentrantLock mainLock = new ReentrantLock();
    private final HashSet workers = new HashSet();
    private final Condition termination = this.mainLock.newCondition();
    private int largestPoolSize;
    private long completedTaskCount;
    private volatile ThreadFactory threadFactory;
    private volatile RejectedExecutionHandler handler;
    private volatile long keepAliveTime;
    private volatile boolean allowCoreThreadTimeOut;
    private volatile int corePoolSize;
    private volatile int maximumPoolSize;
    private static final RejectedExecutionHandler defaultHandler = new AbortPolicy();
    private static final RuntimePermission shutdownPerm = new RuntimePermission("modifyThread");
    private static final boolean ONLY_ONE = true;

    private static int runStateOf(int n2) {
        return n2 & 0xE0000000;
    }

    private static int workerCountOf(int n2) {
        return n2 & 0x1FFFFFFF;
    }

    private static int ctlOf(int n2, int n3) {
        return n2 | n3;
    }

    private static boolean runStateLessThan(int n2, int n3) {
        return n2 < n3;
    }

    private static boolean runStateAtLeast(int n2, int n3) {
        return n2 >= n3;
    }

    private static boolean isRunning(int n2) {
        return n2 < 0;
    }

    private boolean compareAndIncrementWorkerCount(int n2) {
        return this.ctl.compareAndSet(n2, n2 + 1);
    }

    private boolean compareAndDecrementWorkerCount(int n2) {
        return this.ctl.compareAndSet(n2, n2 - 1);
    }

    private void decrementWorkerCount() {
        while (!this.compareAndDecrementWorkerCount(this.ctl.get())) {
        }
    }

    private void advanceRunState(int n2) {
        int n3;
        while (!ThreadPoolExecutor.runStateAtLeast(n3 = this.ctl.get(), n2) && !this.ctl.compareAndSet(n3, ThreadPoolExecutor.ctlOf(n2, ThreadPoolExecutor.workerCountOf(n3)))) {
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    final void tryTerminate() {
        int n2;
        while (!(ThreadPoolExecutor.isRunning(n2 = this.ctl.get()) || ThreadPoolExecutor.runStateAtLeast(n2, 0x40000000) || ThreadPoolExecutor.runStateOf(n2) == 0 && !this.workQueue.isEmpty())) {
            if (ThreadPoolExecutor.workerCountOf(n2) != 0) {
                this.interruptIdleWorkers(true);
                return;
            }
            ReentrantLock reentrantLock = this.mainLock;
            reentrantLock.lock();
            try {
                if (!this.ctl.compareAndSet(n2, ThreadPoolExecutor.ctlOf(0x40000000, 0))) continue;
                try {
                    this.terminated();
                }
                finally {
                    this.ctl.set(ThreadPoolExecutor.ctlOf(0x60000000, 0));
                    this.termination.signalAll();
                }
                return;
            }
            finally {
                reentrantLock.unlock();
                continue;
            }
            break;
        }
        return;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void checkShutdownAccess() {
        SecurityManager securityManager = System.getSecurityManager();
        if (securityManager != null) {
            securityManager.checkPermission(shutdownPerm);
            ReentrantLock reentrantLock = this.mainLock;
            reentrantLock.lock();
            try {
                for (Worker worker : this.workers) {
                    securityManager.checkAccess(worker.thread);
                }
            }
            finally {
                reentrantLock.unlock();
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void interruptWorkers() {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            for (Worker worker : this.workers) {
                try {
                    worker.thread.interrupt();
                }
                catch (SecurityException securityException) {}
            }
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void interruptIdleWorkers(boolean bl2) {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            for (Worker worker : this.workers) {
                Thread thread = worker.thread;
                if (!thread.isInterrupted() && worker.tryLock()) {
                    try {
                        thread.interrupt();
                    }
                    catch (SecurityException securityException) {
                    }
                    finally {
                        worker.unlock();
                    }
                }
                if (!bl2) continue;
                break;
            }
        }
        finally {
            reentrantLock.unlock();
        }
    }

    private void interruptIdleWorkers() {
        this.interruptIdleWorkers(false);
    }

    private void clearInterruptsForTaskRun() {
        if (ThreadPoolExecutor.runStateLessThan(this.ctl.get(), 0x20000000) && Thread.interrupted() && ThreadPoolExecutor.runStateAtLeast(this.ctl.get(), 0x20000000)) {
            Thread.currentThread().interrupt();
        }
    }

    final void reject(Runnable runnable) {
        this.handler.rejectedExecution(runnable, this);
    }

    void onShutdown() {
    }

    final boolean isRunningOrShutdown(boolean bl2) {
        int n2 = ThreadPoolExecutor.runStateOf(this.ctl.get());
        return n2 == -536870912 || n2 == 0 && bl2;
    }

    private List drainQueue() {
        BlockingQueue blockingQueue = this.workQueue;
        ArrayList<Runnable> arrayList = new ArrayList<Runnable>();
        blockingQueue.drainTo(arrayList);
        if (!blockingQueue.isEmpty()) {
            Runnable[] runnableArray = blockingQueue.toArray(new Runnable[0]);
            for (int i2 = 0; i2 < runnableArray.length; ++i2) {
                Runnable runnable = runnableArray[i2];
                if (!blockingQueue.remove(runnable)) continue;
                arrayList.add(runnable);
            }
        }
        return arrayList;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private boolean addWorker(Runnable runnable, boolean bl2) {
        block4: while (true) {
            int n2;
            int n3;
            if ((n3 = ThreadPoolExecutor.runStateOf(n2 = this.ctl.get())) >= 0 && (n3 != 0 || runnable != null || this.workQueue.isEmpty())) {
                return false;
            }
            do {
                int n4;
                if ((n4 = ThreadPoolExecutor.workerCountOf(n2)) >= 0x1FFFFFFF || n4 >= (bl2 ? this.corePoolSize : this.maximumPoolSize)) {
                    return false;
                }
                if (this.compareAndIncrementWorkerCount(n2)) break block4;
            } while (ThreadPoolExecutor.runStateOf(n2 = this.ctl.get()) == n3);
        }
        Worker worker = new Worker(runnable);
        Thread thread = worker.thread;
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            int n5 = this.ctl.get();
            int n6 = ThreadPoolExecutor.runStateOf(n5);
            if (thread == null || n6 >= 0 && (n6 != 0 || runnable != null)) {
                this.decrementWorkerCount();
                this.tryTerminate();
                boolean bl3 = false;
                return bl3;
            }
            this.workers.add(worker);
            int n7 = this.workers.size();
            if (n7 > this.largestPoolSize) {
                this.largestPoolSize = n7;
            }
        }
        finally {
            reentrantLock.unlock();
        }
        thread.start();
        if (ThreadPoolExecutor.runStateOf(this.ctl.get()) == 0x20000000 && !thread.isInterrupted()) {
            thread.interrupt();
        }
        return true;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void processWorkerExit(Worker worker, boolean bl2) {
        if (bl2) {
            this.decrementWorkerCount();
        }
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            this.completedTaskCount += worker.completedTasks;
            this.workers.remove(worker);
        }
        finally {
            reentrantLock.unlock();
        }
        this.tryTerminate();
        int n2 = this.ctl.get();
        if (ThreadPoolExecutor.runStateLessThan(n2, 0x20000000)) {
            if (!bl2) {
                int n3;
                int n4 = n3 = this.allowCoreThreadTimeOut ? 0 : this.corePoolSize;
                if (n3 == 0 && !this.workQueue.isEmpty()) {
                    n3 = 1;
                }
                if (ThreadPoolExecutor.workerCountOf(n2) >= n3) {
                    return;
                }
            }
            this.addWorker(null, false);
        }
    }

    private Runnable getTask() {
        boolean bl2 = false;
        while (true) {
            boolean bl3;
            block6: {
                int n2;
                int n3;
                if ((n3 = ThreadPoolExecutor.runStateOf(n2 = this.ctl.get())) >= 0 && (n3 >= 0x20000000 || this.workQueue.isEmpty())) {
                    this.decrementWorkerCount();
                    return null;
                }
                do {
                    int n4 = ThreadPoolExecutor.workerCountOf(n2);
                    boolean bl4 = bl3 = this.allowCoreThreadTimeOut || n4 > this.corePoolSize;
                    if (n4 <= this.maximumPoolSize && (!bl2 || !bl3)) break block6;
                    if (!this.compareAndDecrementWorkerCount(n2)) continue;
                    return null;
                } while (ThreadPoolExecutor.runStateOf(n2 = this.ctl.get()) == n3);
                continue;
            }
            try {
                Runnable runnable;
                Runnable runnable2 = runnable = bl3 ? (Runnable)this.workQueue.poll(this.keepAliveTime, TimeUnit.NANOSECONDS) : (Runnable)this.workQueue.take();
                if (runnable != null) {
                    return runnable;
                }
                bl2 = true;
                continue;
            }
            catch (InterruptedException interruptedException) {
                bl2 = false;
                continue;
            }
            break;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    final void runWorker(Worker worker) {
        Runnable runnable = worker.firstTask;
        worker.firstTask = null;
        boolean bl2 = true;
        try {
            while (runnable != null || (runnable = this.getTask()) != null) {
                worker.lock();
                this.clearInterruptsForTaskRun();
                try {
                    this.beforeExecute(worker.thread, runnable);
                    Throwable throwable = null;
                    try {
                        runnable.run();
                    }
                    catch (RuntimeException runtimeException) {
                        throwable = runtimeException;
                        throw runtimeException;
                    }
                    catch (Error error) {
                        throwable = error;
                        throw error;
                    }
                    catch (Throwable throwable2) {
                        throwable = throwable2;
                        throw new Error(throwable2);
                    }
                    finally {
                        this.afterExecute(runnable, throwable);
                    }
                }
                finally {
                    runnable = null;
                    ++worker.completedTasks;
                    worker.unlock();
                }
            }
            bl2 = false;
        }
        finally {
            this.processWorkerExit(worker, bl2);
        }
    }

    public ThreadPoolExecutor(int n2, int n3, long l2, TimeUnit timeUnit, BlockingQueue blockingQueue) {
        this(n2, n3, l2, timeUnit, blockingQueue, Executors.defaultThreadFactory(), defaultHandler);
    }

    public ThreadPoolExecutor(int n2, int n3, long l2, TimeUnit timeUnit, BlockingQueue blockingQueue, ThreadFactory threadFactory) {
        this(n2, n3, l2, timeUnit, blockingQueue, threadFactory, defaultHandler);
    }

    public ThreadPoolExecutor(int n2, int n3, long l2, TimeUnit timeUnit, BlockingQueue blockingQueue, RejectedExecutionHandler rejectedExecutionHandler) {
        this(n2, n3, l2, timeUnit, blockingQueue, Executors.defaultThreadFactory(), rejectedExecutionHandler);
    }

    public ThreadPoolExecutor(int n2, int n3, long l2, TimeUnit timeUnit, BlockingQueue blockingQueue, ThreadFactory threadFactory, RejectedExecutionHandler rejectedExecutionHandler) {
        if (n2 < 0 || n3 <= 0 || n3 < n2 || l2 < 0L) {
            throw new IllegalArgumentException();
        }
        if (blockingQueue == null || threadFactory == null || rejectedExecutionHandler == null) {
            throw new NullPointerException();
        }
        this.corePoolSize = n2;
        this.maximumPoolSize = n3;
        this.workQueue = blockingQueue;
        this.keepAliveTime = timeUnit.toNanos(l2);
        this.threadFactory = threadFactory;
        this.handler = rejectedExecutionHandler;
    }

    @Override
    public void execute(Runnable runnable) {
        if (runnable == null) {
            throw new NullPointerException();
        }
        int n2 = this.ctl.get();
        if (ThreadPoolExecutor.workerCountOf(n2) < this.corePoolSize) {
            if (this.addWorker(runnable, true)) {
                return;
            }
            n2 = this.ctl.get();
        }
        if (ThreadPoolExecutor.isRunning(n2) && this.workQueue.offer(runnable)) {
            int n3 = this.ctl.get();
            if (!ThreadPoolExecutor.isRunning(n3) && this.remove(runnable)) {
                this.reject(runnable);
            } else if (ThreadPoolExecutor.workerCountOf(n3) == 0) {
                this.addWorker(null, false);
            }
        } else if (!this.addWorker(runnable, false)) {
            this.reject(runnable);
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void shutdown() {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            this.checkShutdownAccess();
            this.advanceRunState(0);
            this.interruptIdleWorkers();
            this.onShutdown();
        }
        finally {
            reentrantLock.unlock();
        }
        this.tryTerminate();
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public List shutdownNow() {
        List list;
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            this.checkShutdownAccess();
            this.advanceRunState(0x20000000);
            this.interruptWorkers();
            list = this.drainQueue();
        }
        finally {
            reentrantLock.unlock();
        }
        this.tryTerminate();
        return list;
    }

    @Override
    public boolean isShutdown() {
        return !ThreadPoolExecutor.isRunning(this.ctl.get());
    }

    public boolean isTerminating() {
        int n2 = this.ctl.get();
        return !ThreadPoolExecutor.isRunning(n2) && ThreadPoolExecutor.runStateLessThan(n2, 0x60000000);
    }

    @Override
    public boolean isTerminated() {
        return ThreadPoolExecutor.runStateAtLeast(this.ctl.get(), 0x60000000);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean awaitTermination(long l2, TimeUnit timeUnit) throws InterruptedException {
        long l3 = timeUnit.toNanos(l2);
        long l4 = Utils.nanoTime() + l3;
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            if (ThreadPoolExecutor.runStateAtLeast(this.ctl.get(), 0x60000000)) {
                boolean bl2 = true;
                return bl2;
            }
            while (l3 > 0L) {
                this.termination.await(l3, TimeUnit.NANOSECONDS);
                if (ThreadPoolExecutor.runStateAtLeast(this.ctl.get(), 0x60000000)) {
                    boolean bl3 = true;
                    return bl3;
                }
                l3 = l4 - Utils.nanoTime();
            }
            boolean bl4 = false;
            return bl4;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    protected void finalize() {
        this.shutdown();
    }

    public void setThreadFactory(ThreadFactory threadFactory) {
        if (threadFactory == null) {
            throw new NullPointerException();
        }
        this.threadFactory = threadFactory;
    }

    public ThreadFactory getThreadFactory() {
        return this.threadFactory;
    }

    public void setRejectedExecutionHandler(RejectedExecutionHandler rejectedExecutionHandler) {
        if (rejectedExecutionHandler == null) {
            throw new NullPointerException();
        }
        this.handler = rejectedExecutionHandler;
    }

    public RejectedExecutionHandler getRejectedExecutionHandler() {
        return this.handler;
    }

    public void setCorePoolSize(int n2) {
        block3: {
            int n3;
            block2: {
                if (n2 < 0) {
                    throw new IllegalArgumentException();
                }
                n3 = n2 - this.corePoolSize;
                this.corePoolSize = n2;
                if (ThreadPoolExecutor.workerCountOf(this.ctl.get()) <= n2) break block2;
                this.interruptIdleWorkers();
                break block3;
            }
            if (n3 <= 0) break block3;
            int n4 = Math.min(n3, this.workQueue.size());
            while (n4-- > 0 && this.addWorker(null, true) && !this.workQueue.isEmpty()) {
            }
        }
    }

    public int getCorePoolSize() {
        return this.corePoolSize;
    }

    public boolean prestartCoreThread() {
        return ThreadPoolExecutor.workerCountOf(this.ctl.get()) < this.corePoolSize && this.addWorker(null, true);
    }

    public int prestartAllCoreThreads() {
        int n2 = 0;
        while (this.addWorker(null, true)) {
            ++n2;
        }
        return n2;
    }

    public boolean allowsCoreThreadTimeOut() {
        return this.allowCoreThreadTimeOut;
    }

    public void allowCoreThreadTimeOut(boolean bl2) {
        if (bl2 && this.keepAliveTime <= 0L) {
            throw new IllegalArgumentException("Core threads must have nonzero keep alive times");
        }
        if (bl2 != this.allowCoreThreadTimeOut) {
            this.allowCoreThreadTimeOut = bl2;
            if (bl2) {
                this.interruptIdleWorkers();
            }
        }
    }

    public void setMaximumPoolSize(int n2) {
        if (n2 <= 0 || n2 < this.corePoolSize) {
            throw new IllegalArgumentException();
        }
        this.maximumPoolSize = n2;
        if (ThreadPoolExecutor.workerCountOf(this.ctl.get()) > n2) {
            this.interruptIdleWorkers();
        }
    }

    public int getMaximumPoolSize() {
        return this.maximumPoolSize;
    }

    public void setKeepAliveTime(long l2, TimeUnit timeUnit) {
        if (l2 < 0L) {
            throw new IllegalArgumentException();
        }
        if (l2 == 0L && this.allowsCoreThreadTimeOut()) {
            throw new IllegalArgumentException("Core threads must have nonzero keep alive times");
        }
        long l3 = timeUnit.toNanos(l2);
        long l4 = l3 - this.keepAliveTime;
        this.keepAliveTime = l3;
        if (l4 < 0L) {
            this.interruptIdleWorkers();
        }
    }

    public long getKeepAliveTime(TimeUnit timeUnit) {
        return timeUnit.convert(this.keepAliveTime, TimeUnit.NANOSECONDS);
    }

    public BlockingQueue getQueue() {
        return this.workQueue;
    }

    public boolean remove(Runnable runnable) {
        boolean bl2 = this.workQueue.remove(runnable);
        this.tryTerminate();
        return bl2;
    }

    public void purge() {
        BlockingQueue blockingQueue = this.workQueue;
        try {
            Iterator iterator = blockingQueue.iterator();
            while (iterator.hasNext()) {
                Runnable runnable = (Runnable)iterator.next();
                if (!(runnable instanceof Future) || !((Future)((Object)runnable)).isCancelled()) continue;
                iterator.remove();
            }
        }
        catch (ConcurrentModificationException concurrentModificationException) {
            Object[] objectArray = blockingQueue.toArray();
            for (int i2 = 0; i2 < objectArray.length; ++i2) {
                Object object = objectArray[i2];
                if (!(object instanceof Future) || !((Future)object).isCancelled()) continue;
                blockingQueue.remove(object);
            }
        }
        this.tryTerminate();
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public int getPoolSize() {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            int n2 = ThreadPoolExecutor.runStateAtLeast(this.ctl.get(), 0x40000000) ? 0 : this.workers.size();
            return n2;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public int getActiveCount() {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            int n2 = 0;
            for (Worker worker : this.workers) {
                if (!worker.isLocked()) continue;
                ++n2;
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
    public int getLargestPoolSize() {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            int n2 = this.largestPoolSize;
            return n2;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public long getTaskCount() {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            long l2 = this.completedTaskCount;
            for (Worker worker : this.workers) {
                l2 += worker.completedTasks;
                if (!worker.isLocked()) continue;
                ++l2;
            }
            long l3 = l2 + (long)this.workQueue.size();
            return l3;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public long getCompletedTaskCount() {
        ReentrantLock reentrantLock = this.mainLock;
        reentrantLock.lock();
        try {
            long l2 = this.completedTaskCount;
            for (Worker worker : this.workers) {
                l2 += worker.completedTasks;
            }
            long l3 = l2;
            return l3;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    protected void beforeExecute(Thread thread, Runnable runnable) {
    }

    protected void afterExecute(Runnable runnable, Throwable throwable) {
    }

    protected void terminated() {
    }

    public static class DiscardOldestPolicy
    implements RejectedExecutionHandler {
        @Override
        public void rejectedExecution(Runnable runnable, ThreadPoolExecutor threadPoolExecutor) {
            if (!threadPoolExecutor.isShutdown()) {
                threadPoolExecutor.getQueue().poll();
                threadPoolExecutor.execute(runnable);
            }
        }
    }

    public static class DiscardPolicy
    implements RejectedExecutionHandler {
        @Override
        public void rejectedExecution(Runnable runnable, ThreadPoolExecutor threadPoolExecutor) {
        }
    }

    public static class AbortPolicy
    implements RejectedExecutionHandler {
        @Override
        public void rejectedExecution(Runnable runnable, ThreadPoolExecutor threadPoolExecutor) {
            throw new RejectedExecutionException();
        }
    }

    public static class CallerRunsPolicy
    implements RejectedExecutionHandler {
        @Override
        public void rejectedExecution(Runnable runnable, ThreadPoolExecutor threadPoolExecutor) {
            if (!threadPoolExecutor.isShutdown()) {
                runnable.run();
            }
        }
    }

    private final class Worker
    extends ReentrantLock
    implements Runnable {
        private static final long serialVersionUID = 6138294804551838833L;
        final Thread thread;
        Runnable firstTask;
        volatile long completedTasks;

        Worker(Runnable runnable) {
            this.firstTask = runnable;
            this.thread = ThreadPoolExecutor.this.getThreadFactory().newThread(this);
        }

        @Override
        public void run() {
            ThreadPoolExecutor.this.runWorker(this);
        }
    }
}

