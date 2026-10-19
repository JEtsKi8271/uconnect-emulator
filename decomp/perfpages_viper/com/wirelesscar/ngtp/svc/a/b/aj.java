/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.an;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.bf;
import java.io.UnsupportedEncodingException;

public final class aj
extends an {
    public final bf b() throws ai {
        return new aj();
    }

    protected final String a(bd bd2, int n2) throws ai {
        StringBuffer stringBuffer = new StringBuffer(n2);
        for (int i2 = 0; i2 < n2; ++i2) {
            char c2 = bd2.a(7);
            c2 = (char)(c2 & 0xFF);
            stringBuffer.append(c2);
        }
        return stringBuffer.toString();
    }

    protected final void a(bd bd2, int n2, long l2) throws ai {
        try {
            Object object = ((aj)object).a.getBytes("US-ASCII");
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new ai(unsupportedEncodingException.getMessage());
        }
        int n3 = 0;
        while ((long)n3 < l2) {
            bd2.a((byte)object[n2 + n3], 7);
            ++n3;
        }
    }

    protected final int c() throws ai {
        try {
            return this.a.getBytes("US-ASCII").length * 7;
        }
        catch (UnsupportedEncodingException unsupportedEncodingException) {
            throw new ai(unsupportedEncodingException.getMessage());
        }
    }

    protected final void d() throws ai {
        for (int i2 = 0; i2 < this.a.length(); ++i2) {
            char c2 = this.a.charAt(i2);
            if ("ABCDEFGHIJLKMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '()+,-./:=?".indexOf(c2) != -1) continue;
            throw new ai("Value contains character not allowed in PrintableString: '" + this.a.charAt(i2) + "'", 0);
        }
    }
}

