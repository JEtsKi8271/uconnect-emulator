/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.ac;
import com.wirelesscar.ngtp.dspt.a.af;
import com.wirelesscar.ngtp.dspt.a.p;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;

public final class h
extends ac {
    public af a = new af();
    public af b = new af();
    public af c = new af();
    public p d = new p();
    public p e = new p();
    public p f = new p();
    public p g = new p();

    public h() {
        this.d.a(3L);
        this.e.a(6L);
        this.f.a(1L);
        this.g.a(7L);
    }

    public final void a(q q2) throws w {
        super.a(q2);
        this.a.a(q2);
        this.b.a(q2);
        this.c.a(q2);
        af af2 = this.a;
        if (af2.d) {
            this.d.a(q2);
        }
        af2 = this.b;
        if (af2.d) {
            this.e.a(q2);
        }
        af2 = this.c;
        if (af2.d) {
            this.f.a(q2);
        }
        this.g.a(q2);
    }

    public final void b(q q2) throws w {
        super.b(q2);
        this.a.b(q2);
        this.b.b(q2);
        this.c.b(q2);
        af af2 = this.a;
        if (af2.d) {
            this.d.b(q2);
        }
        af2 = this.b;
        if (af2.d) {
            this.e.b(q2);
        }
        af2 = this.c;
        if (af2.d) {
            this.f.b(q2);
        }
        this.g.b(q2);
    }
}

