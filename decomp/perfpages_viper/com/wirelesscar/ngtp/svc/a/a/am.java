/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ab;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.as;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bg;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.c;
import com.wirelesscar.ngtp.svc.a.a.cm;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.p;
import com.wirelesscar.ngtp.svc.a.a.t;
import com.wirelesscar.ngtp.svc.a.a.y;

public final class am
extends bg {
    public am() {
        this.a(12);
    }

    public final aw a() throws o {
        switch (aw2.a) {
            case 0: {
                aw aw2 = new ap();
                break;
            }
            case 1: {
                aw aw2 = new t();
                aw2.b(0L, 65535L);
                break;
            }
            case 2: {
                aw aw2 = new cm();
                aw2.b(0L, 65535L);
                break;
            }
            case 3: {
                aw aw2 = new f();
                aw2.b(0L, 0xFFFFFFFFL);
                break;
            }
            case 4: {
                aw aw2 = new f();
                aw2.b(0L, 65535L);
                break;
            }
            case 5: {
                aw aw2 = new f();
                aw2.b(0L, 255L);
                break;
            }
            case 6: {
                aw aw2 = new bt();
                break;
            }
            case 7: {
                aw aw2 = new p();
                break;
            }
            case 8: {
                aw aw2 = new c();
                break;
            }
            case 9: {
                aw aw2 = new y();
                break;
            }
            case 10: {
                aw aw2 = new as();
                aw2.b(1L, 32L);
                break;
            }
            case 11: {
                aw aw2 = new ab();
                break;
            }
            default: {
                throw new o("Undefined Choice value ( " + aw2.a + " ) in type GenericParameterValue", 0);
            }
        }
        return aw2;
    }
}

