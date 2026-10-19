/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.m;
import com.wirelesscar.ngtp.svc.a.b.p;
import com.wirelesscar.ngtp.svc.a.b.u;

public final class e
extends m {
    public e() {
        this.a_(2);
    }

    public final bf b() throws ai {
        switch (bf2.a) {
            case 0: {
                bf bf2 = new u();
                break;
            }
            case 1: {
                bf bf2 = new p();
                break;
            }
            default: {
                throw new ai("Undefined Choice value ( " + bf2.a + " ) in type NGTPCore", 0);
            }
        }
        return bf2;
    }

    public final u c() throws ai {
        if (this.a != 0 || this.b == null) {
            throw new ai("The ASNChoice is not of the requested type", 0);
        }
        return (u)this.b;
    }

    public final void d() throws ai {
        if (this.a != 0 || this.b == null) {
            this.a(0);
        }
    }

    public final p e() throws ai {
        if (this.a != 1 || this.b == null) {
            throw new ai("The ASNChoice is not of the requested type", 0);
        }
        return (p)this.b;
    }

    public final void f() throws ai {
        if (this.a != 1 || this.b == null) {
            this.a(1);
        }
    }
}

