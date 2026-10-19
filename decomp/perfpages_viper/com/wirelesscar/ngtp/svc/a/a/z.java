/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class z
extends bn {
    private ap a = new ap();
    private ap b = new ap();
    private ap c = new ap();
    private f d = new f();
    private f e = new f();
    private f f = new f();
    private f g = new f();
    private f h = new f();
    private f i = new f();
    private f j = new f();
    private f k = new f();

    public z() {
        this.d.b(0L, 23L);
        this.e.b(0L, 23L);
        this.f.b(0L, 59L);
        this.g.b(0L, 59L);
        this.h.b(0L, 23L);
        this.i.b(0L, 23L);
        this.j.b(0L, 59L);
        this.k.b(0L, 59L);
    }

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
        this.i.a(n2);
        this.j.a(n2);
        this.k.a(n2);
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
        this.i.b(n2);
        this.j.b(n2);
        this.k.b(n2);
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
        l2 += this.h.b();
        l2 += this.i.b();
        l2 += this.j.b();
        return l2 += this.k.b();
    }
}

