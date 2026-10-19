/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.ar;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.cm;
import java.io.UnsupportedEncodingException;

public final class ck
extends cm {
    public final bf b() throws ai {
        return new ck();
    }

    public final void a(bd bd2) throws ai {
        int n2;
        Object object = null;
        do {
            n2 = (int)bd2.c();
            bd bd3 = object;
            int n3 = n2;
            object = bd2;
            int n4 = n3;
            int n5 = 0;
            if (bd3 != null) {
                n4 = n3 + ((bd)bd3).length;
                n5 = ((bd)bd3).length;
            }
            byte[] byArray = new byte[n4];
            if (bd3 != null) {
                System.arraycopy(bd3, 0, byArray, 0, ((bd)bd3).length);
            }
            for (int i2 = 0; i2 < n3; ++i2) {
                byArray[n5 + i2] = ((bd)object).b();
            }
            object = byArray;
        } while (n2 >= 16384);
        try {
            this.a = new String((byte[])object, "UTF-8");
            return;
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new ai(unsupportedEncodingException.getMessage());
        }
    }

    public final void b(bd bd2) throws ai {
        long l2;
        byte[] byArray;
        switch (this.c) {
            case 1: {
                int n2 = (int)this.e + 1;
                if (this.a.length() != n2) {
                    throw new ai("String is out of range. Expected " + n2 + " characters but was " + this.a.length(), 0);
                }
            }
            case 4: {
                break;
            }
            default: {
                if ((long)this.a.length() <= this.e && (long)this.a.length() >= this.d) break;
                throw new ai("String is out of range. Expected (" + this.d + ".." + this.e + ") characters but was " + this.a.length(), 0);
            }
        }
        try {
            byArray = this.a.getBytes("UTF-8");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new ai(unsupportedEncodingException.getMessage());
        }
        int n3 = byArray.length;
        do {
            l2 = bd2.a((long)n3);
            int n4 = byArray.length - n3;
            int n5 = 0;
            while ((long)n5 < l2) {
                bd2.a(byArray[n4 + n5]);
                ++n5;
            }
        } while ((n3 = (int)((long)n3 - l2)) > 0);
    }

    public final long a() {
        try {
            Object object = ((ck)object).a.getBytes("UTF-8");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new ar(unsupportedEncodingException.getMessage(), unsupportedEncodingException);
        }
        int n2 = ((Object)object).length << 3;
        try {
            return bd.b(((Object)object).length) + (long)n2;
        }
        catch (ai ai2) {
            throw new ar(ai2.getMessage(), ai2);
        }
    }
}

