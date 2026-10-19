/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bo;

public class ax
extends bo {
    public bf[] a;
    private bo f = null;

    public final void b(bd bd2) throws ai {
        if (this.c == 2) {
            if ((long)this.a.length < this.d || (long)this.a.length > this.e) {
                throw new ai("Array size breaks constraints low: " + this.d + " high: " + this.e + " actual size: " + this.a.length, 0);
            }
            bd2.a((long)this.a.length - this.d, ax.a(this.d, this.e));
        }
        for (int i2 = 0; i2 < this.a.length; ++i2) {
            this.a[i2].b(bd2);
        }
    }

    public final void a(bd bd2) throws ai {
        bd bd3 = bd2;
        if (this.c == 2) {
            super.b(this.d + bd2.b(ax.a(this.d, this.e)));
        } else if (this.c == 1) {
            super.b(this.e + 1L);
        } else {
            super.b(((bo)null).c());
        }
        this.a = new bf[(int)this.c()];
        for (int i2 = 0; i2 < (int)this.c(); ++i2) {
            bf bf2 = this.b();
            bf2.a(bd2);
            this.a[i2] = bf2;
        }
        bd bd4 = bd2;
    }

    public final long a() {
        long l2 = 0L;
        l2 = 0L + (long)ax.a(this.d, this.e);
        for (int i2 = 0; i2 < this.a.length; ++i2) {
            l2 += this.a[i2].a();
        }
        return l2;
    }

    public final void c_(long l2) throws ai {
        if (this.c == 1 && l2 != this.e + 1L) {
            throw new ai("Can not set size on fixed size array that differs from protocol definition", 0);
        }
        super.b(l2);
        this.a = new bf[(int)l2];
        for (int i2 = 0; i2 < (int)l2; ++i2) {
            this.a[i2] = this.b();
        }
    }

    public bf b() throws ai {
        return new ax();
    }
}

