/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.PointOfInterest;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.SvcMessage;

public interface SvcDownlinkMessage
extends SvcMessage {
    public boolean isRemoteOperationUpdateRequest();

    public RoRequestList getRemoteOperationRequestList();

    public String getGenericText();

    public void setGenericText(String var1);

    public PointOfInterest[] getPointOfInterests();

    public void setPointOfInterests(PointOfInterest[] var1);
}

