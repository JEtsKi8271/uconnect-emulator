/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.ai;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;

public abstract class z
extends ai {
    protected abstract void c(q var1) throws w;

    protected abstract void a(q var1, int var2) throws w;

    protected abstract void b() throws w;

    public final void a(q q2) throws w {
        int n2;
        Object object = q2;
        q q3 = q2;
        object = this;
        switch (((z)object).a) {
            case 4: {
                n2 = (int)q3.c();
                break;
            }
            case 1: {
                n2 = (int)((z)object).c + 1;
                break;
            }
            default: {
                n2 = (int)(((z)object).b + q3.b(z.b(((z)object).b, ((z)object).c)));
            }
        }
        int n3 = n2;
        this.a(q2, n3);
        q q4 = q2;
    }

    public final void b(q q2) throws w {
        if (this.d == null) {
            throw new w("Cannot encode null value", 0);
        }
        this.b();
        q q3 = q2;
        z z2 = this;
        int n2 = z2.d.length();
        if (z2.a == 4) {
            q3.a((long)n2);
        } else if (z2.a != 1) {
            if ((long)n2 > z2.c || (long)n2 < z2.b) {
                throw new w("String is out of range. Expected (" + z2.b + ".." + z2.c + ") characters but was " + n2, 0);
            }
            q3.a((long)n2 - z2.b, z.b(z2.b, z2.c));
        } else {
            int n3 = (int)z2.c + 1;
            if (n2 != n3) {
                throw new w("String is out of range. Expected " + n3 + " characters but was " + n2, 0);
            }
        }
        this.c(q2);
    }
}

