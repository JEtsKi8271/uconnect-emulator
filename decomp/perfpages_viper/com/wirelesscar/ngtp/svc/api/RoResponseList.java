/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.RoResponse;
import com.wirelesscar.ngtp.svc.api.Version;
import java.util.Date;

public interface RoResponseList {
    public RoResponse addRemoteServiceResponse(int var1, Date var2, String var3);

    public Version getOperationScriptVersion();

    public boolean existsTimesExecuted();

    public Integer getTimesExecuted();

    public boolean existsLastExecuted();

    public Date getLastExecuted();

    public RoResponse[] getRemoteOperationResponse();
}

