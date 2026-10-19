/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.ar;
import com.wirelesscar.ngtp.svc.a.c.as;
import com.wirelesscar.ngtp.svc.a.c.ba;
import com.wirelesscar.ngtp.svc.a.c.bc;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.bk;
import com.wirelesscar.ngtp.svc.a.c.f;
import com.wirelesscar.ngtp.svc.a.c.j;

public final class aw
extends bk {
    public aw() {
        this.b(21);
    }

    public final ap a() throws j {
        switch (ap2.d) {
            case 0: {
                ap ap2 = new ar();
                break;
            }
            case 1: {
                ap ap2 = new ar();
                break;
            }
            case 2: {
                ap ap2 = new as();
                break;
            }
            case 3: {
                ap ap2 = new bc();
                break;
            }
            case 4: {
                ap ap2 = new ba();
                ap2.a(0L, 1024L);
                break;
            }
            case 5: {
                ap ap2 = new bf();
                ap2.a(1L, 1000000L);
                break;
            }
            case 6: {
                ap ap2 = new bf();
                ap2.a(0L, 255L);
                break;
            }
            case 7: {
                ap ap2 = new bf();
                ap2.a(0L, 86400L);
                break;
            }
            case 8: {
                ap ap2 = new ar();
                break;
            }
            case 9: {
                ap ap2 = new ar();
                break;
            }
            case 10: {
                ap ap2 = new ar();
                break;
            }
            case 11: {
                ap ap2 = new ar();
                break;
            }
            case 12: {
                ap ap2 = new f();
                break;
            }
            case 13: {
                ap ap2 = new ar();
                break;
            }
            case 14: {
                ap ap2 = new ar();
                break;
            }
            case 15: {
                ap ap2 = new bf();
                ap2.a(0L, 100L);
                break;
            }
            case 16: {
                ap ap2 = new bf();
                ap2.a(0L, 100L);
                break;
            }
            case 17: {
                ap ap2 = new bf();
                ap2.a(-100L, 100L);
                break;
            }
            case 18: {
                ap ap2 = new bf();
                ap2.a(-100L, 100L);
                break;
            }
            case 19: {
                ap ap2 = new bf();
                ap2.a(-100L, 100L);
                break;
            }
            case 20: {
                ap ap2 = new bf();
                ap2.a(-100L, 100L);
                break;
            }
            default: {
                throw new j("Undefined Choice value ( " + ap2.d + " ) in type RemoteOperationTrigger", 0);
            }
        }
        return ap2;
    }

    public final void c() throws j {
        if (this.d != 0 || this.e == null) {
            this.a(0);
        }
    }

    public final void d() throws j {
        if (this.d != 1 || this.e == null) {
            this.a(1);
        }
    }

    public final bc e() throws j {
        if (this.d != 3 || this.e == null) {
            throw new j("The ASNChoice is not of the requested type", 0);
        }
        return (bc)this.e;
    }

    public final void a(bc bc2) {
        this.d = 3;
        this.e = bc2;
    }
}

