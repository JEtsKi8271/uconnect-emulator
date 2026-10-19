/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.ac;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.y;

public final class aa
extends ac {
    public y a = new y();
    public y b = new y();

    public aa() {
        this.a.a(0L, Integer.MAX_VALUE);
        this.b.a(0L, 999L);
    }

    public final void a(q q2) throws w {
        super.a(q2);
        this.a.a(q2);
        this.b.a(q2);
    }

    public final void b(q q2) throws w {
        super.b(q2);
        this.a.b(q2);
        this.b.b(q2);
    }

    public final void a(long l2) {
        this.a.b(l2);
    }

    public final void b(long l2) {
        this.b.b(l2);
    }
}

