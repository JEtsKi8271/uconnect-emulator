/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Display
 *  javax.microedition.xlet.XletContext
 *  javax.microedition.xlet.ixc.IxcRegistry
 *  kona.platform.PlatformInfo
 *  kona.version.Version
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.xlet;

import com.sprint.gskills.concurrency.GSkillsRunnableWithErrorHandler;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.controller.GSkillsVehicleInfo;
import com.sprint.gskills.controller.SensorsManager;
import com.sprint.gskills.util.GSkillsXletProperties;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsUIRunnable;
import com.sun.lwuit.Display;
import java.awt.Container;
import java.rmi.registry.Registry;
import java.util.Date;
import javax.microedition.xlet.XletContext;
import javax.microedition.xlet.ixc.IxcRegistry;
import kona.platform.PlatformInfo;
import kona.version.Version;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsModule {
    private static final GSkillsModule INSTANCE = new GSkillsModule();
    private Registry _registry = null;
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private static final int FRAMERATE = 10;

    public static GSkillsModule getInstance() {
        return INSTANCE;
    }

    private GSkillsModule() {
    }

    public void initModule(XletContext xletContext) throws Exception {
        this._logger.debug((Object)"INIT:entering initModule()");
        this._logger.debug((Object)"===================================================================");
        this._logger.debug((Object)"************************* PERFORMANCE PAGES ***********************");
        this._logger.debug((Object)"===================================================================");
        Container container = xletContext.getContainer();
        container.setVisible(true);
        Display.init((Object)container);
        Display.getInstance().setPureTouch(true);
        Display.getInstance().setThirdSoftButton(false);
        Display.getInstance().setFramerate(10);
        this._registry = IxcRegistry.getRegistry((XletContext)xletContext);
        if (!PlatformInfo.isRunningInEmulator()) {
            this.printPlatformInfo();
        }
        GSkillsVehicleInfo.getInstance().setVehicleInfo();
        if (GSkillsStateManager.getInstance().getVehicleLine() == VehicleLineEnum.UNSUPPORTED) {
            this._logger.debug((Object)"****************************************************************");
            this._logger.debug((Object)"INIT:Running on an unsupported vehicle line. Closing application");
            this._logger.debug((Object)"****************************************************************");
            throw new Exception("Unsupported vehicle line");
        }
        this._logger.debug((Object)"INIT:exiting initModule()");
    }

    public void startModule() throws Exception {
        this._logger.debug((Object)"INIT:entering startModule()");
        if (GSkillsStateManager.getInstance().getVehicleLine() == VehicleLineEnum.UNSUPPORTED) {
            this._logger.debug((Object)"****************************************************************");
            this._logger.debug((Object)"INIT:Running on an unsupported vehicle line. Closing application");
            this._logger.debug((Object)"****************************************************************");
            throw new Exception("Unsupported vehicle line");
        }
        GSkillsThreadManager threadManager = GSkillsThreadManager.getInstance();
        threadManager.startThreadMonitor();
        threadManager.submit(new GSkillsRunnableWithErrorHandler(GSkillsUIRunnable.getInstance()));
        this._logger.debug((Object)"INIT:exiting startModule()");
    }

    public void pauseModule() {
        this._logger.debug((Object)"GSkillsModule: In pauseModule");
        GSkillsUIRunnable.getInstance().onPauseXlet();
    }

    public void destroyModule() {
        try {
            this._logger.debug((Object)"GSkillsModule: In destroyModule()");
            GSkillsUIRunnable.getInstance().destroyUIRunnable();
            SensorsManager.getInstance().closeAllSensorConnections();
            GSkillsThreadManager.getInstance().destroy();
        }
        catch (Exception e2) {
            this._logger.error((Object)("destroyModule: " + e2));
        }
    }

    public Registry getRegistry() {
        return this._registry;
    }

    private void printPlatformInfo() {
        StringBuilder version = null;
        try {
            PlatformInfo platformInfo = PlatformInfo.getPlatformInfo();
            Version platformVersion = platformInfo.getPlatformVersion();
            version = new StringBuilder(platformVersion.getMajor() + "." + platformVersion.getMinor() + "." + platformVersion.getRelease());
            this._logger.debug((Object)("*** START TIMESTAMP: " + new Date(System.currentTimeMillis()) + " ***"));
            this._logger.debug((Object)("*** FIRMWARE VERSION: " + version.toString() + " ***"));
            this._logger.debug((Object)("*** APPLICATION VERSION: " + GSkillsXletProperties.getJarName() + GSkillsXletProperties.getXletVersion() + " ***"));
            this._logger.debug((Object)("*** VEHICLE BRAND: " + platformInfo.getVehicleBrand() + " ***"));
            this._logger.debug((Object)("*** PLATFORM VARIANT: " + platformInfo.getPlatformVariant() + " ***"));
            this._logger.debug((Object)("*** COUNTRY: " + platformInfo.getCurrentLocale().getDisplayCountry() + " ***"));
            this._logger.debug((Object)("*** LANGUAGE: " + platformInfo.getCurrentLocale().getDisplayLanguage() + " ***"));
            this._logger.debug((Object)("*** EMBEDDED PHONE AVAILABLE: " + platformInfo.isEmbeddedPhonePresent() + " ***"));
        }
        catch (Exception e2) {
            this._logger.debug((Object)"Exception while reading platform version");
            e2.printStackTrace();
        }
    }
}

