/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.t;
import com.wirelesscar.ngtp.svc.b.d;

final class g
extends d {
    g(t t2) {
        String string;
        bf bf2 = t2;
        String string2 = bf2.b.e();
        bf2 = t2;
        int n2 = (int)bf2.c.c();
        bf2 = t2;
        bf2 = bf2.a;
        if (((cf)bf2).a) {
            bf2 = t2;
            string = bf2.d.e();
        } else {
            string = null;
        }
        super(string2, n2, string);
    }

    g(String string, int n2, String string2) {
        super(string, n2, string2);
    }

    final t a() {
        t t2;
        t t3 = t2 = new t();
        t2.b.a(this.getComponent());
        long l2 = this.getRemoteOperationType();
        t3 = t2;
        t3.c.b(l2);
        if (this.getState() != null) {
            t3 = t2;
            t3.d.a(this.getState());
            t2.a(true);
        } else {
            t2.a(false);
        }
        return t2;
    }
}

