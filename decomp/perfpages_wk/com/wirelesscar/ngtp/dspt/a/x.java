/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.c;
import com.wirelesscar.ngtp.dspt.a.f;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.y;

public final class x
extends f {
    public x() {
        this.a(3);
    }

    public final m a() throws w {
        switch (c2.d) {
            case 0: {
                c c2 = new y();
                c2.a(0L, 255L);
                break;
            }
            case 1: {
                c c2 = new y();
                c2.a(0L, 65535L);
                break;
            }
            case 2: {
                c c2 = new y();
                c2.a(0L, 0xFFFFFFL);
                break;
            }
            default: {
                throw new w("Undefined Choice value ( " + c2.d + " ) in type MessageLength", 0);
            }
        }
        return c2;
    }

    public final long c() throws w {
        if (this.d != 0 || this.e == null) {
            throw new w("The ASNChoice is not of the requested type", 0);
        }
        return ((y)this.e).b();
    }

    public final void b(long l2) throws w {
        if (this.d != 0 || this.e == null) {
            this.b(0);
        }
        ((y)this.e).b(l2);
    }

    public final long d() throws w {
        if (this.d != 1 || this.e == null) {
            throw new w("The ASNChoice is not of the requested type", 0);
        }
        return ((y)this.e).b();
    }

    public final void c(long l2) throws w {
        if (this.d != 1 || this.e == null) {
            this.b(1);
        }
        ((y)this.e).b(l2);
    }

    public final long e() throws w {
        if (this.d != 2 || this.e == null) {
            throw new w("The ASNChoice is not of the requested type", 0);
        }
        return ((y)this.e).b();
    }

    public final void d(long l2) throws w {
        if (this.d != 2 || this.e == null) {
            this.b(2);
        }
        ((y)this.e).b(l2);
    }
}

