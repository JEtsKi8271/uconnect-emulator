/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Display
 *  javax.microedition.xlet.UnavailableContainerException
 *  javax.microedition.xlet.XletContext
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.xlet;

import com.airbiquity.sdp.common.SDPClientException;
import com.airbiquity.sdp.common.XletModule;
import com.sprint.gskills.controller.GSkillsVehicleBrand;
import com.sprint.gskills.controller.SensorsManager;
import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsUIRunnable;
import com.sun.lwuit.Display;
import java.awt.Container;
import java.rmi.registry.Registry;
import javax.microedition.xlet.UnavailableContainerException;
import javax.microedition.xlet.XletContext;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsModule
implements XletModule {
    private static Registry registry = null;
    private Logger logger = LoggerFactory.getLogger(GSkillsModule.class);
    private Container container = null;
    private GSkillsUIRunnable uiRunnable = null;

    public GSkillsModule(Registry registry, XletContext xletContext) {
        GSkillsModule.registry = registry;
        try {
            this.logger.trace((Object)"In GSkillsModule constructor..");
            this.container = xletContext.getContainer();
            this.container.setVisible(true);
            Display.init((Object)this.container);
            Display.getInstance().setPureTouch(true);
            Display.getInstance().setThirdSoftButton(false);
            this.initModule();
        }
        catch (UnavailableContainerException e2) {
            this.logger.error((Object)" ", (Throwable)e2);
            this.destroyModule();
            xletContext.notifyDestroyed();
        }
    }

    public void initModule() {
        this.logger.trace((Object)"In initModule()call..");
        GSkillsVehicleBrand.getInstance().defineCarBrand();
        CommonViewResourceManager.getInstance().loadLegalResource();
        SensorsManager.getInstance().hasHULanguageChanged();
    }

    public void destroyModule() {
        try {
            this.logger.debug((Object)"In destroyModule() GSkillsModule.java");
            SensorsManager.getInstance().unregisterLanguageListener();
            SensorsManager.getInstance().closeSensorConnection();
            this.uiRunnable.destroyUIRunnable();
            GSkillsProjectFactory.destroyStartApplicationExecutor();
            GSkillsProjectFactory.destroySendDataToWebsiteExecutor();
        }
        catch (Exception e2) {
            this.logger.error((Object)("destroyModule: " + e2));
        }
    }

    public void startModule() throws SDPClientException {
        this.logger.debug((Object)"startModule:");
        if (GSkillsStateManager.getInstance().getCurrentRunningState() < 1 && this.uiRunnable == null) {
            this.uiRunnable = new GSkillsUIRunnable();
        }
        new Thread(this.uiRunnable).start();
    }

    public void pauseModule() {
        this.uiRunnable.onPauseXlet();
    }

    public static Registry getRegistry() {
        return registry;
    }
}

