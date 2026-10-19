/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.EncodedImage
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.plaf.UIManager
 *  com.sun.lwuit.util.Resources
 *  kona.platform.PlatformInfo
 *  kona.utils.Resource
 *  kona.utils.ResourceException
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.EncodedImage;
import com.sun.lwuit.Font;
import com.sun.lwuit.Image;
import com.sun.lwuit.plaf.UIManager;
import com.sun.lwuit.util.Resources;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import kona.platform.PlatformInfo;
import kona.utils.Resource;
import kona.utils.ResourceException;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

/*
 * This class specifies class file version 49.0 but uses Java 6 signatures.  Assumed Java 6.
 */
public class GSkillsResourceManager {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private Resource _resourceUtil = null;
    private Resources _fontResource = null;
    private Resources _localizationResource = null;
    private String _currentLocale = "";
    private boolean _useSharedResources;
    private String _sharedResourcePath;
    private ArrayList<String> _localeList = null;
    private HashMap<String, Image> _commonGraphicsCache = null;
    private HashMap<String, Image> _lineSpecificGraphicsCache = null;
    private HashMap<String, Image> _trimSpecificGraphicsCache = null;
    private final String VEH_LINE = GSkillsStateManager.getInstance().getVehicleLine().toString();
    private final String VEH_TRIM = GSkillsStateManager.getInstance().getVehicleTrim().toString();
    private static final GSkillsResourceManager INSTANCE = new GSkillsResourceManager();

    private GSkillsResourceManager() {
        boolean bl2 = this._useSharedResources = ResKeyPropertiesFactory.useSharedResources() && false == PlatformInfo.isRunningInEmulator();
        if (this._useSharedResources) {
            this._resourceUtil = Resource.getInstance();
            this._sharedResourcePath = ResKeyPropertiesFactory.getSharedResourcesPath();
        }
    }

    public static GSkillsResourceManager getInstance() {
        return INSTANCE;
    }

    public synchronized void loadFontResourceFile() {
        try {
            if (null == this._fontResource) {
                String fontResFileName = ResKeyPropertiesFactory.getFontResFileName();
                if (this._useSharedResources) {
                    this._logger.debug((Object)("************* Using pre-installed font resource file at " + this._sharedResourcePath + fontResFileName + " ***************"));
                    this._fontResource = Resources.open((InputStream)this._resourceUtil.getResourcesAsInputStream(this._sharedResourcePath + fontResFileName));
                } else {
                    this._logger.debug((Object)("************* Using font resource file at " + fontResFileName + " ***************"));
                    this._fontResource = Resources.open((InputStream)this.getClass().getResourceAsStream(fontResFileName));
                }
            }
        }
        catch (IOException e2) {
            e2.printStackTrace();
        }
        catch (ResourceException e3) {
            e3.printStackTrace();
        }
    }

    public synchronized void loadLocalizationResourceFile() {
        try {
            if (null == this._localizationResource) {
                String localizationResFileName = ResKeyPropertiesFactory.getLocalizationResFileName();
                if (this._useSharedResources) {
                    this._logger.debug((Object)("************* Using pre-installed localization resource file at " + this._sharedResourcePath + localizationResFileName + " ***************"));
                    this._localizationResource = Resources.open((InputStream)this._resourceUtil.getResourcesAsInputStream(this._sharedResourcePath + localizationResFileName));
                } else {
                    this._logger.debug((Object)("************* Using localization resource file at " + localizationResFileName + " ***************"));
                    this._localizationResource = Resources.open((InputStream)this.getClass().getResourceAsStream(localizationResFileName));
                }
                this._localeList = Collections.list(this._localizationResource.listL10NLocales(ResKeyPropertiesFactory.getLocaleName()));
            }
        }
        catch (IOException e2) {
            e2.printStackTrace();
        }
        catch (ResourceException e3) {
            e3.printStackTrace();
        }
    }

    public synchronized void loadCommonGraphicsResFile() {
        if (this._commonGraphicsCache == null) {
            this._commonGraphicsCache = new HashMap();
            this.createImageCache(this._commonGraphicsCache, this.loadResFile(ResKeyPropertiesFactory.getCommonGraphicsResFileName()));
        }
    }

