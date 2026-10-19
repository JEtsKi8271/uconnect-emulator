/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.aj;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.cj;

public final class o
extends bm {
    public aj a = new aj();
    public cj b = new cj();

    public o() {
        this.a.b(0L, 27L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        return l2 += this.b.a();
    }

    public final void a(long l2) {
        this.b.b(l2);
    }
}

