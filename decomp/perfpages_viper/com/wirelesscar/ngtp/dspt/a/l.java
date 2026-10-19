/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.ac;
import com.wirelesscar.ngtp.dspt.a.af;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.p;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;

public final class l
extends ac {
    public af a = new af();
    public af b = new af();
    public af c = new af();
    public af d = new af();
    public p e = new p();
    public p f = new p();
    public p g = new p();
    public p h = new p();

    public l() {
        this.e.a(1L, 32L);
        this.f.a(1L, 32L);
        this.g.a(1L, 32L);
        this.h.a(1L, 32L);
    }

    public final void a(q q2) throws w {
        super.a(q2);
        this.a.a(q2);
        this.b.a(q2);
        this.c.a(q2);
        this.d.a(q2);
        af af2 = this.a;
        if (af2.d) {
            this.e.a(q2);
        }
        af2 = this.b;
        if (af2.d) {
            this.f.a(q2);
        }
        af2 = this.c;
        if (af2.d) {
            this.g.a(q2);
        }
        af2 = this.d;
        if (af2.d) {
            this.h.a(q2);
        }
    }

    public final void b(q q2) throws w {
        super.b(q2);
        this.a.b(q2);
        this.b.b(q2);
        this.c.b(q2);
        this.d.b(q2);
        af af2 = this.a;
        if (af2.d) {
            this.e.b(q2);
        }
        af2 = this.b;
        if (af2.d) {
            this.f.b(q2);
        }
        af2 = this.c;
        if (af2.d) {
            this.g.b(q2);
        }
        af2 = this.d;
        if (af2.d) {
            this.h.b(q2);
        }
    }

    public final void a(boolean bl2) {
        m m2 = m2.a;
        m2.a.d = bl2;
    }

    public final void b(boolean bl2) {
        m m2 = m2.b;
        m2.b.d = bl2;
    }

    public final void c(boolean bl2) {
        m m2 = m2.c;
        m2.c.d = bl2;
    }

    public final void d(boolean bl2) {
        m m2 = m2.d;
        m2.d.d = bl2;
    }
}

