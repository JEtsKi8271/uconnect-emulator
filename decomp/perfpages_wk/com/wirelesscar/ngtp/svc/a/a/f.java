/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.cf;
import com.wirelesscar.ngtp.svc.a.a.j;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public class f
extends cf {
    protected long a;

    public f() {
        this.c = 5;
    }

    public aw a() throws o {
        return new f();
    }

    public long c() {
        return this.a;
    }

    public void a(long l2) {
        this.a = l2;
    }

    public void b(n n2) throws o {
        if (this.c == 5 || this.c == 7) {
            if (this.c == 7 && this.a > this.e) {
                throw new o("Integer is out of range. Expected value in range (MIN...." + this.e + ") but was " + this.a, 0);
            }
            throw new o("Unbounded integer not supported!", 0);
        }
        if (this.c == 6) {
            if (this.a < this.d) {
                throw new o("Integer is out of range. Expected value in range (" + this.d + "..MAX" + ") but was " + this.a, 0);
            }
            long l2 = this.a - this.d;
            int n3 = l2 > 0L ? (f.a(0L, l2) + 7) / 8 : 1;
            n2.a((long)n3);
            n2.a(l2, n3 << 3);
            return;
        }
        if (this.a < this.d || this.a > this.e) {
            throw new o("Integer is out of range. Expected value in range (" + this.d + ".." + this.e + ") but was " + this.a, 0);
        }
        n2.a(this.a - this.d, f.a(this.d, this.e));
    }

    public void a(n n2) throws o {
        n n3 = n2;
        if (((f)object).c == 5 || ((f)object).c == 7) {
            long l2 = n2.c();
            Object object = new byte[(int)l2];
            for (int i2 = 0; i2 < ((Object)object).length; ++i2) {
                object[i2] = n2.b();
            }
            throw new o("Unbounded integer not supported!", 0);
        }
        if (((f)object).c == 6) {
            long l3 = n2.c();
            if (l3 > 0L) {
                ((f)object).a = ((f)object).d + n2.b((int)l3 << 3);
            }
        } else {
            int n4 = f.a(((f)object).d, ((f)object).e);
            if (n4 > 0) {
                ((f)object).a = ((f)object).d + n2.b(n4);
            }
        }
        n n5 = n2;
    }

    public long b() {
        if (this.c == 5 || this.c == 7) {
            throw new j("Unbounded integer not supported!");
        }
        if (this.c == 6) {
            long l2 = this.a - this.d;
            int n2 = l2 > 0L ? (f.c(l2) + 7) / 8 : 1;
            try {
                return super.b() + n.b(n2) + (long)(n2 << 3);
            }
            catch (o o2) {
                throw new j(o2.getMessage(), o2);
            }
        }
        return super.b() + (long)f.a(this.d, this.e);
    }
}

