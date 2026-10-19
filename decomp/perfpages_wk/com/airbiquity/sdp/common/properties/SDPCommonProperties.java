/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.airbiquity.sdp.common.properties;

import com.wirelesscar.ngtp.svc.api.Version;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Properties;
import java.util.StringTokenizer;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class SDPCommonProperties {
    private static Properties properties;
    private static final String FILE_NAME = "SDPCommon.properties";
    static Logger logger;
    private static final String EMULATION_MODE = "emulation_mode";
    private static final String DSPT_MESSAGE_CODER_VERSION_MAJOR = "dspt_message_coder_version_major";
    private static final String DSPT_MESSAGE_CODER_VERSION_MINOR = "dspt_message_coder_version_minor";
    private static final String TU_TIMESTAMP = "tu_timestamp";
    private static final String GENERIC_COMP_NAME = "generic_comp_name";
    private static final String THEFT_ALARM_NAME = "theft_alarm_name";
    private static final String VIN = "vin";
    private static final String WAKEUP_REASON_NAME = "wakeupreason_sensor_name";
    private static final String SENSOR_PREFIX = "sensor_prefix";
    private static final String SENSOR_BUFFER_SIZE = "sensor_buffer_size";
    private static final String NAME_DELIMITER = ":";
    private static final String HORIZONTAL_ACURACY = "horisontal_acuracy";
    private static final String TIMEOUT_SEC = "timeout_sec";
    private static final String NUMBER_SUFFIX = "number_suffix";
    private static final String POLLING_DURATION_PREFIX = "polling_duration_prefix";
    private static final String POLLING_INTERVAL_PREFIX = "polling_interval_prefix";
    private static final String STARTTIME_PREFIX = "starttime_prefix";
    private static Version svcVersion;
    private static Object lock;

    private static void loadProperties() {
        InputStream in = null;
        try {
            logger.info((Object)"Loading properties from file = SDPCommon.properties");
            in = SDPCommonProperties.class.getClassLoader().getResourceAsStream(FILE_NAME);
            properties.load(in);
        }
        catch (Throwable e2) {
            logger.error((Object)"Can't load common properties: ", e2);
        }
        finally {
            if (in != null) {
                try {
                    in.close();
                }
                catch (IOException e3) {
                    logger.error((Object)"Can't close stream: ", (Throwable)e3);
                }
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public static boolean isAPIEmulated() {
        if (properties == null) {
            return false;
        }
        Object object = lock;
        synchronized (object) {
            String emu = properties.getProperty(EMULATION_MODE);
            return Boolean.valueOf(emu);
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public static void setAPIEmulated(Boolean emulation) {
        Object object = lock;
        synchronized (object) {
            properties.setProperty(EMULATION_MODE, emulation.toString());
        }
    }

    public static String getSensorPrefix() {
        return properties.getProperty(SENSOR_PREFIX);
    }

    public static String getWakeupReasonSensorName() {
        return SDPCommonProperties.getSensorPrefix() + NAME_DELIMITER + properties.getProperty(WAKEUP_REASON_NAME);
    }

    private static int getDSPTMessageCoderVersionMajor() {
        return Integer.parseInt(properties.getProperty(DSPT_MESSAGE_CODER_VERSION_MAJOR));
    }

    private static int getDSPTMessageCoderVersionMinor() {
        return Integer.parseInt(properties.getProperty(DSPT_MESSAGE_CODER_VERSION_MINOR));
    }

    public static com.wirelesscar.ngtp.dspt.api.Version getDSPTCoderVersion() {
        return new com.wirelesscar.ngtp.dspt.api.Version(SDPCommonProperties.getDSPTMessageCoderVersionMajor(), SDPCommonProperties.getDSPTMessageCoderVersionMinor());
    }

    public static String getGenericComponentName() {
        return properties.getProperty(GENERIC_COMP_NAME);
    }

    public static String getTheftAlarmName() {
        return properties.getProperty(THEFT_ALARM_NAME);
    }

    public static long getTimestamp() {
        String timestampStr = properties.getProperty(TU_TIMESTAMP);
        long timestamp = Long.parseLong(timestampStr);
        return timestamp;
    }

    public static String getVehicleId() {
        return properties.getProperty(VIN);
    }

    public static int getSensorBufferSize() {
        String str = properties.getProperty(SENSOR_BUFFER_SIZE);
        return Integer.parseInt(str);
    }

    public static int getLocationHorizontalAcuracy() {
        String str = properties.getProperty(HORIZONTAL_ACURACY);
        return Integer.parseInt(str);
    }

    public static int getLocationTimeout() {
        String str = properties.getProperty(TIMEOUT_SEC);
        return Integer.parseInt(str);
    }

    public static String[] getNumberPrefixArray() {
        String delim = ",";
        int expectCount = 7;
        String eString = properties.getProperty(NUMBER_SUFFIX);
        StringTokenizer stringTokenizer = new StringTokenizer(eString, delim);
        int count = stringTokenizer.countTokens();
        if (count != expectCount) {
            logger.error((Object)("Attention: Error in SDPClient property file!!! Expected count is " + expectCount + " but found " + count));
        }
        ArrayList<String> numberPrefixList = new ArrayList<String>();
        while (stringTokenizer.hasMoreTokens()) {
            numberPrefixList.add(stringTokenizer.nextToken());
        }
        String[] numberPrefixArray = numberPrefixList.toArray(new String[0]);
        return numberPrefixArray;
    }

    public static String getPollingDurationPrefix() {
        return properties.getProperty(POLLING_DURATION_PREFIX);
    }

    public static String getPollingIntervalPrefix() {
        return properties.getProperty(POLLING_INTERVAL_PREFIX);
    }

    public static String getStarttimePrefix() {
        return properties.getProperty(STARTTIME_PREFIX);
    }

    static {
        logger = LoggerFactory.getLogger(SDPCommonProperties.class);
        lock = new Object();
        properties = new Properties();
        SDPCommonProperties.loadProperties();
    }
}

