/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsXletProperties {
    private static Logger logger = Log.createLogger((String)"GSkillsXletProperties");
    private static Properties properties = new Properties();
    private static final String FILE_NAME = "xlet.properties";
    private static final String XLET_VERSION = "xlet.version";

    private static void loadProperties() {
        InputStream in = null;
        try {
            logger.info((Object)"Loading properties from file = xlet.properties");
            in = GSkillsXletProperties.class.getClassLoader().getResourceAsStream(FILE_NAME);
            properties.load(in);
        }
        catch (Throwable e2) {
            logger.error((Object)"Unable to load properties: ", e2);
        }
        finally {
            if (in != null) {
                try {
                    in.close();
                }
                catch (IOException e3) {
                    logger.error((Object)"Unable to close properties: ", (Throwable)e3);
                }
            }
        }
    }

    public static String getXletVersion() {
        return properties.getProperty(XLET_VERSION);
    }

    static {
        GSkillsXletProperties.loadProperties();
    }
}

