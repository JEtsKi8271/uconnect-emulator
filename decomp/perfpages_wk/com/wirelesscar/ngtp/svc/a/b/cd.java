/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.e;
import com.wirelesscar.ngtp.svc.a.b.l;

public final class cd
extends bm {
    public cf a = new cf();
    private cf h = new cf();
    public cf b = new cf();
    public cf c = new cf();
    public cf d = new cf();
    public l e = new l();
    public cf f = new cf();
    public e g = new e();

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.h.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        this.d.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.e.a(bd2);
        }
        this.f.a(bd2);
        cf2 = this.h;
        if (cf2.a) {
            this.g.a(bd2);
        }
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.h.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        this.d.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.e.b(bd2);
        }
        this.f.b(bd2);
        cf2 = this.h;
        if (cf2.a) {
            this.g.b(bd2);
        }
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.h.a();
        l2 += this.b.a();
        l2 += this.c.a();
        l2 += this.d.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.e.a();
        }
        l2 += this.f.a();
        cf2 = this.h;
        if (cf2.a) {
            l2 += this.g.a();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        bf bf2 = bf2.a;
        bf2.a.a = bl2;
    }

    public final void b(boolean bl2) {
        bl2 = true;
        bf bf2 = bf2.h;
        bf2.h.a = bl2;
    }

    public final void a(long l2) {
        this.e.b(l2);
    }
}

