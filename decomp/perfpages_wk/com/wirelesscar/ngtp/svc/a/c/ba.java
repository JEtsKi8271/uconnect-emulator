/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.c;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.k;
import com.wirelesscar.ngtp.svc.a.c.u;

public final class ba
extends c {
    private bf d = null;
    private long e = 0L;
    private byte[] f = null;

    public ba() {
        this.a = 4;
    }

    public final ap a() throws j {
        return new ba();
    }

    public final void b(int n2) {
        this.e = n2;
        super.b(n2);
    }

    public final void a(long l2) {
        this.e = l2;
        super.a(l2);
    }

    private void c(u u2) throws j {
        for (int i2 = 0; i2 < this.f.length; ++i2) {
            u2.a(this.f[i2]);
        }
    }

    public final void a(u u2) throws j {
        if (this.f == null) {
            throw new j("Cannot encode null value", 0);
        }
        u u3 = u2;
        ba ba2 = this;
        if (ba2.a == 4) {
            u3.a((long)ba2.f.length);
        } else if (ba2.a != 1) {
            if ((long)ba2.f.length > ba2.c || (long)ba2.f.length < ba2.b) {
                throw new j("OctetString is out of range. Expected (" + ba2.b + ".." + ba2.c + ") octets but was " + ba2.f.length, 0);
            }
            u3.a(ba2.e - ba2.b, ba.b(ba2.b, ba2.c));
        } else if ((long)ba2.f.length != ba2.e) {
            throw new j("OctetString is out of range. Expected " + ba2.e + " octets but was " + ba2.f.length, 0);
        }
        this.c(u2);
    }

    private void d(u u2) throws j {
        this.f = new byte[(int)this.e];
        int n2 = 0;
        while ((long)n2 < this.e) {
            this.f[n2] = u2.b();
            ++n2;
        }
    }

    public final void b(u u2) throws j {
        Object object = u2;
        u u3 = u2;
        object = this;
        if (((ba)object).a == 4) {
            ((ba)object).e = u3.c();
        } else if (((ba)object).a != 1) {
            ((ba)object).e = ((ba)object).b + u3.b(ba.b(((ba)object).b, ((ba)object).c));
        }
        this.d(u2);
        object = u2;
    }

    public final long b() {
        long l2 = super.b();
        if (this.a == 4) {
            try {
                l2 += u.b(this.f.length);
            }
            catch (j j2) {
                throw new k(j2.getMessage(), j2);
            }
        } else if (this.a != 1) {
            l2 += (long)ba.b(this.b, this.c);
        }
        return l2 += (long)8 * this.e;
    }

    static {
        char[] cArray = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    }
}

