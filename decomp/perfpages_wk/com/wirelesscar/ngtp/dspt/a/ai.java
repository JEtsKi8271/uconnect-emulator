/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.c;

public abstract class ai
extends c {
    protected String d = null;

    protected ai() {
        this.a = 4;
    }

    public final void a(String string) {
        this.d = string;
    }

    public final String c() {
        return this.d;
    }
}

