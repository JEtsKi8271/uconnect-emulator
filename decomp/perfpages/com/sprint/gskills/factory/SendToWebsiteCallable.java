/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 *  org.stringtree.json.JSONReader
 *  org.stringtree.json.JSONValidatingWriter
 */
package com.sprint.gskills.factory;

import com.airbiquity.sdp.common.DownlinkEventMessageHandle;
import com.airbiquity.sdp.common.DsptMessageWrapper;
import com.airbiquity.sdp.common.EventHandle;
import com.airbiquity.sdp.common.EventHandlerListener;
import com.airbiquity.sdp.common.SDPClient;
import com.airbiquity.sdp.common.SDPClientException;
import com.airbiquity.sdp.common.impl.WCarSvcVersion;
import com.sprint.gskills.GSkillsLifeCycleListener;
import com.sprint.gskills.concurrency.GSkillsCallable;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.timers.CommonTimerView;
import com.sprint.gskills.xlet.GSkillsModule;
import com.wirelesscar.ngtp.dspt.api.DsptDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.DecodeException;
import com.wirelesscar.ngtp.svc.api.EncodeException;
import com.wirelesscar.ngtp.svc.api.MessageCoder;
import com.wirelesscar.ngtp.svc.api.MessageCoderFactory;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.Version;
import edu.emory.mathcs.backport.java.util.concurrent.CountDownLatch;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import java.rmi.AccessException;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.util.HashMap;
import java.util.HashSet;
import kona.logger.Log;
import net.sf.microlog.core.Logger;
import org.stringtree.json.JSONReader;
import org.stringtree.json.JSONValidatingWriter;

/*
 * This class specifies class file version 49.0 but uses Java 6 signatures.  Assumed Java 6.
 */
