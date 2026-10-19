/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.an;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.b.b.c;
import com.wirelesscar.ngtp.svc.b.e;
import java.util.Date;

final class h
extends e {
    h(an an2) {
        String string;
        aw aw2 = an2;
        int n2 = (int)aw2.c.c();
        aw2 = an2;
        aw2 = aw2.d;
        Date date = NgtpUtil.ngtp2Date((int)((bt)aw2).a.c());
        aw2 = an2;
        aw2 = aw2.a;
        if (((ap)aw2).a) {
            aw2 = an2;
            string = aw2.e.d();
        } else {
            string = null;
        }
        aw2 = an2;
        super(n2, date, string, new c(aw2.b));
    }

    h(int n2, Date date, String string) {
        super(n2, date, string, null);
    }

    public final void addOperationDescription(String object, int n2, String string) {
        v0.a = object = new c((String)object, n2, string);
    }
}

