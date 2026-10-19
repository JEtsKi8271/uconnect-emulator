/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.a;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.ba;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;
import java.io.UnsupportedEncodingException;

public final class a
extends ba {
    public final aw a() throws o {
        return new a();
    }

    protected final String a(n n2, int n3) throws o {
        StringBuffer stringBuffer = new StringBuffer(n3);
        for (int i2 = 0; i2 < n3; ++i2) {
            char c2 = n2.a(7);
            c2 = (char)(c2 & 0xFF);
            stringBuffer.append(c2);
        }
        return stringBuffer.toString();
    }

    protected final void a(n n2, int n3, long l2) throws o {
        try {
            Object object = ((a)object).a.getBytes("US-ASCII");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new o(unsupportedEncodingException.getMessage());
        }
        int n4 = 0;
        while ((long)n4 < l2) {
            n2.a((byte)object[n3 + n4], 7);
            ++n4;
        }
    }

    protected final int a_() throws o {
        try {
            return this.a.getBytes("US-ASCII").length * 7;
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new o(unsupportedEncodingException.getMessage());
        }
    }

    protected final void c() throws o {
        for (int i2 = 0; i2 < this.a.length(); ++i2) {
            char c2 = this.a.charAt(i2);
            if ("ABCDEFGHIJLKMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '()+,-./:=?".indexOf(c2) != -1) continue;
            throw new o("Value contains character not allowed in PrintableString: '" + this.a.charAt(i2) + "'", 0);
        }
    }
}