    public synchronized void loadLineSpecificGraphicsResFile() {
        if (this._lineSpecificGraphicsCache == null) {
            this._lineSpecificGraphicsCache = new HashMap();
            this.createImageCache(this._lineSpecificGraphicsCache, this.loadResFile("/" + this.VEH_LINE + "/" + this.VEH_LINE + "_common.res"));
        }
    }

    public synchronized void loadTrimSpecificGraphicsResFile() {
        if (this._trimSpecificGraphicsCache == null) {
            this._trimSpecificGraphicsCache = new HashMap();
            this.createImageCache(this._trimSpecificGraphicsCache, this.loadResFile("/" + this.VEH_LINE + "/" + this.VEH_LINE + "_" + this.VEH_TRIM + ".res"));
        }
    }

    private Resources loadResFile(String resFilePath) {
        Resources resFile = null;
        try {
            if (this._useSharedResources) {
                this._logger.debug((Object)("************* Using pre-installed resource file " + this._sharedResourcePath + resFilePath + " ***************"));
                resFile = Resources.open((InputStream)this._resourceUtil.getResourcesAsInputStream(this._sharedResourcePath + resFilePath));
            } else {
                this._logger.debug((Object)("************* Loading resource file " + resFilePath + " ***************"));
                resFile = Resources.open((InputStream)GSkillsResourceManager.class.getResourceAsStream(resFilePath));
            }
        }
        catch (IOException e2) {
            e2.printStackTrace();
        }
        catch (ResourceException e3) {
            e3.printStackTrace();
        }
        return resFile;
    }

    private void getResOnLanguageChanged() {
        UIManager.getInstance().setResourceBundle(this._localizationResource.getL10N(ResKeyPropertiesFactory.getLocaleName(), this._currentLocale));
        this._localizationResource.getL10N(ResKeyPropertiesFactory.getLocaleName(), this._currentLocale);
    }

    public String getLanguageResByKey(String lanResKey) {
        try {
            return UIManager.getInstance().localize(lanResKey, "");
        }
        catch (Exception ex) {
            this._logger.error((Object)("key not exist : " + lanResKey), (Throwable)ex);
            return lanResKey + "NOT EXIST";
        }
    }

    public Font getFontByKey(String fontResKey) {
        return this._fontResource.getFont(fontResKey);
    }

    public Image getCommonImage(String imageName) {
        if (this._commonGraphicsCache == null) {
            this.loadCommonGraphicsResFile();
        }
        return this._commonGraphicsCache.get(imageName);
    }

    public Image getLineSpecificImage(String imageName) {
        if (this._lineSpecificGraphicsCache == null) {
            this.loadLineSpecificGraphicsResFile();
        }
        return this._lineSpecificGraphicsCache.get(imageName);
    }

    public Image getTrimSpecificImage(String imageName) {
        if (this._trimSpecificGraphicsCache == null) {
            this.loadTrimSpecificGraphicsResFile();
        }
        return this._trimSpecificGraphicsCache.get(imageName);
    }

    public void setCurrentLocale(String localeName) {
        if (!this._localeList.contains(localeName)) {
            this._logger.debug((Object)("******************** Locale " + localeName + " not supported by the res file. Using default locale en_US instead *******************"));
            localeName = "en_US";
        }
        if (!this._currentLocale.equalsIgnoreCase(localeName)) {
            this._logger.debug((Object)("**************** Locale changed to " + localeName + " **************************"));
            this._currentLocale = localeName;
            this.getResOnLanguageChanged();
        }
    }

    public String getCurrentLocale() {
        return this._currentLocale;
    }

    private void createImageCache(HashMap<String, Image> map, Resources res) {
        String[] imgNames = res.getImageResourceNames();
        for (int i2 = 0; i2 < imgNames.length; ++i2) {
            EncodedImage enImg = (EncodedImage)res.getImage(imgNames[i2]);
            Image img = Image.createImage((byte[])enImg.getImageData(), (int)0, (int)enImg.getImageData().length);
            map.put(imgNames[i2], img);
        }
    }
}

