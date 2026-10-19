/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public class af
extends bf {
    public ap[] d;
    private bf f = null;

    public final void a(u u2) throws j {
        if (this.a == 2) {
            if ((long)this.d.length < this.b || (long)this.d.length > this.c) {
                throw new j("Array size breaks constraints low: " + this.b + " high: " + this.c + " actual size: " + this.d.length, 0);
            }
            u2.a((long)this.d.length - this.b, af.b(this.b, this.c));
        }
        for (int i2 = 0; i2 < this.d.length; ++i2) {
            this.d[i2].a(u2);
        }
    }

    public final void b(u u2) throws j {
        u u3 = u2;
        if (this.a == 2) {
            super.b(this.b + u2.b(af.b(this.b, this.c)));
        } else if (this.a == 1) {
            super.b(this.c + 1L);
        } else {
            super.b(((bf)null).c());
        }
        this.d = new ap[(int)this.c()];
        for (int i2 = 0; i2 < (int)this.c(); ++i2) {
            ap ap2 = this.a();
            ap2.b(u2);
            this.d[i2] = ap2;
        }
        u u4 = u2;
    }

    public final long b() {
        long l2 = 0L;
        l2 = 0L + (long)af.b(this.b, this.c);
        for (int i2 = 0; i2 < this.d.length; ++i2) {
            l2 += this.d[i2].b();
        }
        return l2;
    }

    public final void a_(long l2) throws j {
        if (this.a == 1 && l2 != this.c + 1L) {
            throw new j("Can not set size on fixed size array that differs from protocol definition", 0);
        }
        super.b(l2);
        this.d = new ap[(int)l2];
        for (int i2 = 0; i2 < (int)l2; ++i2) {
            this.d[i2] = this.a();
        }
    }

    public ap a() throws j {
        return new af();
    }
}

