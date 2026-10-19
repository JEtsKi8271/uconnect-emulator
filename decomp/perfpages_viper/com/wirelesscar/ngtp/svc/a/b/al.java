/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.aj;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.cf;

public final class al
extends bm {
    private cf a = new cf();
    private cf b = new cf();
    private cf c = new cf();
    private aj d = new aj();
    private aj e = new aj();
    private aj f = new aj();
    private aj g = new aj();

    public al() {
        this.d.a(3L);
        this.e.a(6L);
        this.f.a(1L);
        this.g.a(7L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.d.a(bd2);
        }
        cf2 = this.b;
        if (cf2.a) {
            this.e.a(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.f.a(bd2);
        }
        this.g.a(bd2);
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.d.b(bd2);
        }
        cf2 = this.b;
        if (cf2.a) {
            this.e.b(bd2);
        }
        cf2 = this.c;
        if (cf2.a) {
            this.f.b(bd2);
        }
        this.g.b(bd2);
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.d.a();
        }
        cf2 = this.b;
        if (cf2.a) {
            l2 += this.e.a();
        }
        cf2 = this.c;
        if (cf2.a) {
            l2 += this.f.a();
        }
        return l2 += this.g.a();
    }
}

