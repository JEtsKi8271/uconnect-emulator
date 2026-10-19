/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class ValueRangePropertiesFactory {
    private static Properties properties;
    private static Logger logger;
    private static String FILE_NAME;

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
                    logger.error((Object)("loadProperties()in ValueRangePropertiesFactory " + e3));
                }
            }
        }
    }

    public static double getValueByKey(String str) {
        double returnValue = 10000.123;
        try {
            String unitMode = GSkillsStateManager.getInstance().getCurrentUnit() == 0 ? "_US" : "_M";
            returnValue = Double.parseDouble(properties.getProperty(str + unitMode));
        }
        catch (Exception ex) {
            logger.error((Object)"", (Throwable)ex);
        }
        return returnValue;
    }

    public static int getRangeValueByKey(String str) {
        try {
            return Integer.parseInt(properties.getProperty(str));
        }
        catch (Exception ex) {
            logger.error((Object)"", (Throwable)ex);
            return -1;
        }
    }

    static {
        logger = LoggerFactory.getLogger(ValueRangePropertiesFactory.class);
        FILE_NAME = "valueRange.properties";
        properties = new Properties();
        ValueRangePropertiesFactory.loadProperties();
    }
}

