/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.b;
import com.wirelesscar.ngtp.svc.b.d;

final class c
extends d {
    c(b b2) {
        String string;
        aw aw2 = b2;
        String string2 = aw2.b.d();
        aw2 = b2;
        int n2 = (int)aw2.c.c();
        aw2 = b2;
        aw2 = aw2.a;
        if (((ap)aw2).a) {
            aw2 = b2;
            string = aw2.d.d();
        } else {
            string = null;
        }
        super(string2, n2, string);
    }

    c(String string, int n2, String string2) {
        super(string, n2, string2);
    }

    final b a() {
        b b2;
        b b3 = b2 = new b();
        b2.b.a(this.getComponent());
        long l2 = this.getRemoteOperationType();
        b3 = b2;
        b3.c.a(l2);
        if (this.getState() != null) {
            b3 = b2;
            b3.d.a(this.getState());
            b2.a(true);
        } else {
            b2.a(false);
        }
        return b2;
    }
}

