/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util;

import java.util.Collection;

public interface Queue
extends Collection {
    public boolean add(Object var1);

    public boolean offer(Object var1);

    public Object remove();

    public Object poll();

    public Object element();

    public Object peek();
}

