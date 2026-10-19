/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.plaf.UIManager
 *  com.sun.lwuit.util.Resources
 *  kona.utils.Resource
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Font;
import com.sun.lwuit.Image;
import com.sun.lwuit.plaf.UIManager;
import com.sun.lwuit.util.Resources;
import java.io.InputStream;
import java.util.Enumeration;
import kona.utils.Resource;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class CommonViewResourceManager {
    private Logger logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private static final CommonViewResourceManager INSTANCE = new CommonViewResourceManager();
    private Resources legalDisclaimerResFile = null;
    private Resources commonImagesResFile = null;
    private Resources brandSpecificResFile = null;
    private final String sharedResourcePath;
    private Resource resourceUtil = null;
    private String currentLanguage = "";
    private final boolean useSharedResources = ResKeyPropertiesFactory.useSharedResources();
    boolean languageFlag;

    private CommonViewResourceManager() {
        this.sharedResourcePath = 1 == GSkillsStateManager.getInstance().getVehicleLine() ? "/gskills_jeep_res/" : "/gskills_viper_res/";
        if (this.useSharedResources) {
            this.resourceUtil = Resource.getInstance();
        }
    }

    public static CommonViewResourceManager getInstance() {
        return INSTANCE;
    }

    public void loadLegalResource() {
        try {
            String legalResourceFileName = ResKeyPropertiesFactory.getLegalResName();
            if (this.useSharedResources) {
                this.logger.debug((Object)("************* Using pre-installed resource file for Legal Disclaimer at " + this.sharedResourcePath + legalResourceFileName + " ***************"));
                this.legalDisclaimerResFile = Resources.open((InputStream)this.resourceUtil.getResourcesAsInputStream(this.sharedResourcePath + "/" + legalResourceFileName));
            } else {
                this.legalDisclaimerResFile = Resources.open((InputStream)this.getClass().getResourceAsStream("/" + legalResourceFileName));
            }
        }
        catch (Exception e2) {
            this.logger.error((Object)"Error loading legal resource file with exception - ", (Throwable)e2);
        }
    }

    public void loadCommonResources() {
        try {
            if (this.commonImagesResFile == null) {
                String commonImagesResFileName = ResKeyPropertiesFactory.getCommonResFileName();
                if (this.useSharedResources) {
                    this.logger.debug((Object)("************* Using pre-installed resource file for common resources at " + this.sharedResourcePath + commonImagesResFileName + " ***************"));
                    this.commonImagesResFile = Resources.open((InputStream)this.resourceUtil.getResourcesAsInputStream(this.sharedResourcePath + "/" + commonImagesResFileName));
                } else {
                    this.commonImagesResFile = Resources.open((InputStream)CommonViewResourceManager.class.getResourceAsStream("/" + commonImagesResFileName));
                }
            }
        }
        catch (Exception e2) {
            this.logger.error((Object)"Error loading common resource file with exception - ", (Throwable)e2);
        }
    }

    public void loadBrandSpecificResources() {
        try {
            String brandSpecificResFileName = ResKeyPropertiesFactory.getBrandSpecificResFileName();
            if (this.useSharedResources) {
                this.logger.debug((Object)("************* Using pre-installed resource file for GForce at " + this.sharedResourcePath + brandSpecificResFileName + " ***************"));
                this.brandSpecificResFile = Resources.open((InputStream)this.resourceUtil.getResourcesAsInputStream(this.sharedResourcePath + "/" + brandSpecificResFileName));
            } else {
                this.brandSpecificResFile = Resources.open((InputStream)CommonViewResourceManager.class.getResourceAsStream("/" + brandSpecificResFileName));
            }
        }
        catch (Exception e2) {
            this.logger.error((Object)"Error loading brand specific resource file with exception - ", (Throwable)e2);
        }
    }

    private void getResOnLanguageChanged() {
        if (this.legalDisclaimerResFile == null) {
            this.loadLegalResource();
        }
        if (this.legalDisclaimerResFile != null) {
            UIManager.getInstance().setResourceBundle(this.legalDisclaimerResFile.getL10N(ResKeyPropertiesFactory.getLanguageResName(), this.currentLanguage));
            this.legalDisclaimerResFile.getL10N(ResKeyPropertiesFactory.getLanguageResName(), this.currentLanguage);
        }
    }

    public String getSupportedLocale(String localeName) {
        try {
            Enumeration supportedLocales = this.legalDisclaimerResFile.listL10NLocales(ResKeyPropertiesFactory.getLanguageResName());
            while (supportedLocales.hasMoreElements()) {
                if (!((String)supportedLocales.nextElement()).equals(localeName)) continue;
                return localeName;
            }
            return "en_US";
        }
        catch (Exception e2) {
            this.logger.error((Object)"verifyLocaleSupported:", (Throwable)e2);
            return "en_US";
        }
    }

    public String getLanguageResByKey(String lanResKey) {
        try {
            return UIManager.getInstance().localize(lanResKey, "");
        }
        catch (Exception ex) {
            this.logger.error((Object)("key not exist : " + lanResKey), (Throwable)ex);
            return lanResKey + "NOT EXIST";
        }
    }

    public Font getFontByKey(String fontResKey) {
        return this.legalDisclaimerResFile.getFont(fontResKey);
    }

    public Image getImgFromCommonResFile(String imageName) {
        if (this.commonImagesResFile == null) {
            this.loadCommonResources();
        }
        return this.commonImagesResFile.getImage(imageName);
    }

    public Image getImgFromBrandSpecificResFile(String imageName) {
        if (this.brandSpecificResFile == null) {
            this.loadBrandSpecificResources();
        }
        return this.brandSpecificResFile.getImage(imageName);
    }

    public boolean setCurrentLanguage(String localeName) {
        boolean languageChanged = false;
        String languageName = this.getSupportedLocale(localeName);
        if (!this.currentLanguage.equalsIgnoreCase(languageName)) {
            this.logger.debug((Object)("Language has changed. Setting current language from " + this.currentLanguage + " to " + languageName));
            languageChanged = true;
            this.currentLanguage = languageName;
            if (this.currentLanguage.equalsIgnoreCase("ar_AR")) {
                UIManager.getInstance().getLookAndFeel().setRTL(true);
            } else {
                UIManager.getInstance().getLookAndFeel().setRTL(false);
            }
            this.getResOnLanguageChanged();
        }
        return languageChanged;
    }
}

