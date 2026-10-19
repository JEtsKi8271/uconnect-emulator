/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.t;

public final class bw
extends bn {
    private t a = new t();

    public bw() {
        this.a.b(0L, 511L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
    }

    public final long b() {
        long l2 = super.b();
        return l2 += this.a.b();
    }
}

