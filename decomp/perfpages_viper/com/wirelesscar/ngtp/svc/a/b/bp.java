/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;

public class bp
extends bf {
    protected int c = 0;
    protected long d = 0L;
    protected long e = 0L;

    public bf b() throws ai {
        return new bp();
    }

    void a_(int n2) {
        this.c = 1;
        this.d = 0L;
        this.e = (long)n2 - 1L;
    }

    void a(long l2) {
        this.c = 1;
        this.d = 0L;
        this.e = l2 - 1L;
    }

    final void b(long l2, long l3) {
        this.c = 2;
        this.d = l2;
        this.e = l3;
    }

    public void b(bd bd2) throws ai {
    }

    public void a(bd bd2) throws ai {
    }

    public long a() {
        return 0L;
    }
}

