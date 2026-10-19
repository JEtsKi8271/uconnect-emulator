/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.ab;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bg;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.ca;
import com.wirelesscar.ngtp.svc.a.a.ch;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.t;

public final class e
extends bg {
    public e() {
        this.a(21);
    }

    public final aw a() throws o {
        switch (aw2.a) {
            case 0: {
                aw aw2 = new ab();
                break;
            }
            case 1: {
                aw aw2 = new ab();
                break;
            }
            case 2: {
                aw aw2 = new ch();
                break;
            }
            case 3: {
                aw aw2 = new bt();
                break;
            }
            case 4: {
                aw aw2 = new t();
                aw2.b(0L, 1024L);
                break;
            }
            case 5: {
                aw aw2 = new f();
                aw2.b(1L, 1000000L);
                break;
            }
            case 6: {
                aw aw2 = new f();
                aw2.b(0L, 255L);
                break;
            }
            case 7: {
                aw aw2 = new f();
                aw2.b(0L, 86400L);
                break;
            }
            case 8: {
                aw aw2 = new ab();
                break;
            }
            case 9: {
                aw aw2 = new ab();
                break;
            }
            case 10: {
                aw aw2 = new ab();
                break;
            }
            case 11: {
                aw aw2 = new ab();
                break;
            }
            case 12: {
                aw aw2 = new ca();
                break;
            }
            case 13: {
                aw aw2 = new ab();
                break;
            }
            case 14: {
                aw aw2 = new ab();
                break;
            }
            case 15: {
                aw aw2 = new f();
                aw2.b(0L, 100L);
                break;
            }
            case 16: {
                aw aw2 = new f();
                aw2.b(0L, 100L);
                break;
            }
            case 17: {
                aw aw2 = new f();
                aw2.b(-100L, 100L);
                break;
            }
            case 18: {
                aw aw2 = new f();
                aw2.b(-100L, 100L);
                break;
            }
            case 19: {
                aw aw2 = new f();
                aw2.b(-100L, 100L);
                break;
            }
            case 20: {
                aw aw2 = new f();
                aw2.b(-100L, 100L);
                break;
            }
            default: {
                throw new o("Undefined Choice value ( " + aw2.a + " ) in type RemoteOperationTrigger", 0);
            }
        }
        return aw2;
    }

    public final void c() throws o {
        if (this.a != 0 || this.b == null) {
            this.b(0);
        }
    }

    public final void d() throws o {
        if (this.a != 1 || this.b == null) {
            this.b(1);
        }
    }

    public final bt e() throws o {
        if (this.a != 3 || this.b == null) {
            throw new o("The ASNChoice is not of the requested type", 0);
        }
        return (bt)this.b;
    }

    public final void a(bt bt2) {
        this.a = 3;
        this.b = bt2;
    }
}

