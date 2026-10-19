/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.controller.savetimerrun;

import com.airbiquity.sdp.common.SDPClient;
import com.sprint.gskills.GSkillsLifeCycleListener;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.factory.SendToWebsiteCallable;
import com.sprint.gskills.factory.VSBSendToWebsiteCallable;
import com.sprint.gskills.view.timers.CommonTimerView;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class UploadTimerRunController {
    private Logger logger = LoggerFactory.getLogger(UploadTimerRunController.class);
    private SendToWebsiteCallable sendToWebsiteCallable;
    private SDPClient sdpClient = null;

    private UploadTimerRunController() {
    }

    public static UploadTimerRunController getInstance() {
        return new UploadTimerRunController();
    }

    public void submitUploadTask(String htmlFileContent, String fileName, CommonTimerView commonTimerViewContainer) {
        try {
            this.logger.debug((Object)"Attempting to upload timer data to Uconnect using SDPClient");
            this.sdpClient = GSkillsLifeCycleListener.getInstance().getSDPClient();
            if (null != this.sdpClient) {
                this.sendToWebsiteCallable = new SendToWebsiteCallable("SendDataToWebsiteThread", htmlFileContent, fileName, commonTimerViewContainer);
                GSkillsThreadManager.getInstance().submit(this.sendToWebsiteCallable);
            } else {
                this.logger.debug((Object)"SDP Client object not found");
                commonTimerViewContainer.notifyStatus(22);
            }
        }
        catch (Exception ex) {
            this.logger.debug((Object)("SDP Client is not running or VSBClient is installed. Exception thrown - " + ex));
            this.logger.debug((Object)"Attempting to upload timer data to Uconnect using VSBClient");
            GSkillsThreadManager.getInstance().submit(new VSBSendToWebsiteCallable("VSBSendDataToWebsiteThread", htmlFileContent, fileName, commonTimerViewContainer));
        }
    }

    public void cancelUploadTask() {
        if (this.sendToWebsiteCallable != null) {
            this.sendToWebsiteCallable.cancelUploadTask();
        }
    }
}

