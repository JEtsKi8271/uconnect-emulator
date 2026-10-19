/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.c;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.k;
import com.wirelesscar.ngtp.svc.a.c.u;

public class bf
extends c {
    protected long e;

    public bf() {
        this.a = 5;
    }

    public ap a() throws j {
        return new bf();
    }

    public long c() {
        return this.e;
    }

    public void b(long l2) {
        this.e = l2;
    }

    public void a(u u2) throws j {
        if (this.a == 5 || this.a == 7) {
            if (this.a == 7 && this.e > this.c) {
                throw new j("Integer is out of range. Expected value in range (MIN...." + this.c + ") but was " + this.e, 0);
            }
            throw new j("Unbounded integer not supported!", 0);
        }
        if (this.a == 6) {
            if (this.e < this.b) {
                throw new j("Integer is out of range. Expected value in range (" + this.b + "..MAX" + ") but was " + this.e, 0);
            }
            long l2 = this.e - this.b;
            int n2 = l2 > 0L ? (bf.b(0L, l2) + 7) / 8 : 1;
            u2.a((long)n2);
            u2.a(l2, n2 << 3);
            return;
        }
        if (this.e < this.b || this.e > this.c) {
            throw new j("Integer is out of range. Expected value in range (" + this.b + ".." + this.c + ") but was " + this.e, 0);
        }
        u2.a(this.e - this.b, bf.b(this.b, this.c));
    }

    public void b(u u2) throws j {
        u u3 = u2;
        if (((bf)object).a == 5 || ((bf)object).a == 7) {
            long l2 = u2.c();
            Object object = new byte[(int)l2];
            for (int i2 = 0; i2 < ((Object)object).length; ++i2) {
                object[i2] = u2.b();
            }
            throw new j("Unbounded integer not supported!", 0);
        }
        if (((bf)object).a == 6) {
            long l3 = u2.c();
            if (l3 > 0L) {
                ((bf)object).e = ((bf)object).b + u2.b((int)l3 << 3);
            }
        } else {
            int n2 = bf.b(((bf)object).b, ((bf)object).c);
            if (n2 > 0) {
                ((bf)object).e = ((bf)object).b + u2.b(n2);
            }
        }
        u u4 = u2;
    }

    public long b() {
        if (this.a == 5 || this.a == 7) {
            throw new k("Unbounded integer not supported!");
        }
        if (this.a == 6) {
            long l2 = this.e - this.b;
            int n2 = l2 > 0L ? (bf.c(l2) + 7) / 8 : 1;
            try {
                return super.b() + u.b(n2) + (long)(n2 << 3);
            }
            catch (j j2) {
                throw new k(j2.getMessage(), j2);
            }
        }
        return super.b() + (long)bf.b(this.b, this.c);
    }
}