public class SendToWebsiteCallable
extends GSkillsCallable
implements EventHandlerListener {
    public static final String LISTENER_BIND_NAME = "GSKILLS:com.sprint.gskills.factory.SendToWebsiteCallable";
    private Logger _logger = Log.createLogger((String)this.getClass().getName());
    private String _htmlFileContent;
    private String _fileName;
    private SDPClient _sdpClient = null;
    private EventHandle _uploadEvent;
    private CommonTimerView _commonTimerViewContainer;
    private long _uploadStartTime;
    private long _timeSpentToSendRequest;
    private CountDownLatch _wasResponseGotLatch;
    private final String NO_UCONNECT_ID = "400";
    private final int RESPONSE_CODE_MIN = 200;
    private final int RESPONSE_CODE_MAX = 206;

    public SendToWebsiteCallable(String name, String htmlFileContent, String fileName, CommonTimerView commonTimerViewContainer) {
        super(name);
        this._htmlFileContent = htmlFileContent;
        this._fileName = fileName;
        this._commonTimerViewContainer = commonTimerViewContainer;
        this._wasResponseGotLatch = new CountDownLatch(1);
    }

    @Override
    public Object call() {
        try {
            this._uploadStartTime = System.currentTimeMillis();
            this._sdpClient = GSkillsLifeCycleListener.getInstance().getSDPClient();
            this.registerListener();
            this._uploadEvent = this._sdpClient.createStatefulEvent(ResKeyPropertiesFactory.getServiceType());
            this._sdpClient.sendDataTU(this._uploadEvent, this.createServiceData(this.createUplinkJSONString()), new WCarSvcVersion(MessageCoderFactory.getDefaultMessageCoder().getVersion().getMajor(), MessageCoderFactory.getDefaultMessageCoder().getVersion().getMinor()));
            try {
                this._timeSpentToSendRequest = TimeUnit.MILLISECONDS.toMinutes(System.currentTimeMillis() - this._uploadStartTime);
                if (!this._wasResponseGotLatch.await((long)ResKeyPropertiesFactory.saveToUConnectTimeOutMin() - this._timeSpentToSendRequest, TimeUnit.MINUTES)) {
                    if (this._logger.isDebugEnabled()) {
                        this._logger.debug((Object)"no response from server");
                    }
                    this.cleanUp();
                    this._commonTimerViewContainer.notifyStatus(22);
                }
            }
            catch (InterruptedException e2) {
                e2.printStackTrace();
                this.cleanUp();
            }
        }
        catch (RemoteException e3) {
            this._logger.error((Object)"RemoteException", (Throwable)e3);
            this.cleanUp();
            this._commonTimerViewContainer.notifyStatus(22);
        }
        catch (SDPClientException e4) {
            this._logger.error((Object)"SDPClientException", (Throwable)e4);
            this.cleanUp();
            this._commonTimerViewContainer.notifyStatus(22);
        }
        catch (EncodeException e5) {
            this._logger.error((Object)"EncodeException", (Throwable)e5);
            this.cleanUp();
            this._commonTimerViewContainer.notifyStatus(22);
        }
        catch (NotBoundException e6) {
            this._logger.error((Object)"NotBoundException", (Throwable)e6);
            this.cleanUp();
            this._commonTimerViewContainer.notifyStatus(22);
        }
        return this;
    }

    private void registerListener() throws AccessException, RemoteException, SDPClientException {
        GSkillsModule.getInstance().getRegistry().rebind(LISTENER_BIND_NAME, this);
        this._sdpClient.setEventHandlerListener(LISTENER_BIND_NAME, this.getServiceTypeSet());
    }

    private void deregisterListener() {
        try {
            this._sdpClient.removeEventHandlerListener(LISTENER_BIND_NAME, this.getServiceTypeSet());
        }
        catch (Exception e2) {
            this._logger.error((Object)"", (Throwable)e2);
        }
        try {
            GSkillsModule.getInstance().getRegistry().unbind(LISTENER_BIND_NAME);
        }
        catch (Exception e3) {
            this._logger.error((Object)"", (Throwable)e3);
        }
    }

    private HashSet<Integer> getServiceTypeSet() {
        HashSet<Integer> serviceTypeSet = new HashSet<Integer>();
        serviceTypeSet.add(ResKeyPropertiesFactory.getServiceType());
        return serviceTypeSet;
    }

    private byte[] createServiceData(String createUplinkJSonString) throws EncodeException {
        MessageCoder coder = MessageCoderFactory.getDefaultMessageCoder();
        SvcUplinkMessage svcUplinkMsg = coder.createUplinkMessage();
        svcUplinkMsg.setGenericText(createUplinkJSonString);
        byte[] bytes = coder.encode(svcUplinkMsg);
        return bytes;
    }

    private String createUplinkJSONString() {
        this._logger.debug((Object)("Upload filename: " + this._fileName));
        this._logger.debug((Object)("Upload html data: " + this._htmlFileContent));
        HashMap<String, String> filetoUploadmap = new HashMap<String, String>();
        filetoUploadmap.put("data", this._htmlFileContent);
        filetoUploadmap.put("fileName", this._fileName);
        JSONValidatingWriter writer = new JSONValidatingWriter();
        String jsonString = writer.write(filetoUploadmap);
        this._logger.debug((Object)("Upload JSON data: " + jsonString));
        return jsonString;
    }

    private void cleanUp() {
        this.deregisterListener();
    }

    @Override
    public void eventTerminated(EventHandle eventHandle) throws RemoteException {
        if (this._logger.isDebugEnabled()) {
            this._logger.debug((Object)"eventTerminated");
        }
        this.cleanUp();
    }

    @Override
    public void handleError(EventHandle eventhandle, Throwable error) throws RemoteException {
        if (this._logger.isDebugEnabled()) {
            this._logger.debug((Object)"listener notified", error);
        }
        this.cleanUp();
        this._commonTimerViewContainer.notifyStatus(22);
    }

    @Override
    public void notify(DownlinkEventMessageHandle downlinkEventMessageHandle) throws RemoteException, SDPClientException {
        if (this._logger.isDebugEnabled()) {
            this._logger.debug((Object)"received downlink message");
        }
        this._wasResponseGotLatch.countDown();
        DsptMessageWrapper dsptMessageWrapper = this._sdpClient.getDownlinkMessage(downlinkEventMessageHandle);
        DsptDownlinkMessage message = (DsptDownlinkMessage)dsptMessageWrapper.getDsptMessage();
        MessageCoder coder = MessageCoderFactory.getMessageCoderByVersion(new Version(message.getServiceDataVersion().getMajor(), message.getServiceDataVersion().getMinor()));
        try {
            SvcDownlinkMessage svcDownlinkMsg = (SvcDownlinkMessage)coder.decode(message.getServiceData());
            String jsonStr = svcDownlinkMsg.getGenericText();
            if (this._logger.isDebugEnabled()) {
                this._logger.debug((Object)("received json string :" + jsonStr));
            }
            this.parseAndNotifyView(jsonStr);
        }
        catch (DecodeException e2) {
            this._logger.error((Object)"", (Throwable)e2);
        }
    }

    protected void parseAndNotifyView(String jsonStr) {
        JSONReader jsonReader = new JSONReader();
        HashMap jasonObject = (HashMap)jsonReader.read(jsonStr);
        String statusCode = null;
        String statusMessage = null;
        if (jasonObject != null) {
            if (jasonObject.containsKey("statusCode")) {
                statusCode = jasonObject.get("statusCode").toString();
            }
            if (jasonObject.containsKey("statusMessage")) {
                statusMessage = jasonObject.get("statusMessage").toString();
            }
            this._logger.debug((Object)("statusCode is : " + statusCode));
            this._logger.debug((Object)("statusMessage is : " + statusMessage));
        }
        if (null != statusCode) {
            int statusCodeNumber = Integer.parseInt(jasonObject.get("statusCode").toString());
            if (statusCodeNumber >= 200 && statusCodeNumber <= 206) {
                this._commonTimerViewContainer.notifyStatus(14);
            } else if (statusCode.equals("400")) {
                this._commonTimerViewContainer.notifyStatus(34);
            } else {
                this._logger.error((Object)"NOT IMPLEMENTED");
                this._commonTimerViewContainer.notifyStatus(22);
            }
        }
    }

    public void cancelUploadTask() {
        this._wasResponseGotLatch.countDown();
        this.cleanUp();
    }
}

