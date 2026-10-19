/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.ae;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.k;
import com.wirelesscar.ngtp.svc.a.c.u;
import java.io.UnsupportedEncodingException;

public final class z
extends ae {
    public final ap a() throws j {
        return new z();
    }

    public final void b(u u2) throws j {
        int n2 = (int)u2.c();
        byte[] byArray = new byte[n2];
        for (int i2 = 0; i2 < n2; ++i2) {
            byArray[i2] = u2.b();
        }
        try {
            this.d = new String(byArray, "UTF-8");
            return;
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new j(unsupportedEncodingException.getMessage());
        }
    }

    public final void a(u u2) throws j {
        byte[] byArray;
        switch (this.a) {
            case 1: {
                int n2 = (int)this.c + 1;
                if (this.d.length() != n2) {
                    throw new j("String is out of range. Expected " + n2 + " characters but was " + this.d.length(), 0);
                }
            }
            case 4: {
                break;
            }
            default: {
                if ((long)this.d.length() <= this.c && (long)this.d.length() >= this.b) break;
                throw new j("String is out of range. Expected (" + this.b + ".." + this.c + ") characters but was " + this.d.length(), 0);
            }
        }
        try {
            byArray = this.d.getBytes("UTF-8");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new j(unsupportedEncodingException.getMessage());
        }
        u2.a((long)byArray.length);
        for (int i2 = 0; i2 < byArray.length; ++i2) {
            u2.a(byArray[i2]);
        }
    }

    public final long b() {
        try {
            Object object = ((z)object).d.getBytes("UTF-8");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new k(unsupportedEncodingException.getMessage(), unsupportedEncodingException);
        }
        int n2 = ((Object)object).length << 3;
        try {
            return u.b(((Object)object).length) + (long)n2;
        }
        catch (j j2) {
            throw new k(j2.getMessage(), j2);
        }
    }
}

