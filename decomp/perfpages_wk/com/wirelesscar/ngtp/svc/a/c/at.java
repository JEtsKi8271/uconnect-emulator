/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public class at
extends bf {
    public final ap a() throws j {
        return new at();
    }

    public final long c() {
        return this.e;
    }

    public final void b(long l2) {
        this.e = l2;
    }

    public final void a(u u2) throws j {
        u2.a(this.e - this.b, at.b(this.b, this.c));
    }

    public final void b(u u2) throws j {
        u u3 = u2;
        this.e = this.b + u2.b(at.b(this.b, this.c));
        u3 = u2;
    }

    public final long b() {
        return at.b(this.b, this.c);
    }
}

