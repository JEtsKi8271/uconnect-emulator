/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bo;

public class bh
extends bo {
    public final bf b() throws ai {
        return new bh();
    }

    public final long c() {
        return this.b;
    }

    public final void b(long l2) {
        this.b = l2;
    }

    public final void b(bd bd2) throws ai {
        bd2.a(this.b - this.d, bh.a(this.d, this.e));
    }

    public final void a(bd bd2) throws ai {
        bd bd3 = bd2;
        this.b = this.d + bd2.b(bh.a(this.d, this.e));
        bd3 = bd2;
    }

    public final long a() {
        return bh.a(this.d, this.e);
    }
}

