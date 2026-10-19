/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.DecodeException;
import com.wirelesscar.ngtp.dspt.api.DsptControlMessage;
import com.wirelesscar.ngtp.dspt.api.DsptDownlinkMessage;
import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import com.wirelesscar.ngtp.dspt.api.DsptUplinkMessage;
import com.wirelesscar.ngtp.dspt.api.EncodeException;
import com.wirelesscar.ngtp.dspt.api.InvalidSignatureException;
import com.wirelesscar.ngtp.dspt.api.SecurityProvider;
import com.wirelesscar.ngtp.dspt.api.Timestamp;

public interface MessageCoder {
    public void setSecurityProvider(SecurityProvider var1);

    public DsptDownlinkMessage createDownlinkMessage(int var1, String var2, Timestamp var3, boolean var4);

    public DsptUplinkMessage createUplinkMessage(int var1, String var2, Timestamp var3, boolean var4);

    public DsptControlMessage createControlMessage(int var1, String var2, Timestamp var3, boolean var4);

    public DsptMessage decode(byte[] var1) throws DecodeException, InvalidSignatureException;

    public byte[] encode(DsptMessage var1) throws EncodeException;
}

