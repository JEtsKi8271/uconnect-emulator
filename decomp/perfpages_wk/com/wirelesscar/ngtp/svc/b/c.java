/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b;

import com.wirelesscar.ngtp.svc.api.RoRequest;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.RoTrigger;
import com.wirelesscar.ngtp.svc.api.Version;
import java.util.Enumeration;
import java.util.Vector;

public abstract class c
implements RoRequestList {
    private Version b;
    public RoTrigger a;
    private String c;
    private Integer d;
    private Integer e;
    private Vector f;

    public c(Version version, String string, Integer n2, Integer n3) {
        this.b = version;
        this.c = string;
        this.d = n2;
        this.e = n3;
    }

    public Version getOperationScriptVersion() {
        return this.b;
    }

    public RoTrigger getExecutionTrigger() {
        return this.a;
    }

    public boolean existsName() {
        return this.c != null;
    }

    public String getName() {
        return this.c;
    }

    public boolean existsFrequency() {
        return this.d != null;
    }

    public Integer getFrequency() {
        return this.d;
    }

    public boolean existsOccurs() {
        return this.e != null;
    }

    public Integer getOccurs() {
        return this.e;
    }

    public final void a(RoRequest roRequest) {
        if (this.f == null) {
            this.f = new Vector();
        }
        this.f.addElement(roRequest);
    }

    public RoRequest[] getRemoteOperations() {
        Object[] objectArray = null;
        if (this.f != null) {
            objectArray = new RoRequest[this.f.size()];
            this.f.copyInto(objectArray);
        }
        return objectArray;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("RoRequestListImpl").append(" [");
        stringBuffer.append("operationScriptVersion=").append(((c)((Object)enumeration)).b);
        stringBuffer.append(", executionTrigger=").append(((c)((Object)enumeration)).a);
        stringBuffer.append(", name=").append(((c)((Object)enumeration)).c);
        stringBuffer.append(", frequency=").append(((c)((Object)enumeration)).d);
        stringBuffer.append(", occurs=").append(((c)((Object)enumeration)).e);
        if (((c)((Object)enumeration)).f != null && ((c)((Object)enumeration)).f.size() > 0) {
            stringBuffer.append(", remoteOperations={");
            Enumeration enumeration = ((c)((Object)enumeration)).f.elements();
            while (enumeration.hasMoreElements()) {
                stringBuffer.append(", remoteOperation=").append(enumeration.nextElement());
            }
            stringBuffer.append("}");
        } else {
            stringBuffer.append(", remoteOperations={null or empty}");
        }
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

