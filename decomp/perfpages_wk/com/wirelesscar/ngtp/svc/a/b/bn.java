/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ab;
import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.az;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.cf;

public final class bn
extends bm {
    private cf a = new cf();
    private cf b = new cf();
    private cf c = new cf();
    private cf d = new cf();
    private ab e = new ab();
    private az f = new az();
    private bo g = new bo();
    private bo h = new bo();

    public bn() {
        this.g.b(0L, 4095L);
        this.h.b(0L, 4095L);
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
        cf2 = this.b;
        if (cf2.a) {
            this.f.a(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.g.a(bd2);
        }
        cf2 = this.d;
        if (cf2.a) {
            this.h.a(bd2);
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
        cf2 = this.b;
        if (cf2.a) {
            this.f.b(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.g.b(bd2);
        }
        cf2 = this.d;
        if (cf2.a) {
            this.h.b(bd2);
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
        cf2 = this.b;
        if (cf2.a) {
            l2 += this.f.a();
        }
        cf2 = this.c;
        if (cf2.a) {
            l2 += this.g.a();
        }
        cf2 = this.d;
        if (cf2.a) {
            l2 += this.h.a();
        }
        return l2;
    }
}

