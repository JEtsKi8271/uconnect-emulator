/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.controller.savetimerrun;

import com.airbiquity.sdp.common.SDPClient;
import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.factory.SendToWebsiteCallable;
import com.sprint.gskills.factory.VSBSendToWebsiteCallable;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class UploadTimerRunController {
    private Logger logger = LoggerFactory.getLogger(UploadTimerRunController.class);
    private SendToWebsiteCallable sendToWebsiteCallable;
    private SDPClient sdpClient = null;
    private static final UploadTimerRunController INSTANCE = new UploadTimerRunController();

    private UploadTimerRunController() {
    }

    public static UploadTimerRunController getInstance() {
        return INSTANCE;
    }

    public void submitUploadTask(String htmlFileContent, String fileName, GSkillsViewDataListener commonTimerViewContainer) {
        try {
            this.logger.debug((Object)"Attempting to upload timer data to Uconnect using SDPClient");
            this.sdpClient = GSkillsProjectFactory.getGSkillsLifeCycleListener().getSDPClient();
            if (this.sdpClient != null) {
                this.sendToWebsiteCallable = GSkillsProjectFactory.getSendToWebsiteCallable(htmlFileContent, fileName, commonTimerViewContainer);
                GSkillsProjectFactory.getSendDataToWebsiteExecutor().submit(this.sendToWebsiteCallable);
            } else {
                this.logger.debug((Object)"SDP Client object not found");
                commonTimerViewContainer.notifyStatus(22);
            }
        }
        catch (Exception ex) {
            this.logger.debug((Object)("SDP Client is not running or VSBClient is installed. Exception thrown - " + ex));
            this.logger.debug((Object)"Attempting to upload timer data to Uconnect using VSBClient");
            GSkillsProjectFactory.getSendDataToWebsiteExecutor().submit(new VSBSendToWebsiteCallable(htmlFileContent, fileName, commonTimerViewContainer));
        }
    }

    public void cancelUploadTask() {
        if (this.sendToWebsiteCallable != null) {
            this.sendToWebsiteCallable.cancelUploadTask();
        }
    }
}

