/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public class cf
extends aw {
    protected int c = 0;
    protected long d = 0L;
    protected long e = 0L;

    public aw a() throws o {
        return new cf();
    }

    void a(int n2) {
        this.c = 1;
        this.d = 0L;
        this.e = (long)n2 - 1L;
    }

    void b_(long l2) {
        this.c = 1;
        this.d = 0L;
        this.e = l2 - 1L;
    }

    final void b(long l2, long l3) {
        this.c = 2;
        this.d = l2;
        this.e = l3;
    }

    public void b(n n2) throws o {
    }

    public void a(n n2) throws o {
    }

    public long b() {
        return 0L;
    }
}

