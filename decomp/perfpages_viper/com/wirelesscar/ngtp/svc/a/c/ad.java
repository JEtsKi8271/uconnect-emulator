/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ag;
import com.wirelesscar.ngtp.svc.a.c.ah;
import com.wirelesscar.ngtp.svc.a.c.bc;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class ad
extends g {
    public aa a = new aa();
    public ag b = new ag();
    public bf c = new bf();
    public bc d = new bc();
    public ah e = new ah();

    public ad() {
        this.c.a(0L, 65535L);
        this.e.a(1L, 256L);
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
        return l2;
    }
}

