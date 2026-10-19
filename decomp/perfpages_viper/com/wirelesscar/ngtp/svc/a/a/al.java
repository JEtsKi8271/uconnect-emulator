/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ah;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.cm;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class al
extends bn {
    private ap a = new ap();
    private ah b = new ah();
    private cm c = new cm();

    public al() {
        this.c.b(1L, 1024L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.c.a(n2);
        }
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.c.b(n2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.c.b();
        }
        return l2;
    }
}

