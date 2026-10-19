/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.i;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class av
extends g {
    private i a = new i();
    private i b = new i();
    private i c = new i();
    private i d = new i();
    private i e = new i();
    private i f = new i();

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        this.d.b(u2);
        this.e.b(u2);
        this.f.b(u2);
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        this.d.a(u2);
        this.e.a(u2);
        this.f.a(u2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        l2 += this.e.b();
        return l2 += this.f.b();
    }
}

