/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ac;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bk;
import com.wirelesscar.ngtp.svc.a.c.c;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.z;

public final class e
extends bk {
    public e() {
        this.b(2);
    }

    public final ap a() throws j {
        switch (c2.d) {
            case 0: {
                c c2 = new z();
                c2.a(0L, 255L);
                break;
            }
            case 1: {
                c c2 = new ac();
                c2.a(0L, 255L);
                break;
            }
            default: {
                throw new j("Undefined Choice value ( " + c2.d + " ) in type I18NString", 0);
            }
        }
        return c2;
    }
}

