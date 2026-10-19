/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

public final class j
extends RuntimeException {
    public j(String string, Throwable throwable) {
        super(string + throwable != null ? " (" + throwable.getMessage() + " [" + throwable.getClass().getName() + "])" : "");
    }

    public j(String string) {
        this(string, null);
    }
}

