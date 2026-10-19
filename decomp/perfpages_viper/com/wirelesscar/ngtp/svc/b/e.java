/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b;

import com.wirelesscar.ngtp.svc.api.RoResponse;
import com.wirelesscar.ngtp.svc.api.SimpleRo;
import java.util.Date;

public abstract class e
implements RoResponse {
    public SimpleRo a;
    private int b;
    private Date c;
    private String d;

    public e(int n2, Date date, String string, SimpleRo simpleRo) {
        this.b = n2;
        this.c = date;
        if (string != null) {
            this.d = string;
        }
        this.a = simpleRo;
    }

    public SimpleRo getOperationDesc() {
        return this.a;
    }

    public int getTimesExecuted() {
        return this.b;
    }

    public Date getLastExecuted() {
        return this.c;
    }

    public boolean existsErrorDesc() {
        return this.d != null;
    }

    public String getErrorDesc() {
        return this.d;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("RoResponseImpl").append(" [");
        stringBuffer.append("operationDesc").append(this.a);
        stringBuffer.append(", timesExecuted=").append(this.b);
        stringBuffer.append(", lastExecuted=").append(this.c);
        stringBuffer.append(", errorDesc=").append(this.d);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

