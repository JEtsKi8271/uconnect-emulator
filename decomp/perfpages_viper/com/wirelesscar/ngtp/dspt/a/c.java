/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;

public class c
extends m {
    protected int a = 0;
    protected long b = 0L;
    protected long c = 0L;

    public m a() throws w {
        return new c();
    }

    void a(int n2) {
        this.a = 1;
        this.b = 0L;
        this.c = (long)n2 - 1L;
    }

    void a(long l2) {
        this.a = 1;
        this.b = 0L;
        this.c = l2 - 1L;
    }

    final void a(long l2, long l3) {
        this.a = 2;
        this.b = l2;
        this.c = l3;
    }

    public void b(q q2) throws w {
    }

    public void a(q q2) throws w {
    }
}

