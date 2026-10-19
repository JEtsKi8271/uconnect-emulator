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
    private SDPClient _sdpClient = null;
    private boolean _isBoundToRegistry = false;
    private static final GSkillsLifeCycleListener INSTANCE = new GSkillsLifeCycleListener();
    public static final String BIND_NAME = "LifeCycleListener:com.sprint.gskills.GSkillsLifeCycleListener";

    private GSkillsLifeCycleListener() {
        this.bindListenerToRegistry();
    }

    public static GSkillsLifeCycleListener getInstance() {
        return INSTANCE;
    }

    private void bindListenerToRegistry() {
        try {
            if (!this._isBoundToRegistry) {
                GSkillsModule.getInstance().getRegistry().rebind(BIND_NAME, this);
                this._isBoundToRegistry = true;
                this.deleteSDPClientReference();
            }
        }
        catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    public void invalidateSDPClientReference() throws RemoteException {
        this.deleteSDPClientReference();
    }

    public void refreshSDPClientReference() throws RemoteException, SDPClientException {
        this.deleteSDPClientReference();
    }

    private void deleteSDPClientReference() {
        this._sdpClient = null;
    }

    public SDPClient getSDPClient() throws AccessException, RemoteException, NotBoundException, SDPClientException {
        if (this._sdpClient == null) {
            this._sdpClient = (SDPClient)GSkillsModule.getInstance().getRegistry().lookup("SDP:com.airbiquity.sdp.common.SDPClient");
        }
        return this._sdpClient;
    }
}

