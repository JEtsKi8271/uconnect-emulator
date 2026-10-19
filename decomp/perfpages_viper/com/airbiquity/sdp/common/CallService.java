/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import com.airbiquity.sdp.common.SDPClientException;
import java.rmi.RemoteException;

public interface CallService {
    public void makeCall(String var1) throws RemoteException;

    public void endCall() throws RemoteException, SDPClientException;
}

