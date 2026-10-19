/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bg;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.b.b;
import com.wirelesscar.ngtp.svc.b.c.g;

final class f
extends b {
    f(bg bg2) {
        Integer n2;
        bf bf2 = bg2;
        bf2 = bf2.c;
        boolean bl2 = ((cf)bf2).a;
        bf2 = bg2;
        bf2 = bf2.d;
        boolean bl3 = ((cf)bf2).a;
        bf2 = bg2;
        int n3 = (int)bf2.e.c();
        bf2 = bg2;
        int n4 = (int)bf2.h.c();
        bf2 = bg2;
        int n5 = (int)bf2.f.c();
        bf2 = bg2;
        int n6 = (int)bf2.g.c();
        bf2 = bg2;
        bf2 = bf2.a;
        if (((cf)bf2).a) {
            bf2 = bg2;
            n2 = new Integer((int)bf2.i.c());
        } else {
            n2 = null;
        }
        bf2 = bg2;
        super(bl2, bl3, n3, n4, n5, n6, n2, new g(bf2.b));
    }

    f(boolean bl2, boolean bl3, int n2, int n3, int n4, int n5, Integer n6) {
        super(bl2, bl3, n2, n3, n4, n5, n6, null);
    }

    public final void addOperationDescription(String object, int n2, String string) {
        v0.a = object = new g((String)object, n2, string);
    }
}

