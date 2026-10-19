/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.RoRequest;
import com.wirelesscar.ngtp.svc.api.RoTrigger;
import com.wirelesscar.ngtp.svc.api.Version;

public interface RoRequestList {
    public RoRequest addRemoteOperationRequest(boolean var1, boolean var2, int var3, int var4, int var5, int var6, Integer var7);

    public Version getOperationScriptVersion();

    public RoTrigger getExecutionTrigger();

    public boolean existsName();

    public String getName();

    public boolean existsFrequency();

    public Integer getFrequency();

    public boolean existsOccurs();

    public Integer getOccurs();

    public RoRequest[] getRemoteOperations();
}

