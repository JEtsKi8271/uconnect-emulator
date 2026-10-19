/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ag;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.b.d;

final class i
extends d {
    i(ag ag2) {
        String string;
        ap ap2 = ag2;
        String string2 = ap2.b.e();
        ap2 = ag2;
        int n2 = (int)ap2.c.c();
        ap2 = ag2;
        ap2 = ap2.a;
        if (((aa)ap2).d) {
            ap2 = ag2;
            string = ap2.d.e();
        } else {
            string = null;
        }
        super(string2, n2, string);
    }

    i(String string, int n2, String string2) {
        super(string, n2, string2);
    }

    final ag a() {
        ag ag2;
        ag ag3 = ag2 = new ag();
        ag2.b.a(this.getComponent());
        long l2 = this.getRemoteOperationType();
        ag3 = ag2;
        ag3.c.b(l2);
        if (this.getState() != null) {
            ag3 = ag2;
            ag3.d.a(this.getState());
            ag2.a(true);
        } else {
            ag2.a(false);
        }
        return ag2;
    }
}

