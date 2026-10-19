/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import java.util.Map;

public interface ConcurrentMap
extends Map {
    public Object putIfAbsent(Object var1, Object var2);

    @Override
    public boolean remove(Object var1, Object var2);

    public boolean replace(Object var1, Object var2, Object var3);

    public Object replace(Object var1, Object var2);
}

