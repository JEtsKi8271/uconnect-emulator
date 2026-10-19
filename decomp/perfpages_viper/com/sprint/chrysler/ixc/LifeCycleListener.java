/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.chrysler.ixc;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface LifeCycleListener
extends Remote {
    public void invalidateVSBClientReference() throws RemoteException;

    public void refreshVSBClientReference() throws RemoteException;
}

