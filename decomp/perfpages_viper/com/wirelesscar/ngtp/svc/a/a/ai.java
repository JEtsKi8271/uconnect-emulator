/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ad;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class ai
extends bn {
    public ad a = new ad();
    public ad b = new ad();
    public ad c = new ad();
    public ad d = new ad();

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        this.d.a(n2);
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        this.d.b(n2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        return l2 += this.d.b();
    }
}

