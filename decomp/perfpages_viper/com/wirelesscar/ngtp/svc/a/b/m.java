/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bp;

public class m
extends bp {
    protected int a = -1;
    protected bf b = null;
    private bo f = null;

    public bf b() throws ai {
        return new m();
    }

    public final int g() {
        return this.a;
    }

    public final void b(bd bd2) throws ai {
        if ((long)this.a < this.d || (long)this.a > this.e) {
            throw new ai("Illegal choice value", 0);
        }
        bd2.a(this.a, m.a(this.d, this.e));
        this.b.b(bd2);
    }

    public final void a(bd bd2) throws ai {
        bd bd3 = bd2;
        this.a((int)bd2.b(m.a(this.d, this.e)));
        this.b.a(bd2);
        bd3 = bd2;
    }

    public final void a(int n2) throws ai {
        if ((long)n2 < this.d || (long)n2 > this.e) {
            throw new ai("Choice value: " + n2 + " must be between " + this.d + " - " + this.e, 0);
        }
        this.a = n2;
        this.b = this.b();
    }

    public final long a() {
        long l2 = 0L;
        l2 = 0L + (long)m.a(this.d, this.e);
        if (this.b != null) {
            l2 += this.b.a();
        }
        return l2;
    }
}

