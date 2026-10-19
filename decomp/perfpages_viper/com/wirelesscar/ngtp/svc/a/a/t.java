/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.cf;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.j;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;

public final class t
extends cf {
    private f a = null;
    private long b = 0L;
    private byte[] f = null;

    public t() {
        this.c = 4;
    }

    public final aw a() throws o {
        return new t();
    }

    public final void a(int n2) {
        this.b = n2;
        super.a(n2);
    }

    public final void b_(long l2) {
        this.b = l2;
        super.b_(l2);
    }

    private void a(n n2, int n3, long l2) throws o {
        int n4 = 0;
        while ((long)n4 < l2) {
            n2.a(this.f[n3 + n4]);
            ++n4;
        }
    }

    public final void b(n n2) throws o {
        if (this.f == null) {
            throw new o("Cannot encode null value", 0);
        }
        long l2 = this.b;
        while (l2 >= 0L) {
            long l3;
            long l4;
            long l5 = l2;
            n n3 = n2;
            t t2 = this;
            if (t2.c == 4) {
                l4 = n3.a(l5);
            } else {
                if (t2.c != 1) {
                    if ((long)t2.f.length > t2.e || (long)t2.f.length < t2.d) {
                        throw new o("OctetString is out of range. Expected (" + t2.d + ".." + t2.e + ") octets but was " + t2.f.length, 0);
                    }
                    n3.a(t2.b - t2.d, t.a(t2.d, t2.e));
                } else if ((long)t2.f.length != t2.b) {
                    throw new o("OctetString is out of range. Expected " + t2.b + " octets but was " + t2.f.length, 0);
                }
                l4 = l3 = t2.b;
            }
            if (l4 > 0L) {
                this.a(n2, (int)(this.b - l2), l3);
                if ((l2 -= l3) != 0L || l3 >= 16384L) continue;
            }
            l2 = -1L;
        }
    }

    private static byte[] a(n n2, int n3, byte[] byArray) throws o {
        int n4 = n3;
        int n5 = 0;
        if (byArray != null) {
            n4 = n3 + byArray.length;
            n5 = byArray.length;
        }
        byte[] byArray2 = new byte[n4];
        if (byArray != null) {
            System.arraycopy(byArray, 0, byArray2, 0, byArray.length);
        }
        for (int i2 = 0; i2 < n3; ++i2) {
            byArray2[n5 + i2] = n2.b();
        }
        return byArray2;
    }

    public final void a(n n2) throws o {
        int n3;
        n n4 = n2;
        long l2 = 0L;
        byte[] byArray = null;
        do {
            n n5 = n2;
            t t2 = this;
            long l3 = -1L;
            if (t2.c == 4) {
                l3 = n5.c();
            } else if (t2.c != 1) {
                l3 = t2.d + n5.b(t.a(t2.d, t2.e));
            } else if (t2.c == 1) {
                l3 = t2.b;
            }
            n3 = (int)l3;
            byArray = t.a(n2, n3, byArray);
            l2 += (long)n3;
        } while (n3 >= 16384);
        this.b = l2;
        this.f = byArray;
        n n6 = n2;
    }

    public final long b() {
        long l2 = super.b();
        if (this.c == 4) {
            try {
                l2 += n.b(this.f.length);
            }
            catch (o o2) {
                throw new j(o2.getMessage(), o2);
            }
        } else if (this.c != 1) {
            l2 += (long)t.a(this.d, this.e);
        }
        return l2 += (long)8 * this.b;
    }

    static {
        char[] cArray = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    }
}

