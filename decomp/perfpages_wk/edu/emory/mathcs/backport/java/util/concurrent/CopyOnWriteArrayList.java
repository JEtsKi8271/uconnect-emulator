/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.Arrays;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.util.Collection;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;
import java.util.RandomAccess;

public class CopyOnWriteArrayList
implements List,
RandomAccess,
Cloneable,
Serializable {
    private static final long serialVersionUID = 8673264195747942595L;
    private volatile transient Object[] array;

    public CopyOnWriteArrayList() {
        this.setArray(new Object[0]);
    }

    public CopyOnWriteArrayList(Collection collection) {
        Object[] objectArray = collection.toArray();
        if (objectArray.getClass() != Object[].class) {
            objectArray = Arrays.copyOf(objectArray, objectArray.length, Object[].class);
        }
        this.setArray(objectArray);
    }

    public CopyOnWriteArrayList(Object[] objectArray) {
        this.setArray(Arrays.copyOf(objectArray, objectArray.length, Object[].class));
    }

    final Object[] getArray() {
        return this.array;
    }

    final void setArray(Object[] objectArray) {
        this.array = objectArray;
    }

    @Override
    public int size() {
        return this.getArray().length;
    }

    @Override
    public boolean isEmpty() {
        return this.getArray().length == 0;
    }

    private static int search(Object[] objectArray, Object object, int n2, int n3) {
        if (object == null) {
            while (n2 < n3) {
                if (objectArray[n2] == null) {
                    return n2;
                }
                ++n2;
            }
        } else {
            while (n2 < n3) {
                if (object.equals(objectArray[n2])) {
                    return n2;
                }
                ++n2;
            }
        }
        return -1;
    }

    private static int reverseSearch(Object[] objectArray, Object object, int n2, int n3) {
        if (object == null) {
            --n3;
            while (n3 >= n2) {
                if (objectArray[n3] == null) {
                    return n3;
                }
                --n3;
            }
        } else {
            --n3;
            while (n3 >= n2) {
                if (object.equals(objectArray[n3])) {
                    return n3;
                }
                --n3;
            }
        }
        return -1;
    }

    @Override
    public boolean contains(Object object) {
        Object[] objectArray = this.getArray();
        return CopyOnWriteArrayList.search(objectArray, object, 0, objectArray.length) >= 0;
    }

    @Override
    public Iterator iterator() {
        return new COWIterator(this.getArray(), 0);
    }

    @Override
    public Object[] toArray() {
        Object[] objectArray = this.getArray();
        return Arrays.copyOf(objectArray, objectArray.length, Object[].class);
    }

    @Override
    public Object[] toArray(Object[] objectArray) {
        Object[] objectArray2 = this.getArray();
        int n2 = objectArray2.length;
        if (objectArray.length < n2) {
            return Arrays.copyOf(objectArray2, n2, objectArray.getClass());
        }
        System.arraycopy(objectArray2, 0, objectArray, 0, n2);
        if (objectArray.length > n2) {
            objectArray[n2] = null;
        }
        return objectArray;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean add(Object object) {
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n2 = objectArray.length;
            Object[] objectArray2 = new Object[n2 + 1];
            System.arraycopy(objectArray, 0, objectArray2, 0, n2);
            objectArray2[n2] = object;
            this.setArray(objectArray2);
            return true;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public boolean addIfAbsent(Object object) {
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n2 = objectArray.length;
            if (CopyOnWriteArrayList.search(this.array, object, 0, n2) >= 0) {
                return false;
            }
            Object[] objectArray2 = new Object[n2 + 1];
            System.arraycopy(objectArray, 0, objectArray2, 0, n2);
            objectArray2[n2] = object;
            this.setArray(objectArray2);
            return true;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public int addAllAbsent(Collection collection) {
        Object[] objectArray = collection.toArray();
        if (objectArray.length == 0) {
            return 0;
        }
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray2 = this.getArray();
            int n2 = objectArray2.length;
            Object[] objectArray3 = new Object[objectArray.length];
            int n3 = 0;
            for (int i2 = 0; i2 < objectArray.length; ++i2) {
                Object object = objectArray[i2];
                if (CopyOnWriteArrayList.search(objectArray2, object, 0, n2) >= 0 || CopyOnWriteArrayList.search(objectArray3, object, 0, n3) >= 0) continue;
                objectArray3[n3++] = object;
            }
            if (n3 == 0) {
                return 0;
            }
            Object[] objectArray4 = new Object[n2 + n3];
            System.arraycopy(objectArray2, 0, objectArray4, 0, n2);
            System.arraycopy(objectArray3, 0, objectArray4, n2, n3);
            this.setArray(objectArray4);
            return n3;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean remove(Object object) {
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n2 = objectArray.length;
            int n3 = CopyOnWriteArrayList.search(objectArray, object, 0, n2);
            if (n3 < 0) {
                return false;
            }
            Object[] objectArray2 = new Object[n2 - 1];
            int n4 = n2 - n3 - 1;
            if (n3 > 0) {
                System.arraycopy(objectArray, 0, objectArray2, 0, n3);
            }
            if (n4 > 0) {
                System.arraycopy(objectArray, n3 + 1, objectArray2, n3, n4);
            }
            this.setArray(objectArray2);
            return true;
        }
    }

    @Override
    public boolean containsAll(Collection collection) {
        Object[] objectArray = this.getArray();
        Iterator iterator = collection.iterator();
        while (iterator.hasNext()) {
            if (CopyOnWriteArrayList.search(objectArray, iterator.next(), 0, objectArray.length) >= 0) continue;
            return false;
        }
        return true;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean addAll(Collection collection) {
        Object[] objectArray = collection.toArray();
        if (objectArray.length == 0) {
            return false;
        }
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray2 = this.getArray();
            int n2 = objectArray2.length;
            Object[] objectArray3 = new Object[n2 + objectArray.length];
            System.arraycopy(objectArray2, 0, objectArray3, 0, n2);
            int n3 = n2;
            System.arraycopy(objectArray, 0, objectArray3, n3, objectArray.length);
            this.setArray(objectArray3);
            return true;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public boolean addAll(int n2, Collection collection) {
        Object[] objectArray = collection.toArray();
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray2 = this.getArray();
            int n3 = objectArray2.length;
            if (n2 < 0 || n2 > n3) {
                throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + n3);
            }
            if (objectArray.length == 0) {
                return false;
            }
            Object[] objectArray3 = new Object[n3 + objectArray.length];
            int n4 = n3 - n2;
            System.arraycopy(objectArray2, 0, objectArray3, 0, n2);
            int n5 = n3;
            System.arraycopy(objectArray, 0, objectArray3, n2, objectArray.length);
            if (n4 > 0) {
                System.arraycopy(objectArray2, n2, objectArray3, n2 + objectArray.length, n4);
            }
            this.setArray(objectArray3);
            return true;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean removeAll(Collection collection) {
        if (collection.isEmpty()) {
            return false;
        }
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n2 = objectArray.length;
            Object[] objectArray2 = new Object[n2];
            int n3 = 0;
            for (int i2 = 0; i2 < n2; ++i2) {
                Object object = objectArray[i2];
                if (collection.contains(object)) continue;
                objectArray2[n3++] = object;
            }
            if (n3 == n2) {
                return false;
            }
            Object[] objectArray3 = new Object[n3];
            System.arraycopy(objectArray2, 0, objectArray3, 0, n3);
            this.setArray(objectArray3);
            return true;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean retainAll(Collection collection) {
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n2 = objectArray.length;
            Object[] objectArray2 = new Object[n2];
            int n3 = 0;
            for (int i2 = 0; i2 < n2; ++i2) {
                Object object = objectArray[i2];
                if (!collection.contains(object)) continue;
                objectArray2[n3++] = object;
            }
            if (n3 == n2) {
                return false;
            }
            Object[] objectArray3 = new Object[n3];
            System.arraycopy(objectArray2, 0, objectArray3, 0, n3);
            this.setArray(objectArray3);
            return true;
        }
    }

    @Override
    public void clear() {
        this.setArray(new Object[0]);
    }

    public Object clone() {
        try {
            return super.clone();
        }
        catch (CloneNotSupportedException cloneNotSupportedException) {
            throw new InternalError();
        }
    }

    @Override
    public boolean equals(Object object) {
        if (object == this) {
            return true;
        }
        if (!(object instanceof List)) {
            return false;
        }
        ListIterator listIterator = ((List)object).listIterator();
        Object[] objectArray = this.getArray();
        int n2 = objectArray.length;
        int n3 = 0;
        while (n3 < n2 && listIterator.hasNext()) {
            Object object2;
            Object e2 = listIterator.next();
            if (CopyOnWriteArrayList.eq(object2 = objectArray[n3++], e2)) continue;
            return false;
        }
        return n3 == n2 && !listIterator.hasNext();
    }

    @Override
    public int hashCode() {
        int n2 = 1;
        for (Object object : this.getArray()) {
            n2 = 31 * n2 + (object == null ? 0 : object.hashCode());
        }
        return n2;
    }

    public Object get(int n2) {
        return this.getArray()[n2];
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public Object set(int n2, Object object) {
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n3 = objectArray.length;
            Object object2 = objectArray[n2];
            if (object2 == object) {
                this.setArray(objectArray);
            } else {
                Object[] objectArray2 = new Object[n3];
                System.arraycopy(objectArray, 0, objectArray2, 0, n3);
                objectArray2[n2] = object;
                this.setArray(objectArray2);
            }
            return object2;
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void add(int n2, Object object) {
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n3 = objectArray.length;
            if (n2 < 0 || n2 > n3) {
                throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + n3);
            }
            Object[] objectArray2 = new Object[n3 + 1];
            int n4 = n3 - n2;
            System.arraycopy(objectArray, 0, objectArray2, 0, n2);
            objectArray2[n2] = object;
            if (n4 > 0) {
                System.arraycopy(objectArray, n2, objectArray2, n2 + 1, n4);
            }
            this.setArray(objectArray2);
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public Object remove(int n2) {
        CopyOnWriteArrayList copyOnWriteArrayList = this;
        synchronized (copyOnWriteArrayList) {
            Object[] objectArray = this.getArray();
            int n3 = objectArray.length;
            if (n2 < 0 || n2 >= n3) {
                throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + n3);
            }
            Object object = objectArray[n2];
            Object[] objectArray2 = new Object[n3 - 1];
            int n4 = n3 - n2 - 1;
            if (n2 > 0) {
                System.arraycopy(objectArray, 0, objectArray2, 0, n2);
            }
            if (n4 > 0) {
                System.arraycopy(objectArray, n2 + 1, objectArray2, n2, n4);
            }
            this.setArray(objectArray2);
            return object;
        }
    }

    @Override
    public int indexOf(Object object) {
        Object[] objectArray = this.getArray();
        return CopyOnWriteArrayList.search(objectArray, object, 0, objectArray.length);
    }

    public int indexOf(Object object, int n2) {
        Object[] objectArray = this.getArray();
        return CopyOnWriteArrayList.search(objectArray, object, n2, objectArray.length);
    }

    @Override
    public int lastIndexOf(Object object) {
        Object[] objectArray = this.getArray();
        return CopyOnWriteArrayList.reverseSearch(objectArray, object, 0, objectArray.length);
    }

    public int lastIndexOf(Object object, int n2) {
        Object[] objectArray = this.getArray();
        return CopyOnWriteArrayList.reverseSearch(objectArray, object, 0, n2);
    }

    public ListIterator listIterator() {
        return new COWIterator(this.getArray(), 0);
    }

    public ListIterator listIterator(int n2) {
        Object[] objectArray = this.getArray();
        if (n2 < 0 || n2 > objectArray.length) {
            throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + objectArray.length);
        }
        return new COWIterator(objectArray, n2);
    }

    public List subList(int n2, int n3) {
        Object[] objectArray = this.getArray();
        if (n2 < 0 || n3 > objectArray.length || n2 > n3) {
            throw new IndexOutOfBoundsException();
        }
        return new COWSubList(n2, n3 - n2);
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        Object[] objectArray = this.getArray();
        int n2 = objectArray.length;
        objectOutputStream.writeInt(n2);
        for (int i2 = 0; i2 < n2; ++i2) {
            objectOutputStream.writeObject(objectArray[i2]);
        }
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        objectInputStream.defaultReadObject();
        int n2 = objectInputStream.readInt();
        Object[] objectArray = new Object[n2];
        for (int i2 = 0; i2 < n2; ++i2) {
            objectArray[i2] = objectInputStream.readObject();
        }
        this.setArray(objectArray);
    }

    public String toString() {
        Object[] objectArray = this.getArray();
        int n2 = objectArray.length;
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append('[');
        for (int i2 = 0; i2 < n2; ++i2) {
            if (i2 > 0) {
                stringBuffer.append(", ");
            }
            stringBuffer.append(objectArray[i2]);
        }
        stringBuffer.append(']');
        return stringBuffer.toString();
    }

    private static boolean eq(Object object, Object object2) {
        return object == null ? object2 == null : object.equals(object2);
    }

    static class COWSubIterator
    implements ListIterator {
        final Object[] array;
        int cursor;
        int first;
        int last;

        COWSubIterator(Object[] objectArray, int n2, int n3, int n4) {
            this.array = objectArray;
            this.first = n2;
            this.last = n3;
            this.cursor = n4;
        }

        @Override
        public boolean hasNext() {
            return this.cursor < this.last;
        }

        @Override
        public boolean hasPrevious() {
            return this.cursor > this.first;
        }

        @Override
        public int nextIndex() {
            return this.cursor - this.first;
        }

        @Override
        public Object next() {
            if (this.cursor == this.last) {
                throw new NoSuchElementException();
            }
            return this.array[this.cursor++];
        }

        @Override
        public int previousIndex() {
            return this.cursor - this.first - 1;
        }

        public Object previous() {
            if (this.cursor == this.first) {
                throw new NoSuchElementException();
            }
            return this.array[--this.cursor];
        }

        public void add(Object object) {
            throw new UnsupportedOperationException();
        }

        public void set(Object object) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }

    class COWSubList
    implements Serializable,
    List {
        private static final long serialVersionUID = -8660955369431018984L;
        final int offset;
        int length;
        transient Object[] expectedArray;

        COWSubList(int n2, int n3) {
            this.offset = n2;
            this.length = n3;
            this.expectedArray = CopyOnWriteArrayList.this.getArray();
        }

        @Override
        public int size() {
            return this.length;
        }

        @Override
        public boolean isEmpty() {
            return this.length == 0;
        }

        @Override
        public boolean contains(Object object) {
            return CopyOnWriteArrayList.search(CopyOnWriteArrayList.this.getArray(), object, this.offset, this.offset + this.length) >= 0;
        }

        @Override
        public Iterator iterator() {
            return this.listIterator();
        }

        @Override
        public Object[] toArray() {
            Object[] objectArray = CopyOnWriteArrayList.this.getArray();
            Object[] objectArray2 = new Object[this.length];
            System.arraycopy(objectArray, this.offset, objectArray2, 0, this.length);
            return objectArray2;
        }

        @Override
        public Object[] toArray(Object[] objectArray) {
            Object[] objectArray2 = CopyOnWriteArrayList.this.getArray();
            if (objectArray.length < this.length) {
                objectArray = (Object[])Array.newInstance(objectArray.getClass().getComponentType(), this.length);
                System.arraycopy(objectArray2, this.offset, objectArray, 0, this.length);
            } else {
                System.arraycopy(objectArray2, this.offset, objectArray, 0, this.length);
                if (objectArray.length > this.length) {
                    objectArray[this.length] = null;
                }
            }
            return objectArray;
        }

        @Override
        public boolean add(Object object) {
            this.add(this.length, object);
            return true;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean remove(Object object) {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                int n2 = objectArray.length;
                int n3 = CopyOnWriteArrayList.search(objectArray, object, this.offset, this.length);
                if (n3 < 0) {
                    return false;
                }
                Object[] objectArray2 = new Object[n2 - 1];
                int n4 = this.length - n3 - 1;
                if (n3 > 0) {
                    System.arraycopy(objectArray, 0, objectArray2, 0, n3);
                }
                if (n4 > 0) {
                    System.arraycopy(objectArray, n3 + 1, objectArray2, n3, n4);
                }
                CopyOnWriteArrayList.this.setArray(objectArray2);
                this.expectedArray = objectArray2;
                --this.length;
                return true;
            }
        }

        @Override
        public boolean containsAll(Collection collection) {
            Object[] objectArray = CopyOnWriteArrayList.this.getArray();
            Iterator iterator = collection.iterator();
            while (iterator.hasNext()) {
                if (CopyOnWriteArrayList.search(objectArray, iterator.next(), this.offset, this.length) >= 0) continue;
                return false;
            }
            return true;
        }

        @Override
        public boolean addAll(Collection collection) {
            return this.addAll(this.length, collection);
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public boolean addAll(int n2, Collection collection) {
            int n3 = collection.size();
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                int n4;
                if (n2 < 0 || n2 >= this.length) {
                    throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + this.length);
                }
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                if (n3 == 0) {
                    return false;
                }
                int n5 = objectArray.length;
                Object[] objectArray2 = new Object[n5 + n3];
                int n6 = n4 = this.offset + n2;
                System.arraycopy(objectArray, 0, objectArray2, 0, n4);
                int n7 = n5 - n4;
                Iterator iterator = collection.iterator();
                while (iterator.hasNext()) {
                    objectArray2[n6++] = iterator.next();
                }
                if (n7 > 0) {
                    System.arraycopy(objectArray, n4, objectArray2, n6, n7);
                }
                CopyOnWriteArrayList.this.setArray(objectArray2);
                this.expectedArray = objectArray2;
                this.length += n3;
                return true;
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean removeAll(Collection collection) {
            if (collection.isEmpty()) {
                return false;
            }
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                int n2 = objectArray.length;
                Object[] objectArray2 = new Object[this.length];
                int n3 = 0;
                for (int i2 = this.offset; i2 < this.offset + this.length; ++i2) {
                    Object object = objectArray[i2];
                    if (collection.contains(object)) continue;
                    objectArray2[n3++] = object;
                }
                if (n3 == this.length) {
                    return false;
                }
                Object[] objectArray3 = new Object[n2 + n3 - this.length];
                int n4 = n2 - this.offset - this.length;
                if (this.offset > 0) {
                    System.arraycopy(objectArray, 0, objectArray3, 0, this.offset);
                }
                if (n3 > 0) {
                    System.arraycopy(objectArray2, 0, objectArray3, this.offset, n3);
                }
                if (n4 > 0) {
                    System.arraycopy(objectArray, this.offset + this.length, objectArray3, this.offset + n3, n4);
                }
                CopyOnWriteArrayList.this.setArray(objectArray3);
                this.expectedArray = objectArray3;
                this.length = n3;
                return true;
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean retainAll(Collection collection) {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                int n2 = objectArray.length;
                Object[] objectArray2 = new Object[this.length];
                int n3 = 0;
                for (int i2 = this.offset; i2 < this.offset + this.length; ++i2) {
                    Object object = objectArray[i2];
                    if (!collection.contains(object)) continue;
                    objectArray2[n3++] = object;
                }
                if (n3 == this.length) {
                    return false;
                }
                Object[] objectArray3 = new Object[n2 + n3 - this.length];
                int n4 = n2 - this.offset - this.length;
                if (this.offset > 0) {
                    System.arraycopy(objectArray, 0, objectArray3, 0, this.offset);
                }
                if (n3 > 0) {
                    System.arraycopy(objectArray2, 0, objectArray3, this.offset, n3);
                }
                if (n4 > 0) {
                    System.arraycopy(objectArray, this.offset + this.length, objectArray3, this.offset + n3, n4);
                }
                CopyOnWriteArrayList.this.setArray(objectArray3);
                this.expectedArray = objectArray3;
                this.length = n3;
                return true;
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public void clear() {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                int n2 = objectArray.length;
                Object[] objectArray2 = new Object[n2 - this.length];
                int n3 = n2 - this.offset - this.length;
                if (this.offset > 0) {
                    System.arraycopy(objectArray, 0, objectArray2, 0, this.offset);
                }
                if (n3 > 0) {
                    System.arraycopy(objectArray, this.offset + this.length, objectArray2, this.offset, n3);
                }
                CopyOnWriteArrayList.this.setArray(objectArray2);
                this.expectedArray = objectArray2;
                this.length = 0;
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public boolean equals(Object object) {
            int n2;
            Object[] objectArray;
            if (object == this) {
                return true;
            }
            if (!(object instanceof List)) {
                return false;
            }
            Object object2 = CopyOnWriteArrayList.this;
            synchronized (object2) {
                objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                n2 = this.offset + this.length;
            }
            object2 = ((List)object).listIterator();
            int n3 = this.offset;
            while (n3 < n2 && object2.hasNext()) {
                Object object3 = objectArray[n3];
                Object e2 = object2.next();
                if (CopyOnWriteArrayList.eq(object3, e2)) continue;
                return false;
            }
            return n3 == n2 && !object2.hasNext();
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        @Override
        public int hashCode() {
            int n2;
            Object[] objectArray;
            int n3 = 1;
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                n2 = this.offset + this.length;
            }
            for (int i2 = this.offset; i2 < n2; ++i2) {
                Object object = objectArray[i2];
                n3 = 31 * n3 + (object == null ? 0 : object.hashCode());
            }
            return n3;
        }

        public Object get(int n2) {
            return CopyOnWriteArrayList.this.getArray()[this.offset + n2];
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public Object set(int n2, Object object) {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                if (n2 < 0 || n2 >= this.length) {
                    throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + this.length);
                }
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                int n3 = objectArray.length;
                Object object2 = objectArray[this.offset + n2];
                if (object2 == object) {
                    CopyOnWriteArrayList.this.setArray(objectArray);
                } else {
                    Object[] objectArray2 = new Object[n3];
                    System.arraycopy(objectArray, 0, objectArray2, 0, n3);
                    objectArray2[this.offset + n2] = object;
                    CopyOnWriteArrayList.this.setArray(objectArray2);
                    this.expectedArray = objectArray2;
                }
                return object2;
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public void add(int n2, Object object) {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                if (n2 < 0 || n2 > this.length) {
                    throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + this.length);
                }
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                int n3 = objectArray.length;
                Object[] objectArray2 = new Object[n3 + 1];
                int n4 = this.offset + n2;
                int n5 = n3 - n4;
                System.arraycopy(objectArray, 0, objectArray2, 0, n4);
                objectArray2[n4] = object;
                if (n5 > 0) {
                    System.arraycopy(objectArray, n4, objectArray2, n4 + 1, n5);
                }
                CopyOnWriteArrayList.this.setArray(objectArray2);
                this.expectedArray = objectArray2;
                ++this.length;
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public Object remove(int n2) {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                if (n2 < 0 || n2 >= this.length) {
                    throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + this.length);
                }
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                int n3 = objectArray.length;
                int n4 = this.offset + n2;
                Object object = objectArray[n4];
                Object[] objectArray2 = new Object[n3 - 1];
                int n5 = n3 - n4 - 1;
                if (n2 > 0) {
                    System.arraycopy(objectArray, 0, objectArray2, 0, n4);
                }
                if (n5 > 0) {
                    System.arraycopy(objectArray, n4 + 1, objectArray2, n4, n5);
                }
                CopyOnWriteArrayList.this.setArray(objectArray2);
                this.expectedArray = objectArray2;
                --this.length;
                return object;
            }
        }

        @Override
        public int indexOf(Object object) {
            int n2 = CopyOnWriteArrayList.search(CopyOnWriteArrayList.this.getArray(), object, this.offset, this.offset + this.length);
            return n2 >= 0 ? n2 - this.offset : -1;
        }

        public int indexOf(Object object, int n2) {
            int n3 = CopyOnWriteArrayList.search(CopyOnWriteArrayList.this.getArray(), object, this.offset + n2, this.offset + this.length) - this.offset;
            return n3 >= 0 ? n3 - this.offset : -1;
        }

        @Override
        public int lastIndexOf(Object object) {
            int n2 = CopyOnWriteArrayList.reverseSearch(CopyOnWriteArrayList.this.getArray(), object, this.offset, this.offset + this.length) - this.offset;
            return n2 >= 0 ? n2 - this.offset : -1;
        }

        public int lastIndexOf(Object object, int n2) {
            int n3 = CopyOnWriteArrayList.reverseSearch(CopyOnWriteArrayList.this.getArray(), object, this.offset, this.offset + n2) - this.offset;
            return n3 >= 0 ? n3 - this.offset : -1;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public ListIterator listIterator() {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                return new COWSubIterator(objectArray, this.offset, this.offset + this.length, this.offset);
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public ListIterator listIterator(int n2) {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                if (n2 < 0 || n2 >= this.length) {
                    throw new IndexOutOfBoundsException("Index: " + n2 + ", Size: " + this.length);
                }
                Object[] objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                return new COWSubIterator(objectArray, this.offset, this.offset + this.length, this.offset + n2);
            }
        }

        public List subList(int n2, int n3) {
            if (n2 < 0 || n3 > this.length || n2 > n3) {
                throw new IndexOutOfBoundsException();
            }
            return new COWSubList(this.offset + n2, n3 - n2);
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public String toString() {
            int n2;
            Object[] objectArray;
            Serializable serializable = CopyOnWriteArrayList.this;
            synchronized (serializable) {
                objectArray = CopyOnWriteArrayList.this.getArray();
                if (objectArray != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
                n2 = this.offset + this.length;
            }
            serializable = new StringBuffer();
            ((StringBuffer)serializable).append('[');
            for (int i2 = this.offset; i2 < n2; ++i2) {
                if (i2 > this.offset) {
                    ((StringBuffer)serializable).append(", ");
                }
                ((StringBuffer)serializable).append(objectArray[i2]);
            }
            ((StringBuffer)serializable).append(']');
            return ((StringBuffer)serializable).toString();
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                if (CopyOnWriteArrayList.this.getArray() != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
            }
            objectOutputStream.defaultWriteObject();
            copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                if (CopyOnWriteArrayList.this.getArray() != this.expectedArray) {
                    throw new ConcurrentModificationException();
                }
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
            objectInputStream.defaultReadObject();
            CopyOnWriteArrayList copyOnWriteArrayList = CopyOnWriteArrayList.this;
            synchronized (copyOnWriteArrayList) {
                this.expectedArray = CopyOnWriteArrayList.this.getArray();
            }
        }
    }

    static class COWIterator
    implements ListIterator {
        final Object[] array;
        int cursor;

        COWIterator(Object[] objectArray, int n2) {
            this.array = objectArray;
            this.cursor = n2;
        }

        @Override
        public boolean hasNext() {
            return this.cursor < this.array.length;
        }

        @Override
        public boolean hasPrevious() {
            return this.cursor > 0;
        }

        @Override
        public int nextIndex() {
            return this.cursor;
        }

        @Override
        public Object next() {
            try {
                return this.array[this.cursor++];
            }
            catch (IndexOutOfBoundsException indexOutOfBoundsException) {
                --this.cursor;
                throw new NoSuchElementException();
            }
        }

        @Override
        public int previousIndex() {
            return this.cursor - 1;
        }

        public Object previous() {
            try {
                return this.array[--this.cursor];
            }
            catch (IndexOutOfBoundsException indexOutOfBoundsException) {
                ++this.cursor;
                throw new NoSuchElementException();
            }
        }

        public void add(Object object) {
            throw new UnsupportedOperationException();
        }

        public void set(Object object) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }
}

