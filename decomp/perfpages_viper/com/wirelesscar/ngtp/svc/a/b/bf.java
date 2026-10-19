/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;

public class bf {
    public void b(bd bd2) throws ai {
    }

    public void a(bd bd2) throws ai {
    }

    public long a() {
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
        return bf.c(l3 - l2 + 1L);
    }

    bf b() throws ai {
        return new bf();
    }
}

