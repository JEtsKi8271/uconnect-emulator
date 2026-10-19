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

class CurrentTimerMetricModelListener
extends CommonTimerModelImpl {
    public CurrentTimerMetricModelListener() {
        super("CurrentMetricTimer");
    }

    public String getZeroToSixtyValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(0)).getDoubleValue());
    }

    public String getEighthEValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(6)).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(12)).getIntValue());
    }

    public String getQuarterEtValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(18)).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(24)).getIntValue());
    }

    public String getBrakeDistValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(30)).getIntValue());
    }

    public String getBrakeSpeedValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(36)).getIntValue());
    }

    protected void initializeAttributeToListenTo() {
        this.performanceSRTAttributesToValue.put(0, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(0));
        this.performanceSRTAttributesToValue.put(6, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(6));
        this.performanceSRTAttributesToValue.put(12, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(12));
        this.performanceSRTAttributesToValue.put(18, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(18));
        this.performanceSRTAttributesToValue.put(24, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(24));
        this.performanceSRTAttributesToValue.put(30, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(30));
        this.performanceSRTAttributesToValue.put(36, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(36));
    }
}

