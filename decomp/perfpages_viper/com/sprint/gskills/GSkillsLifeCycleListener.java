/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills;

import com.airbiquity.sdp.common.LifeCycleListener;
import com.airbiquity.sdp.common.SDPClient;
import com.airbiquity.sdp.common.SDPClientException;
import com.sprint.gskills.xlet.GSkillsModule;
import java.rmi.AccessException;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;

public class GSkillsLifeCycleListener
implements LifeCycleListener {
    public static final String BIND_NAME = "LifeCycleListener:com.sprint.gskills.GSkillsLifeCycleListener";
    private static SDPClient sdpClient = null;
    private static boolean isBoundToRegistry = false;

    public GSkillsLifeCycleListener() throws AccessException, RemoteException {
        this.bindListernerToRegistry();
    }

    private void bindListernerToRegistry() throws AccessException, RemoteException {
        if (!isBoundToRegistry) {
            GSkillsModule.getRegistry().rebind(BIND_NAME, this);
            isBoundToRegistry = true;
            this.deleteSDPClientReference();
        }
    }

    public void invalidateSDPClientReference() throws RemoteException {
        this.deleteSDPClientReference();
    }

    public void refreshSDPClientReference() throws RemoteException, SDPClientException {
        this.deleteSDPClientReference();
    }

    private void deleteSDPClientReference() {
        sdpClient = null;
    }

    public SDPClient getSDPClient() throws AccessException, RemoteException, NotBoundException, SDPClientException {
        if (sdpClient == null) {
            sdpClient = (SDPClient)GSkillsModule.getRegistry().lookup("SDP:com.airbiquity.sdp.common.SDPClient");
        }
        return sdpClient;
    }
}

