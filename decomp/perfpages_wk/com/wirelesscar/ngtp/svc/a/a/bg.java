/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.cf;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public class bg
extends cf {
    protected int a = -1;
    protected aw b = null;
    private f f = null;

    public aw a() throws o {
        return new bg();
    }

    public final int f() {
        return this.a;
    }

    public final void b(n n2) throws o {
        if ((long)this.a < this.d || (long)this.a > this.e) {
            throw new o("Illegal choice value", 0);
        }
        n2.a(this.a, bg.a(this.d, this.e));
        this.b.b(n2);
    }

    public final void a(n n2) throws o {
        n n3 = n2;
        this.b((int)n2.b(bg.a(this.d, this.e)));
        this.b.a(n2);
        n3 = n2;
    }

    public final void b(int n2) throws o {
        if ((long)n2 < this.d || (long)n2 > this.e) {
            throw new o("Choice value: " + n2 + " must be between " + this.d + " - " + this.e, 0);
        }
        this.a = n2;
        this.b = this.a();
    }

    public final long b() {
        long l2 = 0L;
        l2 = 0L + (long)bg.a(this.d, this.e);
        if (this.b != null) {
            l2 += this.b.b();
        }
        return l2;
    }
}

