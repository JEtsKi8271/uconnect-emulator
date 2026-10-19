/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.av;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;

public final class bq
extends bm {
    private av a = new av();

    public bq() {
        this.a.b(0L, 511L);
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
}

