/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.c;

public abstract class ae
extends c {
    protected String d = null;

    protected ae() {
        this.a = 4;
    }

    public final void a(String string) {
        this.d = string;
    }

    public final String e() {
        return this.d;
    }
}

