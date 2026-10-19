/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.bh;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class by
extends bn {
    private bh a = new bh();
    private bh b = new bh();
    private bh c = new bh();
    private bh d = new bh();
    private bh e = new bh();
    private bh f = new bh();
    private bh g = new bh();
    private bh h = new bh();

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        this.d.a(n2);
        this.e.a(n2);
        this.f.a(n2);
        this.g.a(n2);
        this.h.a(n2);
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        this.d.b(n2);
        this.e.b(n2);
        this.f.b(n2);
        this.g.b(n2);
        this.h.b(n2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        l2 += this.e.b();
        l2 += this.f.b();
        l2 += this.g.b();
        return l2 += this.h.b();
    }
}

