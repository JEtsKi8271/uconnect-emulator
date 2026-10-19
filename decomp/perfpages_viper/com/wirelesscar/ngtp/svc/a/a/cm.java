/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.d;
import com.wirelesscar.ngtp.svc.a.a.j;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;
import java.io.UnsupportedEncodingException;

public final class cm
extends d {
    public final aw a() throws o {
        return new cm();
    }

    public final void a(n n2) throws o {
        int n3;
        Object object = null;
        do {
            n3 = (int)n2.c();
            n n4 = object;
            int n5 = n3;
            object = n2;
            int n6 = n5;
            int n7 = 0;
            if (n4 != null) {
                n6 = n5 + ((n)n4).length;
                n7 = ((n)n4).length;
            }
            byte[] byArray = new byte[n6];
            if (n4 != null) {
                System.arraycopy(n4, 0, byArray, 0, ((n)n4).length);
            }
            for (int i2 = 0; i2 < n5; ++i2) {
                byArray[n7 + i2] = ((n)object).b();
            }
            object = byArray;
        } while (n3 >= 16384);
        try {
            this.a = new String((byte[])object, "UTF-8");
            return;
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new o(unsupportedEncodingException.getMessage());
        }
    }

    public final void b(n n2) throws o {
        long l2;
        byte[] byArray;
        switch (this.c) {
            case 1: {
                int n3 = (int)this.e + 1;
                if (this.a.length() != n3) {
                    throw new o("String is out of range. Expected " + n3 + " characters but was " + this.a.length(), 0);
                }
            }
            case 4: {
                break;
            }
            default: {
                if ((long)this.a.length() <= this.e && (long)this.a.length() >= this.d) break;
                throw new o("String is out of range. Expected (" + this.d + ".." + this.e + ") characters but was " + this.a.length(), 0);
            }
        }
        try {
            byArray = this.a.getBytes("UTF-8");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new o(unsupportedEncodingException.getMessage());
        }
        int n4 = byArray.length;
        do {
            l2 = n2.a((long)n4);
            int n5 = byArray.length - n4;
            int n6 = 0;
            while ((long)n6 < l2) {
                n2.a(byArray[n5 + n6]);
                ++n6;
            }
        } while ((n4 = (int)((long)n4 - l2)) > 0);
    }

    public final long b() {
        try {
            Object object = ((cm)object).a.getBytes("UTF-8");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new j(unsupportedEncodingException.getMessage(), unsupportedEncodingException);
        }
        int n2 = ((Object)object).length << 3;
        try {
            return n.b(((Object)object).length) + (long)n2;
        }
        catch (o o2) {
            throw new j(o2.getMessage(), o2);
        }
    }
}

