/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public class bs
extends f {
    public final aw a() throws o {
        return new bs();
    }

    public final long c() {
        return this.a;
    }

    public final void a(long l2) {
        this.a = l2;
    }

    public final void b(n n2) throws o {
        n2.a(this.a - this.d, bs.a(this.d, this.e));
    }

    public final void a(n n2) throws o {
        n n3 = n2;
        this.a = this.d + n2.b(bs.a(this.d, this.e));
        n3 = n2;
    }

    public final long b() {
        return bs.a(this.d, this.e);
    }
}

