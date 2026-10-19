/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import com.airbiquity.sdp.common.SDPClientException;
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface LifeCycleListener
extends Remote {
    public void invalidateSDPClientReference() throws RemoteException;

    public void refreshSDPClientReference() throws RemoteException, SDPClientException;
}

