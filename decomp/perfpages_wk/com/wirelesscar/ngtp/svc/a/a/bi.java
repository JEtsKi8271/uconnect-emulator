/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.a;
import com.wirelesscar.ngtp.svc.a.a.av;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class bi
extends bn {
    public a a = new a();
    public av b = new av();

    public bi() {
        this.a.b(0L, 27L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        return l2 += this.b.b();
    }

    public final void a(long l2) {
        this.b.a(l2);
    }
}

