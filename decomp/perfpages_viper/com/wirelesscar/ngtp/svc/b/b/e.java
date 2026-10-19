/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bk;
import com.wirelesscar.ngtp.svc.b.b;
import com.wirelesscar.ngtp.svc.b.b.c;

final class e
extends b {
    e(bk bk2) {
        Integer n2;
        aw aw2 = bk2;
        aw2 = aw2.c;
        boolean bl2 = ((ap)aw2).a;
        aw2 = bk2;
        aw2 = aw2.d;
        boolean bl3 = ((ap)aw2).a;
        aw2 = bk2;
        int n3 = (int)aw2.e.c();
        aw2 = bk2;
        int n4 = (int)aw2.h.c();
        aw2 = bk2;
        int n5 = (int)aw2.f.c();
        aw2 = bk2;
        int n6 = (int)aw2.g.c();
        aw2 = bk2;
        aw2 = aw2.a;
        if (((ap)aw2).a) {
            aw2 = bk2;
            n2 = new Integer((int)aw2.i.c());
        } else {
            n2 = null;
        }
        aw2 = bk2;
        super(bl2, bl3, n3, n4, n5, n6, n2, new c(aw2.b));
    }

    e(boolean bl2, boolean bl3, int n2, int n3, int n4, int n5, Integer n6) {
        super(bl2, bl3, n2, n3, n4, n5, n6, null);
    }

    public final void addOperationDescription(String object, int n2, String string) {
        v0.a = object = new c((String)object, n2, string);
    }
}

