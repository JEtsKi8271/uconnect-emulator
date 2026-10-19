/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b;

import com.wirelesscar.ngtp.svc.api.RoResponse;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.Version;
import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;

public abstract class a
implements RoResponseList {
    private Version a;
    private Integer b;
    private Date c;
    private Vector d = null;

    public a(Version version, Integer n2, Date date) {
        this.a = version;
        this.b = n2;
        this.c = date;
    }

    public Version getOperationScriptVersion() {
        return this.a;
    }

    public boolean existsTimesExecuted() {
        return this.b != null;
    }

    public Integer getTimesExecuted() {
        return this.b;
    }

    public boolean existsLastExecuted() {
        return this.c != null;
    }

    public Date getLastExecuted() {
        return this.c;
    }

    public final void a(RoResponse roResponse) {
        if (this.d == null) {
            this.d = new Vector();
        }
        this.d.addElement(roResponse);
    }

    public RoResponse[] getRemoteOperationResponse() {
        Object[] objectArray = null;
        if (this.d != null) {
            objectArray = new RoResponse[this.d.size()];
            this.d.copyInto(objectArray);
        }
        return objectArray;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("RoResponseListImpl").append(" [");
        stringBuffer.append("operationScriptVersion=").append(((a)((Object)enumeration)).a);
        stringBuffer.append(", timesExecuted=").append(((a)((Object)enumeration)).b);
        stringBuffer.append(", lastExecuted=").append(((a)((Object)enumeration)).c);
        if (((a)((Object)enumeration)).d != null && ((a)((Object)enumeration)).d.size() > 0) {
            stringBuffer.append(", remoteOperationResponses={");
            Enumeration enumeration = ((a)((Object)enumeration)).d.elements();
            while (enumeration.hasMoreElements()) {
                stringBuffer.append("remoteOperationResponse=").append(enumeration.nextElement()).append(", ");
            }
            stringBuffer.append("}");
        } else {
            stringBuffer.append("remoteOperationResponses={null or empty}");
        }
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

