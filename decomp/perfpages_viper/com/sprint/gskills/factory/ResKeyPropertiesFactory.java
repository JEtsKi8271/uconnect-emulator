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
    private static Logger logger = LoggerFactory.getLogger(ResKeyPropertiesFactory.class);
    private static Properties properties = new Properties();
    private static String carBrand;
    private static final String FILE_NAME = "resKey.properties";
    private static final String COMMON_RES_FILE = "commonResFile";
    private static final String BRAND_SPECIFIC_RES_FILE = "brandSpecificResFile";
    private static final String LEGAL_RES_FILE = "legalResName";
    private static final String LEGAL_RES_CHINA_FILE = "legalResName_ch";
    private static final String LANGUAGE_RES_NAME = "lanResName";
    private static final String SAVE_PATH_SD = "savePath_SD";
    private static final String SAVE_PATH_USB = "savePath_USB";
    private static final String SAVE_FOLDER_NAME = "save_folder_name";
    private static final String SERVICE_TYPE = "serviceType";
    private static final String SAVE_UCONNECT_TIMEOUT_MIN = "save_to_uconnect_timeout_min";
    private static final String SRT_WEBSITE = "website";
    private static final String TIMERS_REGISTER_RETRY_TIME_SEC = "timers_register_retry_time_sec";
    private static final String VIEW_REFRESH_FREQUENCY = "screen_refresh_frequency_msec";
    private static final String USE_SHARED_RESOURCES = "use_shared_resources";

    private static void loadProperties() {
        InputStream in = null;
        try {
            in = ResKeyPropertiesFactory.class.getClassLoader().getResourceAsStream(FILE_NAME);
            properties.load(in);
        }
        catch (IOException e2) {
            logger.error((Object)(" " + e2));
        }
        finally {
            if (in != null) {
                try {
                    in.close();
                }
                catch (IOException e3) {
                    logger.error((Object)(" loadProperties() in ResKeyPropertiesFactory " + e3));
                }
            }
        }
    }

    public static String getLegalResName() {
        try {
            if (PlatformInfo.getPlatformInfo().getPlatformVariant().equalsIgnoreCase("2:CH:USA:VP4")) {
                return properties.getProperty(LEGAL_RES_CHINA_FILE);
            }
            return properties.getProperty(LEGAL_RES_FILE);
        }
        catch (PlatformException e2) {
            e2.printStackTrace();
            return properties.getProperty(LEGAL_RES_FILE);
        }
    }

    public static String getCommonResFileName() {
        return properties.getProperty(COMMON_RES_FILE);
    }

    public static String getBrandSpecificResFileName() {
        return properties.getProperty(BRAND_SPECIFIC_RES_FILE);
    }

    public static String getLanguageResName() {
        return properties.getProperty(LANGUAGE_RES_NAME);
    }

    public static String getSDSavePath() {
        return properties.getProperty(SAVE_PATH_SD);
    }

    public static String getUSBSavePath() {
        return properties.getProperty(SAVE_PATH_USB);
    }

    public static String getSaveFolder() {
        return properties.getProperty(SAVE_FOLDER_NAME);
    }

    public static int getServiceType() {
        return Integer.parseInt(properties.getProperty(SERVICE_TYPE));
    }

    public static String getThemeKey(int themeCode) {
        return properties.getProperty("carTheme_" + carBrand + themeCode);
    }

    public static String getBrandWebSite() {
        return properties.getProperty(SRT_WEBSITE);
    }

    public static String getVehicleLineName(int lineNum) {
        return properties.getProperty("vehicle_line_" + lineNum);
    }

    public static int saveToUConnectTimeOutMin() {
        return Integer.parseInt(properties.getProperty(SAVE_UCONNECT_TIMEOUT_MIN));
    }

    public static int getTimersRegisterRetryTime() {
        return Integer.parseInt(properties.getProperty(TIMERS_REGISTER_RETRY_TIME_SEC));
    }

    public static int getViewRefreshFrequency() {
        return Integer.parseInt(properties.getProperty(VIEW_REFRESH_FREQUENCY));
    }

    public static boolean useSharedResources() {
        return Boolean.valueOf(properties.getProperty(USE_SHARED_RESOURCES));
    }

    static {
        ResKeyPropertiesFactory.loadProperties();
        carBrand = GSkillsStateManager.getInstance().getVehicleLine() == 1 ? "wk_" : "zd_";
    }
}

