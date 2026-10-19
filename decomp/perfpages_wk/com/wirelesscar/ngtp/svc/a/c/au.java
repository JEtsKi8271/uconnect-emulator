/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ag;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;
import com.wirelesscar.ngtp.svc.a.c.y;

public final class au
extends g {
    public aa a = new aa();
    public ag b = new ag();
    public aa c = new aa();
    public aa d = new aa();
    public bf e = new bf();
    public bf f = new bf();
    public bf g = new bf();
    public bf h = new bf();
    public y i = new y();

    public au() {
        this.e.a(0L, 1023L);
        this.f.a(0L, 1023L);
        this.g.a(-1L, 65534L);
        this.h.a(0L, 1023L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        this.d.b(u2);
        this.e.b(u2);
        this.f.b(u2);
        this.g.b(u2);
        this.h.b(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.i.b(u2);
        }
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        this.d.a(u2);
        this.e.a(u2);
        this.f.a(u2);
        this.g.a(u2);
        this.h.a(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.i.a(u2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        l2 += this.e.b();
        l2 += this.f.b();
        l2 += this.g.b();
        l2 += this.h.b();
        aa aa2 = this.a;
        if (aa2.d) {
            l2 += this.i.b();
        }
        return l2;
    }
}

