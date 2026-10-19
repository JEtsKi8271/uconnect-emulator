/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.bi;
import com.wirelesscar.ngtp.svc.api.Phone;

final class i {
    i() {
    }

    static Phone a(bi bi2) {
        int n2;
        Object object = bi2;
        object = ((bi)object).a.d();
        switch ((int)bi2.b.c()) {
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

    static bi a(Phone phone) {
        bi bi2;
        bi bi3 = bi2 = new bi();
        bi2.a.a(phone.getPhoneNumber());
        switch (phone.getType()) {
            case 0: {
                bi2.a(0L);
                break;
            }
            case 1: {
                bi2.a(1L);
                break;
            }
            case 2: {
                bi2.a(2L);
                break;
            }
            case 3: {
                bi2.a(3L);
                break;
            }
            default: {
                bi2.a(0L);
            }
        }
        return bi2;
    }
}

