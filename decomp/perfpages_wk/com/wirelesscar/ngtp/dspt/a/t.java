/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.ac;
import com.wirelesscar.ngtp.dspt.a.af;
import com.wirelesscar.ngtp.dspt.a.d;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.p;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.v;
import com.wirelesscar.ngtp.dspt.a.w;

public final class t
extends ac {
    private af e = new af();
    private af f = new af();
    public af a = new af();
    public p b = new p();
    public d c = new d();
    public v d = new v();

    public t() {
        this.b.a(0L, 27L);
        this.c.a(1L, 64L);
    }

    public final void a(q q2) throws w {
        super.a(q2);
        this.e.a(q2);
        this.f.a(q2);
        this.a.a(q2);
        af af2 = this.e;
        if (af2.d) {
            this.b.a(q2);
        }
        af2 = this.f;
        if (af2.d) {
            this.c.a(q2);
        }
        af2 = this.a;
        if (af2.d) {
            this.d.a(q2);
        }
    }

    public final void b(q q2) throws w {
        super.b(q2);
        this.e.b(q2);
        this.f.b(q2);
        this.a.b(q2);
        af af2 = this.e;
        if (af2.d) {
            this.b.b(q2);
        }
        af2 = this.f;
        if (af2.d) {
            this.c.b(q2);
        }
        af2 = this.a;
        if (af2.d) {
            this.d.b(q2);
        }
    }

    public final void a(boolean bl2) {
        m m2 = m2.e;
        m2.e.d = bl2;
    }

    public final void b(boolean bl2) {
        m m2 = m2.f;
        m2.f.d = bl2;
    }

    public final void c(boolean bl2) {
        m m2 = m2.a;
        m2.a.d = bl2;
    }
}

