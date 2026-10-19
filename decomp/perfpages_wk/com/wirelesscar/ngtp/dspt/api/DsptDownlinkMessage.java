/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import com.wirelesscar.ngtp.dspt.api.Version;

public interface DsptDownlinkMessage
extends DsptMessage {
    public void setServiceData(byte[] var1, Version var2, int var3);

    public int getServiceDataEncodingType();

    public Version getServiceDataVersion();

    public byte[] getServiceData();
}

