/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import edu.emory.mathcs.backport.java.util.AbstractSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public abstract class AbstractMap
extends java.util.AbstractMap {
    transient Set keySet;

    protected AbstractMap() {
    }

    @Override
    public Set keySet() {
        if (this.keySet == null) {
            this.keySet = new AbstractSet(){

                @Override
                public int size() {
                    return AbstractMap.this.size();
                }

                @Override
                public boolean contains(Object object) {
                    return AbstractMap.this.containsKey(object);
                }

                @Override
                public Iterator iterator() {
                    return new Iterator(){
                        final Iterator itr;
                        {
                            this.itr = AbstractMap.this.entrySet().iterator();
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
                    };
                }
            };
        }
        return this.keySet;
    }

    private static boolean eq(Object object, Object object2) {
        return object == null ? object2 == null : object.equals(object2);
    }

    public static class SimpleImmutableEntry
    implements Map.Entry {
        private final Object key;
        private final Object value;

        public SimpleImmutableEntry(Object object, Object object2) {
            this.key = object;
            this.value = object2;
        }

        public SimpleImmutableEntry(Map.Entry entry) {
            this.key = entry.getKey();
            this.value = entry.getValue();
        }

        public Object getKey() {
            return this.key;
        }

        public Object getValue() {
            return this.value;
        }

        public Object setValue(Object object) {
            throw new UnsupportedOperationException();
        }

        @Override
        public boolean equals(Object object) {
            if (!(object instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry)object;
            return AbstractMap.eq(this.key, entry.getKey()) && AbstractMap.eq(this.value, entry.getValue());
        }

        @Override
        public int hashCode() {
            return (this.key == null ? 0 : this.key.hashCode()) ^ (this.value == null ? 0 : this.value.hashCode());
        }

        public String toString() {
            return this.key + "=" + this.value;
        }
    }

    public static class SimpleEntry
    implements Map.Entry {
        private final Object key;
        private Object value;

        public SimpleEntry(Object object, Object object2) {
            this.key = object;
            this.value = object2;
        }

        public SimpleEntry(Map.Entry entry) {
            this.key = entry.getKey();
            this.value = entry.getValue();
        }

        public Object getKey() {
            return this.key;
        }

        public Object getValue() {
            return this.value;
        }

        public Object setValue(Object object) {
            Object object2 = this.value;
            this.value = object;
            return object2;
        }

        @Override
        public boolean equals(Object object) {
            if (!(object instanceof Map.Entry)) {
                return false;
            }
            Map.Entry entry = (Map.Entry)object;
            return AbstractMap.eq(this.key, entry.getKey()) && AbstractMap.eq(this.value, entry.getValue());
        }

        @Override
        public int hashCode() {
            return (this.key == null ? 0 : this.key.hashCode()) ^ (this.value == null ? 0 : this.value.hashCode());
        }

        public String toString() {
            return this.key + "=" + this.value;
        }
    }
}

