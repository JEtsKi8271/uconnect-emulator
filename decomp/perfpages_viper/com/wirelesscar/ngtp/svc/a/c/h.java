/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ah;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class h
extends g {
    private aa a = new aa();
    private aa b = new aa();
    private aa c = new aa();
    private ah d = new ah();
    private ah e = new ah();
    private ah f = new ah();
    private ah g = new ah();

    public h() {
        this.d.a(3L);
        this.e.a(6L);
        this.f.a(1L);
        this.g.a(7L);
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
        this.g.b(u2);
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
        this.g.a(u2);
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
        return l2 += this.g.b();
    }
}

