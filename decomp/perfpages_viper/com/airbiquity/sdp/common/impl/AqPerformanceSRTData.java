/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.performancesrt.PerformanceSRTData
 */
package com.airbiquity.sdp.common.impl;

import kona.performancesrt.PerformanceSRTData;

public class AqPerformanceSRTData
implements PerformanceSRTData {
    private int dataType;
    private int intValue = 255;
    private double doubleValue = 25.5;
    private int attribute;

    private AqPerformanceSRTData(int attribute, int intValue) {
        this.dataType = 0;
        this.intValue = intValue;
        this.attribute = attribute;
    }

    private AqPerformanceSRTData(int attribute, double doubleValue2) {
        this.dataType = 1;
        this.doubleValue = doubleValue2;
        this.attribute = attribute;
    }

    private AqPerformanceSRTData(int attribute2) {
        this.attribute = attribute2;
    }

    public static AqPerformanceSRTData getDefaultPerformanceSRTData(int attribute) {
        return new AqPerformanceSRTData(attribute);
    }

    public static AqPerformanceSRTData getDoublePerformanceSRTData(int attribute, double doubleValue2) {
        return new AqPerformanceSRTData(attribute, doubleValue2);
    }

    public static AqPerformanceSRTData getIntPerformanceSRTData(int attribute, int intValue) {
        return new AqPerformanceSRTData(attribute, intValue);
    }

    public int getAttribute() {
        return this.attribute;
    }

    public int getDataType() {
        return this.dataType;
    }

    public double getDoubleValue() {
        return this.doubleValue;
    }

    public int getIntValue() {
        return this.intValue;
    }
}

