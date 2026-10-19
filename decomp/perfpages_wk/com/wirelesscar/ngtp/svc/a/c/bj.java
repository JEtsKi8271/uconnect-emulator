/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ba;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class bj
extends g {
    private ba a = new ba();

    public bj() {
        this.a.a(0L, 511L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
    }

    public final long b() {
        long l2 = super.b();
        return l2 += this.a.b();
    }
}

