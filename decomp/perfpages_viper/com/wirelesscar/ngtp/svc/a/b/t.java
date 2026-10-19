/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.aj;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bk;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.ck;

public final class t
extends bm {
    public cf a = new cf();
    public aj b = new aj();
    public bk c = new bk();
    public ck d = new ck();

    public t() {
        this.b.b(1L, 256L);
        this.d.b(0L, 131071L);
    }

    public final void a(bd bd2) throws ai {
        super.a(bd2);
        this.a.a(bd2);
        this.b.a(bd2);
        this.c.a(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.d.a(bd2);
        }
    }

    public final void b(bd bd2) throws ai {
        super.b(bd2);
        this.a.b(bd2);
        this.b.b(bd2);
        this.c.b(bd2);
        cf cf2 = this.a;
        if (cf2.a) {
            this.d.b(bd2);
        }
    }

    public final long a() {
        long l2 = super.a();
        l2 += this.a.a();
        l2 += this.b.a();
        l2 += this.c.a();
        cf cf2 = this.a;
        if (cf2.a) {
            l2 += this.d.a();
        }
        return l2;
    }

    public final void a(boolean bl2) {
        bf bf2 = bf2.a;
        bf2.a.a = bl2;
    }
}

