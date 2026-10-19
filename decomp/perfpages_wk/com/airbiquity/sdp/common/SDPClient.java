/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import com.airbiquity.sdp.common.DownlinkEventMessageHandle;
import com.airbiquity.sdp.common.DsptMessageWrapper;
import com.airbiquity.sdp.common.EventHandle;
import com.airbiquity.sdp.common.SDPClientException;
import com.airbiquity.sdp.common.impl.WCarSvcVersion;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.HashSet;

public interface SDPClient
extends Remote {
    public static final String SDP_CLIENT_BIND_NAME = "SDP:com.airbiquity.sdp.common.SDPClient";

    public void setEventHandlerListener(String var1, HashSet var2) throws RemoteException, SDPClientException;

    public void removeEventHandlerListener(String var1, HashSet var2) throws RemoteException, SDPClientException;

    public DsptMessageWrapper getDownlinkMessage(DownlinkEventMessageHandle var1) throws RemoteException, SDPClientException;

    public void ackDownlinkMessage(DownlinkEventMessageHandle var1) throws RemoteException, SDPClientException;

    public void sendDataTU(EventHandle var1, byte[] var2) throws RemoteException, SDPClientException;

    public void sendDataTU(EventHandle var1, byte[] var2, WCarSvcVersion var3) throws RemoteException, SDPClientException;

    public EventHandle createStatefulEvent(int var1) throws RemoteException, SDPClientException;

    public void terminateEvent(EventHandle var1) throws RemoteException, SDPClientException;

    public void sendStatelessEvent(int var1, byte[] var2) throws RemoteException, SDPClientException;

    public void sendStatelessEvent(int var1, byte[] var2, WCarSvcVersion var3) throws RemoteException, SDPClientException;

    public void requestCRQMNumber(EventHandle var1, byte[] var2) throws RemoteException, SDPClientException;

    public void requestCRQMNumber(EventHandle var1, byte[] var2, WCarSvcVersion var3) throws RemoteException, SDPClientException;
}

