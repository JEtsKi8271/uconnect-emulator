/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.performancesrt.PerformanceSRTData
 */
package com.sprint.gskills.factory;

import java.io.Serializable;
import kona.performancesrt.PerformanceSRTData;

public class GSkillsPerformanceSRTData
implements PerformanceSRTData,
Serializable {
    private static final long serialVersionUID = 1L;
    private int dataType;
    private int intValue = 255;
    private double doubleValue = 25.5;
    private int attribute;

    private GSkillsPerformanceSRTData(int attribute, int intValue) {
        this.dataType = 0;
        this.intValue = intValue;
        this.attribute = attribute;
    }

    private GSkillsPerformanceSRTData(int attribute, double doubleValue) {
        this.dataType = 1;
        this.attribute = attribute;
        this.doubleValue = doubleValue;
    }

    public static GSkillsPerformanceSRTData createGSkillsPerformanceSRTData(int attribute, double doubleValue) {
        return new GSkillsPerformanceSRTData(attribute, doubleValue);
    }

    public static GSkillsPerformanceSRTData createGSkillsPerformanceSRTData(int attribute, int intValue) {
        return new GSkillsPerformanceSRTData(attribute, intValue);
    }

    private GSkillsPerformanceSRTData(int attribute) {
        this.attribute = attribute;
    }

    public static GSkillsPerformanceSRTData getDefaultPerformanceSRTData(int attribute) {
        return new GSkillsPerformanceSRTData(attribute);
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

