/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import com.airbiquity.sdp.common.DownlinkEventMessageHandle;
import com.airbiquity.sdp.common.EventHandle;
import com.airbiquity.sdp.common.SDPClientException;
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface EventHandlerListener
extends Remote {
    public void notify(DownlinkEventMessageHandle var1) throws RemoteException, SDPClientException;

    public void eventTerminated(EventHandle var1) throws RemoteException;

    public void handleError(EventHandle var1, Throwable var2) throws RemoteException;
}

