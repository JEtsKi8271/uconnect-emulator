/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;

public final class g
extends bm {
    public bo a = new bo();

    public g() {
        this.a.b(0L, Integer.MAX_VALUE);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
    }

    public final long a() {
        long l2 = super.a();
        return l2 += this.a.a();
    }

    public final void a(long l2) {
        this.a.b(l2);
    }
}

