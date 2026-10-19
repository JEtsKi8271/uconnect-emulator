/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.ar;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bp;

public final class av
extends bp {
    private bo a = null;
    private long b = 0L;
    private byte[] f = null;

    public av() {
        this.c = 4;
    }

    public final bf b() throws ai {
        return new av();
    }

    public final void a_(int n2) {
        this.b = n2;
        super.a_(n2);
    }

    public final void a(long l2) {
        this.b = l2;
        super.a(l2);
    }

    private void a(bd bd2, int n2, long l2) throws ai {
        int n3 = 0;
        while ((long)n3 < l2) {
            bd2.a(this.f[n2 + n3]);
            ++n3;
        }
    }

    public final void b(bd bd2) throws ai {
        if (this.f == null) {
            throw new ai("Cannot encode null value", 0);
        }
        long l2 = this.b;
        while (l2 >= 0L) {
            long l3;
            long l4;
            long l5 = l2;
            bd bd3 = bd2;
            av av2 = this;
            if (av2.c == 4) {
                l4 = bd3.a(l5);
            } else {
                if (av2.c != 1) {
                    if ((long)av2.f.length > av2.e || (long)av2.f.length < av2.d) {
                        throw new ai("OctetString is out of range. Expected (" + av2.d + ".." + av2.e + ") octets but was " + av2.f.length, 0);
                    }
                    bd3.a(av2.b - av2.d, av.a(av2.d, av2.e));
                } else if ((long)av2.f.length != av2.b) {
                    throw new ai("OctetString is out of range. Expected " + av2.b + " octets but was " + av2.f.length, 0);
                }
                l4 = l3 = av2.b;
            }
            if (l4 > 0L) {
                this.a(bd2, (int)(this.b - l2), l3);
                if ((l2 -= l3) != 0L || l3 >= 16384L) continue;
            }
            l2 = -1L;
        }
    }

    private static byte[] a(bd bd2, int n2, byte[] byArray) throws ai {
        int n3 = n2;
        int n4 = 0;
        if (byArray != null) {
            n3 = n2 + byArray.length;
            n4 = byArray.length;
        }
        byte[] byArray2 = new byte[n3];
        if (byArray != null) {
            System.arraycopy(byArray, 0, byArray2, 0, byArray.length);
        }
        for (int i2 = 0; i2 < n2; ++i2) {
            byArray2[n4 + i2] = bd2.b();
        }
        return byArray2;
    }

    public final void a(bd bd2) throws ai {
        int n2;
        bd bd3 = bd2;
        long l2 = 0L;
        byte[] byArray = null;
        do {
            bd bd4 = bd2;
            av av2 = this;
            long l3 = -1L;
            if (av2.c == 4) {
                l3 = bd4.c();
            } else if (av2.c != 1) {
                l3 = av2.d + bd4.b(av.a(av2.d, av2.e));
            } else if (av2.c == 1) {
                l3 = av2.b;
            }
            n2 = (int)l3;
            byArray = av.a(bd2, n2, byArray);
            l2 += (long)n2;
        } while (n2 >= 16384);
        this.b = l2;
        this.f = byArray;
        bd bd5 = bd2;
    }

    public final long a() {
        long l2 = super.a();
        if (this.c == 4) {
            try {
                l2 += bd.b(this.f.length);
            }
            catch (ai ai2) {
                throw new ar(ai2.getMessage(), ai2);
            }
        } else if (this.c != 1) {
            l2 += (long)av.a(this.d, this.e);
        }
        return l2 += (long)8 * this.b;
    }

    static {
        char[] cArray = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    }
}

