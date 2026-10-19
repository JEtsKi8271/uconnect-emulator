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

class BestTimerMetricModelListener
extends CommonTimerModelImpl {
    public BestTimerMetricModelListener() {
        super("BestMetricTimer");
    }

    protected void initializeAttributeToListenTo() {
        this.performanceSRTAttributesToValue.put(4, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(4));
        this.performanceSRTAttributesToValue.put(8, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(8));
        this.performanceSRTAttributesToValue.put(16, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(16));
        this.performanceSRTAttributesToValue.put(22, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(22));
        this.performanceSRTAttributesToValue.put(28, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(28));
    }

    public String getZeroToSixtyValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(4)).getDoubleValue());
    }

    public String getEighthEValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(8)).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(16)).getIntValue());
    }

    public String getQuarterEtValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(22)).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(28)).getIntValue());
    }

    public String getBrakeDistValue() {
        return "--";
    }

    public String getBrakeSpeedValue() {
        return "--";
    }
}

