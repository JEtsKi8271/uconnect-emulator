/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bv;
import com.wirelesscar.ngtp.svc.a.b.cb;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.g;

public final class h
extends bm {
    public cf a = new cf();
    public cf b = new cf();
    public bv c = new bv();
    public bo d = new bo();
    public g e = new g();
    public cb f = new cb();

    public h() {
        this.d.b(0L, 65535L);
        this.f.b(1L, 31L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.d.a(bd2);
        }
        cf2 = this.b;
        if (cf2.a) {
            this.e.a(bd2);
        }
        this.f.a(bd2);
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.d.b(bd2);
        }
        cf2 = this.b;
        if (cf2.a) {
            this.e.b(bd2);
        }
        this.f.b(bd2);
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.d.a();
        }
        cf2 = this.b;
        if (cf2.a) {
            l2 += this.e.a();
        }
        return l2 += this.f.a();
    }
}

