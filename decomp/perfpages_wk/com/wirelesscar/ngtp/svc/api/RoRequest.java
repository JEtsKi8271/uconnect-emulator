/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.SimpleRo;

public interface RoRequest {
    public void addOperationDescription(String var1, int var2, String var3);

    public SimpleRo getOperationDesc();

    public boolean stopIfFail();

    public boolean waitForPreviousCommand();

    public int getOperationTimeout();

    public int getFrequency();

    public int getOccurs();

    public int getInitialWaitTime();

    public boolean existsRequiredVehicleStates();

    public Integer getRequiredVehicleStates();
}

