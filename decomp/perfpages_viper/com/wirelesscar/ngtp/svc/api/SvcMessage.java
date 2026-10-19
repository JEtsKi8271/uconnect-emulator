/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public interface SvcMessage {
    public Boolean getApplicationAck();

    public void setApplicationAck(Boolean var1);

    public boolean isApplicationAckRequired();

    public void setApplicationAckRequired(boolean var1);

    public boolean isServiceDataUpdateRequest();

    public void setServiceDataUpdateRequest(boolean var1);

    public boolean isServiceDataUpdateResponse();

    public void setServiceDataUpdateResponse(boolean var1);

    public boolean isTestCallFlag();

    public void setTestCallFlag(boolean var1);
}

