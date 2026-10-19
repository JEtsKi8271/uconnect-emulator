/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ac;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.br;
import com.wirelesscar.ngtp.svc.a.a.cl;
import com.wirelesscar.ngtp.svc.a.a.g;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.z;

public final class cj
extends bn {
    public ap a = new ap();
    public ap b = new ap();
    public ap c = new ap();
    private ap g = new ap();
    private ap h = new ap();
    public br d = new br();
    public ac e = new ac();
    public cl f = new cl();
    private z i = new z();
    private g j = new g();

    public cj() {
        this.d.b(0L, 15L);
        this.j.b(0L, 255L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        this.g.a(n2);
        this.h.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.d.a(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.e.a(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.f.a(n2);
        }
        ap2 = this.g;
        if (ap2.a) {
            this.i.a(n2);
        }
        ap2 = this.h;
        if (ap2.a) {
            this.j.a(n2);
        }
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        this.g.b(n2);
        this.h.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.d.b(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.e.b(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.f.b(n2);
        }
        ap2 = this.g;
        if (ap2.a) {
            this.i.b(n2);
        }
        ap2 = this.h;
        if (ap2.a) {
            this.j.b(n2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.g.b();
        l2 += this.h.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.d.b();
        }
        ap2 = this.b;
        if (ap2.a) {
            l2 += this.e.b();
        }
        ap2 = this.c;
        if (ap2.a) {
            l2 += this.f.b();
        }
        ap2 = this.g;
        if (ap2.a) {
            l2 += this.i.b();
        }
        ap2 = this.h;
        if (ap2.a) {
            l2 += this.j.b();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        aw aw2 = aw2.a;
        aw2.a.a = bl2;
    }

    public final void b(boolean bl2) {
        aw aw2 = aw2.c;
        aw2.c.a = bl2;
    }
}

