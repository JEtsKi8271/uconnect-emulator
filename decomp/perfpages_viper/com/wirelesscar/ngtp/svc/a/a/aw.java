/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public class aw {
    public void b(n n2) throws o {
    }

    public void a(n n2) throws o {
    }

    public long b() {
        return 0L;
    }

    static int c(long l2) {
        int n2 = 0;
        while (l2 > 1L << n2) {
            ++n2;
        }
        return n2;
    }

    static int a(long l2, long l3) {
        return aw.c(l3 - l2 + 1L);
    }

    aw a() throws o {
        return new aw();
    }
}

