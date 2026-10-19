/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.performancesrt.PerformanceSRTData
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsPerformanceSRTData;
import com.sprint.gskills.model.CommonTimerModelImpl;
import kona.performancesrt.PerformanceSRTData;

class LastTimerMetricModelListener
extends CommonTimerModelImpl {
    public LastTimerMetricModelListener() {
        super("LastMetricTimer");
    }

    public String getZeroToSixtyValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(2)).getDoubleValue());
    }

    public String getEighthEValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(10)).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(14)).getIntValue());
    }

    public String getQuarterEtValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(20)).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(26)).getIntValue());
    }

    public String getBrakeDistValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(31)).getIntValue());
    }

    public String getBrakeSpeedValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(37)).getIntValue());
    }

    protected void initializeAttributeToListenTo() {
        this.performanceSRTAttributesToValue.put(2, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(2));
        this.performanceSRTAttributesToValue.put(10, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(10));
        this.performanceSRTAttributesToValue.put(14, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(14));
        this.performanceSRTAttributesToValue.put(20, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(20));
        this.performanceSRTAttributesToValue.put(26, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(26));
        this.performanceSRTAttributesToValue.put(31, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(31));
        this.performanceSRTAttributesToValue.put(37, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(37));
    }
}

