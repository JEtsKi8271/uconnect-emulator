/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import edu.emory.mathcs.backport.java.util.AbstractCollection;
import edu.emory.mathcs.backport.java.util.AbstractMap;
import edu.emory.mathcs.backport.java.util.AbstractSet;
import edu.emory.mathcs.backport.java.util.Collections;
import edu.emory.mathcs.backport.java.util.NavigableMap;
import edu.emory.mathcs.backport.java.util.NavigableSet;
import edu.emory.mathcs.backport.java.util.concurrent.ConcurrentNavigableMap;
import edu.emory.mathcs.backport.java.util.concurrent.ConcurrentSkipListSet;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Random;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;

public class ConcurrentSkipListMap
extends AbstractMap
implements ConcurrentNavigableMap,
Cloneable,
Serializable {
    private static final long serialVersionUID = -8627078645895051609L;
    private static final Random seedGenerator = new Random();
    private static final Object BASE_HEADER = new Object();
    private volatile transient HeadIndex head;
    private final Comparator comparator;
    private transient int randomSeed;
    private transient KeySet keySet;
    private transient EntrySet entrySet;
    private transient Values values;
    private transient ConcurrentNavigableMap descendingMap;
    private static final int EQ = 1;
    private static final int LT = 2;
    private static final int GT = 0;

    final void initialize() {
        this.keySet = null;
        this.entrySet = null;
        this.values = null;
        this.descendingMap = null;
        this.randomSeed = seedGenerator.nextInt() | 0x100;
        this.head = new HeadIndex(new Node(null, BASE_HEADER, null), null, null, 1);
    }

    private synchronized boolean casHead(HeadIndex headIndex, HeadIndex headIndex2) {
        if (this.head == headIndex) {
            this.head = headIndex2;
            return true;
        }
        return false;
    }

    private Comparable comparable(Object object) throws ClassCastException {
        if (object == null) {
            throw new NullPointerException();
        }
        if (this.comparator != null) {
            return new ComparableUsingComparator(object, this.comparator);
        }
        return (Comparable)object;
    }

    int compare(Object object, Object object2) throws ClassCastException {
        Comparator comparator = this.comparator;
        if (comparator != null) {
            return comparator.compare(object, object2);
        }
        return ((Comparable)object).compareTo(object2);
    }

    boolean inHalfOpenRange(Object object, Object object2, Object object3) {
        if (object == null) {
            throw new NullPointerException();
        }
        return !(object2 != null && this.compare(object, object2) < 0 || object3 != null && this.compare(object, object3) >= 0);
    }

    boolean inOpenRange(Object object, Object object2, Object object3) {
        if (object == null) {
            throw new NullPointerException();
        }
        return !(object2 != null && this.compare(object, object2) < 0 || object3 != null && this.compare(object, object3) > 0);
    }

    private Node findPredecessor(Comparable comparable) {
        Object object;
        if (comparable == null) {
            throw new NullPointerException();
        }
        block0: while (true) {
            object = this.head;
            Index index = ((Index)object).right;
            while (true) {
                Object object2;
                if (index != null) {
                    object2 = index.node;
                    Object object3 = ((Node)object2).key;
                    if (((Node)object2).value == null) {
                        if (!((Index)object).unlink(index)) continue block0;
                        index = ((Index)object).right;
                        continue;
                    }
                    if (comparable.compareTo(object3) > 0) {
                        object = index;
                        index = index.right;
                        continue;
                    }
                }
                if ((object2 = ((Index)object).down) == null) break block0;
                object = object2;
                index = ((Index)object2).right;
            }
            break;
        }
        return ((Index)object).node;
    }

    /*
     * Unable to fully structure code
     */
    private Node findNode(Comparable var1_1) {
        block0: while (true) {
            var2_2 = this.findPredecessor(var1_1);
            var3_3 = var2_2.next;
            while (true) {
                if (var3_3 == null) {
                    return null;
                }
                var4_4 = var3_3.next;
                if (var3_3 != var2_2.next) continue block0;
                var5_5 = var3_3.value;
                if (var5_5 == null) {
                    var3_3.helpDelete(var2_2, var4_4);
                    continue block0;
                }
                if (var5_5 != var3_3 && var2_2.value != null) ** break;
                continue block0;
                var6_6 = var1_1.compareTo(var3_3.key);
                if (var6_6 == 0) {
                    return var3_3;
                }
                if (var6_6 < 0) {
                    return null;
                }
                var2_2 = var3_3;
                var3_3 = var4_4;
            }
            break;
        }
    }

    private Object doGet(Object object) {
        Object object2;
        int n2;
        Object object3;
        Node node;
        Comparable comparable = this.comparable(object);
        Node node2 = null;
        Index index = this.head;
        Index index2 = index.right;
        while (true) {
            if (index2 != null && (node = index2.node) != node2 && (object3 = node.key) != null) {
                n2 = comparable.compareTo(object3);
                if (n2 > 0) {
                    index = index2;
                    index2 = index2.right;
                    continue;
                }
                if (n2 == 0) {
                    Object object4 = node.value;
                    return object4 != null ? object4 : this.getUsingFindNode(comparable);
                }
                node2 = node;
            }
            if ((object2 = index.down) == null) break;
            index = object2;
            index2 = ((Index)object2).right;
        }
        node = index.node.next;
        while (node != null) {
            object3 = node.key;
            if (object3 != null) {
                n2 = comparable.compareTo(object3);
                if (n2 == 0) {
                    object2 = node.value;
                    return object2 != null ? object2 : this.getUsingFindNode(comparable);
                }
                if (n2 < 0) break;
            }
            node = node.next;
        }
        return null;
    }

    private Object getUsingFindNode(Comparable comparable) {
        Node node;
        Object object;
        do {
            if ((node = this.findNode(comparable)) != null) continue;
            return null;
        } while ((object = node.value) == null);
        return object;
    }

    private Object doPut(Object object, Object object2, boolean bl2) {
        Node node;
        Comparable comparable = this.comparable(object);
        block0: while (true) {
            Node node2 = this.findPredecessor(comparable);
            Node node3 = node2.next;
            while (node3 != null) {
                node = node3.next;
                if (node3 != node2.next) continue block0;
                Object object3 = node3.value;
                if (object3 == null) {
                    node3.helpDelete(node2, node);
                    continue block0;
                }
                if (object3 == node3 || node2.value == null) continue block0;
                int n2 = comparable.compareTo(node3.key);
                if (n2 > 0) {
                    node2 = node3;
                    node3 = node;
                    continue;
                }
                if (n2 != 0) break;
                if (!bl2 && !node3.casValue(object3, object2)) continue block0;
                return object3;
            }
            if (node2.casNext(node3, node = new Node(object, object2, node3))) break;
        }
        int n3 = this.randomLevel();
        if (n3 > 0) {
            this.insertIndex(node, n3);
        }
        return null;
    }

    private int randomLevel() {
        int n2 = this.randomSeed;
        n2 ^= n2 << 13;
        n2 ^= n2 >>> 17;
        n2 ^= n2 << 5;
        this.randomSeed = n2;
        if ((n2 & 0x8001) != 0) {
            return 0;
        }
        int n3 = 1;
        while (((n2 >>>= 1) & 1) != 0) {
            ++n3;
        }
        return n3;
    }

    private void insertIndex(Node node, int n2) {
        HeadIndex headIndex = this.head;
        int n3 = headIndex.level;
        if (n2 <= n3) {
            Index index = null;
            for (int i2 = 1; i2 <= n2; ++i2) {
                index = new Index(node, index, null);
            }
            this.addIndex(index, headIndex, n2);
        } else {
            int n4;
            HeadIndex headIndex2;
            Index[] indexArray;
            block7: {
                int n5;
                HeadIndex headIndex3;
                n2 = n3 + 1;
                indexArray = new Index[n2 + 1];
                Index index = null;
                for (int i3 = 1; i3 <= n2; ++i3) {
                    indexArray[i3] = index = new Index(node, index, null);
                }
                do {
                    headIndex2 = this.head;
                    n5 = headIndex2.level;
                    if (n2 <= n5) {
                        n4 = n2;
                        break block7;
                    }
                    headIndex3 = headIndex2;
                    Node node2 = headIndex2.node;
                    for (int i4 = n5 + 1; i4 <= n2; ++i4) {
                        headIndex3 = new HeadIndex(node2, headIndex3, indexArray[i4], i4);
                    }
                } while (!this.casHead(headIndex2, headIndex3));
                n4 = n5;
            }
            this.addIndex(indexArray[n4], headIndex2, n4);
        }
    }

    /*
     * Unable to fully structure code
     */
    private void addIndex(Index var1_1, HeadIndex var2_2, int var3_3) {
        var4_4 = var3_3;
        var5_5 = this.comparable(var1_1.node.key);
        if (var5_5 == null) {
            throw new NullPointerException();
        }
        block0: while (true) {
            var6_6 = var2_2.level;
            var7_7 = var2_2;
            var8_8 = var7_7.right;
            var9_9 = var1_1;
            while (true) {
                if (var8_8 != null) {
                    var10_10 = var8_8.node;
                    var11_11 = var5_5.compareTo(var10_10.key);
                    if (var10_10.value == null) {
                        if (!var7_7.unlink(var8_8)) continue block0;
                        var8_8 = var7_7.right;
                        continue;
                    }
                    if (var11_11 > 0) {
                        var7_7 = var8_8;
                        var8_8 = var8_8.right;
                        continue;
                    }
                }
                if (var6_6 == var4_4) {
                    if (var9_9.indexesDeletedNode()) {
                        this.findNode(var5_5);
                        return;
                    }
                    if (var7_7.link(var8_8, var9_9)) ** break;
                    continue block0;
                    if (--var4_4 == 0) {
                        if (var9_9.indexesDeletedNode()) {
                            this.findNode(var5_5);
                        }
                        return;
                    }
                }
                if (--var6_6 >= var4_4 && var6_6 < var3_3) {
                    var9_9 = var9_9.down;
                }
                var7_7 = var7_7.down;
                var8_8 = var7_7.right;
            }
            break;
        }
    }

    final Object doRemove(Object object, Object object2) {
        Object object3;
        Node node;
        Node node2;
        Node node3;
        Comparable comparable = this.comparable(object);
        block0: while (true) {
            node3 = this.findPredecessor(comparable);
            node2 = node3.next;
            while (true) {
                if (node2 == null) {
                    return null;
                }
                node = node2.next;
                if (node2 != node3.next) continue block0;
                object3 = node2.value;
                if (object3 == null) {
                    node2.helpDelete(node3, node);
                    continue block0;
                }
                if (object3 == node2 || node3.value == null) continue block0;
                int n2 = comparable.compareTo(node2.key);
                if (n2 < 0) {
                    return null;
                }
                if (n2 <= 0) break;
                node3 = node2;
                node2 = node;
            }
            if (object2 != null && !object2.equals(object3)) {
                return null;
            }
            if (node2.casValue(object3, null)) break;
        }
        if (!node2.appendMarker(node) || !node3.casNext(node2, node)) {
            this.findNode(comparable);
        } else {
            this.findPredecessor(comparable);
            if (this.head.right == null) {
                this.tryReduceLevel();
            }
        }
        return object3;
    }

    private void tryReduceLevel() {
        HeadIndex headIndex;
        HeadIndex headIndex2;
        HeadIndex headIndex3 = this.head;
        if (headIndex3.level > 3 && (headIndex2 = (HeadIndex)headIndex3.down) != null && (headIndex = (HeadIndex)headIndex2.down) != null && headIndex.right == null && headIndex2.right == null && headIndex3.right == null && this.casHead(headIndex3, headIndex2) && headIndex3.right != null) {
            this.casHead(headIndex2, headIndex3);
        }
    }

    Node findFirst() {
        while (true) {
            Node node = this.head.node;
            Node node2 = node.next;
            if (node2 == null) {
                return null;
            }
            if (node2.value != null) {
                return node2;
            }
            node2.helpDelete(node, node2.next);
        }
    }

    Map.Entry doRemoveFirstEntry() {
        Object object;
        Node node;
        Node node2;
        Node node3;
        while (true) {
            node3 = this.head.node;
            node2 = node3.next;
            if (node2 == null) {
                return null;
            }
            node = node2.next;
            if (node2 != node3.next) continue;
            object = node2.value;
            if (object == null) {
                node2.helpDelete(node3, node);
                continue;
            }
            if (node2.casValue(object, null)) break;
        }
        if (!node2.appendMarker(node) || !node3.casNext(node2, node)) {
            this.findFirst();
        }
        this.clearIndexToFirst();
        return new AbstractMap.SimpleImmutableEntry(node2.key, object);
    }

    private void clearIndexToFirst() {
        block0: while (true) {
            Index index = this.head;
            do {
                Index index2;
                if ((index2 = index.right) != null && index2.indexesDeletedNode() && !index.unlink(index2)) continue block0;
            } while ((index = index.down) != null);
            break;
        }
        if (this.head.right == null) {
            this.tryReduceLevel();
        }
    }

    Node findLast() {
        Index index = this.head;
        while (true) {
            Index index2;
            if ((index2 = index.right) != null) {
                if (index2.indexesDeletedNode()) {
                    index.unlink(index2);
                    index = this.head;
                    continue;
                }
                index = index2;
                continue;
            }
            Index index3 = index.down;
            if (index3 != null) {
                index = index3;
                continue;
            }
            Node node = index.node;
            Node node2 = node.next;
            while (true) {
                if (node2 == null) {
                    return node.isBaseHeader() ? null : node;
                }
                Node node3 = node2.next;
                if (node2 != node.next) break;
                Object object = node2.value;
                if (object == null) {
                    node2.helpDelete(node, node3);
                    break;
                }
                if (object == node2 || node.value == null) break;
                node = node2;
                node2 = node3;
            }
            index = this.head;
        }
    }

    private Node findPredecessorOfLast() {
        Index index;
        block0: while (true) {
            index = this.head;
            while (true) {
                Index index2;
                Index index3;
                if ((index3 = index.right) != null) {
                    if (index3.indexesDeletedNode()) {
                        index.unlink(index3);
                        continue block0;
                    }
                    if (index3.node.next != null) {
                        index = index3;
                        continue;
                    }
                }
                if ((index2 = index.down) == null) break block0;
                index = index2;
            }
            break;
        }
        return index.node;
    }

    Map.Entry doRemoveLastEntry() {
        Object object;
        Node node;
        Node node2;
        Node node3;
        block0: while (true) {
            node3 = this.findPredecessorOfLast();
            node2 = node3.next;
            if (node2 == null) {
                if (!node3.isBaseHeader()) continue;
                return null;
            }
            while (true) {
                node = node2.next;
                if (node2 != node3.next) continue block0;
                object = node2.value;
                if (object == null) {
                    node2.helpDelete(node3, node);
                    continue block0;
                }
                if (object == node2 || node3.value == null) continue block0;
                if (node == null) break;
                node3 = node2;
                node2 = node;
            }
            if (node2.casValue(object, null)) break;
        }
        Object object2 = node2.key;
        Comparable comparable = this.comparable(object2);
        if (!node2.appendMarker(node) || !node3.casNext(node2, node)) {
            this.findNode(comparable);
        } else {
            this.findPredecessor(comparable);
            if (this.head.right == null) {
                this.tryReduceLevel();
            }
        }
        return new AbstractMap.SimpleImmutableEntry(object2, object);
    }

    /*
     * Unable to fully structure code
     */
    Node findNear(Object var1_1, int var2_2) {
        var3_3 = this.comparable(var1_1);
        block0: while (true) {
            var4_4 = this.findPredecessor(var3_3);
            var5_5 = var4_4.next;
            while (true) {
                if (var5_5 == null) {
                    return (var2_2 & 2) == 0 || var4_4.isBaseHeader() != false ? null : var4_4;
                }
                var6_6 = var5_5.next;
                if (var5_5 != var4_4.next) continue block0;
                var7_7 = var5_5.value;
                if (var7_7 == null) {
                    var5_5.helpDelete(var4_4, var6_6);
                    continue block0;
                }
                if (var7_7 != var5_5 && var4_4.value != null) ** break;
                continue block0;
                var8_8 = var3_3.compareTo(var5_5.key);
                if (var8_8 == 0 && (var2_2 & 1) != 0 || var8_8 < 0 && (var2_2 & 2) == 0) {
                    return var5_5;
                }
                if (var8_8 <= 0 && (var2_2 & 2) != 0) {
                    return var4_4.isBaseHeader() != false ? null : var4_4;
                }
                var4_4 = var5_5;
                var5_5 = var6_6;
            }
            break;
        }
    }

    AbstractMap.SimpleImmutableEntry getNear(Object object, int n2) {
        Node node;
        AbstractMap.SimpleImmutableEntry simpleImmutableEntry;
        do {
            if ((node = this.findNear(object, n2)) != null) continue;
            return null;
        } while ((simpleImmutableEntry = node.createSnapshot()) == null);
        return simpleImmutableEntry;
    }

    public ConcurrentSkipListMap() {
        this.comparator = null;
        this.initialize();
    }

    public ConcurrentSkipListMap(Comparator comparator) {
        this.comparator = comparator;
        this.initialize();
    }

    public ConcurrentSkipListMap(Map map) {
        this.comparator = null;
        this.initialize();
        this.putAll(map);
    }

    public ConcurrentSkipListMap(SortedMap sortedMap) {
        this.comparator = sortedMap.comparator();
        this.initialize();
        this.buildFromSorted(sortedMap);
    }

    @Override
    public Object clone() {
        ConcurrentSkipListMap concurrentSkipListMap = null;
        try {
            concurrentSkipListMap = (ConcurrentSkipListMap)super.clone();
        }
        catch (CloneNotSupportedException cloneNotSupportedException) {
            throw new InternalError();
        }
        concurrentSkipListMap.initialize();
        concurrentSkipListMap.buildFromSorted(this);
        return concurrentSkipListMap;
    }

    private void buildFromSorted(SortedMap sortedMap) {
        if (sortedMap == null) {
            throw new NullPointerException();
        }
        HeadIndex headIndex = this.head;
        Node node = headIndex.node;
        ArrayList<Index> arrayList = new ArrayList<Index>();
        for (int i2 = 0; i2 <= headIndex.level; ++i2) {
            arrayList.add(null);
        }
        Index index = headIndex;
        for (int i3 = headIndex.level; i3 > 0; --i3) {
            arrayList.set(i3, index);
            index = index.down;
        }
        for (Map.Entry entry : sortedMap.entrySet()) {
            Node node2;
            int n2 = this.randomLevel();
            if (n2 > headIndex.level) {
                n2 = headIndex.level + 1;
            }
            Object k2 = entry.getKey();
            Object v2 = entry.getValue();
            if (k2 == null || v2 == null) {
                throw new NullPointerException();
            }
            node.next = node2 = new Node(k2, v2, null);
            node = node2;
            if (n2 <= 0) continue;
            Index index2 = null;
            for (int i4 = 1; i4 <= n2; ++i4) {
                index2 = new Index(node2, index2, null);
                if (i4 > headIndex.level) {
                    headIndex = new HeadIndex(headIndex.node, headIndex, index2, i4);
                }
                if (i4 < arrayList.size()) {
                    ((Index)arrayList.get((int)i4)).right = index2;
                    arrayList.set(i4, index2);
                    continue;
                }
                arrayList.add(index2);
            }
        }
        this.head = headIndex;
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        Node node = this.findFirst();
        while (node != null) {
            Object object = node.getValidValue();
            if (object != null) {
                objectOutputStream.writeObject(node.key);
                objectOutputStream.writeObject(object);
            }
            node = node.next;
        }
        objectOutputStream.writeObject(null);
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        Object object;
        objectInputStream.defaultReadObject();
        this.initialize();
        HeadIndex headIndex = this.head;
        Node node = headIndex.node;
        ArrayList<Index> arrayList = new ArrayList<Index>();
        for (int i2 = 0; i2 <= headIndex.level; ++i2) {
            arrayList.add(null);
        }
        Index index = headIndex;
        for (int i3 = headIndex.level; i3 > 0; --i3) {
            arrayList.set(i3, index);
            index = index.down;
        }
        while ((object = objectInputStream.readObject()) != null) {
            Node node2;
            Object object2 = objectInputStream.readObject();
            if (object2 == null) {
                throw new NullPointerException();
            }
            Object object3 = object;
            Object object4 = object2;
            int n2 = this.randomLevel();
            if (n2 > headIndex.level) {
                n2 = headIndex.level + 1;
            }
            node.next = node2 = new Node(object3, object4, null);
            node = node2;
            if (n2 <= 0) continue;
            Index index2 = null;
            for (int i4 = 1; i4 <= n2; ++i4) {
                index2 = new Index(node2, index2, null);
                if (i4 > headIndex.level) {
                    headIndex = new HeadIndex(headIndex.node, headIndex, index2, i4);
                }
                if (i4 < arrayList.size()) {
                    ((Index)arrayList.get((int)i4)).right = index2;
                    arrayList.set(i4, index2);
                    continue;
                }
                arrayList.add(index2);
            }
        }
        this.head = headIndex;
    }

    @Override
    public boolean containsKey(Object object) {
        return this.doGet(object) != null;
    }

    @Override
    public Object get(Object object) {
        return this.doGet(object);
    }

    @Override
    public Object put(Object object, Object object2) {
        if (object2 == null) {
            throw new NullPointerException();
        }
        return this.doPut(object, object2, false);
    }

    @Override
    public Object remove(Object object) {
        return this.doRemove(object, null);
    }

    @Override
    public boolean containsValue(Object object) {
        if (object == null) {
            throw new NullPointerException();
        }
        Node node = this.findFirst();
        while (node != null) {
            Object object2 = node.getValidValue();
            if (object2 != null && object.equals(object2)) {
                return true;
            }
            node = node.next;
        }
        return false;
    }

    @Override
    public int size() {
        long l2 = 0L;
        Node node = this.findFirst();
        while (node != null) {
            if (node.getValidValue() != null) {
                ++l2;
            }
            node = node.next;
        }
        return l2 >= Integer.MAX_VALUE ? Integer.MAX_VALUE : (int)l2;
    }

    @Override
    public boolean isEmpty() {
        return this.findFirst() == null;
    }

    @Override
    public void clear() {
        this.initialize();
    }

    @Override
    public Set keySet() {
        KeySet keySet = this.keySet;
        return keySet != null ? keySet : (this.keySet = new KeySet(this));
    }

    @Override
    public NavigableSet navigableKeySet() {
        KeySet keySet = this.keySet;
        return keySet != null ? keySet : (this.keySet = new KeySet(this));
    }

    @Override
    public Collection values() {
        Values values = this.values;
        return values != null ? values : (this.values = new Values(this));
    }

    @Override
    public Set entrySet() {
        EntrySet entrySet = this.entrySet;
        return entrySet != null ? entrySet : (this.entrySet = new EntrySet(this));
    }

    @Override
    public NavigableMap descendingMap() {
        ConcurrentNavigableMap concurrentNavigableMap = this.descendingMap;
        return concurrentNavigableMap != null ? concurrentNavigableMap : (this.descendingMap = new SubMap(this, null, false, null, false, true));
    }

    @Override
    public NavigableSet descendingKeySet() {
        return this.descendingMap().navigableKeySet();
    }

    @Override
    public boolean equals(Object object) {
        if (object == this) {
            return true;
        }
        if (!(object instanceof Map)) {
            return false;
        }
        Map map = (Map)object;
        try {
            for (Map.Entry entry : this.entrySet()) {
                if (entry.getValue().equals(map.get(entry.getKey()))) continue;
                return false;
            }
            for (Map.Entry entry : map.entrySet()) {
                Object k2 = entry.getKey();
                Object v2 = entry.getValue();
                if (k2 != null && v2 != null && v2.equals(this.get(k2))) continue;
                return false;
            }
            return true;
        }
        catch (ClassCastException classCastException) {
            return false;
        }
        catch (NullPointerException nullPointerException) {
            return false;
        }
    }

    @Override
    public Object putIfAbsent(Object object, Object object2) {
        if (object2 == null) {
            throw new NullPointerException();
        }
        return this.doPut(object, object2, true);
    }

    @Override
    public boolean remove(Object object, Object object2) {
        if (object == null) {
            throw new NullPointerException();
        }
        if (object2 == null) {
            return false;
        }
        return this.doRemove(object, object2) != null;
    }

    @Override
    public boolean replace(Object object, Object object2, Object object3) {
        if (object2 == null || object3 == null) {
            throw new NullPointerException();
        }
        Comparable comparable = this.comparable(object);
        while (true) {
            Node node;
            if ((node = this.findNode(comparable)) == null) {
                return false;
            }
            Object object4 = node.value;
            if (object4 == null) continue;
            if (!object2.equals(object4)) {
                return false;
            }
            if (node.casValue(object4, object3)) break;
        }
        return true;
    }

    @Override
    public Object replace(Object object, Object object2) {
        Node node;
        Object object3;
        if (object2 == null) {
            throw new NullPointerException();
        }
        Comparable comparable = this.comparable(object);
        do {
            if ((node = this.findNode(comparable)) != null) continue;
            return null;
        } while ((object3 = node.value) == null || !node.casValue(object3, object2));
        return object3;
    }

    public Comparator comparator() {
        return this.comparator;
    }

    public Object firstKey() {
        Node node = this.findFirst();
        if (node == null) {
            throw new NoSuchElementException();
        }
        return node.key;
    }

    public Object lastKey() {
        Node node = this.findLast();
        if (node == null) {
            throw new NoSuchElementException();
        }
        return node.key;
    }

    @Override
    public NavigableMap subMap(Object object, boolean bl2, Object object2, boolean bl3) {
        if (object == null || object2 == null) {
            throw new NullPointerException();
        }
        return new SubMap(this, object, bl2, object2, bl3, false);
    }

    @Override
    public NavigableMap headMap(Object object, boolean bl2) {
        if (object == null) {
            throw new NullPointerException();
        }
        return new SubMap(this, null, false, object, bl2, false);
    }

    @Override
    public NavigableMap tailMap(Object object, boolean bl2) {
        if (object == null) {
            throw new NullPointerException();
        }
        return new SubMap(this, object, bl2, null, false, false);
    }

    @Override
    public SortedMap subMap(Object object, Object object2) {
        return this.subMap(object, true, object2, false);
    }

    @Override
    public SortedMap headMap(Object object) {
        return this.headMap(object, false);
    }

    @Override
    public SortedMap tailMap(Object object) {
        return this.tailMap(object, true);
    }

    @Override
    public Map.Entry lowerEntry(Object object) {
        return this.getNear(object, 2);
    }

    @Override
    public Object lowerKey(Object object) {
        Node node = this.findNear(object, 2);
        return node == null ? null : node.key;
    }

    @Override
    public Map.Entry floorEntry(Object object) {
        return this.getNear(object, 3);
    }

    @Override
    public Object floorKey(Object object) {
        Node node = this.findNear(object, 3);
        return node == null ? null : node.key;
    }

    @Override
    public Map.Entry ceilingEntry(Object object) {
        return this.getNear(object, 1);
    }

    @Override
    public Object ceilingKey(Object object) {
        Node node = this.findNear(object, 1);
        return node == null ? null : node.key;
    }

    @Override
    public Map.Entry higherEntry(Object object) {
        return this.getNear(object, 0);
    }

    @Override
    public Object higherKey(Object object) {
        Node node = this.findNear(object, 0);
        return node == null ? null : node.key;
    }

    @Override
    public Map.Entry firstEntry() {
        Node node;
        AbstractMap.SimpleImmutableEntry simpleImmutableEntry;
        do {
            if ((node = this.findFirst()) != null) continue;
            return null;
        } while ((simpleImmutableEntry = node.createSnapshot()) == null);
        return simpleImmutableEntry;
    }

    @Override
    public Map.Entry lastEntry() {
        Node node;
        AbstractMap.SimpleImmutableEntry simpleImmutableEntry;
        do {
            if ((node = this.findLast()) != null) continue;
            return null;
        } while ((simpleImmutableEntry = node.createSnapshot()) == null);
        return simpleImmutableEntry;
    }

    @Override
    public Map.Entry pollFirstEntry() {
        return this.doRemoveFirstEntry();
    }

    @Override
    public Map.Entry pollLastEntry() {
        return this.doRemoveLastEntry();
    }

    Iterator keyIterator() {
        return new KeyIterator();
    }

    Iterator valueIterator() {
        return new ValueIterator();
    }

    Iterator entryIterator() {
        return new EntryIterator();
    }

    static final List toList(Collection collection) {
        ArrayList arrayList = new ArrayList();
        Iterator iterator = collection.iterator();
        while (iterator.hasNext()) {
            arrayList.add(iterator.next());
        }
        return arrayList;
    }

    static final class SubMap
    extends AbstractMap
    implements ConcurrentNavigableMap,
    Cloneable,
    Serializable {
        private static final long serialVersionUID = -7647078645895051609L;
        private final ConcurrentSkipListMap m;
        private final Object lo;
        private final Object hi;
        private final boolean loInclusive;
        private final boolean hiInclusive;
        private final boolean isDescending;
        private transient KeySet keySetView;
        private transient Set entrySetView;
        private transient Collection valuesView;

        SubMap(ConcurrentSkipListMap concurrentSkipListMap, Object object, boolean bl2, Object object2, boolean bl3, boolean bl4) {
            if (object != null && object2 != null && concurrentSkipListMap.compare(object, object2) > 0) {
                throw new IllegalArgumentException("inconsistent range");
            }
            this.m = concurrentSkipListMap;
            this.lo = object;
            this.hi = object2;
            this.loInclusive = bl2;
            this.hiInclusive = bl3;
            this.isDescending = bl4;
        }

        private boolean tooLow(Object object) {
            int n2;
            return this.lo != null && ((n2 = this.m.compare(object, this.lo)) < 0 || n2 == 0 && !this.loInclusive);
        }

        private boolean tooHigh(Object object) {
            int n2;
            return this.hi != null && ((n2 = this.m.compare(object, this.hi)) > 0 || n2 == 0 && !this.hiInclusive);
        }

        private boolean inBounds(Object object) {
            return !this.tooLow(object) && !this.tooHigh(object);
        }

        private void checkKeyBounds(Object object) throws IllegalArgumentException {
            if (object == null) {
                throw new NullPointerException();
            }
            if (!this.inBounds(object)) {
                throw new IllegalArgumentException("key out of range");
            }
        }

        private boolean isBeforeEnd(Node node) {
            if (node == null) {
                return false;
            }
            if (this.hi == null) {
                return true;
            }
            Object object = node.key;
            if (object == null) {
                return true;
            }
            int n2 = this.m.compare(object, this.hi);
            return n2 <= 0 && (n2 != 0 || this.hiInclusive);
        }

        private Node loNode() {
            if (this.lo == null) {
                return this.m.findFirst();
            }
            if (this.loInclusive) {
                return this.m.findNear(this.lo, 0 | 1);
            }
            return this.m.findNear(this.lo, 0);
        }

        private Node hiNode() {
            if (this.hi == null) {
                return this.m.findLast();
            }
            if (this.hiInclusive) {
                return this.m.findNear(this.hi, 2 | 1);
            }
            return this.m.findNear(this.hi, 2);
        }

        private Object lowestKey() {
            Node node = this.loNode();
            if (this.isBeforeEnd(node)) {
                return node.key;
            }
            throw new NoSuchElementException();
        }

        private Object highestKey() {
            Object object;
            Node node = this.hiNode();
            if (node != null && this.inBounds(object = node.key)) {
                return object;
            }
            throw new NoSuchElementException();
        }

        private Map.Entry lowestEntry() {
            Node node;
            AbstractMap.SimpleImmutableEntry simpleImmutableEntry;
            do {
                if (this.isBeforeEnd(node = this.loNode())) continue;
                return null;
            } while ((simpleImmutableEntry = node.createSnapshot()) == null);
            return simpleImmutableEntry;
        }

        private Map.Entry highestEntry() {
            Node node;
            AbstractMap.SimpleImmutableEntry simpleImmutableEntry;
            do {
                if ((node = this.hiNode()) != null && this.inBounds(node.key)) continue;
                return null;
            } while ((simpleImmutableEntry = node.createSnapshot()) == null);
            return simpleImmutableEntry;
        }

        private Map.Entry removeLowest() {
            Object object;
            Object object2;
            do {
                Node node;
                if ((node = this.loNode()) == null) {
                    return null;
                }
                object = node.key;
                if (this.inBounds(object)) continue;
                return null;
            } while ((object2 = this.m.doRemove(object, null)) == null);
            return new AbstractMap.SimpleImmutableEntry(object, object2);
        }

        private Map.Entry removeHighest() {
            Object object;
            Object object2;
            do {
                Node node;
                if ((node = this.hiNode()) == null) {
                    return null;
                }
                object = node.key;
                if (this.inBounds(object)) continue;
                return null;
            } while ((object2 = this.m.doRemove(object, null)) == null);
            return new AbstractMap.SimpleImmutableEntry(object, object2);
        }

        private Map.Entry getNearEntry(Object object, int n2) {
            Object object2;
            Node node;
            Object object3;
            if (this.isDescending) {
                n2 = (n2 & 2) == 0 ? (n2 |= 2) : (n2 &= ~2);
            }
            if (this.tooLow(object)) {
                return (n2 & 2) != 0 ? null : this.lowestEntry();
            }
            if (this.tooHigh(object)) {
                return (n2 & 2) != 0 ? this.highestEntry() : null;
            }
            do {
                if ((node = this.m.findNear(object, n2)) == null || !this.inBounds(node.key)) {
                    return null;
                }
                object2 = node.key;
            } while ((object3 = node.getValidValue()) == null);
            return new AbstractMap.SimpleImmutableEntry(object2, object3);
        }

        private Object getNearKey(Object object, int n2) {
            Object object2;
            Node node;
            Object object3;
            if (this.isDescending) {
                n2 = (n2 & 2) == 0 ? (n2 |= 2) : (n2 &= ~2);
            }
            if (this.tooLow(object)) {
                Node node2;
                if ((n2 & 2) == 0 && this.isBeforeEnd(node2 = this.loNode())) {
                    return node2.key;
                }
                return null;
            }
            if (this.tooHigh(object)) {
                Object object4;
                Node node3;
                if ((n2 & 2) != 0 && (node3 = this.hiNode()) != null && this.inBounds(object4 = node3.key)) {
                    return object4;
                }
                return null;
            }
            do {
                if ((node = this.m.findNear(object, n2)) == null || !this.inBounds(node.key)) {
                    return null;
                }
                object2 = node.key;
            } while ((object3 = node.getValidValue()) == null);
            return object2;
        }

        @Override
        public boolean containsKey(Object object) {
            if (object == null) {
                throw new NullPointerException();
            }
            Object object2 = object;
            return this.inBounds(object2) && this.m.containsKey(object2);
        }

        @Override
        public Object get(Object object) {
            if (object == null) {
                throw new NullPointerException();
            }
            Object object2 = object;
            return !this.inBounds(object2) ? null : this.m.get(object2);
        }

        @Override
        public Object put(Object object, Object object2) {
            this.checkKeyBounds(object);
            return this.m.put(object, object2);
        }

        @Override
        public Object remove(Object object) {
            Object object2 = object;
            return !this.inBounds(object2) ? null : this.m.remove(object2);
        }

        @Override
        public int size() {
            long l2 = 0L;
            Node node = this.loNode();
            while (this.isBeforeEnd(node)) {
                if (node.getValidValue() != null) {
                    ++l2;
                }
                node = node.next;
            }
            return l2 >= Integer.MAX_VALUE ? Integer.MAX_VALUE : (int)l2;
        }

        @Override
        public boolean isEmpty() {
            return !this.isBeforeEnd(this.loNode());
        }

        @Override
        public boolean containsValue(Object object) {
            if (object == null) {
                throw new NullPointerException();
            }
            Node node = this.loNode();
            while (this.isBeforeEnd(node)) {
                Object object2 = node.getValidValue();
                if (object2 != null && object.equals(object2)) {
                    return true;
                }
                node = node.next;
            }
            return false;
        }

        @Override
        public void clear() {
            Node node = this.loNode();
            while (this.isBeforeEnd(node)) {
                if (node.getValidValue() != null) {
                    this.m.remove(node.key);
                }
                node = node.next;
            }
        }

        @Override
        public Object putIfAbsent(Object object, Object object2) {
            this.checkKeyBounds(object);
            return this.m.putIfAbsent(object, object2);
        }

        @Override
        public boolean remove(Object object, Object object2) {
            Object object3 = object;
            return this.inBounds(object3) && this.m.remove(object3, object2);
        }

        @Override
        public boolean replace(Object object, Object object2, Object object3) {
            this.checkKeyBounds(object);
            return this.m.replace(object, object2, object3);
        }

        @Override
        public Object replace(Object object, Object object2) {
            this.checkKeyBounds(object);
            return this.m.replace(object, object2);
        }

        public Comparator comparator() {
            Comparator comparator = this.m.comparator();
            if (this.isDescending) {
                return Collections.reverseOrder(comparator);
            }
            return comparator;
        }

        private SubMap newSubMap(Object object, boolean bl2, Object object2, boolean bl3) {
            if (this.isDescending) {
                Object object3 = object;
                object = object2;
                object2 = object3;
                boolean bl4 = bl2;
                bl2 = bl3;
                bl3 = bl4;
            }
            if (this.lo != null) {
                if (object == null) {
                    object = this.lo;
                    bl2 = this.loInclusive;
                } else {
                    int n2 = this.m.compare(object, this.lo);
                    if (n2 < 0 || n2 == 0 && !this.loInclusive && bl2) {
                        throw new IllegalArgumentException("key out of range");
                    }
                }
            }
            if (this.hi != null) {
                if (object2 == null) {
                    object2 = this.hi;
                    bl3 = this.hiInclusive;
                } else {
                    int n3 = this.m.compare(object2, this.hi);
                    if (n3 > 0 || n3 == 0 && !this.hiInclusive && bl3) {
                        throw new IllegalArgumentException("key out of range");
                    }
                }
            }
            return new SubMap(this.m, object, bl2, object2, bl3, this.isDescending);
        }

        @Override
        public NavigableMap subMap(Object object, boolean bl2, Object object2, boolean bl3) {
            if (object == null || object2 == null) {
                throw new NullPointerException();
            }
            return this.newSubMap(object, bl2, object2, bl3);
        }

        @Override
        public NavigableMap headMap(Object object, boolean bl2) {
            if (object == null) {
                throw new NullPointerException();
            }
            return this.newSubMap(null, false, object, bl2);
        }

        @Override
        public NavigableMap tailMap(Object object, boolean bl2) {
            if (object == null) {
                throw new NullPointerException();
            }
            return this.newSubMap(object, bl2, null, false);
        }

        @Override
        public SortedMap subMap(Object object, Object object2) {
            return this.subMap(object, true, object2, false);
        }

        @Override
        public SortedMap headMap(Object object) {
            return this.headMap(object, false);
        }

        @Override
        public SortedMap tailMap(Object object) {
            return this.tailMap(object, true);
        }

        @Override
        public NavigableMap descendingMap() {
            return new SubMap(this.m, this.lo, this.loInclusive, this.hi, this.hiInclusive, !this.isDescending);
        }

        @Override
        public Map.Entry ceilingEntry(Object object) {
            return this.getNearEntry(object, 0 | 1);
        }

        @Override
        public Object ceilingKey(Object object) {
            return this.getNearKey(object, 0 | 1);
        }

        @Override
        public Map.Entry lowerEntry(Object object) {
            return this.getNearEntry(object, 2);
        }

        @Override
        public Object lowerKey(Object object) {
            return this.getNearKey(object, 2);
        }

        @Override
        public Map.Entry floorEntry(Object object) {
            return this.getNearEntry(object, 2 | 1);
        }

        @Override
        public Object floorKey(Object object) {
            return this.getNearKey(object, 2 | 1);
        }

        @Override
        public Map.Entry higherEntry(Object object) {
            return this.getNearEntry(object, 0);
        }

        @Override
        public Object higherKey(Object object) {
            return this.getNearKey(object, 0);
        }

        public Object firstKey() {
            return this.isDescending ? this.highestKey() : this.lowestKey();
        }

        public Object lastKey() {
            return this.isDescending ? this.lowestKey() : this.highestKey();
        }

        @Override
        public Map.Entry firstEntry() {
            return this.isDescending ? this.highestEntry() : this.lowestEntry();
        }

        @Override
        public Map.Entry lastEntry() {
            return this.isDescending ? this.lowestEntry() : this.highestEntry();
        }

        @Override
        public Map.Entry pollFirstEntry() {
            return this.isDescending ? this.removeHighest() : this.removeLowest();
        }

        @Override
        public Map.Entry pollLastEntry() {
            return this.isDescending ? this.removeLowest() : this.removeHighest();
        }

        @Override
        public Set keySet() {
            KeySet keySet = this.keySetView;
            return keySet != null ? keySet : (this.keySetView = new KeySet(this));
        }

        @Override
        public NavigableSet navigableKeySet() {
            KeySet keySet = this.keySetView;
            return keySet != null ? keySet : (this.keySetView = new KeySet(this));
        }

        @Override
        public Collection values() {
            Collection collection = this.valuesView;
            return collection != null ? collection : (this.valuesView = new Values(this));
        }

        @Override
        public Set entrySet() {
            Set set = this.entrySetView;
            return set != null ? set : (this.entrySetView = new EntrySet(this));
        }

        @Override
        public NavigableSet descendingKeySet() {
            return this.descendingMap().navigableKeySet();
        }

        Iterator keyIterator() {
            return new SubMapKeyIterator();
        }

        Iterator valueIterator() {
            return new SubMapValueIterator();
        }

        Iterator entryIterator() {
            return new SubMapEntryIterator();
        }

        final class SubMapEntryIterator
        extends SubMapIter {
            SubMapEntryIterator() {
            }

            public Object next() {
                Node node = this.next;
                Object object = this.nextValue;
                this.advance();
                return new AbstractMap.SimpleImmutableEntry(node.key, object);
            }
        }

        final class SubMapKeyIterator
        extends SubMapIter {
            SubMapKeyIterator() {
            }

            public Object next() {
                Node node = this.next;
                this.advance();
                return node.key;
            }
        }

        final class SubMapValueIterator
        extends SubMapIter {
            SubMapValueIterator() {
            }

            public Object next() {
                Object object = this.nextValue;
                this.advance();
                return object;
            }
        }

        abstract class SubMapIter
        implements Iterator {
            Node lastReturned;
            Node next;
            Object nextValue;

            SubMapIter() {
                block3: {
                    Object object;
                    do {
                        Node node = this.next = SubMap.this.isDescending ? SubMap.this.hiNode() : SubMap.this.loNode();
                        if (this.next == null) break block3;
                    } while ((object = this.next.value) == null || object == this.next);
                    if (!SubMap.this.inBounds(this.next.key)) {
                        this.next = null;
                    } else {
                        this.nextValue = object;
                    }
                }
            }

            @Override
            public final boolean hasNext() {
                return this.next != null;
            }

            final void advance() {
                if (this.next == null) {
                    throw new NoSuchElementException();
                }
                this.lastReturned = this.next;
                if (SubMap.this.isDescending) {
                    this.descend();
                } else {
                    this.ascend();
                }
            }

            private void ascend() {
                block3: {
                    Object object;
                    do {
                        this.next = this.next.next;
                        if (this.next == null) break block3;
                    } while ((object = this.next.value) == null || object == this.next);
                    if (SubMap.this.tooHigh(this.next.key)) {
                        this.next = null;
                    } else {
                        this.nextValue = object;
                    }
                }
            }

            private void descend() {
                block3: {
                    Object object;
                    do {
                        this.next = SubMap.this.m.findNear(this.lastReturned.key, 2);
                        if (this.next == null) break block3;
                    } while ((object = this.next.value) == null || object == this.next);
                    if (SubMap.this.tooLow(this.next.key)) {
                        this.next = null;
                    } else {
                        this.nextValue = object;
                    }
                }
            }

            @Override
            public void remove() {
                Node node = this.lastReturned;
                if (node == null) {
                    throw new IllegalStateException();
                }
                SubMap.this.m.remove(node.key);
                this.lastReturned = null;
            }
        }
    }

    static final class EntrySet
    extends AbstractSet {
        private final ConcurrentNavigableMap m;

        EntrySet(ConcurrentNavigableMap concurrentNavigableMap) {
            this.m = concurrentNavigableMap;
        }

        @Override
        public Iterator iterator() {
            if (this.m instanceof ConcurrentSkipListMap) {
                return ((ConcurrentSkipListMap)this.m).entryIterator();
            }
            return ((SubMap)this.m).entryIterator();
        }

        @Override
        public boolean contains(Object object) {
            if (!(object instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry)object;
            Object v2 = this.m.get(entry.getKey());
            return v2 != null && v2.equals(entry.getValue());
        }

        @Override
        public boolean remove(Object object) {
            if (!(object instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry)object;
            return this.m.remove(entry.getKey(), entry.getValue());
        }

        @Override
        public boolean isEmpty() {
            return this.m.isEmpty();
        }

        @Override
        public int size() {
            return this.m.size();
        }

        @Override
        public void clear() {
            this.m.clear();
        }

        @Override
        public boolean equals(Object object) {
            if (object == this) {
                return true;
            }
            if (!(object instanceof Set)) {
                return false;
            }
            Collection collection = (Collection)object;
            try {
                return this.containsAll(collection) && collection.containsAll(this);
            }
            catch (ClassCastException classCastException) {
                return false;
            }
            catch (NullPointerException nullPointerException) {
                return false;
            }
        }

        @Override
        public Object[] toArray() {
            return ConcurrentSkipListMap.toList(this).toArray();
        }

        @Override
        public Object[] toArray(Object[] objectArray) {
            return ConcurrentSkipListMap.toList(this).toArray(objectArray);
        }
    }

    static final class Values
    extends AbstractCollection {
        private final ConcurrentNavigableMap m;

        Values(ConcurrentNavigableMap concurrentNavigableMap) {
            this.m = concurrentNavigableMap;
        }

        @Override
        public Iterator iterator() {
            if (this.m instanceof ConcurrentSkipListMap) {
                return ((ConcurrentSkipListMap)this.m).valueIterator();
            }
            return ((SubMap)this.m).valueIterator();
        }

        @Override
        public boolean isEmpty() {
            return this.m.isEmpty();
        }

        @Override
        public int size() {
            return this.m.size();
        }

        @Override
        public boolean contains(Object object) {
            return this.m.containsValue(object);
        }

        @Override
        public void clear() {
            this.m.clear();
        }

        @Override
        public Object[] toArray() {
            return ConcurrentSkipListMap.toList(this).toArray();
        }

        @Override
        public Object[] toArray(Object[] objectArray) {
            return ConcurrentSkipListMap.toList(this).toArray(objectArray);
        }
    }

    static final class KeySet
    extends AbstractSet
    implements NavigableSet {
        private final ConcurrentNavigableMap m;

        KeySet(ConcurrentNavigableMap concurrentNavigableMap) {
            this.m = concurrentNavigableMap;
        }

        @Override
        public int size() {
            return this.m.size();
        }

        @Override
        public boolean isEmpty() {
            return this.m.isEmpty();
        }

        @Override
        public boolean contains(Object object) {
            return this.m.containsKey(object);
        }

        @Override
        public boolean remove(Object object) {
            return this.m.remove(object) != null;
        }

        @Override
        public void clear() {
            this.m.clear();
        }

        @Override
        public Object lower(Object object) {
            return this.m.lowerKey(object);
        }

        @Override
        public Object floor(Object object) {
            return this.m.floorKey(object);
        }

        @Override
        public Object ceiling(Object object) {
            return this.m.ceilingKey(object);
        }

        @Override
        public Object higher(Object object) {
            return this.m.higherKey(object);
        }

        public Comparator comparator() {
            return this.m.comparator();
        }

        public Object first() {
            return this.m.firstKey();
        }

        public Object last() {
            return this.m.lastKey();
        }

        @Override
        public Object pollFirst() {
            Map.Entry entry = this.m.pollFirstEntry();
            return entry == null ? null : entry.getKey();
        }

        @Override
        public Object pollLast() {
            Map.Entry entry = this.m.pollLastEntry();
            return entry == null ? null : entry.getKey();
        }

        @Override
        public Object[] toArray() {
            return ConcurrentSkipListMap.toList(this).toArray();
        }

        @Override
        public Object[] toArray(Object[] objectArray) {
            return ConcurrentSkipListMap.toList(this).toArray(objectArray);
        }

        @Override
        public Iterator iterator() {
            if (this.m instanceof ConcurrentSkipListMap) {
                return ((ConcurrentSkipListMap)this.m).keyIterator();
            }
            return ((SubMap)this.m).keyIterator();
        }

        @Override
        public boolean equals(Object object) {
            if (object == this) {
                return true;
            }
            if (!(object instanceof Set)) {
                return false;
            }
            Collection collection = (Collection)object;
            try {
                return this.containsAll(collection) && collection.containsAll(this);
            }
            catch (ClassCastException classCastException) {
                return false;
            }
            catch (NullPointerException nullPointerException) {
                return false;
            }
        }

        @Override
        public Iterator descendingIterator() {
            return this.descendingSet().iterator();
        }

        @Override
        public NavigableSet subSet(Object object, boolean bl2, Object object2, boolean bl3) {
            return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.subMap(object, bl2, object2, bl3));
        }

        @Override
        public NavigableSet headSet(Object object, boolean bl2) {
            return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.headMap(object, bl2));
        }

        @Override
        public NavigableSet tailSet(Object object, boolean bl2) {
            return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.tailMap(object, bl2));
        }

        @Override
        public SortedSet subSet(Object object, Object object2) {
            return this.subSet(object, true, object2, false);
        }

        @Override
        public SortedSet headSet(Object object) {
            return this.headSet(object, false);
        }

        @Override
        public SortedSet tailSet(Object object) {
            return this.tailSet(object, true);
        }

        @Override
        public NavigableSet descendingSet() {
            return new ConcurrentSkipListSet((ConcurrentNavigableMap)this.m.descendingMap());
        }
    }

    final class EntryIterator
    extends Iter {
        EntryIterator() {
        }

        public Object next() {
            Node node = this.next;
            Object object = this.nextValue;
            this.advance();
            return new AbstractMap.SimpleImmutableEntry(node.key, object);
        }
    }

    final class KeyIterator
    extends Iter {
        KeyIterator() {
        }

        public Object next() {
            Node node = this.next;
            this.advance();
            return node.key;
        }
    }

    final class ValueIterator
    extends Iter {
        ValueIterator() {
        }

        public Object next() {
            Object object = this.nextValue;
            this.advance();
            return object;
        }
    }

    abstract class Iter
    implements Iterator {
        Node lastReturned;
        Node next;
        Object nextValue;

        Iter() {
            block1: {
                Object object;
                do {
                    this.next = ConcurrentSkipListMap.this.findFirst();
                    if (this.next == null) break block1;
                } while ((object = this.next.value) == null || object == this.next);
                this.nextValue = object;
            }
        }

        @Override
        public final boolean hasNext() {
            return this.next != null;
        }

        final void advance() {
            block2: {
                Object object;
                if (this.next == null) {
                    throw new NoSuchElementException();
                }
                this.lastReturned = this.next;
                do {
                    this.next = this.next.next;
                    if (this.next == null) break block2;
                } while ((object = this.next.value) == null || object == this.next);
                this.nextValue = object;
            }
        }

        @Override
        public void remove() {
            Node node = this.lastReturned;
            if (node == null) {
                throw new IllegalStateException();
            }
            ConcurrentSkipListMap.this.remove(node.key);
            this.lastReturned = null;
        }
    }

    static final class ComparableUsingComparator
    implements Comparable {
        final Object actualKey;
        final Comparator cmp;

        ComparableUsingComparator(Object object, Comparator comparator) {
            this.actualKey = object;
            this.cmp = comparator;
        }

        public int compareTo(Object object) {
            return this.cmp.compare(this.actualKey, object);
        }
    }

    static final class HeadIndex
    extends Index {
        final int level;

        HeadIndex(Node node, Index index, Index index2, int n2) {
            super(node, index, index2);
            this.level = n2;
        }
    }

    static class Index {
        final Node node;
        final Index down;
        volatile Index right;

        Index(Node node, Index index, Index index2) {
            this.node = node;
            this.down = index;
            this.right = index2;
        }

        final synchronized boolean casRight(Index index, Index index2) {
            if (this.right == index) {
                this.right = index2;
                return true;
            }
            return false;
        }

        final boolean indexesDeletedNode() {
            return this.node.value == null;
        }

        final boolean link(Index index, Index index2) {
            Node node = this.node;
            index2.right = index;
            return node.value != null && this.casRight(index, index2);
        }

        final boolean unlink(Index index) {
            return !this.indexesDeletedNode() && this.casRight(index, index.right);
        }
    }

    static final class Node {
        final Object key;
        volatile Object value;
        volatile Node next;

        Node(Object object, Object object2, Node node) {
            this.key = object;
            this.value = object2;
            this.next = node;
        }

        Node(Node node) {
            this.key = null;
            this.value = this;
            this.next = node;
        }

        synchronized boolean casValue(Object object, Object object2) {
            if (this.value == object) {
                this.value = object2;
                return true;
            }
            return false;
        }

        synchronized boolean casNext(Node node, Node node2) {
            if (this.next == node) {
                this.next = node2;
                return true;
            }
            return false;
        }

        boolean isMarker() {
            return this.value == this;
        }

        boolean isBaseHeader() {
            return this.value == BASE_HEADER;
        }

        boolean appendMarker(Node node) {
            return this.casNext(node, new Node(node));
        }

        void helpDelete(Node node, Node node2) {
            if (node2 == this.next && this == node.next) {
                if (node2 == null || node2.value != node2) {
                    this.appendMarker(node2);
                } else {
                    node.casNext(this, node2.next);
                }
            }
        }

        Object getValidValue() {
            Object object = this.value;
            if (object == this || object == BASE_HEADER) {
                return null;
            }
            return object;
        }

        AbstractMap.SimpleImmutableEntry createSnapshot() {
            Object object = this.getValidValue();
            if (object == null) {
                return null;
            }
            return new AbstractMap.SimpleImmutableEntry(this.key, object);
        }
    }
}

