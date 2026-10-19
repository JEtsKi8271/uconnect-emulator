/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.chrysler.ixc;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface VSBClient
extends Remote {
    public static final String VSB_CLIENT_BIND_NAME = "VSB:com.sprint.chrysler.vsbclient.ixc.VSBClient";

    public void sendDataToVSB(String var1, String var2, String var3) throws RemoteException;

    public void setBindNameForCallback(String var1, String var2) throws RemoteException;

    public void removeBindName(String var1) throws RemoteException;
}

