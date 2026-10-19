/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public class i
extends f {
    public aw[] b;
    private f f = null;

    public final void b(n n2) throws o {
        if (this.c == 2) {
            if ((long)this.b.length < this.d || (long)this.b.length > this.e) {
                throw new o("Array size breaks constraints low: " + this.d + " high: " + this.e + " actual size: " + this.b.length, 0);
            }
            n2.a((long)this.b.length - this.d, i.a(this.d, this.e));
        }
        for (int i2 = 0; i2 < this.b.length; ++i2) {
            this.b[i2].b(n2);
        }
    }

    public final void a(n n2) throws o {
        n n3 = n2;
        if (this.c == 2) {
            super.a(this.d + n2.b(i.a(this.d, this.e)));
        } else if (this.c == 1) {
            super.a(this.e + 1L);
        } else {
            super.a(((f)null).c());
        }
        this.b = new aw[(int)this.c()];
        for (int i2 = 0; i2 < (int)this.c(); ++i2) {
            aw aw2 = this.a();
            aw2.a(n2);
            this.b[i2] = aw2;
        }
        n n4 = n2;
    }

    public final long b() {
        long l2 = 0L;
        l2 = 0L + (long)i.a(this.d, this.e);
        for (int i2 = 0; i2 < this.b.length; ++i2) {
            l2 += this.b[i2].b();
        }
        return l2;
    }

    public final void b(long l2) throws o {
        if (this.c == 1 && l2 != this.e + 1L) {
            throw new o("Can not set size on fixed size array that differs from protocol definition", 0);
        }
        super.a(l2);
        this.b = new aw[(int)l2];
        for (int i2 = 0; i2 < (int)l2; ++i2) {
            this.b[i2] = this.a();
        }
    }

    public aw a() throws o {
        return new i();
    }
}

