/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.AbstractMap;
import edu.emory.mathcs.backport.java.util.Collections;
import edu.emory.mathcs.backport.java.util.NavigableMap;
import edu.emory.mathcs.backport.java.util.NavigableSet;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.AbstractSet;
import java.util.Comparator;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;

public class TreeMap
extends AbstractMap
implements NavigableMap,
Serializable {
    private static final long serialVersionUID = 919286545866124006L;
    private final Comparator comparator;
    private transient Entry root;
    private transient int size = 0;
    private transient int modCount = 0;
    private transient EntrySet entrySet;
    private transient KeySet navigableKeySet;
    private transient NavigableMap descendingMap;
    private transient Comparator reverseComparator;

    public TreeMap() {
        this.comparator = null;
    }

    public TreeMap(Comparator comparator) {
        this.comparator = comparator;
    }

    public TreeMap(SortedMap sortedMap) {
        this.comparator = sortedMap.comparator();
        this.buildFromSorted(sortedMap.entrySet().iterator(), sortedMap.size());
    }

    public TreeMap(Map map) {
        this.comparator = null;
        this.putAll(map);
    }

    @Override
    public int size() {
        return this.size;
    }

    @Override
    public void clear() {
        this.root = null;
        this.size = 0;
        ++this.modCount;
    }

    @Override
    public Object clone() {
        TreeMap treeMap;
        try {
            treeMap = (TreeMap)super.clone();
        }
        catch (CloneNotSupportedException cloneNotSupportedException) {
            throw new InternalError();
        }
        treeMap.root = null;
        treeMap.size = 0;
        treeMap.modCount = 0;
        if (!this.isEmpty()) {
            treeMap.buildFromSorted(this.entrySet().iterator(), this.size);
        }
        return treeMap;
    }

    @Override
    public Object put(Object object, Object object2) {
        if (this.root == null) {
            this.root = new Entry(object, object2);
            ++this.size;
            ++this.modCount;
            return null;
        }
        Entry entry = this.root;
        while (true) {
            int n2;
            if ((n2 = TreeMap.compare(object, entry.getKey(), this.comparator)) == 0) {
                return entry.setValue(object2);
            }
            if (n2 <= 0) {
                if (entry.left != null) {
                    entry = entry.left;
                    continue;
                }
                ++this.size;
                ++this.modCount;
                Entry entry2 = new Entry(object, object2);
                entry2.parent = entry;
                entry.left = entry2;
                this.fixAfterInsertion(entry2);
                return null;
            }
            if (entry.right == null) break;
            entry = entry.right;
        }
        ++this.size;
        ++this.modCount;
        Entry entry3 = new Entry(object, object2);
        entry3.parent = entry;
        entry.right = entry3;
        this.fixAfterInsertion(entry3);
        return null;
    }

    @Override
    public Object get(Object object) {
        Entry entry = this.getEntry(object);
        return entry == null ? null : entry.getValue();
    }

    @Override
    public boolean containsKey(Object object) {
        return this.getEntry(object) != null;
    }

    @Override
    public Set entrySet() {
        if (this.entrySet == null) {
            this.entrySet = new EntrySet();
        }
        return this.entrySet;
    }

    private static Entry successor(Entry entry) {
        if (entry.right != null) {
            entry = entry.right;
            while (entry.left != null) {
                entry = entry.left;
            }
            return entry;
        }
        Entry entry2 = entry.parent;
        while (entry2 != null && entry == entry2.right) {
            entry = entry2;
            entry2 = entry2.parent;
        }
        return entry2;
    }

    private static Entry predecessor(Entry entry) {
        if (entry.left != null) {
            entry = entry.left;
            while (entry.right != null) {
                entry = entry.right;
            }
            return entry;
        }
        Entry entry2 = entry.parent;
        while (entry2 != null && entry == entry2.left) {
            entry = entry2;
            entry2 = entry2.parent;
        }
        return entry2;
    }

    private Entry getEntry(Object object) {
        Entry entry = this.root;
        if (this.comparator != null) {
            while (true) {
                if (entry == null) {
                    return null;
                }
                int n2 = this.comparator.compare(object, entry.key);
                if (n2 == 0) {
                    return entry;
                }
                entry = n2 < 0 ? entry.left : entry.right;
            }
        }
        Comparable comparable = (Comparable)object;
        while (entry != null) {
            int n3 = comparable.compareTo(entry.key);
            if (n3 == 0) {
                return entry;
            }
            entry = n3 < 0 ? entry.left : entry.right;
        }
        return null;
    }

    private Entry getHigherEntry(Object object) {
        Entry entry = this.root;
        if (entry == null) {
            return null;
        }
        while (true) {
            int n2;
            if ((n2 = TreeMap.compare(object, entry.key, this.comparator)) < 0) {
                if (entry.left != null) {
                    entry = entry.left;
                    continue;
                }
                return entry;
            }
            if (entry.right == null) break;
            entry = entry.right;
        }
        Entry entry2 = entry.parent;
        while (entry2 != null && entry == entry2.right) {
            entry = entry2;
            entry2 = entry2.parent;
        }
        return entry2;
    }

    private Entry getFirstEntry() {
        Entry entry = this.root;
        if (entry == null) {
            return null;
        }
        while (entry.left != null) {
            entry = entry.left;
        }
        return entry;
    }

    private Entry getLastEntry() {
        Entry entry = this.root;
        if (entry == null) {
            return null;
        }
        while (entry.right != null) {
            entry = entry.right;
        }
        return entry;
    }

    private Entry getCeilingEntry(Object object) {
        Entry entry;
        block5: {
            entry = this.root;
            if (entry == null) {
                return null;
            }
            while (true) {
                int n2;
                if ((n2 = TreeMap.compare(object, entry.key, this.comparator)) < 0) {
                    if (entry.left != null) {
                        entry = entry.left;
                        continue;
                    }
                    return entry;
                }
                if (n2 <= 0) break block5;
                if (entry.right == null) break;
                entry = entry.right;
            }
            Entry entry2 = entry.parent;
            while (entry2 != null && entry == entry2.right) {
                entry = entry2;
                entry2 = entry2.parent;
            }
            return entry2;
        }
        return entry;
    }

    private Entry getLowerEntry(Object object) {
        Entry entry = this.root;
        if (entry == null) {
            return null;
        }
        while (true) {
            int n2;
            if ((n2 = TreeMap.compare(object, entry.key, this.comparator)) > 0) {
                if (entry.right != null) {
                    entry = entry.right;
                    continue;
                }
                return entry;
            }
            if (entry.left == null) break;
            entry = entry.left;
        }
        Entry entry2 = entry.parent;
        while (entry2 != null && entry == entry2.left) {
            entry = entry2;
            entry2 = entry2.parent;
        }
        return entry2;
    }

    private Entry getFloorEntry(Object object) {
        Entry entry;
        block5: {
            entry = this.root;
            if (entry == null) {
                return null;
            }
            while (true) {
                int n2;
                if ((n2 = TreeMap.compare(object, entry.key, this.comparator)) > 0) {
                    if (entry.right != null) {
                        entry = entry.right;
                        continue;
                    }
                    return entry;
                }
                if (n2 >= 0) break block5;
                if (entry.left == null) break;
                entry = entry.left;
            }
            Entry entry2 = entry.parent;
            while (entry2 != null && entry == entry2.left) {
                entry = entry2;
                entry2 = entry2.parent;
            }
            return entry2;
        }
        return entry;
    }

    void buildFromSorted(Iterator iterator, int n2) {
        ++this.modCount;
        this.size = n2;
        int n3 = 0;
        int n4 = 1;
        while (n4 - 1 < n2) {
            ++n3;
            n4 <<= 1;
        }
        this.root = TreeMap.createFromSorted(iterator, n2, 0, n3);
    }

    private static Entry createFromSorted(Iterator iterator, int n2, int n3, int n4) {
        ++n3;
        if (n2 == 0) {
            return null;
        }
        int n5 = n2 - 1 >> 1;
        int n6 = n2 - 1 - n5;
        Entry entry = TreeMap.createFromSorted(iterator, n5, n3, n4);
        Map.Entry entry2 = (Map.Entry)iterator.next();
        Entry entry3 = TreeMap.createFromSorted(iterator, n6, n3, n4);
        Entry entry4 = new Entry(entry2.getKey(), entry2.getValue());
        if (entry != null) {
            entry4.left = entry;
            entry.parent = entry4;
        }
        if (entry3 != null) {
            entry4.right = entry3;
            entry3.parent = entry4;
        }
        if (n3 == n4) {
            entry4.color = false;
        }
        return entry4;
    }

    private void delete(Entry entry) {
        Entry entry2;
        if (entry.left == null && entry.right == null && entry.parent == null) {
            this.root = null;
            this.size = 0;
            ++this.modCount;
            return;
        }
        if (entry.left != null && entry.right != null) {
            entry2 = TreeMap.successor(entry);
            entry.key = entry2.key;
            entry.element = entry2.element;
            entry = entry2;
        }
        if (entry.left == null && entry.right == null) {
            if (entry.color) {
                this.fixAfterDeletion(entry);
            }
            if (entry.parent != null) {
                if (entry == entry.parent.left) {
                    entry.parent.left = null;
                } else if (entry == entry.parent.right) {
                    entry.parent.right = null;
                }
                entry.parent = null;
            }
        } else {
            entry2 = entry.left;
            if (entry2 == null) {
                entry2 = entry.right;
            }
            entry2.parent = entry.parent;
            if (entry.parent == null) {
                this.root = entry2;
            } else if (entry == entry.parent.left) {
                entry.parent.left = entry2;
            } else {
                entry.parent.right = entry2;
            }
            entry.left = null;
            entry.right = null;
            entry.parent = null;
            if (entry.color) {
                this.fixAfterDeletion(entry2);
            }
        }
        --this.size;
        ++this.modCount;
    }

    static boolean colorOf(Entry entry) {
        return entry == null ? true : entry.color;
    }

    static Entry parentOf(Entry entry) {
        return entry == null ? null : entry.parent;
    }

    private static void setColor(Entry entry, boolean bl2) {
        if (entry != null) {
            entry.color = bl2;
        }
    }

    private static Entry leftOf(Entry entry) {
        return entry == null ? null : entry.left;
    }

    private static Entry rightOf(Entry entry) {
        return entry == null ? null : entry.right;
    }

    private final void rotateLeft(Entry entry) {
        Entry entry2 = entry.right;
        entry.right = entry2.left;
        if (entry2.left != null) {
            entry2.left.parent = entry;
        }
        entry2.parent = entry.parent;
        if (entry.parent == null) {
            this.root = entry2;
        } else if (entry.parent.left == entry) {
            entry.parent.left = entry2;
        } else {
            entry.parent.right = entry2;
        }
        entry2.left = entry;
        entry.parent = entry2;
    }

    private final void rotateRight(Entry entry) {
        Entry entry2 = entry.left;
        entry.left = entry2.right;
        if (entry2.right != null) {
            entry2.right.parent = entry;
        }
        entry2.parent = entry.parent;
        if (entry.parent == null) {
            this.root = entry2;
        } else if (entry.parent.right == entry) {
            entry.parent.right = entry2;
        } else {
            entry.parent.left = entry2;
        }
        entry2.right = entry;
        entry.parent = entry2;
    }

    private final void fixAfterInsertion(Entry entry) {
        entry.color = false;
        Entry entry2 = entry;
        while (entry2 != null && entry2 != this.root && !entry2.parent.color) {
            Entry entry3;
            if (TreeMap.parentOf(entry2) == TreeMap.leftOf(TreeMap.parentOf(TreeMap.parentOf(entry2)))) {
                entry3 = TreeMap.rightOf(TreeMap.parentOf(TreeMap.parentOf(entry2)));
                if (!TreeMap.colorOf(entry3)) {
                    TreeMap.setColor(TreeMap.parentOf(entry2), true);
                    TreeMap.setColor(entry3, true);
                    TreeMap.setColor(TreeMap.parentOf(TreeMap.parentOf(entry2)), false);
                    entry2 = TreeMap.parentOf(TreeMap.parentOf(entry2));
                    continue;
                }
                if (entry2 == TreeMap.rightOf(TreeMap.parentOf(entry2))) {
                    entry2 = TreeMap.parentOf(entry2);
                    this.rotateLeft(entry2);
                }
                TreeMap.setColor(TreeMap.parentOf(entry2), true);
                TreeMap.setColor(TreeMap.parentOf(TreeMap.parentOf(entry2)), false);
                if (TreeMap.parentOf(TreeMap.parentOf(entry2)) == null) continue;
                this.rotateRight(TreeMap.parentOf(TreeMap.parentOf(entry2)));
                continue;
            }
            entry3 = TreeMap.leftOf(TreeMap.parentOf(TreeMap.parentOf(entry2)));
            if (!TreeMap.colorOf(entry3)) {
                TreeMap.setColor(TreeMap.parentOf(entry2), true);
                TreeMap.setColor(entry3, true);
                TreeMap.setColor(TreeMap.parentOf(TreeMap.parentOf(entry2)), false);
                entry2 = TreeMap.parentOf(TreeMap.parentOf(entry2));
                continue;
            }
            if (entry2 == TreeMap.leftOf(TreeMap.parentOf(entry2))) {
                entry2 = TreeMap.parentOf(entry2);
                this.rotateRight(entry2);
            }
            TreeMap.setColor(TreeMap.parentOf(entry2), true);
            TreeMap.setColor(TreeMap.parentOf(TreeMap.parentOf(entry2)), false);
            if (TreeMap.parentOf(TreeMap.parentOf(entry2)) == null) continue;
            this.rotateLeft(TreeMap.parentOf(TreeMap.parentOf(entry2)));
        }
        this.root.color = true;
    }

    private final Entry fixAfterDeletion(Entry entry) {
        Entry entry2 = entry;
        while (entry2 != this.root && TreeMap.colorOf(entry2)) {
            Entry entry3;
            if (entry2 == TreeMap.leftOf(TreeMap.parentOf(entry2))) {
                entry3 = TreeMap.rightOf(TreeMap.parentOf(entry2));
                if (!TreeMap.colorOf(entry3)) {
                    TreeMap.setColor(entry3, true);
                    TreeMap.setColor(TreeMap.parentOf(entry2), false);
                    this.rotateLeft(TreeMap.parentOf(entry2));
                    entry3 = TreeMap.rightOf(TreeMap.parentOf(entry2));
                }
                if (TreeMap.colorOf(TreeMap.leftOf(entry3)) && TreeMap.colorOf(TreeMap.rightOf(entry3))) {
                    TreeMap.setColor(entry3, false);
                    entry2 = TreeMap.parentOf(entry2);
                    continue;
                }
                if (TreeMap.colorOf(TreeMap.rightOf(entry3))) {
                    TreeMap.setColor(TreeMap.leftOf(entry3), true);
                    TreeMap.setColor(entry3, false);
                    this.rotateRight(entry3);
                    entry3 = TreeMap.rightOf(TreeMap.parentOf(entry2));
                }
                TreeMap.setColor(entry3, TreeMap.colorOf(TreeMap.parentOf(entry2)));
                TreeMap.setColor(TreeMap.parentOf(entry2), true);
                TreeMap.setColor(TreeMap.rightOf(entry3), true);
                this.rotateLeft(TreeMap.parentOf(entry2));
                entry2 = this.root;
                continue;
            }
            entry3 = TreeMap.leftOf(TreeMap.parentOf(entry2));
            if (!TreeMap.colorOf(entry3)) {
                TreeMap.setColor(entry3, true);
                TreeMap.setColor(TreeMap.parentOf(entry2), false);
                this.rotateRight(TreeMap.parentOf(entry2));
                entry3 = TreeMap.leftOf(TreeMap.parentOf(entry2));
            }
            if (TreeMap.colorOf(TreeMap.rightOf(entry3)) && TreeMap.colorOf(TreeMap.leftOf(entry3))) {
                TreeMap.setColor(entry3, false);
                entry2 = TreeMap.parentOf(entry2);
                continue;
            }
            if (TreeMap.colorOf(TreeMap.leftOf(entry3))) {
                TreeMap.setColor(TreeMap.rightOf(entry3), true);
                TreeMap.setColor(entry3, false);
                this.rotateLeft(entry3);
                entry3 = TreeMap.leftOf(TreeMap.parentOf(entry2));
            }
            TreeMap.setColor(entry3, TreeMap.colorOf(TreeMap.parentOf(entry2)));
            TreeMap.setColor(TreeMap.parentOf(entry2), true);
            TreeMap.setColor(TreeMap.leftOf(entry3), true);
            this.rotateRight(TreeMap.parentOf(entry2));
            entry2 = this.root;
        }
        TreeMap.setColor(entry2, true);
        return this.root;
    }

    private Entry getMatchingEntry(Object object) {
        if (!(object instanceof Map.Entry)) {
            return null;
        }
        Map.Entry entry = (Map.Entry)object;
        Entry entry2 = this.getEntry(entry.getKey());
        return entry2 != null && TreeMap.eq(entry2.getValue(), entry.getValue()) ? entry2 : null;
    }

    private static boolean eq(Object object, Object object2) {
        return object == null ? object2 == null : object.equals(object2);
    }

    private static int compare(Object object, Object object2, Comparator comparator) {
        return comparator == null ? ((Comparable)object).compareTo(object2) : comparator.compare(object, object2);
    }

    @Override
    public Map.Entry lowerEntry(Object object) {
        Entry entry = this.getLowerEntry(object);
        return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
    }

    @Override
    public Object lowerKey(Object object) {
        Entry entry = this.getLowerEntry(object);
        return entry == null ? null : entry.getKey();
    }

    @Override
    public Map.Entry floorEntry(Object object) {
        Entry entry = this.getFloorEntry(object);
        return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
    }

    @Override
    public Object floorKey(Object object) {
        Entry entry = this.getFloorEntry(object);
        return entry == null ? null : entry.key;
    }

    @Override
    public Map.Entry ceilingEntry(Object object) {
        Entry entry = this.getCeilingEntry(object);
        return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
    }

    @Override
    public Object ceilingKey(Object object) {
        Entry entry = this.getCeilingEntry(object);
        return entry == null ? null : entry.key;
    }

    @Override
    public Map.Entry higherEntry(Object object) {
        Entry entry = this.getHigherEntry(object);
        return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
    }

    @Override
    public Object higherKey(Object object) {
        Entry entry = this.getHigherEntry(object);
        return entry == null ? null : entry.key;
    }

    @Override
    public Map.Entry firstEntry() {
        Entry entry = this.getFirstEntry();
        return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
    }

    @Override
    public Map.Entry lastEntry() {
        Entry entry = this.getLastEntry();
        return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
    }

    @Override
    public Map.Entry pollFirstEntry() {
        Entry entry = this.getFirstEntry();
        if (entry == null) {
            return null;
        }
        AbstractMap.SimpleImmutableEntry simpleImmutableEntry = new AbstractMap.SimpleImmutableEntry(entry);
        this.delete(entry);
        return simpleImmutableEntry;
    }

    @Override
    public Map.Entry pollLastEntry() {
        Entry entry = this.getLastEntry();
        if (entry == null) {
            return null;
        }
        AbstractMap.SimpleImmutableEntry simpleImmutableEntry = new AbstractMap.SimpleImmutableEntry(entry);
        this.delete(entry);
        return simpleImmutableEntry;
    }

    @Override
    public NavigableMap descendingMap() {
        NavigableMap navigableMap = this.descendingMap;
        if (navigableMap == null) {
            this.descendingMap = navigableMap = new DescendingSubMap(true, null, true, true, null, true);
        }
        return navigableMap;
    }

    @Override
    public NavigableSet descendingKeySet() {
        return this.descendingMap().navigableKeySet();
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
    public NavigableMap subMap(Object object, boolean bl2, Object object2, boolean bl3) {
        return new AscendingSubMap(false, object, bl2, false, object2, bl3);
    }

    @Override
    public NavigableMap headMap(Object object, boolean bl2) {
        return new AscendingSubMap(true, null, true, false, object, bl2);
    }

    @Override
    public NavigableMap tailMap(Object object, boolean bl2) {
        return new AscendingSubMap(false, object, bl2, true, null, true);
    }

    public Comparator comparator() {
        return this.comparator;
    }

    final Comparator reverseComparator() {
        if (this.reverseComparator == null) {
            this.reverseComparator = Collections.reverseOrder(this.comparator);
        }
        return this.reverseComparator;
    }

    public Object firstKey() {
        Entry entry = this.getFirstEntry();
        if (entry == null) {
            throw new NoSuchElementException();
        }
        return entry.key;
    }

    public Object lastKey() {
        Entry entry = this.getLastEntry();
        if (entry == null) {
            throw new NoSuchElementException();
        }
        return entry.key;
    }

    @Override
    public boolean isEmpty() {
        return this.size == 0;
    }

    @Override
    public boolean containsValue(Object object) {
        if (this.root == null) {
            return false;
        }
        return object == null ? TreeMap.containsNull(this.root) : TreeMap.containsValue(this.root, object);
    }

    private static boolean containsNull(Entry entry) {
        if (entry.element == null) {
            return true;
        }
        if (entry.left != null && TreeMap.containsNull(entry.left)) {
            return true;
        }
        return entry.right != null && TreeMap.containsNull(entry.right);
    }

    private static boolean containsValue(Entry entry, Object object) {
        if (object.equals(entry.element)) {
            return true;
        }
        if (entry.left != null && TreeMap.containsValue(entry.left, object)) {
            return true;
        }
        return entry.right != null && TreeMap.containsValue(entry.right, object);
    }

    @Override
    public Object remove(Object object) {
        Entry entry = this.getEntry(object);
        if (entry == null) {
            return null;
        }
        Object object2 = entry.getValue();
        this.delete(entry);
        return object2;
    }

    @Override
    public void putAll(Map map) {
        SortedMap sortedMap;
        if (map instanceof SortedMap && TreeMap.eq(this.comparator, (sortedMap = (SortedMap)map).comparator())) {
            this.buildFromSorted(sortedMap.entrySet().iterator(), map.size());
            return;
        }
        super.putAll(map);
    }

    @Override
    public Set keySet() {
        return this.navigableKeySet();
    }

    @Override
    public NavigableSet navigableKeySet() {
        if (this.navigableKeySet == null) {
            this.navigableKeySet = new AscendingKeySet();
        }
        return this.navigableKeySet;
    }

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        objectOutputStream.writeInt(this.size);
        Entry entry = this.getFirstEntry();
        while (entry != null) {
            objectOutputStream.writeObject(entry.key);
            objectOutputStream.writeObject(entry.element);
            entry = TreeMap.successor(entry);
        }
    }

    private void readObject(ObjectInputStream objectInputStream) throws IOException, ClassNotFoundException {
        objectInputStream.defaultReadObject();
        int n2 = objectInputStream.readInt();
        try {
            this.buildFromSorted(new IOIterator(objectInputStream, n2), n2);
        }
        catch (IteratorIOException iteratorIOException) {
            throw iteratorIOException.getException();
        }
        catch (IteratorNoClassException iteratorNoClassException) {
            throw iteratorNoClassException.getException();
        }
    }

    private class SubMap
    extends AbstractMap
    implements Serializable,
    NavigableMap {
        private static final long serialVersionUID = -6520786458950516097L;
        final Object fromKey = null;
        final Object toKey = null;

        SubMap() {
        }

        private Object readResolve() {
            return new AscendingSubMap(this.fromKey == null, this.fromKey, true, this.toKey == null, this.toKey, false);
        }

        @Override
        public Map.Entry lowerEntry(Object object) {
            throw new Error();
        }

        @Override
        public Object lowerKey(Object object) {
            throw new Error();
        }

        @Override
        public Map.Entry floorEntry(Object object) {
            throw new Error();
        }

        @Override
        public Object floorKey(Object object) {
            throw new Error();
        }

        @Override
        public Map.Entry ceilingEntry(Object object) {
            throw new Error();
        }

        @Override
        public Object ceilingKey(Object object) {
            throw new Error();
        }

        @Override
        public Map.Entry higherEntry(Object object) {
            throw new Error();
        }

        @Override
        public Object higherKey(Object object) {
            throw new Error();
        }

        @Override
        public Map.Entry firstEntry() {
            throw new Error();
        }

        @Override
        public Map.Entry lastEntry() {
            throw new Error();
        }

        @Override
        public Map.Entry pollFirstEntry() {
            throw new Error();
        }

        @Override
        public Map.Entry pollLastEntry() {
            throw new Error();
        }

        @Override
        public NavigableMap descendingMap() {
            throw new Error();
        }

        @Override
        public NavigableSet navigableKeySet() {
            throw new Error();
        }

        @Override
        public NavigableSet descendingKeySet() {
            throw new Error();
        }

        @Override
        public Set entrySet() {
            throw new Error();
        }

        @Override
        public NavigableMap subMap(Object object, boolean bl2, Object object2, boolean bl3) {
            throw new Error();
        }

        @Override
        public NavigableMap headMap(Object object, boolean bl2) {
            throw new Error();
        }

        @Override
        public NavigableMap tailMap(Object object, boolean bl2) {
            throw new Error();
        }

        @Override
        public SortedMap subMap(Object object, Object object2) {
            throw new Error();
        }

        @Override
        public SortedMap headMap(Object object) {
            throw new Error();
        }

        @Override
        public SortedMap tailMap(Object object) {
            throw new Error();
        }

        public Comparator comparator() {
            throw new Error();
        }

        public Object firstKey() {
            throw new Error();
        }

        public Object lastKey() {
            throw new Error();
        }
    }

    static class IOIterator
    implements Iterator {
        final ObjectInputStream ois;
        int remaining;

        IOIterator(ObjectInputStream objectInputStream, int n2) {
            this.ois = objectInputStream;
            this.remaining = n2;
        }

        @Override
        public boolean hasNext() {
            return this.remaining > 0;
        }

        public Object next() {
            if (this.remaining <= 0) {
                throw new NoSuchElementException();
            }
            --this.remaining;
            try {
                return new AbstractMap.SimpleImmutableEntry(this.ois.readObject(), this.ois.readObject());
            }
            catch (IOException iOException) {
                throw new IteratorIOException(iOException);
            }
            catch (ClassNotFoundException classNotFoundException) {
                throw new IteratorNoClassException(classNotFoundException);
            }
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }

    static class IteratorNoClassException
    extends RuntimeException {
        IteratorNoClassException(ClassNotFoundException classNotFoundException) {
            super(classNotFoundException);
        }

        ClassNotFoundException getException() {
            return (ClassNotFoundException)this.getCause();
        }
    }

    static class IteratorIOException
    extends RuntimeException {
        IteratorIOException(IOException iOException) {
            super(iOException);
        }

        IOException getException() {
            return (IOException)this.getCause();
        }
    }

    class DescendingSubMap
    extends NavigableSubMap {
        DescendingSubMap(boolean bl2, Object object, boolean bl3, boolean bl4, Object object2, boolean bl5) {
            super(bl2, object, bl3, bl4, object2, bl5);
        }

        public Comparator comparator() {
            return TreeMap.this.reverseComparator();
        }

        @Override
        protected Entry first() {
            return this.absHighest();
        }

        @Override
        protected Entry last() {
            return this.absLowest();
        }

        @Override
        protected Entry lower(Object object) {
            return this.absHigher(object);
        }

        @Override
        protected Entry floor(Object object) {
            return this.absCeiling(object);
        }

        @Override
        protected Entry ceiling(Object object) {
            return this.absFloor(object);
        }

        @Override
        protected Entry higher(Object object) {
            return this.absLower(object);
        }

        @Override
        protected Entry uncheckedHigher(Entry entry) {
            return TreeMap.predecessor(entry);
        }

        @Override
        public NavigableMap subMap(Object object, boolean bl2, Object object2, boolean bl3) {
            if (!this.inRange(object, bl2)) {
                throw new IllegalArgumentException("fromKey out of range");
            }
            if (!this.inRange(object2, bl3)) {
                throw new IllegalArgumentException("toKey out of range");
            }
            return new DescendingSubMap(false, object2, bl3, false, object, bl2);
        }

        @Override
        public NavigableMap headMap(Object object, boolean bl2) {
            if (!this.inRange(object, bl2)) {
                throw new IllegalArgumentException("toKey out of range");
            }
            return new DescendingSubMap(false, object, bl2, this.toEnd, this.toKey, this.toInclusive);
        }

        @Override
        public NavigableMap tailMap(Object object, boolean bl2) {
            if (!this.inRange(object, bl2)) {
                throw new IllegalArgumentException("fromKey out of range");
            }
            return new DescendingSubMap(this.fromStart, this.fromKey, this.fromInclusive, false, object, bl2);
        }

        @Override
        public NavigableMap descendingMap() {
            if (this.descendingMap == null) {
                this.descendingMap = new AscendingSubMap(this.fromStart, this.fromKey, this.fromInclusive, this.toEnd, this.toKey, this.toInclusive);
            }
            return this.descendingMap;
        }
    }

    class AscendingSubMap
    extends NavigableSubMap {
        AscendingSubMap(boolean bl2, Object object, boolean bl3, boolean bl4, Object object2, boolean bl5) {
            super(bl2, object, bl3, bl4, object2, bl5);
        }

        public Comparator comparator() {
            return TreeMap.this.comparator;
        }

        @Override
        protected Entry first() {
            return this.absLowest();
        }

        @Override
        protected Entry last() {
            return this.absHighest();
        }

        @Override
        protected Entry lower(Object object) {
            return this.absLower(object);
        }

        @Override
        protected Entry floor(Object object) {
            return this.absFloor(object);
        }

        @Override
        protected Entry ceiling(Object object) {
            return this.absCeiling(object);
        }

        @Override
        protected Entry higher(Object object) {
            return this.absHigher(object);
        }

        @Override
        protected Entry uncheckedHigher(Entry entry) {
            return TreeMap.successor(entry);
        }

        @Override
        public NavigableMap subMap(Object object, boolean bl2, Object object2, boolean bl3) {
            if (!this.inRange(object, bl2)) {
                throw new IllegalArgumentException("fromKey out of range");
            }
            if (!this.inRange(object2, bl3)) {
                throw new IllegalArgumentException("toKey out of range");
            }
            return new AscendingSubMap(false, object, bl2, false, object2, bl3);
        }

        @Override
        public NavigableMap headMap(Object object, boolean bl2) {
            if (!this.inRange(object, bl2)) {
                throw new IllegalArgumentException("toKey out of range");
            }
            return new AscendingSubMap(this.fromStart, this.fromKey, this.fromInclusive, false, object, bl2);
        }

        @Override
        public NavigableMap tailMap(Object object, boolean bl2) {
            if (!this.inRange(object, bl2)) {
                throw new IllegalArgumentException("fromKey out of range");
            }
            return new AscendingSubMap(false, object, bl2, this.toEnd, this.toKey, this.toInclusive);
        }

        @Override
        public NavigableMap descendingMap() {
            if (this.descendingMap == null) {
                this.descendingMap = new DescendingSubMap(this.fromStart, this.fromKey, this.fromInclusive, this.toEnd, this.toKey, this.toInclusive);
            }
            return this.descendingMap;
        }
    }

    private abstract class NavigableSubMap
    extends AbstractMap
    implements NavigableMap,
    Serializable {
        private static final long serialVersionUID = -6520786458950516097L;
        final Object fromKey;
        final Object toKey;
        final boolean fromStart;
        final boolean toEnd;
        final boolean fromInclusive;
        final boolean toInclusive;
        transient int cachedSize = -1;
        transient int cacheVersion;
        transient SubEntrySet entrySet;
        transient NavigableMap descendingMap;
        transient NavigableSet navigableKeySet;

        NavigableSubMap(boolean bl2, Object object, boolean bl3, boolean bl4, Object object2, boolean bl5) {
            if (!bl2 && !bl4) {
                if (TreeMap.compare(object, object2, TreeMap.this.comparator) > 0) {
                    throw new IllegalArgumentException("fromKey > toKey");
                }
            } else {
                if (!bl2) {
                    TreeMap.compare(object, object, TreeMap.this.comparator);
                }
                if (!bl4) {
                    TreeMap.compare(object2, object2, TreeMap.this.comparator);
                }
            }
            this.fromStart = bl2;
            this.toEnd = bl4;
            this.fromKey = object;
            this.toKey = object2;
            this.fromInclusive = bl3;
            this.toInclusive = bl5;
        }

        final Entry checkLoRange(Entry entry) {
            return entry == null || this.absTooLow(entry.key) ? null : entry;
        }

        final Entry checkHiRange(Entry entry) {
            return entry == null || this.absTooHigh(entry.key) ? null : entry;
        }

        final boolean inRange(Object object) {
            return !this.absTooLow(object) && !this.absTooHigh(object);
        }

        final boolean inRangeExclusive(Object object) {
            return !(!this.fromStart && TreeMap.compare(object, this.fromKey, TreeMap.this.comparator) < 0 || !this.toEnd && TreeMap.compare(this.toKey, object, TreeMap.this.comparator) < 0);
        }

        final boolean inRange(Object object, boolean bl2) {
            return bl2 ? this.inRange(object) : this.inRangeExclusive(object);
        }

        private boolean absTooHigh(Object object) {
            if (this.toEnd) {
                return false;
            }
            int n2 = TreeMap.compare(object, this.toKey, TreeMap.this.comparator);
            return n2 > 0 || n2 == 0 && !this.toInclusive;
        }

        private boolean absTooLow(Object object) {
            if (this.fromStart) {
                return false;
            }
            int n2 = TreeMap.compare(object, this.fromKey, TreeMap.this.comparator);
            return n2 < 0 || n2 == 0 && !this.fromInclusive;
        }

        protected abstract Entry first();

        protected abstract Entry last();

        protected abstract Entry lower(Object var1);

        protected abstract Entry floor(Object var1);

        protected abstract Entry ceiling(Object var1);

        protected abstract Entry higher(Object var1);

        protected abstract Entry uncheckedHigher(Entry var1);

        final Entry absLowest() {
            return this.checkHiRange(this.fromStart ? TreeMap.this.getFirstEntry() : (this.fromInclusive ? TreeMap.this.getCeilingEntry(this.fromKey) : TreeMap.this.getHigherEntry(this.fromKey)));
        }

        final Entry absHighest() {
            return this.checkLoRange(this.toEnd ? TreeMap.this.getLastEntry() : (this.toInclusive ? TreeMap.this.getFloorEntry(this.toKey) : TreeMap.this.getLowerEntry(this.toKey)));
        }

        final Entry absLower(Object object) {
            return this.absTooHigh(object) ? this.absHighest() : this.checkLoRange(TreeMap.this.getLowerEntry(object));
        }

        final Entry absFloor(Object object) {
            return this.absTooHigh(object) ? this.absHighest() : this.checkLoRange(TreeMap.this.getFloorEntry(object));
        }

        final Entry absCeiling(Object object) {
            return this.absTooLow(object) ? this.absLowest() : this.checkHiRange(TreeMap.this.getCeilingEntry(object));
        }

        final Entry absHigher(Object object) {
            return this.absTooLow(object) ? this.absLowest() : this.checkHiRange(TreeMap.this.getHigherEntry(object));
        }

        @Override
        public Map.Entry firstEntry() {
            Entry entry = this.first();
            return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
        }

        public Object firstKey() {
            Entry entry = this.first();
            if (entry == null) {
                throw new NoSuchElementException();
            }
            return entry.key;
        }

        @Override
        public Map.Entry lastEntry() {
            Entry entry = this.last();
            return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
        }

        public Object lastKey() {
            Entry entry = this.last();
            if (entry == null) {
                throw new NoSuchElementException();
            }
            return entry.key;
        }

        @Override
        public Map.Entry pollFirstEntry() {
            Entry entry = this.first();
            if (entry == null) {
                return null;
            }
            AbstractMap.SimpleImmutableEntry simpleImmutableEntry = new AbstractMap.SimpleImmutableEntry(entry);
            TreeMap.this.delete(entry);
            return simpleImmutableEntry;
        }

        @Override
        public Map.Entry pollLastEntry() {
            Entry entry = this.last();
            if (entry == null) {
                return null;
            }
            AbstractMap.SimpleImmutableEntry simpleImmutableEntry = new AbstractMap.SimpleImmutableEntry(entry);
            TreeMap.this.delete(entry);
            return simpleImmutableEntry;
        }

        @Override
        public Map.Entry lowerEntry(Object object) {
            Entry entry = this.lower(object);
            return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
        }

        @Override
        public Object lowerKey(Object object) {
            Entry entry = this.lower(object);
            return entry == null ? null : entry.key;
        }

        @Override
        public Map.Entry floorEntry(Object object) {
            Entry entry = this.floor(object);
            return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
        }

        @Override
        public Object floorKey(Object object) {
            Entry entry = this.floor(object);
            return entry == null ? null : entry.key;
        }

        @Override
        public Map.Entry ceilingEntry(Object object) {
            Entry entry = this.ceiling(object);
            return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
        }

        @Override
        public Object ceilingKey(Object object) {
            Entry entry = this.ceiling(object);
            return entry == null ? null : entry.key;
        }

        @Override
        public Map.Entry higherEntry(Object object) {
            Entry entry = this.higher(object);
            return entry == null ? null : new AbstractMap.SimpleImmutableEntry(entry);
        }

        @Override
        public Object higherKey(Object object) {
            Entry entry = this.higher(object);
            return entry == null ? null : entry.key;
        }

        @Override
        public NavigableSet descendingKeySet() {
            return this.descendingMap().navigableKeySet();
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
        public int size() {
            if (this.cachedSize < 0 || this.cacheVersion != TreeMap.this.modCount) {
                this.cachedSize = this.recalculateSize();
                this.cacheVersion = TreeMap.this.modCount;
            }
            return this.cachedSize;
        }

        private int recalculateSize() {
            Entry entry = this.absHighest();
            Object object = entry != null ? entry.key : null;
            int n2 = 0;
            Entry entry2 = this.absLowest();
            while (entry2 != null) {
                ++n2;
                entry2 = entry2.key == object ? null : TreeMap.successor(entry2);
            }
            return n2;
        }

        @Override
        public boolean isEmpty() {
            return this.absLowest() == null;
        }

        @Override
        public boolean containsKey(Object object) {
            return this.inRange(object) && TreeMap.this.containsKey(object);
        }

        @Override
        public Object get(Object object) {
            if (!this.inRange(object)) {
                return null;
            }
            return TreeMap.this.get(object);
        }

        @Override
        public Object put(Object object, Object object2) {
            if (!this.inRange(object)) {
                throw new IllegalArgumentException("Key out of range");
            }
            return TreeMap.this.put(object, object2);
        }

        @Override
        public Object remove(Object object) {
            if (!this.inRange(object)) {
                return null;
            }
            return TreeMap.this.remove(object);
        }

        @Override
        public Set entrySet() {
            if (this.entrySet == null) {
                this.entrySet = new SubEntrySet();
            }
            return this.entrySet;
        }

        @Override
        public Set keySet() {
            return this.navigableKeySet();
        }

        @Override
        public NavigableSet navigableKeySet() {
            if (this.navigableKeySet == null) {
                this.navigableKeySet = new SubKeySet();
            }
            return this.navigableKeySet;
        }

        private Entry getMatchingSubEntry(Object object) {
            if (!(object instanceof Map.Entry)) {
                return null;
            }
            Map.Entry entry = (Map.Entry)object;
            Object k2 = entry.getKey();
            if (!this.inRange(k2)) {
                return null;
            }
            Entry entry2 = TreeMap.this.getEntry(k2);
            return entry2 != null && TreeMap.eq(entry2.getValue(), entry.getValue()) ? entry2 : null;
        }

        class SubKeyIterator
        implements Iterator {
            final Iterator itr;

            SubKeyIterator(Iterator iterator) {
                this.itr = iterator;
            }

            @Override
            public boolean hasNext() {
                return this.itr.hasNext();
            }

            public Object next() {
                return ((Map.Entry)this.itr.next()).getKey();
            }

            @Override
            public void remove() {
                this.itr.remove();
            }
        }

        class SubEntryIterator
        extends BaseEntryIterator
        implements Iterator {
            final Object terminalKey;

            SubEntryIterator() {
                super(NavigableSubMap.this.first());
                Entry entry = NavigableSubMap.this.last();
                this.terminalKey = entry == null ? null : entry.key;
            }

            @Override
            public boolean hasNext() {
                return this.cursor != null;
            }

            public Object next() {
                Entry entry = this.cursor;
                if (entry == null) {
                    throw new NoSuchElementException();
                }
                if (this.expectedModCount != TreeMap.this.modCount) {
                    throw new ConcurrentModificationException();
                }
                this.cursor = entry.key == this.terminalKey ? null : NavigableSubMap.this.uncheckedHigher(entry);
                this.lastRet = entry;
                return entry;
            }
        }

        class SubKeySet
        extends AbstractSet
        implements NavigableSet {
            SubKeySet() {
            }

            @Override
            public int size() {
                return NavigableSubMap.this.size();
            }

            @Override
            public boolean isEmpty() {
                return NavigableSubMap.this.isEmpty();
            }

            @Override
            public void clear() {
                NavigableSubMap.this.clear();
            }

            @Override
            public boolean contains(Object object) {
                return TreeMap.this.getEntry(object) != null;
            }

            @Override
            public boolean remove(Object object) {
                if (!NavigableSubMap.this.inRange(object)) {
                    return false;
                }
                Entry entry = TreeMap.this.getEntry(object);
                if (entry == null) {
                    return false;
                }
                TreeMap.this.delete(entry);
                return true;
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
            public Iterator iterator() {
                return new SubKeyIterator(NavigableSubMap.this.entrySet().iterator());
            }

            @Override
            public Iterator descendingIterator() {
                return new SubKeyIterator(NavigableSubMap.this.descendingMap().entrySet().iterator());
            }

            @Override
            public Object lower(Object object) {
                return NavigableSubMap.this.lowerKey(object);
            }

            @Override
            public Object floor(Object object) {
                return NavigableSubMap.this.floorKey(object);
            }

            @Override
            public Object ceiling(Object object) {
                return NavigableSubMap.this.ceilingKey(object);
            }

            @Override
            public Object higher(Object object) {
                return NavigableSubMap.this.higherKey(object);
            }

            public Object first() {
                return NavigableSubMap.this.firstKey();
            }

            public Object last() {
                return NavigableSubMap.this.lastKey();
            }

            public Comparator comparator() {
                return NavigableSubMap.this.comparator();
            }

            @Override
            public Object pollFirst() {
                Map.Entry entry = NavigableSubMap.this.pollFirstEntry();
                return entry == null ? null : entry.getKey();
            }

            @Override
            public Object pollLast() {
                Map.Entry entry = NavigableSubMap.this.pollLastEntry();
                return entry == null ? null : entry.getKey();
            }

            @Override
            public NavigableSet subSet(Object object, boolean bl2, Object object2, boolean bl3) {
                return (NavigableSet)NavigableSubMap.this.subMap(object, bl2, object2, bl3).keySet();
            }

            @Override
            public NavigableSet headSet(Object object, boolean bl2) {
                return (NavigableSet)NavigableSubMap.this.headMap(object, bl2).keySet();
            }

            @Override
            public NavigableSet tailSet(Object object, boolean bl2) {
                return (NavigableSet)NavigableSubMap.this.tailMap(object, bl2).keySet();
            }

            @Override
            public NavigableSet descendingSet() {
                return (NavigableSet)NavigableSubMap.this.descendingMap().keySet();
            }
        }

        class SubEntrySet
        extends AbstractSet {
            SubEntrySet() {
            }

            @Override
            public int size() {
                return NavigableSubMap.this.size();
            }

            @Override
            public boolean isEmpty() {
                return NavigableSubMap.this.isEmpty();
            }

            @Override
            public boolean contains(Object object) {
                return NavigableSubMap.this.getMatchingSubEntry(object) != null;
            }

            @Override
            public boolean remove(Object object) {
                Entry entry = NavigableSubMap.this.getMatchingSubEntry(object);
                if (entry == null) {
                    return false;
                }
                TreeMap.this.delete(entry);
                return true;
            }

            @Override
            public Iterator iterator() {
                return new SubEntryIterator();
            }
        }
    }

    class DescendingKeySet
    extends KeySet {
        DescendingKeySet() {
        }

        @Override
        public Iterator iterator() {
            return new DescendingKeyIterator(TreeMap.this.getLastEntry());
        }

        @Override
        public Iterator descendingIterator() {
            return new KeyIterator(TreeMap.this.getFirstEntry());
        }

        @Override
        public Object lower(Object object) {
            return TreeMap.this.higherKey(object);
        }

        @Override
        public Object floor(Object object) {
            return TreeMap.this.ceilingKey(object);
        }

        @Override
        public Object ceiling(Object object) {
            return TreeMap.this.floorKey(object);
        }

        @Override
        public Object higher(Object object) {
            return TreeMap.this.lowerKey(object);
        }

        public Object first() {
            return TreeMap.this.lastKey();
        }

        public Object last() {
            return TreeMap.this.firstKey();
        }

        public Comparator comparator() {
            return TreeMap.this.descendingMap().comparator();
        }

        @Override
        public Object pollFirst() {
            Map.Entry entry = TreeMap.this.pollLastEntry();
            return entry == null ? null : entry.getKey();
        }

        @Override
        public Object pollLast() {
            Map.Entry entry = TreeMap.this.pollFirstEntry();
            return entry == null ? null : entry.getKey();
        }

        @Override
        public NavigableSet subSet(Object object, boolean bl2, Object object2, boolean bl3) {
            return (NavigableSet)TreeMap.this.descendingMap().subMap(object, bl2, object2, bl3).keySet();
        }

        @Override
        public NavigableSet headSet(Object object, boolean bl2) {
            return (NavigableSet)TreeMap.this.descendingMap().headMap(object, bl2).keySet();
        }

        @Override
        public NavigableSet tailSet(Object object, boolean bl2) {
            return (NavigableSet)TreeMap.this.descendingMap().tailMap(object, bl2).keySet();
        }

        @Override
        public NavigableSet descendingSet() {
            return (NavigableSet)TreeMap.this.keySet();
        }
    }

    class AscendingKeySet
    extends KeySet {
        AscendingKeySet() {
        }

        @Override
        public Iterator iterator() {
            return new KeyIterator(TreeMap.this.getFirstEntry());
        }

        @Override
        public Iterator descendingIterator() {
            return new DescendingKeyIterator(TreeMap.this.getFirstEntry());
        }

        @Override
        public Object lower(Object object) {
            return TreeMap.this.lowerKey(object);
        }

        @Override
        public Object floor(Object object) {
            return TreeMap.this.floorKey(object);
        }

        @Override
        public Object ceiling(Object object) {
            return TreeMap.this.ceilingKey(object);
        }

        @Override
        public Object higher(Object object) {
            return TreeMap.this.higherKey(object);
        }

        public Object first() {
            return TreeMap.this.firstKey();
        }

        public Object last() {
            return TreeMap.this.lastKey();
        }

        public Comparator comparator() {
            return TreeMap.this.comparator();
        }

        @Override
        public Object pollFirst() {
            Map.Entry entry = TreeMap.this.pollFirstEntry();
            return entry == null ? null : entry.getKey();
        }

        @Override
        public Object pollLast() {
            Map.Entry entry = TreeMap.this.pollLastEntry();
            return entry == null ? null : entry.getKey();
        }

        @Override
        public NavigableSet subSet(Object object, boolean bl2, Object object2, boolean bl3) {
            return (NavigableSet)TreeMap.this.subMap(object, bl2, object2, bl3).keySet();
        }

        @Override
        public NavigableSet headSet(Object object, boolean bl2) {
            return (NavigableSet)TreeMap.this.headMap(object, bl2).keySet();
        }

        @Override
        public NavigableSet tailSet(Object object, boolean bl2) {
            return (NavigableSet)TreeMap.this.tailMap(object, bl2).keySet();
        }

        @Override
        public NavigableSet descendingSet() {
            return (NavigableSet)TreeMap.this.descendingMap().keySet();
        }
    }

    abstract class KeySet
    extends AbstractSet
    implements NavigableSet {
        KeySet() {
        }

        @Override
        public int size() {
            return TreeMap.this.size();
        }

        @Override
        public boolean isEmpty() {
            return TreeMap.this.isEmpty();
        }

        @Override
        public void clear() {
            TreeMap.this.clear();
        }

        @Override
        public boolean contains(Object object) {
            return TreeMap.this.getEntry(object) != null;
        }

        @Override
        public boolean remove(Object object) {
            Entry entry = TreeMap.this.getEntry(object);
            if (entry == null) {
                return false;
            }
            TreeMap.this.delete(entry);
            return true;
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
    }

    class ValueSet
    extends AbstractSet {
        ValueSet() {
        }

        @Override
        public int size() {
            return TreeMap.this.size();
        }

        @Override
        public boolean isEmpty() {
            return TreeMap.this.isEmpty();
        }

        @Override
        public void clear() {
            TreeMap.this.clear();
        }

        @Override
        public boolean contains(Object object) {
            Entry entry = TreeMap.this.getFirstEntry();
            while (entry != null) {
                if (TreeMap.eq(object, entry.element)) {
                    return true;
                }
                entry = TreeMap.successor(entry);
            }
            return false;
        }

        @Override
        public Iterator iterator() {
            return new ValueIterator(TreeMap.this.getFirstEntry());
        }

        @Override
        public boolean remove(Object object) {
            Entry entry = TreeMap.this.getFirstEntry();
            while (entry != null) {
                if (TreeMap.eq(object, entry.element)) {
                    TreeMap.this.delete(entry);
                    return true;
                }
                entry = TreeMap.successor(entry);
            }
            return false;
        }
    }

    class DescendingEntrySet
    extends EntrySet {
        DescendingEntrySet() {
        }

        @Override
        public Iterator iterator() {
            return new DescendingEntryIterator(TreeMap.this.getLastEntry());
        }
    }

    class EntrySet
    extends AbstractSet {
        EntrySet() {
        }

        @Override
        public int size() {
            return TreeMap.this.size();
        }

        @Override
        public boolean isEmpty() {
            return TreeMap.this.isEmpty();
        }

        @Override
        public void clear() {
            TreeMap.this.clear();
        }

        @Override
        public Iterator iterator() {
            return new EntryIterator(TreeMap.this.getFirstEntry());
        }

        @Override
        public boolean contains(Object object) {
            return TreeMap.this.getMatchingEntry(object) != null;
        }

        @Override
        public boolean remove(Object object) {
            Entry entry = TreeMap.this.getMatchingEntry(object);
            if (entry == null) {
                return false;
            }
            TreeMap.this.delete(entry);
            return true;
        }
    }

    class DescendingValueIterator
    extends BaseEntryIterator
    implements Iterator {
        DescendingValueIterator(Entry entry) {
            super(entry);
        }

        public Object next() {
            return this.prevEntry().element;
        }
    }

    class DescendingKeyIterator
    extends BaseEntryIterator
    implements Iterator {
        DescendingKeyIterator(Entry entry) {
            super(entry);
        }

        public Object next() {
            return this.prevEntry().key;
        }
    }

    class DescendingEntryIterator
    extends BaseEntryIterator
    implements Iterator {
        DescendingEntryIterator(Entry entry) {
            super(entry);
        }

        public Object next() {
            return this.prevEntry();
        }
    }

    class ValueIterator
    extends BaseEntryIterator
    implements Iterator {
        ValueIterator(Entry entry) {
            super(entry);
        }

        public Object next() {
            return this.nextEntry().element;
        }
    }

    class KeyIterator
    extends BaseEntryIterator
    implements Iterator {
        KeyIterator(Entry entry) {
            super(entry);
        }

        public Object next() {
            return this.nextEntry().key;
        }
    }

    class EntryIterator
    extends BaseEntryIterator
    implements Iterator {
        EntryIterator(Entry entry) {
            super(entry);
        }

        public Object next() {
            return this.nextEntry();
        }
    }

    private class BaseEntryIterator {
        Entry cursor;
        Entry lastRet;
        int expectedModCount;

        BaseEntryIterator(Entry entry) {
            this.cursor = entry;
            this.expectedModCount = TreeMap.this.modCount;
        }

        public boolean hasNext() {
            return this.cursor != null;
        }

        Entry nextEntry() {
            Entry entry = this.cursor;
            if (entry == null) {
                throw new NoSuchElementException();
            }
            if (this.expectedModCount != TreeMap.this.modCount) {
                throw new ConcurrentModificationException();
            }
            this.cursor = TreeMap.successor(entry);
            this.lastRet = entry;
            return entry;
        }

        Entry prevEntry() {
            Entry entry = this.cursor;
            if (entry == null) {
                throw new NoSuchElementException();
            }
            if (this.expectedModCount != TreeMap.this.modCount) {
                throw new ConcurrentModificationException();
            }
            this.cursor = TreeMap.predecessor(entry);
            this.lastRet = entry;
            return entry;
        }

        public void remove() {
            if (this.lastRet == null) {
                throw new IllegalStateException();
            }
            if (this.expectedModCount != TreeMap.this.modCount) {
                throw new ConcurrentModificationException();
            }
            if (this.lastRet.left != null && this.lastRet.right != null && this.cursor != null) {
                this.cursor = this.lastRet;
            }
            TreeMap.this.delete(this.lastRet);
            this.lastRet = null;
            ++this.expectedModCount;
        }
    }

    public static class Entry
    implements Map.Entry,
    Cloneable,
    Serializable {
        private static final boolean RED = false;
        private static final boolean BLACK = true;
        private Object key;
        private Object element;
        private boolean color;
        private Entry left;
        private Entry right;
        private Entry parent;

        public Entry(Object object, Object object2) {
            this.key = object;
            this.element = object2;
            this.color = true;
        }

        protected Object clone() throws CloneNotSupportedException {
            Entry entry = new Entry(this.key, this.element);
            entry.color = this.color;
            return entry;
        }

        public final Object getKey() {
            return this.key;
        }

        public final Object getValue() {
            return this.element;
        }

        public final Object setValue(Object object) {
            Object object2 = this.element;
            this.element = object;
            return object2;
        }

        @Override
        public boolean equals(Object object) {
            if (!(object instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry)object;
            return TreeMap.eq(this.key, entry.getKey()) && TreeMap.eq(this.element, entry.getValue());
        }

        @Override
        public int hashCode() {
            return (this.key == null ? 0 : this.key.hashCode()) ^ (this.element == null ? 0 : this.element.hashCode());
        }

        public String toString() {
            return this.key + "=" + this.element;
        }
    }
}

