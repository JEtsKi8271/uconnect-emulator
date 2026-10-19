/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractQueue;
import edu.emory.mathcs.backport.java.util.concurrent.BlockingQueue;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import edu.emory.mathcs.backport.java.util.concurrent.locks.ReentrantLock;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class ArrayBlockingQueue
extends AbstractQueue
implements BlockingQueue,
Serializable {
    private static final long serialVersionUID = -817911632652898426L;
    private final Object[] items;
    private int takeIndex;
    private int putIndex;
    private int count;
    private final ReentrantLock lock;
    private final Condition notEmpty;
    private final Condition notFull;

    final int inc(int n2) {
        return ++n2 == this.items.length ? 0 : n2;
    }

    private void insert(Object object) {
        this.items[this.putIndex] = object;
        this.putIndex = this.inc(this.putIndex);
        ++this.count;
        this.notEmpty.signal();
    }

    private Object extract() {
        Object[] objectArray = this.items;
        Object object = objectArray[this.takeIndex];
        objectArray[this.takeIndex] = null;
        this.takeIndex = this.inc(this.takeIndex);
        --this.count;
        this.notFull.signal();
        return object;
    }

    void removeAt(int n2) {
        Object[] objectArray = this.items;
        if (n2 == this.takeIndex) {
            objectArray[this.takeIndex] = null;
            this.takeIndex = this.inc(this.takeIndex);
        } else {
            int n3;
            while ((n3 = this.inc(n2)) != this.putIndex) {
                objectArray[n2] = objectArray[n3];
                n2 = n3;
            }
            objectArray[n2] = null;
            this.putIndex = n2;
        }
        --this.count;
        this.notFull.signal();
    }

    public ArrayBlockingQueue(int n2) {
        this(n2, false);
    }

    public ArrayBlockingQueue(int n2, boolean bl2) {
        if (n2 <= 0) {
            throw new IllegalArgumentException();
        }
        this.items = new Object[n2];
        this.lock = new ReentrantLock(bl2);
        this.notEmpty = this.lock.newCondition();
        this.notFull = this.lock.newCondition();
    }

    public ArrayBlockingQueue(int n2, boolean bl2, Collection collection) {
        this(n2, bl2);
        if (n2 < collection.size()) {
            throw new IllegalArgumentException();
        }
        Iterator iterator = collection.iterator();
        while (iterator.hasNext()) {
            this.add(iterator.next());
        }
    }

    @Override
    public boolean add(Object object) {
        return super.add(object);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean offer(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            if (this.count == this.items.length) {
                boolean bl2 = false;
                return bl2;
            }
            this.insert(object);
            boolean bl3 = true;
            return bl3;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public void put(Object object) throws InterruptedException {
        if (object == null) {
            throw new NullPointerException();
        }
        Object[] objectArray = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lockInterruptibly();
        try {
            try {
                while (this.count == objectArray.length) {
                    this.notFull.await();
                }
            }
            catch (InterruptedException interruptedException) {
                this.notFull.signal();
                throw interruptedException;
            }
            this.insert(object);
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * Exception decompiling
     */
    @Override
    public boolean offer(Object var1_1, long var2_2, TimeUnit var4_3) throws InterruptedException {
        /*
         * This method has failed to decompile.  When submitting a bug report, please provide this stack trace, and (if you hold appropriate legal rights) the relevant class file.
         * 
         * org.benf.cfr.reader.util.ConfusedCFRException: Tried to end blocks [0[TRYBLOCK]], but top level block is 7[UNCONDITIONALDOLOOP]
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op04StructuredStatement.processEndingBlocks(Op04StructuredStatement.java:435)
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op04StructuredStatement.buildNestedBlocks(Op04StructuredStatement.java:484)
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op03SimpleStatement.createInitialStructuredBlock(Op03SimpleStatement.java:736)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysisInner(CodeAnalyser.java:850)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysisOrWrapFail(CodeAnalyser.java:278)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysis(CodeAnalyser.java:201)
         *     at org.benf.cfr.reader.entities.attributes.AttributeCode.analyse(AttributeCode.java:94)
         *     at org.benf.cfr.reader.entities.Method.analyse(Method.java:531)
         *     at org.benf.cfr.reader.entities.ClassFile.analyseMid(ClassFile.java:1055)
         *     at org.benf.cfr.reader.entities.ClassFile.analyseTop(ClassFile.java:942)
         *     at org.benf.cfr.reader.Driver.doJarVersionTypes(Driver.java:257)
         *     at org.benf.cfr.reader.Driver.doJar(Driver.java:139)
         *     at org.benf.cfr.reader.CfrDriverImpl.analyse(CfrDriverImpl.java:76)
         *     at org.benf.cfr.reader.Main.main(Main.java:54)
         */
        throw new IllegalStateException("Decompilation failed");
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object poll() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            Object object;
            if (this.count == 0) {
                Object var2_2 = null;
                return var2_2;
            }
            Object object2 = object = this.extract();
            return object2;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object take() throws InterruptedException {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lockInterruptibly();
        try {
            Object object;
            try {
                while (this.count == 0) {
                    this.notEmpty.await();
                }
            }
            catch (InterruptedException interruptedException) {
                this.notEmpty.signal();
                throw interruptedException;
            }
            Object object2 = object = this.extract();
            return object2;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * Exception decompiling
     */
    @Override
    public Object poll(long var1_1, TimeUnit var3_2) throws InterruptedException {
        /*
         * This method has failed to decompile.  When submitting a bug report, please provide this stack trace, and (if you hold appropriate legal rights) the relevant class file.
         * 
         * org.benf.cfr.reader.util.ConfusedCFRException: Tried to end blocks [0[TRYBLOCK]], but top level block is 7[UNCONDITIONALDOLOOP]
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op04StructuredStatement.processEndingBlocks(Op04StructuredStatement.java:435)
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op04StructuredStatement.buildNestedBlocks(Op04StructuredStatement.java:484)
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op03SimpleStatement.createInitialStructuredBlock(Op03SimpleStatement.java:736)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysisInner(CodeAnalyser.java:850)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysisOrWrapFail(CodeAnalyser.java:278)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysis(CodeAnalyser.java:201)
         *     at org.benf.cfr.reader.entities.attributes.AttributeCode.analyse(AttributeCode.java:94)
         *     at org.benf.cfr.reader.entities.Method.analyse(Method.java:531)
         *     at org.benf.cfr.reader.entities.ClassFile.analyseMid(ClassFile.java:1055)
         *     at org.benf.cfr.reader.entities.ClassFile.analyseTop(ClassFile.java:942)
         *     at org.benf.cfr.reader.Driver.doJarVersionTypes(Driver.java:257)
         *     at org.benf.cfr.reader.Driver.doJar(Driver.java:139)
         *     at org.benf.cfr.reader.CfrDriverImpl.analyse(CfrDriverImpl.java:76)
         *     at org.benf.cfr.reader.Main.main(Main.java:54)
         */
        throw new IllegalStateException("Decompilation failed");
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Object peek() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            Object object = this.count == 0 ? null : this.items[this.takeIndex];
            return object;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public int size() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            int n2 = this.count;
            return n2;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public int remainingCapacity() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            int n2 = this.items.length - this.count;
            return n2;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    @Override
    public boolean remove(Object object) {
        if (object == null) {
            return false;
        }
        Object[] objectArray = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            int n2 = this.takeIndex;
            int n3 = 0;
            while (true) {
                if (n3++ >= this.count) {
                    boolean bl2 = false;
                    return bl2;
                }
                if (object.equals(objectArray[n2])) {
                    this.removeAt(n2);
                    boolean bl3 = true;
                    return bl3;
                }
                n2 = this.inc(n2);
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
    public boolean contains(Object object) {
        if (object == null) {
            return false;
        }
        Object[] objectArray = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            int n2 = this.takeIndex;
            int n3 = 0;
            while (n3++ < this.count) {
                if (object.equals(objectArray[n2])) {
                    boolean bl2 = true;
                    return bl2;
                }
                n2 = this.inc(n2);
            }
            boolean bl3 = false;
            return bl3;
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
        Object[] objectArray = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            Object[] objectArray2 = new Object[this.count];
            int n2 = 0;
            int n3 = this.takeIndex;
            while (n2 < this.count) {
                objectArray2[n2++] = objectArray[n3];
                n3 = this.inc(n3);
            }
            Object[] objectArray3 = objectArray2;
            return objectArray3;
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
        Object[] objectArray2 = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            if (objectArray.length < this.count) {
                objectArray = (Object[])Array.newInstance(objectArray.getClass().getComponentType(), this.count);
            }
            int n2 = 0;
            int n3 = this.takeIndex;
            while (n2 < this.count) {
                objectArray[n2++] = objectArray2[n3];
                n3 = this.inc(n3);
            }
            if (objectArray.length > this.count) {
                objectArray[this.count] = null;
            }
            Object[] objectArray3 = objectArray;
            return objectArray3;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public String toString() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            String string = super.toString();
            return string;
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
        Object[] objectArray = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            int n2 = this.takeIndex;
            int n3 = this.count;
            while (n3-- > 0) {
                objectArray[n2] = null;
                n2 = this.inc(n2);
            }
            this.count = 0;
            this.putIndex = 0;
            this.takeIndex = 0;
            this.notFull.signalAll();
        }
        finally {
            reentrantLock.unlock();
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
        Object[] objectArray = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            int n2;
            int n3 = this.takeIndex;
            int n4 = this.count;
            for (n2 = 0; n2 < n4; ++n2) {
                collection.add(objectArray[n3]);
                objectArray[n3] = null;
                n3 = this.inc(n3);
            }
            if (n2 > 0) {
                this.count = 0;
                this.putIndex = 0;
                this.takeIndex = 0;
                this.notFull.signalAll();
            }
            int n5 = n2;
            return n5;
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
        Object[] objectArray = this.items;
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            int n3;
            int n4;
            int n5 = this.takeIndex;
            int n6 = this.count;
            int n7 = n4 = n2 < this.count ? n2 : this.count;
            for (n3 = 0; n3 < n4; ++n3) {
                collection.add(objectArray[n5]);
                objectArray[n5] = null;
                n5 = this.inc(n5);
            }
            if (n3 > 0) {
                this.count -= n3;
                this.takeIndex = n5;
                this.notFull.signalAll();
            }
            int n8 = n3;
            return n8;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public Iterator iterator() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            Itr itr = new Itr();
            return itr;
        }
        finally {
            reentrantLock.unlock();
        }
    }

    private class Itr
    implements Iterator {
        private int nextIndex;
        private Object nextItem;
        private int lastRet = -1;

        Itr() {
            if (ArrayBlockingQueue.this.count == 0) {
                this.nextIndex = -1;
            } else {
                this.nextIndex = ArrayBlockingQueue.this.takeIndex;
                this.nextItem = ArrayBlockingQueue.this.items[ArrayBlockingQueue.this.takeIndex];
            }
        }

        @Override
        public boolean hasNext() {
            return this.nextIndex >= 0;
        }

        private void checkNext() {
            if (this.nextIndex == ArrayBlockingQueue.this.putIndex) {
                this.nextIndex = -1;
                this.nextItem = null;
            } else {
                this.nextItem = ArrayBlockingQueue.this.items[this.nextIndex];
                if (this.nextItem == null) {
                    this.nextIndex = -1;
                }
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public Object next() {
            ReentrantLock reentrantLock = ArrayBlockingQueue.this.lock;
            reentrantLock.lock();
            try {
                if (this.nextIndex < 0) {
                    throw new NoSuchElementException();
                }
                this.lastRet = this.nextIndex;
                Object object = this.nextItem;
                this.nextIndex = ArrayBlockingQueue.this.inc(this.nextIndex);
                this.checkNext();
                Object object2 = object;
                return object2;
            }
            finally {
                reentrantLock.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void remove() {
            ReentrantLock reentrantLock = ArrayBlockingQueue.this.lock;
            reentrantLock.lock();
            try {
                int n2 = this.lastRet;
                if (n2 == -1) {
                    throw new IllegalStateException();
                }
                this.lastRet = -1;
                int n3 = ArrayBlockingQueue.this.takeIndex;
                ArrayBlockingQueue.this.removeAt(n2);
                this.nextIndex = n2 == n3 ? ArrayBlockingQueue.this.takeIndex : n2;
                this.checkNext();
            }
            finally {
                reentrantLock.unlock();
            }
        }
    }
}

