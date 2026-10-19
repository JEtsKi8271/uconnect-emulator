/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ad;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bc;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.b.a.i;
import com.wirelesscar.ngtp.svc.b.e;
import java.util.Date;

final class b
extends e {
    b(ad ad2) {
        String string;
        ap ap2 = ad2;
        int n2 = (int)ap2.c.c();
        ap2 = ad2;
        ap2 = ap2.d;
        Date date = NgtpUtil.ngtp2Date((int)((bc)ap2).a.c());
        ap2 = ad2;
        ap2 = ap2.a;
        if (((aa)ap2).d) {
            ap2 = ad2;
            string = ap2.e.e();
        } else {
            string = null;
        }
        ap2 = ad2;
        super(n2, date, string, new i(ap2.b));
    }

    b(int n2, Date date, String string) {
        super(n2, date, string, null);
    }

    public final void addOperationDescription(String object, int n2, String string) {
        v0.a = object = new i((String)object, n2, string);
    }
}

