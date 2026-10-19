/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b;

import com.wirelesscar.ngtp.svc.api.SimpleRo;

public class d
implements SimpleRo {
    private String a;
    private int b;
    private String c;

    public d(String string, int n2, String string2) {
        this.a = string;
        this.b = n2;
        this.c = string2 != null ? string2 : null;
    }

    public String getComponent() {
        return this.a;
    }

    public int getRemoteOperationType() {
        return this.b;
    }

    public boolean existsState() {
        return this.c != null;
    }

    public String getState() {
        return this.c;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SimpleRoImpl").append(" [");
        stringBuffer.append("component=").append(this.a);
        stringBuffer.append(", remoteOperationType=").append(this.b);
        stringBuffer.append(", state=").append(this.c);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

