/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.c;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class aa
extends c {
    public boolean d;

    public final ap a() throws j {
        return new aa();
    }

    public final void a(u u2) throws j {
        u2.a((byte)(this.d ? 1 : 0), 1);
    }

    public final void b(u u2) throws j {
        u u3 = u2;
        this.d = u2.b(1) == 1L;
        u3 = u2;
    }

    public final long b() {
        return 1L;
    }
}

