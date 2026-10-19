/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class bc
extends g {
    public bf a = new bf();

    public bc() {
        this.a.a(0L, Integer.MAX_VALUE);
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

    public final void a(long l2) {
        this.a.b(l2);
    }
}

