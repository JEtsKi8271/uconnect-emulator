/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills;

import com.sprint.chrysler.ixc.LifeCycleListener;
import com.sprint.chrysler.ixc.VSBClient;
import com.sprint.gskills.xlet.GSkillsModule;
import java.rmi.RemoteException;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class VSBGSkillsLifeCycleListener
implements LifeCycleListener {
    public static final String BIND_NAME = "LifeCycleListener:com.sprint.gskills.VSBGSkillsLifeCycleListener";
    private static final VSBGSkillsLifeCycleListener INSTANCE = new VSBGSkillsLifeCycleListener();
    private VSBClient vsbClient = null;
    private Logger logger = Log.createLogger((String)this.getClass().getName());

    private VSBGSkillsLifeCycleListener() {
    }

    public void bind() {
        try {
            this.logger.debug((Object)"***********IXC: Binding GSkillsLifeCycleListener to IXC Registry **************");
            GSkillsModule.getInstance().getRegistry().rebind(BIND_NAME, INSTANCE);
            this.refreshVSBClientReference();
        }
        catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    public static VSBGSkillsLifeCycleListener getInstance() {
        return INSTANCE;
    }

    public void invalidateVSBClientReference() throws RemoteException {
        this.vsbClient = null;
    }

    public void refreshVSBClientReference() throws RemoteException {
        try {
            this.logger.debug((Object)"*********** GSkillsLifeCycleListener - IXC: Looking up VSBClient instance in IXC registry **************");
            this.vsbClient = (VSBClient)GSkillsModule.getInstance().getRegistry().lookup("VSB:com.sprint.chrysler.vsbclient.ixc.VSBClient");
        }
        catch (Exception e2) {
            this.logger.debug((Object)"*********** GSkillsLifeCycleListener - IXC: VSBClient is not running **************");
        }
    }

    public VSBClient getVSBClientInstance() {
        return this.vsbClient;
    }
}

