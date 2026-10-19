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
import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.xlet.GSkillsModule;
import com.wirelesscar.ngtp.dspt.api.DsptDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.DecodeException;
import com.wirelesscar.ngtp.svc.api.EncodeException;
import com.wirelesscar.ngtp.svc.api.MessageCoder;
import com.wirelesscar.ngtp.svc.api.MessageCoderFactory;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.Version;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
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

public class SendToWebsiteCallable
implements Callable,
EventHandlerListener {
    public static final String LISTENER_BIND_NAME = "GSKILLS:com.sprint.gskills.factory.SendToWebsiteCallable";
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private String htmlFileContent;
    private String fileName;
    private SDPClient sdpClient = null;
    private EventHandle uploadEvent;
    private GSkillsViewDataListener commonTimerViewContainer;
    private long uploadStartTime;
    private long timeSpentToSendRequest;
    private CountDownLatch wasResponseGotLatch;
    private final String NO_UCONNECT_ID = "400";
    private final int RESPONSE_CODE_MIN = 200;
    private final int RESPONSE_CODE_MAX = 206;

    public SendToWebsiteCallable(String htmlFileContent, String fileName, GSkillsViewDataListener commonTimerViewContainer) {
        this.htmlFileContent = htmlFileContent;
        this.fileName = fileName;
        this.commonTimerViewContainer = commonTimerViewContainer;
        this.wasResponseGotLatch = new CountDownLatch(1);
    }

    public Object call() {
        try {
            this.uploadStartTime = System.currentTimeMillis();
            this.sdpClient = GSkillsProjectFactory.getGSkillsLifeCycleListener().getSDPClient();
            this.registerListener();
            this.uploadEvent = this.sdpClient.createStatefulEvent(ResKeyPropertiesFactory.getServiceType());
            this.sdpClient.sendDataTU(this.uploadEvent, this.createServiceData(this.createUplinkJSonString()), new WCarSvcVersion(MessageCoderFactory.getDefaultMessageCoder().getVersion().getMajor(), MessageCoderFactory.getDefaultMessageCoder().getVersion().getMinor()));
            try {
                this.timeSpentToSendRequest = TimeUnit.MILLISECONDS.toMinutes(System.currentTimeMillis() - this.uploadStartTime);
                if (!this.wasResponseGotLatch.await((long)ResKeyPropertiesFactory.saveToUConnectTimeOutMin() - this.timeSpentToSendRequest, TimeUnit.MINUTES)) {
                    if (this.logger.isDebugEnabled()) {
                        this.logger.debug((Object)"no response from server");
                    }
                    this.cleanUp();
                    this.commonTimerViewContainer.notifyStatus(22);
                }
            }
            catch (InterruptedException e2) {
                e2.printStackTrace();
                this.cleanUp();
            }
        }
        catch (RemoteException e3) {
            this.logger.error((Object)"RemoteException", (Throwable)e3);
            this.cleanUp();
            this.commonTimerViewContainer.notifyStatus(22);
        }
        catch (SDPClientException e4) {
            this.logger.error((Object)"SDPClientException", (Throwable)e4);
            this.cleanUp();
            this.commonTimerViewContainer.notifyStatus(22);
        }
        catch (EncodeException e5) {
            this.logger.error((Object)"EncodeException", (Throwable)e5);
            this.cleanUp();
            this.commonTimerViewContainer.notifyStatus(22);
        }
        catch (NotBoundException e6) {
            this.logger.error((Object)"NotBoundException", (Throwable)e6);
            this.cleanUp();
            this.commonTimerViewContainer.notifyStatus(22);
        }
        return this;
    }

    private void registerListener() throws AccessException, RemoteException, SDPClientException {
        GSkillsModule.getRegistry().rebind(LISTENER_BIND_NAME, this);
        this.sdpClient.setEventHandlerListener(LISTENER_BIND_NAME, this.getServiceTypeSet());
    }

    private void deregisterListener() {
        try {
            this.sdpClient.removeEventHandlerListener(LISTENER_BIND_NAME, this.getServiceTypeSet());
        }
        catch (Exception e2) {
            this.logger.error((Object)"", (Throwable)e2);
        }
        try {
            GSkillsModule.getRegistry().unbind(LISTENER_BIND_NAME);
        }
        catch (Exception e3) {
            this.logger.error((Object)"", (Throwable)e3);
        }
    }

    private HashSet getServiceTypeSet() {
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

    private String createUplinkJSonString() {
        this.logger.debug((Object)("Upload filename: " + this.fileName));
        this.logger.debug((Object)("Upload html data: " + this.htmlFileContent));
        HashMap<String, String> filetoUploadmap = new HashMap<String, String>();
        filetoUploadmap.put("data", this.htmlFileContent);
        filetoUploadmap.put("fileName", this.fileName);
        JSONValidatingWriter writer = new JSONValidatingWriter();
        String jasonString = writer.write(filetoUploadmap);
        this.logger.debug((Object)("Upload JSON data: " + jasonString));
        return jasonString;
    }

    private void cleanUp() {
        this.deregisterListener();
    }

    public void eventTerminated(EventHandle eventHandle) throws RemoteException {
        if (this.logger.isDebugEnabled()) {
            this.logger.debug((Object)"eventTerminated");
        }
        this.cleanUp();
    }

    public void handleError(EventHandle eventhandle, Throwable error) throws RemoteException {
        if (this.logger.isDebugEnabled()) {
            this.logger.debug((Object)"listener notified", error);
        }
        this.cleanUp();
        this.commonTimerViewContainer.notifyStatus(22);
    }

    public void notify(DownlinkEventMessageHandle downlinkEventMessageHandle) throws RemoteException, SDPClientException {
        if (this.logger.isDebugEnabled()) {
            this.logger.debug((Object)"received downlink message");
        }
        this.wasResponseGotLatch.countDown();
        DsptMessageWrapper dsptMessageWrapper = this.sdpClient.getDownlinkMessage(downlinkEventMessageHandle);
        DsptDownlinkMessage message = (DsptDownlinkMessage)dsptMessageWrapper.getDsptMessage();
        MessageCoder coder = MessageCoderFactory.getMessageCoderByVersion(new Version(message.getServiceDataVersion().getMajor(), message.getServiceDataVersion().getMinor()));
        try {
            SvcDownlinkMessage svcDownlinkMsg = (SvcDownlinkMessage)coder.decode(message.getServiceData());
            String jsonStr = svcDownlinkMsg.getGenericText();
            if (this.logger.isDebugEnabled()) {
                this.logger.debug((Object)("received json string :" + jsonStr));
            }
            this.parseAndNotifyView(jsonStr);
        }
        catch (DecodeException e2) {
            this.logger.error((Object)"", (Throwable)e2);
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
            if (this.logger.isDebugEnabled()) {
                this.logger.debug((Object)("statusCode is : " + statusCode));
                this.logger.debug((Object)("statusMessage is : " + statusMessage));
            }
        }
        if (null != statusCode) {
            int statusCodeNumber = Integer.parseInt(jasonObject.get("statusCode").toString());
            if (statusCodeNumber >= 200 && statusCodeNumber <= 206) {
                this.commonTimerViewContainer.notifyStatus(14);
            } else if (statusCode.equals("400")) {
                this.commonTimerViewContainer.notifyStatus(34);
            } else {
                this.logger.error((Object)"NOT IMPLEMENTED");
                this.commonTimerViewContainer.notifyStatus(22);
            }
        }
    }

    public void cancelUploadTask() {
        this.wasResponseGotLatch.countDown();
        this.cleanUp();
    }
}

