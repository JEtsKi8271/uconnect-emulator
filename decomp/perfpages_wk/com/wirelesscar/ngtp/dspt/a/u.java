/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.ab;
import com.wirelesscar.ngtp.dspt.a.ad;
import com.wirelesscar.ngtp.dspt.a.ag;
import com.wirelesscar.ngtp.dspt.a.f;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.w;

public final class u
extends f {
    public u() {
        this.a(3);
    }

    public final m a() throws w {
        switch (m2.d) {
            case 0: {
                m m2 = new ab();
                break;
            }
            case 1: {
                m m2 = new ad();
                break;
            }
            case 2: {
                m m2 = new ag();
                break;
            }
            default: {
                throw new w("Undefined Choice value ( " + m2.d + " ) in type NGTPDispatcherData", 0);
            }
        }
        return m2;
    }

    public final ab c() throws w {
        if (this.d != 0 || this.e == null) {
            throw new w("The ASNChoice is not of the requested type", 0);
        }
        return (ab)this.e;
    }

    public final void d() throws w {
        if (this.d != 0 || this.e == null) {
            this.b(0);
        }
    }

    public final ad e() throws w {
        if (this.d != 1 || this.e == null) {
            throw new w("The ASNChoice is not of the requested type", 0);
        }
        return (ad)this.e;
    }

    public final void f() throws w {
        if (this.d != 1 || this.e == null) {
            this.b(1);
        }
    }

    public final ag g() throws w {
        if (this.d != 2 || this.e == null) {
            throw new w("The ASNChoice is not of the requested type", 0);
        }
        return (ag)this.e;
    }

    public final void h() throws w {
        if (this.d != 2 || this.e == null) {
            this.b(2);
        }
    }
}

