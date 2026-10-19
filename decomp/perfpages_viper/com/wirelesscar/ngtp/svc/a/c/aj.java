/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ae;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.k;
import com.wirelesscar.ngtp.svc.a.c.u;

public abstract class aj
extends ae {
    protected abstract void c(u var1) throws j;

    protected abstract void a(u var1, int var2) throws j;

    protected abstract int c() throws j;

    protected abstract void d() throws j;

    public final void b(u u2) throws j {
        int n2;
        Object object = u2;
        u u3 = u2;
        object = this;
        switch (((aj)object).a) {
            case 4: {
                n2 = (int)u3.c();
                break;
            }
            case 1: {
                n2 = (int)((aj)object).c + 1;
                break;
            }
            default: {
                n2 = (int)(((aj)object).b + u3.b(aj.b(((aj)object).b, ((aj)object).c)));
            }
        }
        int n3 = n2;
        this.a(u2, n3);
        u u4 = u2;
    }

    public final void a(u u2) throws j {
        if (this.d == null) {
            throw new j("Cannot encode null value", 0);
        }
        this.d();
        u u3 = u2;
        aj aj2 = this;
        int n2 = aj2.d.length();
        if (aj2.a == 4) {
            u3.a((long)n2);
        } else if (aj2.a != 1) {
            if ((long)n2 > aj2.c || (long)n2 < aj2.b) {
                throw new j("String is out of range. Expected (" + aj2.b + ".." + aj2.c + ") characters but was " + n2, 0);
            }
            u3.a((long)n2 - aj2.b, aj.b(aj2.b, aj2.c));
        } else {
            int n3 = (int)aj2.c + 1;
            if (n2 != n3) {
                throw new j("String is out of range. Expected " + n3 + " characters but was " + n2, 0);
            }
        }
        this.c(u2);
    }

    public final long b() {
        int n2;
        try {
            n2 = this.c();
        }
        catch (j j2) {
            throw new k(j2.getMessage(), j2);
        }
        switch (this.a) {
            case 4: {
                try {
                    return u.b(this.d.length()) + (long)n2;
                }
                catch (j j3) {
                    throw new k(j3.getMessage(), j3);
                }
            }
            case 1: {
                return n2;
            }
        }
        return aj.b(this.b, this.c) + n2;
    }
}

