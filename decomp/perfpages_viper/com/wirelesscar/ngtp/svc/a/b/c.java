/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.aj;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bv;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.f;
import com.wirelesscar.ngtp.svc.a.b.y;

public final class c
extends bm {
    public cf a = new cf();
    public cf b = new cf();
    public cf c = new cf();
    public bv d = new bv();
    public f e = new f();
    public aj f = new aj();
    public bo g = new bo();
    public bo h = new bo();
    public y i = new y();

    public c() {
        this.f.b(1L, 128L);
        this.g.b(0L, 1023L);
        this.h.b(-1L, 65534L);
        this.i.b(0L, 31L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        this.d.a(bd2);
        this.e.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.f.a(bd2);
        }
        cf2 = this.b;
        if (cf2.a) {
            this.g.a(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.h.a(bd2);
        }
        this.i.a(bd2);
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        this.d.b(bd2);
        this.e.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.f.b(bd2);
        }
        cf2 = this.b;
        if (cf2.a) {
            this.g.b(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.h.b(bd2);
        }
        this.i.b(bd2);
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        l2 += this.d.a();
        l2 += this.e.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.f.a();
        }
        cf2 = this.b;
        if (cf2.a) {
            l2 += this.g.a();
        }
        cf2 = this.c;
        if (cf2.a) {
            l2 += this.h.a();
        }
        return l2 += this.i.a();
    }
}

