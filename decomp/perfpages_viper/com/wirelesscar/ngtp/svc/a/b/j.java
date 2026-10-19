/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.cg;

public final class j
extends bm {
    public cf a = new cf();
    public cf b = new cf();
    public cf c = new cf();
    public bo d = new bo();
    public bo e = new bo();
    public cg f = new cg();

    public j() {
        this.d.b(-100L, 8091L);
        this.e.b(0L, 359L);
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
        return l2;
    }

    public final void a(boolean bl2) {
        bf bf2 = bf2.a;
        bf2.a.a = bl2;
    }

    public final void b(boolean bl2) {
        bf bf2 = bf2.b;
        bf2.b.a = bl2;
    }

    public final void c(boolean bl2) {
        bf bf2 = bf2.c;
        bf2.c.a = bl2;
    }
}

