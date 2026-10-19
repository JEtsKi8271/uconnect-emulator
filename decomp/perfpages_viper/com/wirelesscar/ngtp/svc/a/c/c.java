/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public class c
extends ap {
    protected int a = 0;
    protected long b = 0L;
    protected long c = 0L;

    public ap a() throws j {
        return new c();
    }

    void b(int n2) {
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

    public void a(u u2) throws j {
    }

    public void b(u u2) throws j {
    }

    public long b() {
        return 0L;
    }
}

