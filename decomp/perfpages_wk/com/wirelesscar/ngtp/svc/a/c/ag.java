/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ah;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.d;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;
import com.wirelesscar.ngtp.svc.a.c.z;

public final class ag
extends g {
    public aa a = new aa();
    public ah b = new ah();
    public d c = new d();
    public z d = new z();

    public ag() {
        this.b.a(1L, 256L);
        this.d.a(1L, 255L);
    }

    public final void b(u u2) throws j {
        super.b(u2);
        this.a.b(u2);
        this.b.b(u2);
        this.c.b(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.d.b(u2);
        }
    }

    public final void a(u u2) throws j {
        super.a(u2);
        this.a.a(u2);
        this.b.a(u2);
        this.c.a(u2);
        aa aa2 = this.a;
        if (aa2.d) {
            this.d.a(u2);
        }
    }

    public final long b() {
        long l2 = super.b();
        l2 += this.a.b();
        l2 += this.b.b();
        l2 += this.c.b();
        aa aa2 = this.a;
        if (aa2.d) {
            l2 += this.d.b();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        ap ap2 = ap2.a;
        ap2.a.d = bl2;
    }
}

