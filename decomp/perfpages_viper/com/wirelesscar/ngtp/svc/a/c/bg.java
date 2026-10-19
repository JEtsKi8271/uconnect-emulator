/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.m;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class bg
extends g {
    public aa a = new aa();
    public aa b = new aa();
    public aa c = new aa();
    public bf d = new bf();
    public bf e = new bf();
    public m f = new m();

    public bg() {
        this.d.a(-100L, 8091L);
        this.e.a(0L, 359L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.d.b(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.e.b(u2);
        }
        aa2 = this.c;
        if (aa2.d) {
            this.f.b(u2);
        }
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.d.a(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.e.a(u2);
        }
        aa2 = this.c;
        if (aa2.d) {
            this.f.a(u2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        aa aa2 = this.a;
        if (aa2.d) {
            l2 += this.d.b();
        }
        aa2 = this.b;
        if (aa2.d) {
            l2 += this.e.b();
        }
        aa2 = this.c;
        if (aa2.d) {
            l2 += this.f.b();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        ap ap2 = ap2.a;
        ap2.a.d = bl2;
    }

    public final void b(boolean bl2) {
        ap ap2 = ap2.b;
        ap2.b.d = bl2;
    }

    public final void c(boolean bl2) {
        ap ap2 = ap2.c;
        ap2.c.d = bl2;
    }
}

