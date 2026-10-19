/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.ChannelInfo
 *  konax.sensors.Data
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.airbiquity.sdp.common.impl;

import konax.sensors.ChannelInfo;
import konax.sensors.Data;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class SDPCommonUtil {
    private static Logger logger = LoggerFactory.getLogger(SDPCommonUtil.class);
    public static final String DATA_DELIMITER = "|";
    public static final String VALUE_DELIMITER = " ";

    public static String dataToString(Data[] data) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i2 = 0; i2 < data.length - 1; ++i2) {
            Data dataItem = data[i2];
            String dataStr = SDPCommonUtil.toString(dataItem);
            stringBuilder.append(dataStr);
            stringBuilder.append(DATA_DELIMITER);
        }
        if (data.length >= 1) {
            Data dataItem = data[data.length - 1];
            String dataStr = SDPCommonUtil.toString(dataItem);
            stringBuilder.append(dataStr);
        }
        return stringBuilder.toString();
    }

    private static String toString(Data dataItem) {
        String values = "";
        ChannelInfo channelInfo = dataItem.getChannelInfo();
        if (channelInfo.getDataType() == 2) {
            int[] intData = dataItem.getIntValues();
            values = SDPCommonUtil.toString(intData, VALUE_DELIMITER);
        } else if (channelInfo.getDataType() == 1) {
            double[] doubData = dataItem.getDoubleValues();
            values = SDPCommonUtil.toString(doubData, VALUE_DELIMITER);
        } else if (channelInfo.getDataType() == 4) {
            Object[] objData = dataItem.getObjectValues();
            values = SDPCommonUtil.toString(objData, VALUE_DELIMITER);
        } else {
            logger.error((Object)("Unknown data type found for channelInfo: " + channelInfo.getDataType()));
        }
        return values;
    }

    private static String toString(int[] array, String delimiter) {
        StringBuilder sb = new StringBuilder();
        for (int i2 = 0; i2 < array.length - 1; ++i2) {
            sb.append(array[i2]);
            sb.append(delimiter);
        }
        if (array.length >= 1) {
            sb.append(array[array.length - 1]);
        }
        return sb.toString();
    }

    private static String toString(double[] array, String delimiter) {
        StringBuilder sb = new StringBuilder();
        for (int i2 = 0; i2 < array.length - 1; ++i2) {
            sb.append(array[i2]);
            sb.append(delimiter);
        }
        if (array.length >= 1) {
            sb.append(array[array.length - 1]);
        }
        return sb.toString();
    }

    private static String toString(Object[] array, String delimiter) {
        StringBuilder sb = new StringBuilder();
        for (int i2 = 0; i2 < array.length - 1; ++i2) {
            sb.append(array[i2]);
            sb.append(delimiter);
        }
        if (array.length >= 1) {
            sb.append(array[array.length - 1]);
        }
        return sb.toString();
    }
}

