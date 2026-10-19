/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.ci;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class v
extends bn {
    public ap a = new ap();
    public ap b = new ap();
    public ap c = new ap();
    public ap d = new ap();
    public ap e = new ap();
    public f f = new f();
    public f g = new f();
    public ci h = new ci();
    public f i = new f();
    public bt j = new bt();

    public v() {
        this.f.b(-100L, 8091L);
        this.g.b(0L, 359L);
        this.i.b(0L, 511L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        this.d.a(n2);
        this.e.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.f.a(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.g.a(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.h.a(n2);
        }
        ap2 = this.d;
        if (ap2.a) {
            this.i.a(n2);
        }
        ap2 = this.e;
        if (ap2.a) {
            this.j.a(n2);
        }
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        this.d.b(n2);
        this.e.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.f.b(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.g.b(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.h.b(n2);
        }
        ap2 = this.d;
        if (ap2.a) {
            this.i.b(n2);
        }
        ap2 = this.e;
        if (ap2.a) {
            this.j.b(n2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        l2 += this.e.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.f.b();
        }
        ap2 = this.b;
        if (ap2.a) {
            l2 += this.g.b();
        }
        ap2 = this.c;
        if (ap2.a) {
            l2 += this.h.b();
        }
        ap2 = this.d;
        if (ap2.a) {
            l2 += this.i.b();
        }
        ap2 = this.e;
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
        aw aw2 = aw2.b;
        aw2.b.a = bl2;
    }

    public final void c(boolean bl2) {
        aw aw2 = aw2.c;
        aw2.c.a = bl2;
    }

    public final void d(boolean bl2) {
        aw aw2 = aw2.d;
        aw2.d.a = bl2;
    }

    public final void e(boolean bl2) {
        aw aw2 = aw2.e;
        aw2.e.a = bl2;
    }
}

