/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.c;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.y;

public class f
extends c {
    protected int d = -1;
    protected m e = null;
    private y f = null;

    public m a() throws w {
        return new f();
    }

    public final int b() {
        return this.d;
    }

    public final void b(q q2) throws w {
        if ((long)this.d < this.b || (long)this.d > this.c) {
            throw new w("Illegal choice value", 0);
        }
        q2.a(this.d, com.wirelesscar.ngtp.dspt.a.f.b(this.b, this.c));
        this.e.b(q2);
    }

    public final void a(q q2) throws w {
        q q3 = q2;
        this.b((int)q2.b(com.wirelesscar.ngtp.dspt.a.f.b(this.b, this.c)));
        this.e.a(q2);
        q3 = q2;
    }

    public final void b(int n2) throws w {
        if ((long)n2 < this.b || (long)n2 > this.c) {
            throw new w("Choice value: " + n2 + " must be between " + this.b + " - " + this.c, 0);
        }
        this.d = n2;
        this.e = this.a();
    }
}

