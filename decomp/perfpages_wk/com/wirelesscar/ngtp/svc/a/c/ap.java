/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;

public class ap {
    public void a(u u2) throws j {
    }

    public void b(u u2) throws j {
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

    static int b(long l2, long l3) {
        return ap.c(l3 - l2 + 1L);
    }

    ap a() throws j {
        return new ap();
    }
}

