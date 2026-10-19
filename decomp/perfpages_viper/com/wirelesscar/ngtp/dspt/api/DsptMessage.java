/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.MessageCount;
import com.wirelesscar.ngtp.dspt.api.MobileDeviceIdentifier;
import com.wirelesscar.ngtp.dspt.api.Timestamp;

public interface DsptMessage {
    public String getVin();

    public int getServiceType();

    public Timestamp getEventCreationTime();

    public boolean isEventBackendInitiated();

    public void setMessageCount(MessageCount var1);

    public MessageCount getMessageCount();

    public void setAckRequired(boolean var1);

    public boolean isAckRequired();

    public void setStateless(boolean var1);

    public boolean isStateless();

    public void setBackendEventId(byte[] var1);

    public byte[] getBackendEventId();

    public void setMessageCreationTime(Timestamp var1);

    public Timestamp getMessageCreationTime();

    public void setMobileDeviceIdentifier(MobileDeviceIdentifier var1);

    public MobileDeviceIdentifier getMobileDeviceIdentifier();
}

