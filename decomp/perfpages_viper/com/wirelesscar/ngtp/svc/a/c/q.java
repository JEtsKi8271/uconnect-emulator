/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.b;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class q
extends g {
    private aa a = new aa();
    private bf b = new bf();
    private b c = new b();

    public q() {
        this.b.a(0L, 100L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.c.b(u2);
        }
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.c.a(u2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        aa aa2 = this.a;
        if (aa2.d) {
            l2 += this.c.b();
        }
        return l2;
    }
}

