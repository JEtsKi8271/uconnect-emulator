/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bb;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.l;
import com.wirelesscar.ngtp.svc.a.c.u;
import com.wirelesscar.ngtp.svc.a.c.x;

public final class ab
extends g {
    private aa e = new aa();
    public aa a = new aa();
    public aa b = new aa();
    private x f = new x();
    public l c = new l();
    public bb d = new bb();

    public ab() {
        this.f.a(0L, 15L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.e.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        aa aa2 = this.e;
        if (aa2.d) {
            this.f.b(u2);
        }
        aa2 = this.a;
        if (aa2.d) {
            this.c.b(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.d.b(u2);
        }
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.e.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        aa aa2 = this.e;
        if (aa2.d) {
            this.f.a(u2);
        }
        aa2 = this.a;
        if (aa2.d) {
            this.c.a(u2);
        }
        aa2 = this.b;
        if (aa2.d) {
            this.d.a(u2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.e.b();
        l2 += this.a.b();
        l2 += this.b.b();
        aa aa2 = this.e;
        if (aa2.d) {
            l2 += this.f.b();
        }
        aa2 = this.a;
        if (aa2.d) {
            l2 += this.c.b();
        }
        aa2 = this.b;
        if (aa2.d) {
            l2 += this.d.b();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        ap ap2 = ap2.b;
        ap2.b.d = bl2;
    }
}

