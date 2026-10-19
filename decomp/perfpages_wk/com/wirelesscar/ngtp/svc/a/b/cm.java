/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.bp;

public abstract class cm
extends bp {
    protected String a = null;

    protected cm() {
        this.c = 4;
    }

    public final void a(String string) {
        this.a = string;
    }

    public final String e() {
        return this.a;
    }
}

