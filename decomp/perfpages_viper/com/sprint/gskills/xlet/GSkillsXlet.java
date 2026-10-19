/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.xlet.Xlet
 *  javax.microedition.xlet.XletContext
 *  javax.microedition.xlet.XletStateChangeException
 *  javax.microedition.xlet.ixc.IxcRegistry
 *  kona.logger.Log
 *  kona.platform.PlatformInfo
 *  kona.version.Version
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.xlet;

import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.util.GSkillsXletProperties;
import com.sprint.gskills.xlet.GSkillsModule;
import javax.microedition.xlet.Xlet;
import javax.microedition.xlet.XletContext;
import javax.microedition.xlet.XletStateChangeException;
import javax.microedition.xlet.ixc.IxcRegistry;
import kona.logger.Log;
import kona.platform.PlatformInfo;
import kona.version.Version;
import net.sf.microlog.core.Logger;

public class GSkillsXlet
implements Xlet {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private IxcRegistry registry = null;
    private GSkillsModule module;

    public void initXlet(XletContext xletContext) throws XletStateChangeException {
        try {
            this.logger.debug((Object)"=========================================================");
            this.logger.debug((Object)"***************** WK/ZD PERFORMANCE PAGES ***************");
            this.logger.debug((Object)"=========================================================");
            this.printPlatformInfo();
            this.registry = IxcRegistry.getRegistry((XletContext)xletContext);
            this.module = GSkillsProjectFactory.getGSkillsModule(this.registry, xletContext);
        }
        catch (Throwable e2) {
            this.logger.error((Object)" init ", e2);
        }
    }

    public void startXlet() throws XletStateChangeException {
        try {
            this.logger.debug((Object)"startXlet:");
            if (this.module != null) {
                this.module.startModule();
            }
        }
        catch (Throwable e2) {
            this.logger.error((Object)" start ", e2);
        }
    }

    public void pauseXlet() {
        try {
            this.logger.debug((Object)"pauseXlet:");
            if (this.module != null) {
                this.module.pauseModule();
            }
        }
        catch (Throwable e2) {
            this.logger.error((Object)" pause ", e2);
        }
    }

    public void destroyXlet(boolean arg0) throws XletStateChangeException {
        try {
            if (this.module != null) {
                this.module.destroyModule();
            }
        }
        catch (Throwable e2) {
            this.logger.error((Object)" destroy ", e2);
        }
    }

    private void printPlatformInfo() {
        StringBuilder version = null;
        try {
            PlatformInfo platformInfo = PlatformInfo.getPlatformInfo();
            Version platformVersion = platformInfo.getPlatformVersion();
            version = new StringBuilder(platformVersion.getMajor() + "." + platformVersion.getMinor() + "." + platformVersion.getRelease());
            this.logger.debug((Object)("*** START TIMESTAMP: " + System.currentTimeMillis() + " ***"));
            this.logger.debug((Object)("*** FIRMWARE VERSION: " + version.toString() + " ***"));
            this.logger.debug((Object)("*** APPLICATION VERSION: " + GSkillsXletProperties.getXletVersion() + " ***"));
            this.logger.debug((Object)("*** DEVELOPER BUILD: " + platformVersion.isDeveloperBuild() + " ***"));
            this.logger.debug((Object)("*** SW RELEASE BRANCH: " + platformInfo.getSWReleaseBranch() + " ***"));
            this.logger.debug((Object)("*** VEHICLE BRAND: " + platformInfo.getVehicleBrand() + " ***"));
            this.logger.debug((Object)("*** PLATFORM VARIANT: " + platformInfo.getPlatformVariant() + " ***"));
            this.logger.debug((Object)("*** COUNTRY: " + platformInfo.getCurrentLocale().getDisplayCountry() + " ***"));
            this.logger.debug((Object)("*** LANGUAGE: " + platformInfo.getCurrentLocale().getDisplayLanguage() + " ***"));
            this.logger.debug((Object)("*** EMBEDDED PHONE AVAILABLE: " + platformInfo.isEmbeddedPhonePresent() + " ***"));
            this.logger.debug((Object)("*** RUNNING EMULATOR: " + PlatformInfo.isRunningInEmulator() + " ***"));
        }
        catch (Exception e2) {
            this.logger.debug((Object)"Exception while reading platform version");
            e2.printStackTrace();
        }
    }
}

