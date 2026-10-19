/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bp;

public final class cf
extends bp {
    public boolean a;

    public final bf b() throws ai {
        return new cf();
    }

    public final void b(bd bd2) throws ai {
        bd2.a((byte)(this.a ? 1 : 0), 1);
    }

    public final void a(bd bd2) throws ai {
        bd bd3 = bd2;
        this.a = bd2.b(1) == 1L;
        bd3 = bd2;
    }

    public final long a() {
        return 1L;
    }
}

