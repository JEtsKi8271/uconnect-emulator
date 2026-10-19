/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.c;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;

public class y
extends c {
    protected long d;

    public y() {
        this.a = 5;
    }

    public m a() throws w {
        return new y();
    }

    public long b() {
        return this.d;
    }

    public void b(long l2) {
        this.d = l2;
    }

    public void b(q q2) throws w {
        if (this.a == 5 || this.a == 7) {
            if (this.a == 7 && this.d > this.c) {
                throw new w("Integer is out of range. Expected value in range (MIN...." + this.c + ") but was " + this.d, 0);
            }
            throw new w("Unbounded integer not supported!", 0);
        }
        if (this.a == 6) {
            if (this.d < this.b) {
                throw new w("Integer is out of range. Expected value in range (" + this.b + "..MAX" + ") but was " + this.d, 0);
            }
            long l2 = this.d - this.b;
            int n2 = l2 > 0L ? (y.b(0L, l2) + 7) / 8 : 1;
            q2.a((long)n2);
            q2.a(l2, n2 << 3);
            return;
        }
        if (this.d < this.b || this.d > this.c) {
            throw new w("Integer is out of range. Expected value in range (" + this.b + ".." + this.c + ") but was " + this.d, 0);
        }
        q2.a(this.d - this.b, y.b(this.b, this.c));
    }

    public void a(q q2) throws w {
        q q3 = q2;
        if (((y)object).a == 5 || ((y)object).a == 7) {
            long l2 = q2.c();
            Object object = new byte[(int)l2];
            for (int i2 = 0; i2 < ((Object)object).length; ++i2) {
                object[i2] = q2.b();
            }
            throw new w("Unbounded integer not supported!", 0);
        }
        if (((y)object).a == 6) {
            long l3 = q2.c();
            if (l3 > 0L) {
                ((y)object).d = ((y)object).b + q2.b((int)l3 << 3);
            }
        } else {
            int n2 = y.b(((y)object).b, ((y)object).c);
            if (n2 > 0) {
                ((y)object).d = ((y)object).b + q2.b(n2);
            }
        }
        q q4 = q2;
    }
}

