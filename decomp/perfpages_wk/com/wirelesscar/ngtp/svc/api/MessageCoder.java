/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.DecodeException;
import com.wirelesscar.ngtp.svc.api.EncodeException;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.SvcMessage;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.Version;
import java.util.Date;

public interface MessageCoder {
    public Version getVersion();

    public SvcUplinkMessage createUplinkMessage();

    public SvcDownlinkMessage createDownlinkMessage();

    public RoResponseList createRemoteOperationResponseList(Version var1, Integer var2, Date var3);

    public SvcUplinkMessage createUplinkMessage(RoResponseList var1, boolean var2);

    public RoRequestList createRemoteOperationRequestList(Version var1, String var2, Integer var3, Integer var4);

    public SvcDownlinkMessage createDownlinkMessage(RoRequestList var1);

    public SvcUplinkMessage createUplinkMessage(String var1);

    public SvcDownlinkMessage createDownlinkMessage(String var1);

    public SvcMessage decode(byte[] var1) throws DecodeException;

    public byte[] encode(SvcMessage var1) throws EncodeException;

    public void setEncodeBufferSize(int var1);
}

