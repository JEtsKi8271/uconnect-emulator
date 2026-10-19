/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ak;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.bj;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.by;
import com.wirelesscar.ngtp.svc.a.a.ce;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class cc
extends bn {
    private ap a = new ap();
    private ap b = new ap();
    private ap c = new ap();
    private ap d = new ap();
    private ak e = new ak();
    private by f = new by();
    private bj g = new bj();
    private ce h = new ce();
    private bt i = new bt();

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        this.d.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.e.a(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.f.a(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.g.a(n2);
        }
        this.h.a(n2);
        ap2 = this.d;
        if (ap2.a) {
            this.i.a(n2);
        }
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        this.d.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.e.b(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.f.b(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.g.b(n2);
        }
        this.h.b(n2);
        ap2 = this.d;
        if (ap2.a) {
            this.i.b(n2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.e.b();
        }
        ap2 = this.b;
        if (ap2.a) {
            l2 += this.f.b();
        }
        ap2 = this.c;
        if (ap2.a) {
            l2 += this.g.b();
        }
        l2 += this.h.b();
        ap2 = this.d;
        if (ap2.a) {
            l2 += this.i.b();
        }
        return l2;
    }
}

