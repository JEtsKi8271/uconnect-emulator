/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class r
extends g {
    private bf a = new bf();
    private bf b = new bf();

    public r() {
        this.a.a(0L, 127L);
        this.b.a(0L, 127L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        return l2 += this.b.b();
    }
}

