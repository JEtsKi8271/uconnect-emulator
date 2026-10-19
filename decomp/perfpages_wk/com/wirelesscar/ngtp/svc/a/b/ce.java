/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.be;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.br;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.ck;

public final class ce
extends bm {
    private cf a = new cf();
    private cf b = new cf();
    private cf c = new cf();
    private cf d = new cf();
    private cf e = new cf();
    private ck f = new ck();
    private be g = new be();
    private be h = new be();
    private be i = new be();
    private bo j = new bo();
    private bo k = new bo();
    private bo l = new bo();
    private br m = new br();

    public ce() {
        this.f.b(0L, 127L);
        this.j.b(0L, 16383L);
        this.k.b(0L, 100L);
        this.l.b(0L, 127L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        this.d.a(bd2);
        this.e.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.f.a(bd2);
        }
        this.g.a(bd2);
        this.h.a(bd2);
        this.i.a(bd2);
        cf2 = this.b;
        if (cf2.a) {
            this.j.a(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.k.a(bd2);
        }
        cf2 = this.d;
        if (cf2.a) {
            this.l.a(bd2);
        }
        cf2 = this.e;
        if (cf2.a) {
            this.m.a(bd2);
        }
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        this.d.b(bd2);
        this.e.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.f.b(bd2);
        }
        this.g.b(bd2);
        this.h.b(bd2);
        this.i.b(bd2);
        cf2 = this.b;
        if (cf2.a) {
            this.j.b(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.k.b(bd2);
        }
        cf2 = this.d;
        if (cf2.a) {
            this.l.b(bd2);
        }
        cf2 = this.e;
        if (cf2.a) {
            this.m.b(bd2);
        }
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        l2 += this.d.a();
        l2 += this.e.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.f.a();
        }
        l2 += this.g.a();
        l2 += this.h.a();
        l2 += this.i.a();
        cf2 = this.b;
        if (cf2.a) {
            l2 += this.j.a();
        }
        cf2 = this.c;
        if (cf2.a) {
            l2 += this.k.a();
        }
        cf2 = this.d;
        if (cf2.a) {
            l2 += this.l.a();
        }
        cf2 = this.e;
        if (cf2.a) {
            l2 += this.m.a();
        }
        return l2;
    }
}

