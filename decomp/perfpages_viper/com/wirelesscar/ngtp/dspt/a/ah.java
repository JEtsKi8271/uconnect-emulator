/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.y;

public class ah
extends y {
    public final m a() throws w {
        return new ah();
    }

    public final long b() {
        return this.d;
    }

    public final void b(long l2) {
        this.d = l2;
    }

    public final void b(q q2) throws w {
        q2.a(this.d - this.b, ah.b(this.b, this.c));
    }

    public final void a(q q2) throws w {
        q q3 = q2;
        this.d = this.b + q2.b(ah.b(this.b, this.c));
        q3 = q2;
    }
}

