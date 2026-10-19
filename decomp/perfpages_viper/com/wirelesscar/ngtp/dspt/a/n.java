/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.f;
import com.wirelesscar.ngtp.dspt.a.h;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.p;
import com.wirelesscar.ngtp.dspt.a.w;

public final class n
extends f {
    public n() {
        this.a(2);
    }

    public final m a() throws w {
        switch (m2.d) {
            case 0: {
                m m2 = new h();
                break;
            }
            case 1: {
                m m2 = new p();
                m2.a(17L);
                break;
            }
            default: {
                throw new w("Undefined Choice value ( " + m2.d + " ) in type VehicleIdentification", 0);
            }
        }
        return m2;
    }

    public final h c() throws w {
        if (this.d != 0 || this.e == null) {
            throw new w("The ASNChoice is not of the requested type", 0);
        }
        return (h)this.e;
    }

    public final void d() throws w {
        if (this.d != 0 || this.e == null) {
            this.b(0);
        }
    }
}

