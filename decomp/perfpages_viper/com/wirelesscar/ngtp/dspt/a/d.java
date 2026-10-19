/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.c;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.y;

public final class d
extends c {
    private y d = null;
    private long e = 0L;
    private byte[] f = null;

    public d() {
        this.a = 4;
    }

    public final m a() throws w {
        return new d();
    }

    public final void a(byte[] byArray) {
        if (this.a != 1) {
            this.e = byArray.length;
        }
        this.f = byArray;
    }

    public final byte[] b() {
        return this.f;
    }

    public final void a(int n2) {
        this.e = n2;
        super.a(n2);
    }

    public final void a(long l2) {
        this.e = l2;
        super.a(l2);
    }

    private void c(q q2) throws w {
        for (int i2 = 0; i2 < this.f.length; ++i2) {
            q2.a(this.f[i2]);
        }
    }

    public final void b(q q2) throws w {
        if (this.f == null) {
            throw new w("Cannot encode null value", 0);
        }
        q q3 = q2;
        d d2 = this;
        if (d2.a == 4) {
            q3.a((long)d2.f.length);
        } else if (d2.a != 1) {
            if ((long)d2.f.length > d2.c || (long)d2.f.length < d2.b) {
                throw new w("OctetString is out of range. Expected (" + d2.b + ".." + d2.c + ") octets but was " + d2.f.length, 0);
            }
            q3.a(d2.e - d2.b, com.wirelesscar.ngtp.dspt.a.d.b(d2.b, d2.c));
        } else if ((long)d2.f.length != d2.e) {
            throw new w("OctetString is out of range. Expected " + d2.e + " octets but was " + d2.f.length, 0);
        }
        this.c(q2);
    }

    private void d(q q2) throws w {
        this.f = new byte[(int)this.e];
        int n2 = 0;
        while ((long)n2 < this.e) {
            this.f[n2] = q2.b();
            ++n2;
        }
    }

    public final void a(q q2) throws w {
        Object object = q2;
        q q3 = q2;
        object = this;
        if (((d)object).a == 4) {
            ((d)object).e = q3.c();
        } else if (((d)object).a != 1) {
            ((d)object).e = ((d)object).b + q3.b(com.wirelesscar.ngtp.dspt.a.d.b(((d)object).b, ((d)object).c));
        }
        this.d(q2);
        object = q2;
    }

    static {
        char[] cArray = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    }
}

