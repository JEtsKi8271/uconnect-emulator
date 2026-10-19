/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aq;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.i;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class bd
extends g {
    private aq a = new aq();
    private aq b = new aq();
    private i c = new i();
    private i d = new i();

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        this.d.b(u2);
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        this.d.a(u2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        return l2 += this.d.b();
    }
}

