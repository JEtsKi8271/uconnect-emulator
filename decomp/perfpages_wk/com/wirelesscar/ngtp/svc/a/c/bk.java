/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.c;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public class bk
extends c {
    protected int d = -1;
    protected ap e = null;
    private bf f = null;

    public ap a() throws j {
        return new bk();
    }

    public final int g() {
        return this.d;
    }

    public final void a(u u2) throws j {
        if ((long)this.d < this.b || (long)this.d > this.c) {
            throw new j("Illegal choice value", 0);
        }
        u2.a(this.d, bk.b(this.b, this.c));
        this.e.a(u2);
    }

    public final void b(u u2) throws j {
        u u3 = u2;
        this.a((int)u2.b(bk.b(this.b, this.c)));
        this.e.b(u2);
        u3 = u2;
    }

    public final void a(int n2) throws j {
        if ((long)n2 < this.b || (long)n2 > this.c) {
            throw new j("Choice value: " + n2 + " must be between " + this.b + " - " + this.c, 0);
        }
        this.d = n2;
        this.e = this.a();
    }

    public final long b() {
        long l2 = 0L;
        l2 = 0L + (long)bk.b(this.b, this.c);
        if (this.e != null) {
            l2 += this.e.b();
        }
        return l2;
    }
}

