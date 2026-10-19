/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.az;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;
import com.wirelesscar.ngtp.svc.a.c.w;

public final class ai
extends g {
    public aa a = new aa();
    private aa h = new aa();
    public aa b = new aa();
    public aa c = new aa();
    public aa d = new aa();
    public az e = new az();
    public aa f = new aa();
    public w g = new w();

    public ai() {
        boolean bl2 = false;
        aa aa2 = this.b;
        this.b.d = bl2;
        bl2 = false;
        aa2 = this.c;
        this.c.d = bl2;
        bl2 = false;
        aa2 = this.d;
        this.d.d = bl2;
        bl2 = false;
        aa2 = this.f;
        this.f.d = bl2;
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.h.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        this.d.b(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.e.b(u2);
        }
        this.f.b(u2);
        aa2 = this.h;
        if (aa2.d) {
            this.g.b(u2);
        }
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.h.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        this.d.a(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.e.a(u2);
        }
        this.f.a(u2);
        aa2 = this.h;
        if (aa2.d) {
            this.g.a(u2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.h.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        aa aa2 = this.a;
        if (aa2.d) {
            l2 += this.e.b();
        }
        l2 += this.f.b();
        aa2 = this.h;
        if (aa2.d) {
            l2 += this.g.b();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        ap ap2 = ap2.a;
        ap2.a.d = bl2;
    }

    public final void b(boolean bl2) {
        bl2 = true;
        ap ap2 = ap2.h;
        ap2.h.d = bl2;
    }

    public final void a(long l2) {
        this.e.b(l2);
    }
}

