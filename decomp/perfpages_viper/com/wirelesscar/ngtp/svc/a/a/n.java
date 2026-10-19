/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.o;

public final class n {
    private int a = 0;
    private boolean b = false;
    private int c = 8;
    private byte[] d = null;

    public n() {
        this.d = new byte[1024];
    }

    public n(int n2) {
        this.d = new byte[n2];
    }

    public n(byte[] byArray) {
        this.d = byArray;
    }

    public final byte[] a() {
        int n2 = this.a;
        if (this.c != 8) {
            ++n2;
        }
        byte[] byArray = new byte[n2];
        for (int i2 = 0; i2 < n2; ++i2) {
            byArray[i2] = this.d[i2];
        }
        return byArray;
    }

    private int d() {
        return (this.d.length << 3) - ((this.a << 3) + (8 - this.c));
    }

    private void e() {
        if (this.c == 0) {
            this.c = 8;
            ++this.a;
        }
    }

    final void a(byte by2, int n2) throws o {
        while (true) {
            if (this.d() < n2) {
                throw new o("Buffer full!", 0);
            }
            byte by3 = (byte)(-1 << n2);
            by2 = (byte)(by2 & ~by3);
            if (n2 <= this.c) {
                by2 = (byte)(by2 << this.c - n2);
                int n3 = this.a;
                this.d[n3] = (byte)(this.d[n3] | by2);
                this.c -= n2;
                this.e();
                return;
            }
            int n4 = n2 - this.c;
            n2 = (byte)(by2 >> n2 - this.c);
            this.a((byte)n2, this.c);
            by3 = (byte)(-1 << n4);
            n2 = n4;
            by2 = (byte)(by2 & ~by3);
        }
    }

    final void a(byte by2) throws o {
        if (this.d() < 8) {
            throw new o("Buffer full!", 0);
        }
        if (this.c == 8) {
            this.d[this.a++] = by2;
            return;
        }
        this.a(by2, 8);
    }

    final byte a(int n2) throws o {
        byte by2;
        if (this.d() < n2) {
            throw new o("Not enough bits in buffer (" + n2 + ">" + this.d() + ")!", 0);
        }
        if (n2 <= this.c) {
            by2 = this.d[this.a];
            by2 = (byte)(by2 >> this.c - n2);
            byte by3 = (byte)(-1 << n2);
            by2 = (byte)(by2 & ~by3);
            this.c -= n2;
            this.e();
        } else {
            int n3 = n2 - this.c;
            by2 = this.a(this.c);
            by2 = (byte)(by2 << n3);
            byte by4 = this.a(n3);
            by2 = (byte)(by2 | by4);
        }
        return by2;
    }

    final byte b() throws o {
        if (this.d() < 8) {
            throw new o("Not enough bits in buffer (8>" + this.d() + ")!", 0);
        }
        if (this.c == 8) {
            return this.d[this.a++];
        }
        return this.a(8);
    }

    final long b(int n2) throws o {
        long l2 = 0L;
        while (n2 > 0) {
            if (n2 < 8) {
                l2 = (l2 << n2) + (long)this.a(n2);
                n2 = 0;
                continue;
            }
            int n3 = this.b();
            l2 = (l2 << 8) + (long)((n3 & 0x80) == 0 ? n3 : (n3 & 0x7F) + 128);
            n2 -= 8;
        }
        return l2;
    }

    final long c() throws o {
        byte by2 = this.a(1);
        if (by2 == 0) {
            return this.b(7);
        }
        by2 = this.a(1);
        if (by2 == 0) {
            return this.b(14);
        }
        long l2 = this.b(6);
        return l2 << 14;
    }

    final long a(long l2) throws o {
        if (l2 < 0L) {
            throw new o("The count in length determinant cannot be negative (" + l2 + ")", 0);
        }
        if (l2 < 128L) {
            this.a((byte)0, 1);
            this.a(l2, 7);
            return l2;
        }
        if (l2 < 16384L) {
            this.a((byte)1, 1);
            this.a((byte)0, 1);
            this.a(l2, 14);
            return l2;
        }
        this.a((byte)1, 1);
        this.a((byte)1, 1);
        int n2 = n.c(l2);
        this.a((byte)n2, 6);
        return (long)n2 << 14;
    }

    private static int c(long l2) {
        return Math.min(4, (int)(l2 / 16384L));
    }

    static long b(long l2) throws o {
        if (l2 < 128L) {
            return 8L;
        }
        if (l2 < 16384L) {
            return 16L;
        }
        int n2 = n.c(l2);
        return 8L + n.b(l2 - (long)(n2 << 14));
    }

    final void a(long l2, int n2) throws o {
        if (n2 <= 0) {
            return;
        }
        long l3 = -1L << n2 ^ 0xFFFFFFFFFFFFFFFFL;
        if (l2 != (l2 & l3)) {
            throw new o("Integer value too big (" + l2 + ")!", 0);
        }
        while (n2 > 8) {
            l3 = 255L << n2 - 8;
            byte by2 = (byte)((l2 & l3) >> n2 - 8);
            this.a(by2);
            n2 -= 8;
        }
        l3 = (-1L << n2 ^ 0xFFFFFFFFFFFFFFFFL) & 0xFFL;
        byte by3 = (byte)(l2 & l3);
        this.a(by3, n2);
    }
}

