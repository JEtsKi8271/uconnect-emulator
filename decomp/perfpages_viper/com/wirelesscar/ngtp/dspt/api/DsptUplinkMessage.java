/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import com.wirelesscar.ngtp.dspt.api.Position;
import com.wirelesscar.ngtp.dspt.api.Version;

public interface DsptUplinkMessage
extends DsptMessage {
    public void setServiceData(byte[] var1, Version var2, int var3);

    public int getServiceDataEncodingType();

    public Version getServiceDataVersion();

    public byte[] getServiceData();

    public void setBasicPosition(Position var1);

    public Position getBasicPosition();

    public void setCurrentNetwork(String var1);

    public String getCurrentNetwork();

    public void setHomeNetwork(String var1);

    public String getHomeNetwork();

    public void setHMILanguage(int var1);

    public int getHMILanguage();

    public void setCrqmRequest(boolean var1);

    public boolean isCrqmRequest();
}

