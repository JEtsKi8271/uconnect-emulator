/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.ar;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.cm;

public abstract class an
extends cm {
    protected abstract void a(bd var1, int var2, long var3) throws ai;

    protected abstract String a(bd var1, int var2) throws ai;

    protected abstract int c() throws ai;

    protected abstract void d() throws ai;

    public final void a(bd bd2) throws ai {
        int n2;
        Object object = bd2;
        StringBuffer stringBuffer = new StringBuffer();
        do {
            int n3;
            Object object2 = bd2;
            object = this;
            switch (((an)object).c) {
                case 4: {
                    n3 = (int)((bd)object2).c();
                    break;
                }
                case 1: {
                    n3 = (int)((an)object).e + 1;
                    break;
                }
                default: {
                    n3 = n2 = (int)(((an)object).d + ((bd)object2).b(an.a(((an)object).d, ((an)object).e)));
                }
            }
            if (n3 <= 0 || (object2 = this.a(bd2, n2)) == null) continue;
            stringBuffer.append((String)object2);
        } while (n2 >= 16384);
        this.a = stringBuffer.toString();
        bd bd3 = bd2;
    }

    public final void b(bd bd2) throws ai {
        if (this.a == null) {
            throw new ai("Cannot encode null value", 0);
        }
        this.d();
        int n2 = this.a.length();
        long l2 = n2;
        while (l2 >= 0L) {
            long l3;
            long l4;
            long l5 = l2;
            bd bd3 = bd2;
            an an2 = this;
            int n3 = (int)l5;
            if (an2.c == 4) {
                l4 = bd3.a((long)n3);
            } else {
                if (an2.c != 1) {
                    if ((long)n3 > an2.e || (long)n3 < an2.d) {
                        throw new ai("String is out of range. Expected (" + an2.d + ".." + an2.e + ") characters but was " + n3, 0);
                    }
                    bd3.a((long)n3 - an2.d, an.a(an2.d, an2.e));
                } else {
                    int n4 = (int)an2.e + 1;
                    if (n3 != n4) {
                        throw new ai("String is out of range. Expected " + n4 + " characters but was " + n3, 0);
                    }
                }
                l4 = l3 = (long)n3;
            }
            if (l4 > 0L) {
                this.a(bd2, (int)((long)n2 - l2), l3);
                if ((l2 -= l3) != 0L || l3 >= 16384L) continue;
            }
            l2 = -1L;
        }
    }

    public final long a() {
        int n2;
        try {
            n2 = this.c();
        }
        catch (ai ai2) {
            throw new ar(ai2.getMessage(), ai2);
        }
        switch (this.c) {
            case 4: {
                try {
                    return bd.b(this.a.length()) + (long)n2;
                }
                catch (ai ai3) {
                    throw new ar(ai3.getMessage(), ai3);
                }
            }
            case 1: {
                return n2;
            }
        }
        return an.a(this.d, this.e) + n2;
    }
}

