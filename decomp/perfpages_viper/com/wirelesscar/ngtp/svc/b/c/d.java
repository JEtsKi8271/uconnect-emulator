/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.aw;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.b.c.g;
import com.wirelesscar.ngtp.svc.b.e;
import java.util.Date;

final class d
extends e {
    d(aw aw2) {
        String string;
        bf bf2 = aw2;
        int n2 = (int)bf2.c.c();
        bf2 = aw2;
        bf2 = bf2.d;
        Date date = NgtpUtil.ngtp2Date((int)((com.wirelesscar.ngtp.svc.a.b.g)bf2).a.c());
        bf2 = aw2;
        bf2 = bf2.a;
        if (((cf)bf2).a) {
            bf2 = aw2;
            string = bf2.e.e();
        } else {
            string = null;
        }
        bf2 = aw2;
        super(n2, date, string, new g(bf2.b));
    }

    d(int n2, Date date, String string) {
        super(n2, date, string, null);
    }

    public final void addOperationDescription(String object, int n2, String string) {
        v0.a = object = new g((String)object, n2, string);
    }
}

