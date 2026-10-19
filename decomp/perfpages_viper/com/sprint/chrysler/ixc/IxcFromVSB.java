/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.chrysler.ixc;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface IxcFromVSB
extends Remote {
    public void notify(String var1) throws RemoteException;

    public void notifySuccess(String var1) throws RemoteException;

    public void notifyFailure(String var1) throws RemoteException;
}

