/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.bh;
import com.wirelesscar.ngtp.svc.a.c.bi;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class t
extends g {
    private aa a = new aa();
    private aa b = new aa();
    private aa c = new aa();
    private aa d = new aa();
    private bi e = new bi();
    private bh f = new bh();
    private bf g = new bf();
    private bf h = new bf();

    public t() {
        this.g.a(0L, 4095L);
        this.h.a(0L, 4095L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        this.d.b(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.e.b(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.f.b(u2);
        }
        aa2 = this.c;
        if (aa2.d) {
            this.g.b(u2);
        }
        aa2 = this.d;
        if (aa2.d) {
            this.h.b(u2);
        }
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        this.d.a(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.e.a(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.f.a(u2);
        }
        aa2 = this.c;
        if (aa2.d) {
            this.g.a(u2);
        }
        aa2 = this.d;
        if (aa2.d) {
            this.h.a(u2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        aa aa2 = this.a;
        if (aa2.d) {
            l2 += this.e.b();
        }
        aa2 = this.b;
        if (aa2.d) {
            l2 += this.f.b();
        }
        aa2 = this.c;
        if (aa2.d) {
            l2 += this.g.b();
        }
        aa2 = this.d;
        if (aa2.d) {
            l2 += this.h.b();
        }
        return l2;
    }
}

