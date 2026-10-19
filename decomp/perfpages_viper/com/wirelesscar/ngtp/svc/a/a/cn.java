/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.at;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.cq;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class cn
extends bn {
    public ap a = new ap();
    public ap b = new ap();
    public cq c = new cq();
    public f d = new f();
    public bt e = new bt();
    public at f = new at();

    public cn() {
        this.d.b(0L, 65535L);
        this.f.b(1L, 31L);
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
        this.f.a(n2);
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
        this.f.b(n2);
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
        return l2 += this.f.b();
    }
}

