/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bx;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.t;

public final class bg
extends bm {
    public cf a = new cf();
    public t b = new t();
    public cf c = new cf();
    public cf d = new cf();
    public bo e = new bo();
    public bo f = new bo();
    public bo g = new bo();
    public bo h = new bo();
    public bx i = new bx();

    public bg() {
        this.e.b(0L, 1023L);
        this.f.b(0L, 1023L);
        this.g.b(-1L, 65534L);
        this.h.b(0L, 1023L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        this.d.a(bd2);
        this.e.a(bd2);
        this.f.a(bd2);
        this.g.a(bd2);
        this.h.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.i.a(bd2);
        }
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        this.d.b(bd2);
        this.e.b(bd2);
        this.f.b(bd2);
        this.g.b(bd2);
        this.h.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.i.b(bd2);
        }
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        l2 += this.d.a();
        l2 += this.e.a();
        l2 += this.f.a();
        l2 += this.g.a();
        l2 += this.h.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.i.a();
        }
        return l2;
    }
}

