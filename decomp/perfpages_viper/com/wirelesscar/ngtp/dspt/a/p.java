/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.a;

import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.z;
import java.io.UnsupportedEncodingException;

public final class p
extends z {
    public final m a() throws w {
        return new p();
    }

    protected final void a(q q2, int n2) throws w {
        StringBuffer stringBuffer = new StringBuffer(n2);
        for (int i2 = 0; i2 < n2; ++i2) {
            char c2 = q2.a(7);
            c2 = (char)(c2 & 0xFF);
            stringBuffer.append(c2);
        }
        this.d = stringBuffer.toString();
    }

    protected final void c(q q2) throws w {
        try {
            Object object = ((p)object).d.getBytes("US-ASCII");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new w(unsupportedEncodingException.getMessage());
        }
        for (int i2 = 0; i2 < ((Object)object).length; ++i2) {
            q2.a((byte)object[i2], 7);
        }
    }

    protected final void b() throws w {
        for (int i2 = 0; i2 < this.d.length(); ++i2) {
            char c2 = this.d.charAt(i2);
            if ("ABCDEFGHIJLKMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '()+,-./:=?".indexOf(c2) != -1) continue;
            throw new w("Value contains character not allowed in PrintableString: '" + this.d.charAt(i2) + "'", 0);
        }
    }
}

