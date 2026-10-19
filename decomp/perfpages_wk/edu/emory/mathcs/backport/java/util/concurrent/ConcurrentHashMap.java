/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractCollection;
import edu.emory.mathcs.backport.java.util.AbstractMap;
import edu.emory.mathcs.backport.java.util.AbstractSet;
import edu.emory.mathcs.backport.java.util.concurrent.ConcurrentMap;
import edu.emory.mathcs.backport.java.util.concurrent.locks.ReentrantLock;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;

public class ConcurrentHashMap
extends AbstractMap
implements ConcurrentMap,
Serializable {
    private static final long serialVersionUID = 7249069246763182397L;
    static final int DEFAULT_INITIAL_CAPACITY = 16;
    static final float DEFAULT_LOAD_FACTOR = 0.75f;
    static final int DEFAULT_CONCURRENCY_LEVEL = 16;
    static final int MAXIMUM_CAPACITY = 0x40000000;
    static final int MAX_SEGMENTS = 65536;
    static final int RETRIES_BEFORE_LOCK = 2;
    final int segmentMask;
    final int segmentShift;
    final Segment[] segments;
    transient Set keySet;
    transient Set entrySet;
    transient Collection values;

    private static int hash(int n2) {
        n2 += n2 << 15 ^ 0xFFFFCD7D;
        n2 ^= n2 >>> 10;
        n2 += n2 << 3;
        n2 ^= n2 >>> 6;
        n2 += (n2 << 2) + (n2 << 14);
        return n2 ^ n2 >>> 16;
    }

    final Segment segmentFor(int n2) {
        return this.segments[n2 >>> this.segmentShift & this.segmentMask];
    }

    public ConcurrentHashMap(int n2, float f2, int n3) {
        int n4;
        int n5;
        int n6;
        if (!(f2 > 0.0f) || n2 < 0 || n3 <= 0) {
            throw new IllegalArgumentException();
        }
        if (n3 > 65536) {
            n3 = 65536;
        }
        int n7 = 0;
        for (n6 = 1; n6 < n3; n6 <<= 1) {
            ++n7;
        }
        this.segmentShift = 32 - n7;
        this.segmentMask = n6 - 1;
        this.segments = Segment.newArray(n6);
        if (n2 > 0x40000000) {
            n2 = 0x40000000;
        }
        if ((n5 = n2 / n6) * n6 < n2) {
            ++n5;
        }
        for (n4 = 1; n4 < n5; n4 <<= 1) {
        }
        for (int i2 = 0; i2 < this.segments.length; ++i2) {
            this.segments[i2] = new Segment(n4, f2);
        }
    }

    public ConcurrentHashMap(int n2, float f2) {
        this(n2, f2, 16);
    }

    public ConcurrentHashMap(int n2) {
        this(n2, 0.75f, 16);
    }

    public ConcurrentHashMap() {
        this(16, 0.75f, 16);
    }

    public ConcurrentHashMap(Map map) {
        this(Math.max((int)((float)map.size() / 0.75f) + 1, 16), 0.75f, 16);
        this.putAll(map);
    }

    @Override
    public boolean isEmpty() {
        int n2;
        Segment[] segmentArray = this.segments;
        int[] nArray = new int[segmentArray.length];
        int n3 = 0;
        for (n2 = 0; n2 < segmentArray.length; ++n2) {
            if (segmentArray[n2].count != 0) {
                return false;
            }
            nArray[n2] = segmentArray[n2].modCount;
            n3 += nArray[n2];
        }
        if (n3 != 0) {
            for (n2 = 0; n2 < segmentArray.length; ++n2) {
                if (segmentArray[n2].count == 0 && nArray[n2] == segmentArray[n2].modCount) continue;
                return false;
            }
        }
        return true;
    }

    @Override
    public int size() {
        int n2;
        Segment[] segmentArray = this.segments;
        long l2 = 0L;
        long l3 = 0L;
        int[] nArray = new int[segmentArray.length];
        for (n2 = 0; n2 < 2; ++n2) {
            int n3;
            l3 = 0L;
            l2 = 0L;
            int n4 = 0;
            for (n3 = 0; n3 < segmentArray.length; ++n3) {
                l2 += (long)segmentArray[n3].count;
                nArray[n3] = segmentArray[n3].modCount;
                n4 += nArray[n3];
            }
            if (n4 != 0) {
                for (n3 = 0; n3 < segmentArray.length; ++n3) {
                    l3 += (long)segmentArray[n3].count;
                    if (nArray[n3] == segmentArray[n3].modCount) continue;
                    l3 = -1L;
                    break;
                }
            }
            if (l3 == l2) break;
        }
        if (l3 != l2) {
            l2 = 0L;
            for (n2 = 0; n2 < segmentArray.length; ++n2) {
                segmentArray[n2].lock();
            }
            for (n2 = 0; n2 < segmentArray.length; ++n2) {
                l2 += (long)segmentArray[n2].count;
            }
            for (n2 = 0; n2 < segmentArray.length; ++n2) {
                segmentArray[n2].unlock();
            }
        }
        if (l2 > Integer.MAX_VALUE) {
            return Integer.MAX_VALUE;
        }
        return (int)l2;
    }

    public Object get(Object object) {
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).get(object, n2);
    }

    @Override
    public boolean containsKey(Object object) {
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).containsKey(object, n2);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    @Override
    public boolean containsValue(Object object) {
        int n2;
        boolean bl2;
        if (object == null) {
            throw new NullPointerException();
        }
        Segment[] segmentArray = this.segments;
        int[] nArray = new int[segmentArray.length];
        for (bl2 = false; bl2 < 2 != 0; bl2 += 1) {
            int n3;
            int n4;
            n2 = 0;
            int n5 = 0;
            for (n4 = 0; n4 < segmentArray.length; ++n4) {
                n3 = segmentArray[n4].count;
                nArray[n4] = segmentArray[n4].modCount;
                n5 += nArray[n4];
                if (!segmentArray[n4].containsValue(object)) continue;
                return true;
            }
            n4 = 1;
            if (n5 != 0) {
                for (n3 = 0; n3 < segmentArray.length; ++n3) {
                    int n6 = segmentArray[n3].count;
                    if (nArray[n3] == segmentArray[n3].modCount) continue;
                    n4 = 0;
                    break;
                }
            }
            if (n4 == 0) continue;
            return false;
        }
        for (bl2 = false; bl2 < segmentArray.length; bl2 += 1) {
            segmentArray[bl2].lock();
        }
        bl2 = false;
        try {
            for (n2 = 0; n2 < segmentArray.length; ++n2) {
                if (!segmentArray[n2].containsValue(object)) continue;
                bl2 = true;
                break;
            }
        }
        finally {
            for (n2 = 0; n2 < segmentArray.length; ++n2) {
                segmentArray[n2].unlock();
            }
        }
        return bl2;
    }

    public boolean contains(Object object) {
        return this.containsValue(object);
    }

    public Object put(Object object, Object object2) {
        if (object2 == null) {
            throw new NullPointerException();
        }
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).put(object, n2, object2, false);
    }

    @Override
    public Object putIfAbsent(Object object, Object object2) {
        if (object2 == null) {
            throw new NullPointerException();
        }
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).put(object, n2, object2, true);
    }

    public void putAll(Map map) {
        for (Map.Entry entry : map.entrySet()) {
            this.put(entry.getKey(), entry.getValue());
        }
    }

    public Object remove(Object object) {
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).remove(object, n2, null);
    }

    @Override
    public boolean remove(Object object, Object object2) {
        if (object2 == null) {
            return false;
        }
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).remove(object, n2, object2) != null;
    }

    @Override
    public boolean replace(Object object, Object object2, Object object3) {
        if (object2 == null || object3 == null) {
            throw new NullPointerException();
        }
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).replace(object, n2, object2, object3);
    }

    @Override
    public Object replace(Object object, Object object2) {
        if (object2 == null) {
            throw new NullPointerException();
        }
        int n2 = ConcurrentHashMap.hash(object.hashCode());
        return this.segmentFor(n2).replace(object, n2, object2);
    }

    @Override
    public void clear() {
        for (int i2 = 0; i2 < this.segments.length; ++i2) {
            this.segments[i2].clear();
        }
    }

    @Override
    public Set keySet() {
        Set set = this.keySet;
        return set != null ? set : (this.keySet = new KeySet());
    }

    public Collection values() {
        Collection collection = this.values;
        return collection != null ? collection : (this.values = new Values());
    }

    public Set entrySet() {
        Set set = this.entrySet;
        return set != null ? set : (this.entrySet = new EntrySet());
    }

    public Enumeration keys() {
        return new KeyIterator();
    }

    public Enumeration elements() {
        return new ValueIterator();
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        for (int i2 = 0; i2 < this.segments.length; ++i2) {
            Segment segment = this.segments[i2];
            segment.lock();
            try {
                HashEntry[] hashEntryArray = segment.table;
                for (int i3 = 0; i3 < hashEntryArray.length; ++i3) {
                    HashEntry hashEntry = hashEntryArray[i3];
                    while (hashEntry != null) {
                        objectOutputStream.writeObject(hashEntry.key);
                        objectOutputStream.writeObject(hashEntry.value);
                        hashEntry = hashEntry.next;
                    }
                }
                continue;
            }
            finally {
                segment.unlock();
            }
        }
        objectOutputStream.writeObject(null);
        objectOutputStream.writeObject(null);
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        objectInputStream.defaultReadObject();
        for (int i2 = 0; i2 < this.segments.length; ++i2) {
            this.segments[i2].setTable(new HashEntry[1]);
        }
        while (true) {
            Object object = objectInputStream.readObject();
            Object object2 = objectInputStream.readObject();
            if (object == null) break;
            this.put(object, object2);
        }
    }

    final class EntrySet
    extends AbstractSet {
        EntrySet() {
        }

        @Override
        public Iterator iterator() {
            return new EntryIterator();
        }

        @Override
        public boolean contains(Object object) {
            if (!(object instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry)object;
            Object object2 = ConcurrentHashMap.this.get(entry.getKey());
            return object2 != null && object2.equals(entry.getValue());
        }

        @Override
        public boolean remove(Object object) {
            if (!(object instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry)object;
            return ConcurrentHashMap.this.remove(entry.getKey(), entry.getValue());
        }

        @Override
        public int size() {
            return ConcurrentHashMap.this.size();
        }

        @Override
        public void clear() {
            ConcurrentHashMap.this.clear();
        }
    }

    final class Values
    extends AbstractCollection {
        Values() {
        }

        @Override
        public Iterator iterator() {
            return new ValueIterator();
        }

        @Override
        public int size() {
            return ConcurrentHashMap.this.size();
        }

        @Override
        public boolean contains(Object object) {
            return ConcurrentHashMap.this.containsValue(object);
        }

        @Override
        public void clear() {
            ConcurrentHashMap.this.clear();
        }
    }

    final class KeySet
    extends AbstractSet {
        KeySet() {
        }

        @Override
        public Iterator iterator() {
            return new KeyIterator();
        }

        @Override
        public int size() {
            return ConcurrentHashMap.this.size();
        }

        @Override
        public boolean contains(Object object) {
            return ConcurrentHashMap.this.containsKey(object);
        }

        @Override
        public boolean remove(Object object) {
            return ConcurrentHashMap.this.remove(object) != null;
        }

        @Override
        public void clear() {
            ConcurrentHashMap.this.clear();
        }
    }

    final class EntryIterator
    extends HashIterator
    implements Iterator {
        EntryIterator() {
        }

        public Object next() {
            HashEntry hashEntry = super.nextEntry();
            return new WriteThroughEntry(hashEntry.key, hashEntry.value);
        }
    }

    final class WriteThroughEntry
    extends AbstractMap.SimpleEntry {
        WriteThroughEntry(Object object, Object object2) {
            super(object, object2);
        }

        @Override
        public Object setValue(Object object) {
            if (object == null) {
                throw new NullPointerException();
            }
            Object object2 = super.setValue(object);
            ConcurrentHashMap.this.put(this.getKey(), object);
            return object2;
        }
    }

    final class ValueIterator
    extends HashIterator
    implements Iterator,
    Enumeration {
        ValueIterator() {
        }

        public Object next() {
            return super.nextEntry().value;
        }

        public Object nextElement() {
            return super.nextEntry().value;
        }
    }

    final class KeyIterator
    extends HashIterator
    implements Iterator,
    Enumeration {
        KeyIterator() {
        }

        public Object next() {
            return super.nextEntry().key;
        }

        public Object nextElement() {
            return super.nextEntry().key;
        }
    }

    abstract class HashIterator {
        int nextSegmentIndex;
        int nextTableIndex;
        HashEntry[] currentTable;
        HashEntry nextEntry;
        HashEntry lastReturned;

        HashIterator() {
            this.nextSegmentIndex = ConcurrentHashMap.this.segments.length - 1;
            this.nextTableIndex = -1;
            this.advance();
        }

        public boolean hasMoreElements() {
            return this.hasNext();
        }

        final void advance() {
            if (this.nextEntry != null && (this.nextEntry = this.nextEntry.next) != null) {
                return;
            }
            while (this.nextTableIndex >= 0) {
                if ((this.nextEntry = this.currentTable[this.nextTableIndex--]) == null) continue;
                return;
            }
            while (this.nextSegmentIndex >= 0) {
                Segment segment = ConcurrentHashMap.this.segments[this.nextSegmentIndex--];
                if (segment.count == 0) continue;
                this.currentTable = segment.table;
                for (int i2 = this.currentTable.length - 1; i2 >= 0; --i2) {
                    this.nextEntry = this.currentTable[i2];
                    if (this.nextEntry == null) continue;
                    this.nextTableIndex = i2 - 1;
                    return;
                }
            }
        }

        public boolean hasNext() {
            return this.nextEntry != null;
        }

        HashEntry nextEntry() {
            if (this.nextEntry == null) {
                throw new NoSuchElementException();
            }
            this.lastReturned = this.nextEntry;
            this.advance();
            return this.lastReturned;
        }

        public void remove() {
            if (this.lastReturned == null) {
                throw new IllegalStateException();
            }
            ConcurrentHashMap.this.remove(this.lastReturned.key);
            this.lastReturned = null;
        }
    }

    static final class Segment
    extends ReentrantLock
    implements Serializable {
        private static final long serialVersionUID = 2249069246763182397L;
        volatile transient int count;
        transient int modCount;
        transient int threshold;
        volatile transient HashEntry[] table;
        final float loadFactor;

        Segment(int n2, float f2) {
            this.loadFactor = f2;
            this.setTable(HashEntry.newArray(n2));
        }

        static final Segment[] newArray(int n2) {
            return new Segment[n2];
        }

        void setTable(HashEntry[] hashEntryArray) {
            this.threshold = (int)((float)hashEntryArray.length * this.loadFactor);
            this.table = hashEntryArray;
        }

        HashEntry getFirst(int n2) {
            HashEntry[] hashEntryArray = this.table;
            return hashEntryArray[n2 & hashEntryArray.length - 1];
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        Object readValueUnderLock(HashEntry hashEntry) {
            this.lock();
            try {
                Object object = hashEntry.value;
                return object;
            }
            finally {
                this.unlock();
            }
        }

        Object get(Object object, int n2) {
            if (this.count != 0) {
                HashEntry hashEntry = this.getFirst(n2);
                while (hashEntry != null) {
                    if (hashEntry.hash == n2 && object.equals(hashEntry.key)) {
                        Object object2 = hashEntry.value;
                        if (object2 != null) {
                            return object2;
                        }
                        return this.readValueUnderLock(hashEntry);
                    }
                    hashEntry = hashEntry.next;
                }
            }
            return null;
        }

        boolean containsKey(Object object, int n2) {
            if (this.count != 0) {
                HashEntry hashEntry = this.getFirst(n2);
                while (hashEntry != null) {
                    if (hashEntry.hash == n2 && object.equals(hashEntry.key)) {
                        return true;
                    }
                    hashEntry = hashEntry.next;
                }
            }
            return false;
        }

        boolean containsValue(Object object) {
            if (this.count != 0) {
                for (HashEntry hashEntry : this.table) {
                    while (hashEntry != null) {
                        Object object2 = hashEntry.value;
                        if (object2 == null) {
                            object2 = this.readValueUnderLock(hashEntry);
                        }
                        if (object.equals(object2)) {
                            return true;
                        }
                        hashEntry = hashEntry.next;
                    }
                }
            }
            return false;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        boolean replace(Object object, int n2, Object object2, Object object3) {
            this.lock();
            try {
                HashEntry hashEntry = this.getFirst(n2);
                while (!(hashEntry == null || hashEntry.hash == n2 && object.equals(hashEntry.key))) {
                    hashEntry = hashEntry.next;
                }
                boolean bl2 = false;
                if (hashEntry != null && object2.equals(hashEntry.value)) {
                    bl2 = true;
                    hashEntry.value = object3;
                }
                boolean bl3 = bl2;
                return bl3;
            }
            finally {
                this.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        Object replace(Object object, int n2, Object object2) {
            this.lock();
            try {
                HashEntry hashEntry = this.getFirst(n2);
                while (!(hashEntry == null || hashEntry.hash == n2 && object.equals(hashEntry.key))) {
                    hashEntry = hashEntry.next;
                }
                Object object3 = null;
                if (hashEntry != null) {
                    object3 = hashEntry.value;
                    hashEntry.value = object2;
                }
                Object object4 = object3;
                return object4;
            }
            finally {
                this.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        Object put(Object object, int n2, Object object2, boolean bl2) {
            this.lock();
            try {
                Object object3;
                HashEntry hashEntry;
                int n3 = this.count;
                if (n3++ > this.threshold) {
                    this.rehash();
                }
                HashEntry[] hashEntryArray = this.table;
                int n4 = n2 & hashEntryArray.length - 1;
                HashEntry hashEntry2 = hashEntry = hashEntryArray[n4];
                while (!(hashEntry2 == null || hashEntry2.hash == n2 && object.equals(hashEntry2.key))) {
                    hashEntry2 = hashEntry2.next;
                }
                if (hashEntry2 != null) {
                    object3 = hashEntry2.value;
                    if (!bl2) {
                        hashEntry2.value = object2;
                    }
                } else {
                    object3 = null;
                    ++this.modCount;
                    hashEntryArray[n4] = new HashEntry(object, n2, hashEntry, object2);
                    this.count = n3;
                }
                Object object4 = object3;
                return object4;
            }
            finally {
                this.unlock();
            }
        }

        void rehash() {
            HashEntry[] hashEntryArray = this.table;
            int n2 = hashEntryArray.length;
            if (n2 >= 0x40000000) {
                return;
            }
            HashEntry[] hashEntryArray2 = HashEntry.newArray(n2 << 1);
            this.threshold = (int)((float)hashEntryArray2.length * this.loadFactor);
            int n3 = hashEntryArray2.length - 1;
            for (int i2 = 0; i2 < n2; ++i2) {
                int n4;
                HashEntry hashEntry = hashEntryArray[i2];
                if (hashEntry == null) continue;
                HashEntry hashEntry2 = hashEntry.next;
                int n5 = hashEntry.hash & n3;
                if (hashEntry2 == null) {
                    hashEntryArray2[n5] = hashEntry;
                    continue;
                }
                HashEntry hashEntry3 = hashEntry;
                int n6 = n5;
                HashEntry hashEntry4 = hashEntry2;
                while (hashEntry4 != null) {
                    n4 = hashEntry4.hash & n3;
                    if (n4 != n6) {
                        n6 = n4;
                        hashEntry3 = hashEntry4;
                    }
                    hashEntry4 = hashEntry4.next;
                }
                hashEntryArray2[n6] = hashEntry3;
                hashEntry4 = hashEntry;
                while (hashEntry4 != hashEntry3) {
                    n4 = hashEntry4.hash & n3;
                    HashEntry hashEntry5 = hashEntryArray2[n4];
                    hashEntryArray2[n4] = new HashEntry(hashEntry4.key, hashEntry4.hash, hashEntry5, hashEntry4.value);
                    hashEntry4 = hashEntry4.next;
                }
            }
            this.table = hashEntryArray2;
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        Object remove(Object object, int n2, Object object2) {
            this.lock();
            try {
                Object object3;
                HashEntry hashEntry;
                int n3 = this.count - 1;
                HashEntry[] hashEntryArray = this.table;
                int n4 = n2 & hashEntryArray.length - 1;
                HashEntry hashEntry2 = hashEntry = hashEntryArray[n4];
                while (!(hashEntry2 == null || hashEntry2.hash == n2 && object.equals(hashEntry2.key))) {
                    hashEntry2 = hashEntry2.next;
                }
                Object object4 = null;
                if (hashEntry2 != null) {
                    object3 = hashEntry2.value;
                    if (object2 == null || object2.equals(object3)) {
                        object4 = object3;
                        ++this.modCount;
                        HashEntry hashEntry3 = hashEntry2.next;
                        HashEntry hashEntry4 = hashEntry;
                        while (hashEntry4 != hashEntry2) {
                            hashEntry3 = new HashEntry(hashEntry4.key, hashEntry4.hash, hashEntry3, hashEntry4.value);
                            hashEntry4 = hashEntry4.next;
                        }
                        hashEntryArray[n4] = hashEntry3;
                        this.count = n3;
                    }
                }
                object3 = object4;
                return object3;
            }
            finally {
                this.unlock();
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        void clear() {
            if (this.count != 0) {
                this.lock();
                try {
                    HashEntry[] hashEntryArray = this.table;
                    for (int i2 = 0; i2 < hashEntryArray.length; ++i2) {
                        hashEntryArray[i2] = null;
                    }
                    ++this.modCount;
                    this.count = 0;
                }
                finally {
                    this.unlock();
                }
            }
        }
    }

    static final class HashEntry {
        final Object key;
        final int hash;
        volatile Object value;
        final HashEntry next;

        HashEntry(Object object, int n2, HashEntry hashEntry, Object object2) {
            this.key = object;
            this.hash = n2;
            this.next = hashEntry;
            this.value = object2;
        }

        static final HashEntry[] newArray(int n2) {
            return new HashEntry[n2];
        }
    }
}

