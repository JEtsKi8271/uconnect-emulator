/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ah;
import com.wirelesscar.ngtp.svc.a.c.aw;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.s;
import com.wirelesscar.ngtp.svc.a.c.u;
import com.wirelesscar.ngtp.svc.a.c.v;

public final class l
extends g {
    public aa a = new aa();
    public aa b = new aa();
    public aa c = new aa();
    public s d = new s();
    public aw e = new aw();
    public ah f = new ah();
    public bf g = new bf();
    public bf h = new bf();
    public v i = new v();

    public l() {
        this.f.a(1L, 128L);
        this.g.a(0L, 1023L);
        this.h.a(-1L, 65534L);
        this.i.a(0L, 31L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        this.d.b(u2);
        this.e.b(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.f.b(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.g.b(u2);
        }
        aa2 = this.c;
        if (aa2.d) {
            this.h.b(u2);
        }
        this.i.b(u2);
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        this.d.a(u2);
        this.e.a(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.f.a(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.g.a(u2);
        }
        aa2 = this.c;
        if (aa2.d) {
            this.h.a(u2);
        }
        this.i.a(u2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        l2 += this.e.b();
        aa aa2 = this.a;
        if (aa2.d) {
            l2 += this.f.b();
        }
        aa2 = this.b;
        if (aa2.d) {
            l2 += this.g.b();
        }
        aa2 = this.c;
        if (aa2.d) {
            l2 += this.h.b();
        }
        return l2 += this.i.b();
    }
}

