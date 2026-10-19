/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.am;
import com.wirelesscar.ngtp.svc.a.c.bc;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.s;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class n
extends g {
    public aa a = new aa();
    public aa b = new aa();
    public s c = new s();
    public bf d = new bf();
    public bc e = new bc();
    public am f = new am();

    public n() {
        this.d.a(0L, 65535L);
        this.f.a(1L, 31L);
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
        this.f.b(u2);
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
        this.f.a(u2);
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
        return l2 += this.f.b();
    }
}

