/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.aj;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.g;
import com.wirelesscar.ngtp.svc.a.b.t;

public final class aw
extends bm {
    public cf a = new cf();
    public t b = new t();
    public bo c = new bo();
    public g d = new g();
    public aj e = new aj();

    public aw() {
        this.c.b(0L, 65535L);
        this.e.b(1L, 256L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        this.d.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.e.a(bd2);
        }
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        this.d.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.e.b(bd2);
        }
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        l2 += this.d.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.e.a();
        }
        return l2;
    }
}

