/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsTestValues {
    private static Logger logger = LoggerFactory.getLogger(GSkillsTestValues.class);
    private static String refreshRate = "";
    private static String animationDelay = "";
    private static String pollingFrequency = "";
    private static String imageIncrement = "";

    public static int getViewRefreshRate() {
        return Integer.parseInt(refreshRate);
    }

    public static int getPollingFrequency() {
        return Integer.parseInt(pollingFrequency);
    }

    public static int getAnimationDelay() {
        return Integer.parseInt(animationDelay);
    }

    public static int getImageIncrementSize() {
        return Integer.parseInt(imageIncrement);
    }

    private static void readProperties() {
        Properties prop = new Properties();
        InputStream input = null;
        try {
            System.out.println("Reading file /fs/etfs/gskills.properties");
            input = new FileInputStream("/fs/etfs/gskills.properties");
            prop.load(input);
            refreshRate = prop.getProperty("screen_refresh_frequency_msec");
            logger.debug((Object)("refresh_rate=" + refreshRate));
            animationDelay = prop.getProperty("animation_delay_msec");
            logger.debug((Object)("animation_delay=" + animationDelay));
            pollingFrequency = prop.getProperty("polling_frequency_msec");
            logger.debug((Object)("polling_frequency_msec=" + pollingFrequency));
            imageIncrement = prop.getProperty("image_increment_size");
            logger.debug((Object)("image_increment_size=" + imageIncrement));
        }
        catch (IOException io) {
            io.printStackTrace();
        }
        finally {
            if (input != null) {
                try {
                    input.close();
                }
                catch (IOException e2) {
                    e2.printStackTrace();
                }
            }
        }
    }

    static {
        GSkillsTestValues.readProperties();
    }
}

