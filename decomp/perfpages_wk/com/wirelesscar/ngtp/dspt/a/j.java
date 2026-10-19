/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.ac;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.y;

public final class j
extends ac {
    private y a = new y();
    private y b = new y();

    public j() {
        this.a.a(0L, 7L);
        this.b.a(0L, 7L);
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
        this.b.b(0L);
    }
}

