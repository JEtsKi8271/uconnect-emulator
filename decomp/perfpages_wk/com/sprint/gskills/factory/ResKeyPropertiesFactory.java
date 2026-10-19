/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.PlatformException
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.view.common.GSkillsStateManager;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import kona.platform.PlatformException;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class ResKeyPropertiesFactory {
    private static Logger _logger = LoggerFactory.getLogger(ResKeyPropertiesFactory.class);
    private static Properties _properties = new Properties();

    private static void loadProperties() {
        InputStream in = null;
        try {
            in = ResKeyPropertiesFactory.class.getClassLoader().getResourceAsStream("common/resKey.properties");
            _properties.load(in);
        }
        catch (IOException e2) {
            _logger.error((Object)(" " + e2));
        }
        finally {
            if (in != null) {
                try {
                    in.close();
                }
                catch (IOException e3) {
                    _logger.error((Object)(" loadProperties() in ResKeyPropertiesFactory " + e3));
                }
            }
        }
    }

    public static String getLocalizationResFileName() {
        try {
            if (PlatformInfo.getPlatformInfo().getPlatformVariant().equalsIgnoreCase("2:CH:USA:VP4")) {
                return _properties.getProperty("localization_ch_res");
            }
            return _properties.getProperty("localization_res");
        }
        catch (PlatformException e2) {
            e2.printStackTrace();
            return _properties.getProperty("localization_res");
        }
    }

    public static String getFontResFileName() {
        return _properties.getProperty("font_res");
    }

    public static String getCommonGraphicsResFileName() {
        return _properties.getProperty("gskills_common_res");
    }

    public static String getLocaleName() {
        return _properties.getProperty("locale_name");
    }

    public static String getSDSavePath() {
        return _properties.getProperty("save_path_SD");
    }

    public static String getUSBSavePath() {
        return _properties.getProperty("save_path_USB");
    }

    public static String getSaveFolder() {
        return _properties.getProperty("save_folder_name");
    }

    public static int getServiceType() {
        return Integer.parseInt(_properties.getProperty("service_type"));
    }

    public static String getBrandWebSite() {
        return _properties.getProperty("website_" + GSkillsStateManager.getInstance().getVehicleBrand().toString());
    }

    public static int saveToUConnectTimeOutMin() {
        return Integer.parseInt(_properties.getProperty("save_to_uconnect_timeout_min"));
    }

    public static int getDelayedTimerRegisterRetryTime() {
        return Integer.parseInt(_properties.getProperty("delay_timer_register_retry_sec"));
    }

    public static boolean useTestValues() {
        return Boolean.valueOf(_properties.getProperty("use_test_values"));
    }

    public static boolean useSharedResources() {
        return Boolean.valueOf(_properties.getProperty("use_shared_resources"));
    }

    public static String getSharedResourcesPath() {
        return _properties.getProperty("shared_resources_path");
    }

    static {
        ResKeyPropertiesFactory.loadProperties();
    }
}

