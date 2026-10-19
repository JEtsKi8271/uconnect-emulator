/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.factory;

import com.sprint.chrysler.ixc.IxcFromVSB;
import com.sprint.chrysler.ixc.VSBClient;
import com.sprint.gskills.VSBGSkillsLifeCycleListener;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.xlet.GSkillsModule;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.CountDownLatch;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import java.rmi.AccessException;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import kona.logger.Log;
import net.sf.microlog.core.Logger;
import org.json.JSONException;
import org.json.JSONObject;

public class VSBSendToWebsiteCallable
implements Callable,
IxcFromVSB {
    public static final String LISTENER_BIND_NAME = "IxcFromVSB:com.sprint.gskills.factory.VSBSendToWebsiteCallable";
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private String htmlFileContent;
    private String fileName;
    private GSkillsViewDataListener commonTimerViewContainer;
    private VSBClient vsbClient = null;
    private CountDownLatch wasResponseGotLatch;
    int errorCode = 22;

    public VSBSendToWebsiteCallable(String htmlFileContent, String fileName, GSkillsViewDataListener commonTimerViewContainer) {
        this.htmlFileContent = htmlFileContent;
        this.fileName = fileName;
        this.commonTimerViewContainer = commonTimerViewContainer;
        this.wasResponseGotLatch = new CountDownLatch(1);
    }

    public Object call() {
        try {
            this.logger.debug((Object)"Registering listener and sending data to VSB");
            this.registerListener();
            if (null != this.vsbClient) {
                this.vsbClient.sendDataToVSB("gskills", String.valueOf(System.currentTimeMillis()), this.createUplinkJSONString());
                this.logger.debug((Object)"***** Data Upload is done, Latch awaiting for response *******");
                this.wasResponseGotLatch.await(ResKeyPropertiesFactory.saveToUConnectTimeOutMin(), TimeUnit.MINUTES);
                this.logger.debug((Object)"***** Response Latch released *******");
            } else {
                this.logger.debug((Object)"VSBClient is not running");
            }
        }
        catch (Exception e2) {
            e2.printStackTrace();
        }
        finally {
            if (14 == this.errorCode) {
                this.logger.debug((Object)"***** Showing success response to the User *******");
                this.commonTimerViewContainer.notifyStatus(14);
            } else if (22 == this.errorCode) {
                this.logger.debug((Object)"***** Showing Failure response to the User *******");
                this.commonTimerViewContainer.notifyStatus(22);
            } else {
                this.logger.debug((Object)"***** Nothing to do *******");
            }
            this.logger.debug((Object)"***** Deregistering Listeners, unbinding GSkills from registry *******");
            this.deregisterListener();
        }
        return this;
    }

    private void registerListener() throws AccessException, RemoteException {
        VSBGSkillsLifeCycleListener.getInstance().refreshVSBClientReference();
        this.vsbClient = VSBGSkillsLifeCycleListener.getInstance().getVSBClientInstance();
        if (null != this.vsbClient) {
            this.logger.debug((Object)"VSBClient is running. Binding SendToWebsiteCallable to IXC registry.");
            GSkillsModule.getRegistry().rebind(LISTENER_BIND_NAME, this);
            this.logger.debug((Object)"Setting bind name in VSBClient to receive callbacks.");
            this.vsbClient.setBindNameForCallback("gskills", LISTENER_BIND_NAME);
        }
    }

    private void deregisterListener() {
        try {
            if (null != this.vsbClient) {
                this.vsbClient.removeBindName("gskills");
                VSBGSkillsLifeCycleListener.getInstance().invalidateVSBClientReference();
            }
            GSkillsModule.getRegistry().unbind(LISTENER_BIND_NAME);
        }
        catch (NotBoundException e2) {
            e2.printStackTrace();
        }
        catch (RemoteException e3) {
            e3.printStackTrace();
        }
    }

    private String createUplinkJSONString() {
        this.logger.debug((Object)("Upload filename: " + this.fileName));
        this.logger.debug((Object)("Upload html data: " + this.htmlFileContent));
        JSONObject obj = new JSONObject();
        try {
            obj.put("data", this.htmlFileContent);
            obj.put("name", this.fileName);
        }
        catch (JSONException e2) {
            this.logger.info((Object)("Exception while creating JSON string " + e2));
        }
        String jsonString = obj.toString();
        this.logger.debug((Object)("Upload JSON data: " + jsonString));
        return jsonString;
    }

    public void notifyFailure(String correlationId) throws RemoteException {
        this.logger.debug((Object)"***** Received Failure response for the GSkills data upload *******");
        this.errorCode = 22;
        this.logger.debug((Object)"***** In Failure Case - Releasing the Latch. *******");
        this.wasResponseGotLatch.countDown();
    }

    public void notifySuccess(String correlationId) throws RemoteException {
        this.logger.debug((Object)"***** Received Success response for the GSkills data upload *******");
        this.errorCode = 14;
        this.logger.debug((Object)"***** In Success Case - Releasing the Latch. *******");
        this.wasResponseGotLatch.countDown();
    }

    public void notify(String message) throws RemoteException {
        this.logger.debug((Object)"NOT IMPLEMENTED");
    }

    public void cancelUploadTask() {
        this.logger.debug((Object)"NOT IMPLEMENTED");
    }
}

