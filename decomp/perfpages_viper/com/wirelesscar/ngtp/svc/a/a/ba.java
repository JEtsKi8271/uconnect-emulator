/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.d;
import com.wirelesscar.ngtp.svc.a.a.j;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public abstract class ba
extends d {
    protected abstract void a(n var1, int var2, long var3) throws o;

    protected abstract String a(n var1, int var2) throws o;

    protected abstract int a_() throws o;

    protected abstract void c() throws o;

    public final void a(n n2) throws o {
        int n3;
        Object object = n2;
        StringBuffer stringBuffer = new StringBuffer();
        do {
            int n4;
            Object object2 = n2;
            object = this;
            switch (((ba)object).c) {
                case 4: {
                    n4 = (int)((n)object2).c();
                    break;
                }
                case 1: {
                    n4 = (int)((ba)object).e + 1;
                    break;
                }
                default: {
                    n4 = n3 = (int)(((ba)object).d + ((n)object2).b(ba.a(((ba)object).d, ((ba)object).e)));
                }
            }
            if (n4 <= 0 || (object2 = this.a(n2, n3)) == null) continue;
            stringBuffer.append((String)object2);
        } while (n3 >= 16384);
        this.a = stringBuffer.toString();
        n n5 = n2;
    }

    public final void b(n n2) throws o {
        if (this.a == null) {
            throw new o("Cannot encode null value", 0);
        }
        this.c();
        int n3 = this.a.length();
        long l2 = n3;
        while (l2 >= 0L) {
            long l3;
            long l4;
            long l5 = l2;
            n n4 = n2;
            ba ba2 = this;
            int n5 = (int)l5;
            if (ba2.c == 4) {
                l4 = n4.a((long)n5);
            } else {
                if (ba2.c != 1) {
                    if ((long)n5 > ba2.e || (long)n5 < ba2.d) {
                        throw new o("String is out of range. Expected (" + ba2.d + ".." + ba2.e + ") characters but was " + n5, 0);
                    }
                    n4.a((long)n5 - ba2.d, ba.a(ba2.d, ba2.e));
                } else {
                    int n6 = (int)ba2.e + 1;
                    if (n5 != n6) {
                        throw new o("String is out of range. Expected " + n6 + " characters but was " + n5, 0);
                    }
                }
                l4 = l3 = (long)n5;
            }
            if (l4 > 0L) {
                this.a(n2, (int)((long)n3 - l2), l3);
                if ((l2 -= l3) != 0L || l3 >= 16384L) continue;
            }
            l2 = -1L;
        }
    }

    public final long b() {
        int n2;
        try {
            n2 = this.a_();
        }
        catch (o o2) {
            throw new j(o2.getMessage(), o2);
        }
        switch (this.c) {
            case 4: {
                try {
                    return n.b(this.a.length()) + (long)n2;
                }
                catch (o o3) {
                    throw new j(o3.getMessage(), o3);
                }
            }
            case 1: {
                return n2;
            }
        }
        return ba.a(this.d, this.e) + n2;
    }
}

