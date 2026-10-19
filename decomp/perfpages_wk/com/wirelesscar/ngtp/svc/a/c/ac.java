/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.c;

import com.wirelesscar.ngtp.svc.a.c.aj;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.u;
import java.io.UnsupportedEncodingException;

public final class ac
extends aj {
    public final ap a() throws j {
        return new ac();
    }

    protected final void c(u u2) throws j {
        try {
            Object object = ((ac)object).d.getBytes("UTF-16BE");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new j(unsupportedEncodingException.getMessage());
        }
        for (int i2 = 0; i2 < ((Object)object).length; ++i2) {
            u2.a((byte)object[i2]);
        }
    }

    protected final void a(u u2, int n2) throws j {
        StringBuffer stringBuffer = new StringBuffer(n2);
        for (int i2 = 0; i2 < n2; ++i2) {
            byte by2 = u2.b();
            char c2 = (char)(by2 & 0xFF);
            if ((by2 & 0x80) == 128) {
                by2 = u2.b();
                c2 = (char)(c2 << 8 | by2 & 0xFF);
            }
            stringBuffer.append(c2);
        }
        this.d = stringBuffer.toString();
    }

    protected final int c() throws j {
        try {
            return this.d.getBytes("UTF-16BE").length << 3;
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new j(unsupportedEncodingException.getMessage());
        }
    }

    protected final void d() throws j {
    }
}

