/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.a;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.cq;
import com.wirelesscar.ngtp.svc.a.a.e;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.r;

public final class ac
extends bn {
    public ap a = new ap();
    public ap b = new ap();
    public ap c = new ap();
    public cq d = new cq();
    public e e = new e();
    public a f = new a();
    public f g = new f();
    public f h = new f();
    public r i = new r();

    public ac() {
        this.f.b(1L, 128L);
        this.g.b(0L, 1023L);
        this.h.b(-1L, 65534L);
        this.i.b(0L, 31L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        this.d.a(n2);
        this.e.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.f.a(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.g.a(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.h.a(n2);
        }
        this.i.a(n2);
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        this.d.b(n2);
        this.e.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.f.b(n2);
        }
        ap2 = this.b;
        if (ap2.a) {
            this.g.b(n2);
        }
        ap2 = this.c;
        if (ap2.a) {
            this.h.b(n2);
        }
        this.i.b(n2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        l2 += this.d.b();
        l2 += this.e.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.f.b();
        }
        ap2 = this.b;
        if (ap2.a) {
            l2 += this.g.b();
        }
        ap2 = this.c;
        if (ap2.a) {
            l2 += this.h.b();
        }
        return l2 += this.i.b();
    }
}

