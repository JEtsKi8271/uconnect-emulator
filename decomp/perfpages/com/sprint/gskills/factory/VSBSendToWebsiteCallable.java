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
import com.sprint.gskills.concurrency.GSkillsCallable;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.timers.CommonTimerView;
import com.sprint.gskills.xlet.GSkillsModule;
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
extends GSkillsCallable
implements IxcFromVSB {
    public static final String LISTENER_BIND_NAME = "IxcFromVSB:com.sprint.gskills.factory.VSBSendToWebsiteCallable";
    private Logger _logger = Log.createLogger((String)this.getClass().getName());
    private String _htmlFileContent;
    private String _fileName;
    private CommonTimerView _commonTimerView;
    private VSBClient _vsbClient = null;
    private CountDownLatch _responseLatch;
    int _errorCode = 22;

    public VSBSendToWebsiteCallable(String name, String htmlFileContent, String fileName, CommonTimerView commonTimerViewContainer) {
        super(name);
        this._htmlFileContent = htmlFileContent;
        this._fileName = fileName;
        this._commonTimerView = commonTimerViewContainer;
        this._responseLatch = new CountDownLatch(1);
    }

    public Object call() {
        try {
            this._logger.debug((Object)"Registering listener and sending Data to VSB");
            this.registerListener();
            if (null != this._vsbClient) {
                this._vsbClient.sendDataToVSB("gskills", String.valueOf(System.currentTimeMillis()), this.createUplinkJSONString());
                this._logger.debug((Object)"***** Data Upload is done, Latch awaiting for response *******");
                this._responseLatch.await(ResKeyPropertiesFactory.saveToUConnectTimeOutMin(), TimeUnit.MINUTES);
                this._logger.debug((Object)"***** Response Latch released *******");
            } else {
                this._logger.debug((Object)"VSBClient is not running");
            }
        }
        catch (AccessException e2) {
            e2.printStackTrace();
        }
        catch (RemoteException e3) {
            e3.printStackTrace();
        }
        catch (InterruptedException e4) {
            e4.printStackTrace();
        }
        finally {
            if (14 == this._errorCode) {
                this._logger.debug((Object)"***** Showing success response to the User *******");
                this._commonTimerView.notifyStatus(14);
            } else if (22 == this._errorCode) {
                this._logger.debug((Object)"***** Showing Failure response to the User *******");
                this._commonTimerView.notifyStatus(22);
            } else {
                this._logger.debug((Object)"***** Nothing to do *******");
            }
            this._logger.debug((Object)"***** Deregistering Listeners, unbinding GSkills from registry *******");
            this.deregisterListener();
        }
        return this;
    }

    private void registerListener() throws AccessException, RemoteException {
        VSBGSkillsLifeCycleListener.getInstance().refreshVSBClientReference();
        this._vsbClient = VSBGSkillsLifeCycleListener.getInstance().getVSBClientInstance();
        if (null != this._vsbClient) {
            this._logger.debug((Object)"VSBClient is running. Binding SendToWebsiteCallable to IXC registry.");
            GSkillsModule.getInstance().getRegistry().rebind(LISTENER_BIND_NAME, this);
            this._logger.debug((Object)"Setting bind name in VSBClient to receive callbacks.");
            this._vsbClient.setBindNameForCallback("gskills", LISTENER_BIND_NAME);
        }
    }

    private void deregisterListener() {
        try {
            if (null != this._vsbClient) {
                this._vsbClient.removeBindName("gskills");
                VSBGSkillsLifeCycleListener.getInstance().invalidateVSBClientReference();
            }
            GSkillsModule.getInstance().getRegistry().unbind(LISTENER_BIND_NAME);
        }
        catch (NotBoundException e2) {
            e2.printStackTrace();
        }
        catch (RemoteException e3) {
            e3.printStackTrace();
        }
    }

    private String createUplinkJSONString() {
        this._logger.debug((Object)("Upload filename: " + this._fileName));
        this._logger.debug((Object)("Upload html data: " + this._htmlFileContent));
        JSONObject obj = new JSONObject();
        try {
            obj.put("data", this._htmlFileContent);
            obj.put("name", this._fileName);
        }
        catch (JSONException e2) {
            this._logger.info((Object)"Adding the data information");
        }
        String jsonString = obj.toString();
        this._logger.debug((Object)("Upload JSON data: " + jsonString));
        return jsonString;
    }

    public void notifyFailure(String correlationId) throws RemoteException {
        this._logger.debug((Object)"***** Received Failure response for the GSkills data upload *******");
        this._errorCode = 22;
        this._responseLatch.countDown();
    }

    public void notifySuccess(String correlationId) throws RemoteException {
        this._logger.debug((Object)"***** Received Success response for the GSkills data upload *******");
        this._errorCode = 14;
        this._responseLatch.countDown();
    }

    public void notify(String message) throws RemoteException {
        this._logger.debug((Object)"NOT IMPLEMENTED");
    }

    public void cancelUploadTask() {
        this._logger.debug((Object)"NOT IMPLEMENTED");
    }
}

