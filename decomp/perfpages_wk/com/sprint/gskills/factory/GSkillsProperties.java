/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import java.io.InputStream;
import java.util.Properties;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsProperties {
    private static Logger _logger = LoggerFactory.getLogger(GSkillsProperties.class);
    private static Properties _valueRangeProperties = new Properties();

    private static void loadValueRangeProperties() {
        InputStream in = null;
        try {
            in = ResKeyPropertiesFactory.class.getClassLoader().getResourceAsStream("common/valueRange.properties");
            _valueRangeProperties.load(in);
        }
        catch (Exception e2) {
            _logger.error((Object)("Failed to load valueRange.properties with the exception - " + e2));
        }
        finally {
            if (in != null) {
                try {
                    in.close();
                }
                catch (Exception e3) {
                    _logger.error((Object)("Failed to close properties files with the exception - " + e3));
                }
            }
        }
    }

    public static double getSensorDisplayRangeByKey(String sensorName) {
        return Double.parseDouble(_valueRangeProperties.getProperty(sensorName));
    }

    static {
        GSkillsProperties.loadValueRangeProperties();
    }
}

