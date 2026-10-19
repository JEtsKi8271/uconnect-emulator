/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;

public final class az
extends bm {
    private bo a = new bo();
    private bo b = new bo();

    public az() {
        this.a.b(0L, 23L);
        this.b.b(0L, 59L);
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
}

