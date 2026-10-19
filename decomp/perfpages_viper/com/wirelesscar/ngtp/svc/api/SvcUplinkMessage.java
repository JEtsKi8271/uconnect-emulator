/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcMessage;
import com.wirelesscar.ngtp.svc.api.VehicleStatus;
import com.wirelesscar.ngtp.svc.api.Waypoint;

public interface SvcUplinkMessage
extends SvcMessage {
    public boolean isRemoteOperationUpdateResponse();

    public RoResponseList getRemoteOperationResponseList();

    public void setWaypoints(Waypoint[] var1);

    public Waypoint[] getWaypoints();

    public boolean isGenericText();

    public String getGenericText();

    public void setGenericText(String var1);

    public VehicleStatus getVehicleStatus();

    public void setVehicleStatus(VehicleStatus var1);
}

