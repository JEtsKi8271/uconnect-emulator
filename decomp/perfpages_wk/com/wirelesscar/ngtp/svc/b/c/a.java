/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.o;
import com.wirelesscar.ngtp.svc.api.Phone;

final class a {
    a() {
    }

    static Phone a(o o2) {
        int n2;
        Object object = o2;
        object = ((o)object).a.e();
        switch ((int)o2.b.c()) {
            case 0: {
                n2 = 0;
                break;
            }
            case 1: {
                n2 = 1;
                break;
            }
            case 2: {
                n2 = 2;
                break;
            }
            case 3: {
                n2 = 3;
                break;
            }
            default: {
                n2 = 0;
            }
        }
        return new Phone((String)object, n2);
    }

    static o a(Phone phone) {
        o o2;
        o o3 = o2 = new o();
        o2.a.a(phone.getPhoneNumber());
        switch (phone.getType()) {
            case 0: {
                o2.a(0L);
                break;
            }
            case 1: {
                o2.a(1L);
                break;
            }
            case 2: {
                o2.a(2L);
                break;
            }
            case 3: {
                o2.a(3L);
                break;
            }
            default: {
                o2.a(0L);
            }
        }
        return o2;
    }
}

