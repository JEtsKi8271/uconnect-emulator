/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.a;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class aq
extends bn {
    private ap a = new ap();
    private ap b = new ap();
    private ap c = new ap();
    private a d = new a();
    private a e = new a();
    private a f = new a();
    private a g = new a();

    public aq() {
        this.d.b_(3L);
        this.e.b_(6L);
        this.f.b_(1L);
        this.g.b_(7L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.d.a(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.e.a(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.f.a(n2);
        }
        this.g.a(n2);
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.d.b(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.e.b(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.f.b(n2);
        }
        this.g.b(n2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.d.b();
        }
        ap2 = this.b;
        if (ap2.a) {
            l2 += this.e.b();
        }
        ap2 = this.c;
        if (ap2.a) {
            l2 += this.f.b();
        }
        return l2 += this.g.b();
    }
}

