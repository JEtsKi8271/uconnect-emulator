/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.ar;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bp;

public class bo
extends bp {
    protected long b;

    public bo() {
        this.c = 5;
    }

    public bf b() throws ai {
        return new bo();
    }

    public long c() {
        return this.b;
    }

    public void b(long l2) {
        this.b = l2;
    }

    public void b(bd bd2) throws ai {
        if (this.c == 5 || this.c == 7) {
            if (this.c == 7 && this.b > this.e) {
                throw new ai("Integer is out of range. Expected value in range (MIN...." + this.e + ") but was " + this.b, 0);
            }
            throw new ai("Unbounded integer not supported!", 0);
        }
        if (this.c == 6) {
            if (this.b < this.d) {
                throw new ai("Integer is out of range. Expected value in range (" + this.d + "..MAX" + ") but was " + this.b, 0);
            }
            long l2 = this.b - this.d;
            int n2 = l2 > 0L ? (bo.a(0L, l2) + 7) / 8 : 1;
            bd2.a((long)n2);
            bd2.a(l2, n2 << 3);
            return;
        }
        if (this.b < this.d || this.b > this.e) {
            throw new ai("Integer is out of range. Expected value in range (" + this.d + ".." + this.e + ") but was " + this.b, 0);
        }
        bd2.a(this.b - this.d, bo.a(this.d, this.e));
    }

    public void a(bd bd2) throws ai {
        bd bd3 = bd2;
        if (((bo)object).c == 5 || ((bo)object).c == 7) {
            long l2 = bd2.c();
            Object object = new byte[(int)l2];
            for (int i2 = 0; i2 < ((Object)object).length; ++i2) {
                object[i2] = bd2.b();
            }
            throw new ai("Unbounded integer not supported!", 0);
        }
        if (((bo)object).c == 6) {
            long l3 = bd2.c();
            if (l3 > 0L) {
                ((bo)object).b = ((bo)object).d + bd2.b((int)l3 << 3);
            }
        } else {
            int n2 = bo.a(((bo)object).d, ((bo)object).e);
            if (n2 > 0) {
                ((bo)object).b = ((bo)object).d + bd2.b(n2);
            }
        }
        bd bd4 = bd2;
    }

    public long a() {
        if (this.c == 5 || this.c == 7) {
            throw new ar("Unbounded integer not supported!");
        }
        if (this.c == 6) {
            long l2 = this.b - this.d;
            int n2 = l2 > 0L ? (bo.c(l2) + 7) / 8 : 1;
            try {
                return super.a() + bd.b(n2) + (long)(n2 << 3);
            }
            catch (ai ai2) {
                throw new ar(ai2.getMessage(), ai2);
            }
        }
        return super.a() + (long)bo.a(this.d, this.e);
    }
}

