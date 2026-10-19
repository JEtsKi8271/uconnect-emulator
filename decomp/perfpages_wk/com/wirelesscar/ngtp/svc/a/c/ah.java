/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aj;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;
import java.io.UnsupportedEncodingException;

public class ah
extends aj {
    public final ap a() throws j {
        return new ah();
    }

    protected final void a(u u2, int n2) throws j {
        StringBuffer stringBuffer = new StringBuffer(n2);
        for (int i2 = 0; i2 < n2; ++i2) {
            char c2 = u2.a(7);
            c2 = (char)(c2 & 0xFF);
            stringBuffer.append(c2);
        }
        this.d = stringBuffer.toString();
    }

    protected final void c(u u2) throws j {
        try {
            Object object = ((ah)object).d.getBytes("US-ASCII");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new j(unsupportedEncodingException.getMessage());
        }
        for (int i2 = 0; i2 < ((Object)object).length; ++i2) {
            u2.a((byte)object[i2], 7);
        }
    }

    protected final int c() throws j {
        try {
            return this.d.getBytes("US-ASCII").length * 7;
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new j(unsupportedEncodingException.getMessage());
        }
    }

    protected final void d() throws j {
        for (int i2 = 0; i2 < this.d.length(); ++i2) {
            char c2 = this.d.charAt(i2);
            if ("ABCDEFGHIJLKMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '()+,-./:=?".indexOf(c2) != -1) continue;
            throw new j("Value contains character not allowed in PrintableString: '" + this.d.charAt(i2) + "'", 0);
        }
    }
}

