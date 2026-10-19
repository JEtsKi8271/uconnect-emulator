/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

public final class ar
extends RuntimeException {
    public ar(String string, Throwable throwable) {
        super(string + throwable != null ? " (" + throwable.getMessage() + " [" + throwable.getClass().getName() + "])" : "");
    }

    public ar(String string) {
        this(string, null);
    }
}

