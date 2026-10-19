/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.DsptMessage;

public interface DsptControlMessage
extends DsptMessage {
    public static final int MESSAGE_TYPE_CRQM = 0;
    public static final int MESSAGE_TYPE_NOTIFICATION = 1;
    public static final int MESSAGE_TYPE_ERROR = 2;
    public static final int MESSAGE_TYPE_ACK = 3;
    public static final int MESSAGE_TYPE_TERMINATE_VOICE = 4;
    public static final int MESSAGE_TYPE_TERMINATE_EVENT = 5;

    public void setMessageType(int var1);

    public int getMessageType();

    public void setCrqNumber(String var1);

    public String getCrqNumber();

    public void setNotificationData(byte[] var1);

    public byte[] getNotificationData();

    public void setErrorInfo(Integer var1);

    public Integer getErrorInfo();
}

