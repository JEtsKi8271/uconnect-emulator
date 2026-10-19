/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ab;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.be;
import com.wirelesscar.ngtp.svc.a.c.bk;
import com.wirelesscar.ngtp.svc.a.c.j;

public final class w
extends bk {
    public w() {
        this.b(2);
    }

    public final ap a() throws j {
        switch (ap2.d) {
            case 0: {
                ap ap2 = new be();
                break;
            }
            case 1: {
                ap ap2 = new ab();
                break;
            }
            default: {
                throw new j("Undefined Choice value ( " + ap2.d + " ) in type NGTPCore", 0);
            }
        }
        return ap2;
    }

    public final be c() throws j {
        if (this.d != 0 || this.e == null) {
            throw new j("The ASNChoice is not of the requested type", 0);
        }
        return (be)this.e;
    }

    public final void d() throws j {
        if (this.d != 0 || this.e == null) {
            this.a(0);
        }
    }

    public final ab e() throws j {
        if (this.d != 1 || this.e == null) {
            throw new j("The ASNChoice is not of the requested type", 0);
        }
        return (ab)this.e;
    }

    public final void f() throws j {
        if (this.d != 1 || this.e == null) {
            this.a(1);
        }
    }
}

