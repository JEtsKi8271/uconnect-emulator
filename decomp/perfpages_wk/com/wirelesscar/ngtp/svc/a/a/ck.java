/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.bv;
import com.wirelesscar.ngtp.svc.a.a.bx;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class ck
extends bn {
    public ap a = new ap();
    private ap h = new ap();
    public ap b = new ap();
    public ap c = new ap();
    public ap d = new ap();
    public bv e = new bv();
    public ap f = new ap();
    public bx g = new bx();

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.h.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        this.d.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.e.a(n2);
        }
        this.f.a(n2);
        ap2 = this.h;
        if (ap2.a) {
            this.g.a(n2);
        }
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.h.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        this.d.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.e.b(n2);
        }
        this.f.b(n2);
        ap2 = this.h;
        if (ap2.a) {
            this.g.b(n2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.h.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.e.b();
        }
        l2 += this.f.b();
        ap2 = this.h;
        if (ap2.a) {
            l2 += this.g.b();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        aw aw2 = aw2.a;
        aw2.a.a = bl2;
    }

    public final void b(boolean bl2) {
        bl2 = true;
        aw aw2 = aw2.h;
        aw2.h.a = bl2;
    }

    public final void a(long l2) {
        this.e.a(l2);
    }
}

