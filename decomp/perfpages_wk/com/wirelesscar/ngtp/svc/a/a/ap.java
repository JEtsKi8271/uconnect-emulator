/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.cf;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class ap
extends cf {
    public boolean a;

    public final aw a() throws o {
        return new ap();
    }

    public final void b(n n2) throws o {
        n2.a((byte)(this.a ? 1 : 0), 1);
    }

    public final void a(n n2) throws o {
        n n3 = n2;
        this.a = n2.b(1) == 1L;
        n3 = n2;
    }

    public final long b() {
        return 1L;
    }
}

