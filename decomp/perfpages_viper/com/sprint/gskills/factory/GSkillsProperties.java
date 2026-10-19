/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsProperties {
    private static Logger logger = Log.createLogger((String)"GSkillsProperties");
    private static Properties properties = new Properties();
    private static final String FILE_NAME = "gskills.properties";
    private static final String DATA_LISTENER_THREAD_POOL_SIZE = "data_listener_thread_pool_size";
    private static final String VIEWCHANGE_THREAD_POOL_SIZE = "view_change_thread_pool_size";
    private static final String START_APP_THREAD_POOL_SIZE = "start_app_thread_pool_size";
    private static final String SEND_DATA_TO_WEBSITE = "send_data_to_website";
    private static final String LISTENER_BUFFER_SIZE = "harman_listener_buffer_size";
    private static final String DELAY_REGISTER_TIMER_LISTENER_THREAD_POOL_SIZE = "delay_register_timer_listener_thread_pool_size";

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
                    logger.error((Object)("loadProperties() in GSkillsProperties " + e3));
                }
            }
        }
    }

    public static int getDataListenersThreadpoolSize() {
        String threadPoolsize = properties.getProperty(DATA_LISTENER_THREAD_POOL_SIZE);
        return Integer.parseInt(threadPoolsize);
    }

    public static int getViewChangeThreadpoolSize() {
        String threadPoolsize = properties.getProperty(VIEWCHANGE_THREAD_POOL_SIZE);
        return Integer.parseInt(threadPoolsize);
    }

    public static int getStartAppThreadpoolSize() {
        String threadPoolsize = properties.getProperty(START_APP_THREAD_POOL_SIZE);
        return Integer.parseInt(threadPoolsize);
    }

    public static int getSendDataToWebsiteThreadpoolSize() {
        String threadPoolsize = properties.getProperty(SEND_DATA_TO_WEBSITE);
        return Integer.parseInt(threadPoolsize);
    }

    public static int getHarmanListenerBufferSize() {
        String bufferSize = properties.getProperty(LISTENER_BUFFER_SIZE);
        return Integer.parseInt(bufferSize);
    }

    public static int getRegisterTimerListenerThreadpoolSize() {
        return Integer.parseInt(properties.getProperty(DELAY_REGISTER_TIMER_LISTENER_THREAD_POOL_SIZE));
    }

    static {
        GSkillsProperties.loadProperties();
    }
}

