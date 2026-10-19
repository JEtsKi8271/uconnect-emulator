/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.au;
import com.wirelesscar.ngtp.svc.b.a.i;
import com.wirelesscar.ngtp.svc.b.b;

final class d
extends b {
    d(au au2) {
        Integer n2;
        ap ap2 = au2;
        ap2 = ap2.c;
        boolean bl2 = ((aa)ap2).d;
        ap2 = au2;
        ap2 = ap2.d;
        boolean bl3 = ((aa)ap2).d;
        ap2 = au2;
        int n3 = (int)ap2.e.c();
        ap2 = au2;
        int n4 = (int)ap2.h.c();
        ap2 = au2;
        int n5 = (int)ap2.f.c();
        ap2 = au2;
        int n6 = (int)ap2.g.c();
        ap2 = au2;
        ap2 = ap2.a;
        if (((aa)ap2).d) {
            ap2 = au2;
            n2 = new Integer((int)ap2.i.c());
        } else {
            n2 = null;
        }
        ap2 = au2;
        super(bl2, bl3, n3, n4, n5, n6, n2, new i(ap2.b));
    }

    d(boolean bl2, boolean bl3, int n2, int n3, int n4, int n5, Integer n6) {
        super(bl2, bl3, n2, n3, n4, n5, n6, null);
    }

    public final void addOperationDescription(String object, int n2, String string) {
        v0.a = object = new i((String)object, n2, string);
    }
}

