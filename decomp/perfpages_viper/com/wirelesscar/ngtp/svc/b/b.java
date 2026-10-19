/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b;

import com.wirelesscar.ngtp.svc.api.RoRequest;
import com.wirelesscar.ngtp.svc.api.SimpleRo;

public abstract class b
implements RoRequest {
    public SimpleRo a;
    private boolean b;
    private boolean c;
    private int d;
    private int e;
    private int f;
    private int g;
    private Integer h;

    public b(boolean bl2, boolean bl3, int n2, int n3, int n4, int n5, Integer n6, SimpleRo simpleRo) {
        this.b = bl2;
        this.c = bl3;
        this.d = n2;
        this.e = n3;
        this.f = n4;
        this.g = n5;
        this.h = n6;
        this.a = simpleRo;
    }

    public SimpleRo getOperationDesc() {
        return this.a;
    }

    public boolean stopIfFail() {
        return this.b;
    }

    public boolean waitForPreviousCommand() {
        return this.c;
    }

    public int getOperationTimeout() {
        return this.d;
    }

    public int getInitialWaitTime() {
        return this.e;
    }

    public int getFrequency() {
        return this.f;
    }

    public int getOccurs() {
        return this.g;
    }

    public boolean existsRequiredVehicleStates() {
        return this.h != null;
    }

    public Integer getRequiredVehicleStates() {
        return this.h;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SimpleRoImpl").append(" [");
        stringBuffer.append("operationDesc=").append(this.a);
        stringBuffer.append(", stopIfFail=").append(this.b);
        stringBuffer.append(", waitForPreviousCommand=").append(this.c);
        stringBuffer.append(", operationTimeout=").append(this.d);
        stringBuffer.append(", initialWaitTime=").append(this.e);
        stringBuffer.append(", occurs=").append(this.g);
        stringBuffer.append(", frequency=").append(this.f);
        stringBuffer.append(", requiredVehicleStates=").append(this.h);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

