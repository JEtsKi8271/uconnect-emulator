/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bg;
import com.wirelesscar.ngtp.svc.a.a.cj;
import com.wirelesscar.ngtp.svc.a.a.cp;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class bx
extends bg {
    public bx() {
        this.a(2);
    }

    public final aw a() throws o {
        switch (aw2.a) {
            case 0: {
                aw aw2 = new cp();
                break;
            }
            case 1: {
                aw aw2 = new cj();
                break;
            }
            default: {
                throw new o("Undefined Choice value ( " + aw2.a + " ) in type NGTPCore", 0);
            }
        }
        return aw2;
    }

    public final cp c() throws o {
        if (this.a != 0 || this.b == null) {
            throw new o("The ASNChoice is not of the requested type", 0);
        }
        return (cp)this.b;
    }

    public final void d() throws o {
        if (this.a != 0 || this.b == null) {
            this.b(0);
        }
    }

    public final cj e() throws o {
        if (this.a != 1 || this.b == null) {
            throw new o("The ASNChoice is not of the requested type", 0);
        }
        return (cj)this.b;
    }

    public final void g() throws o {
        if (this.a != 1 || this.b == null) {
            this.b(1);
        }
    }
}

