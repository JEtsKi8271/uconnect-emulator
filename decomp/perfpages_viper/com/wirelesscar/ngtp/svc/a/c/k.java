/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

public final class k
extends RuntimeException {
    public k(String string, Throwable throwable) {
        super(string + throwable != null ? " (" + throwable.getClass().getName() + ")" : "");
    }

    public k(String string) {
        this(string, null);
    }
}

