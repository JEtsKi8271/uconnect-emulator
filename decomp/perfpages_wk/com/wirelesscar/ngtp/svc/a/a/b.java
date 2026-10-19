/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.a;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.cm;
import com.wirelesscar.ngtp.svc.a.a.co;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class b
extends bn {
    public ap a = new ap();
    public a b = new a();
    public co c = new co();
    public cm d = new cm();

    public b() {
        this.b.b(1L, 256L);
        this.d.b(0L, 131071L);
    }

    public final void a(n n2) throws o {
        super.a(n2);
        this.a.a(n2);
        this.b.a(n2);
        this.c.a(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.d.a(n2);
        }
    }

    public final void b(n n2) throws o {
        super.b(n2);
        this.a.b(n2);
        this.b.b(n2);
        this.c.b(n2);
        ap ap2 = this.a;
        if (ap2.a) {
            this.d.b(n2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        ap ap2 = this.a;
        if (ap2.a) {
            l2 += this.d.b();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        aw aw2 = aw2.a;
        aw2.a.a = bl2;
    }
}

