/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;

public class m {
    public void b(q q2) throws w {
    }

    public void a(q q2) throws w {
    }

    static int b(long l2, long l3) {
        long l4 = l3 - l2 + 1L;
        int n2 = 0;
        while (l4 > 1L << n2) {
            ++n2;
        }
        return n2;
    }

    m a() throws w {
        return new m();
    }
}

