/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.cc;

public final class v
extends bm {
    private cc a = new cc();
    private cc b = new cc();
    private cc c = new cc();
    private cc d = new cc();
    private cc e = new cc();
    private cc f = new cc();
    private cc g = new cc();
    private cc h = new cc();

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        this.d.a(bd2);
        this.e.a(bd2);
        this.f.a(bd2);
        this.g.a(bd2);
        this.h.a(bd2);
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        this.d.b(bd2);
        this.e.b(bd2);
        this.f.b(bd2);
        this.g.b(bd2);
        this.h.b(bd2);
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        l2 += this.d.a();
        l2 += this.e.a();
        l2 += this.f.a();
        l2 += this.g.a();
        return l2 += this.h.a();
    }
}

