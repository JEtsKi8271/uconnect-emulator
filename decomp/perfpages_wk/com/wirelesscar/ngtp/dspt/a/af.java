/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.c;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;

public final class af
extends c {
    public boolean d;

    public final m a() throws w {
        return new af();
    }

    public final void b(q q2) throws w {
        q2.a((byte)(this.d ? 1 : 0), 1);
    }

    public final void a(q q2) throws w {
        q q3 = q2;
        this.d = q2.b(1) == 1L;
        q3 = q2;
    }
}

