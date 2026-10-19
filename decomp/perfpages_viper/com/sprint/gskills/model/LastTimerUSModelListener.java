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

class LastTimerUSModelListener
extends CommonTimerModelImpl {
    public LastTimerUSModelListener() {
        super("LastUSTimer");
    }

    public String getZeroToSixtyValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(3)).getDoubleValue());
    }

    public String getEighthEValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(11)).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(15)).getIntValue());
    }

    public String getQuarterEtValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(21)).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(27)).getIntValue());
    }

    public String getBrakeDistValue() {
        return this.convertYardtoFeet(Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(33)).getIntValue()));
    }

    public String getBrakeSpeedValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(40)).getIntValue());
    }

    protected void initializeAttributeToListenTo() {
        this.performanceSRTAttributesToValue.put(3, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(3));
        this.performanceSRTAttributesToValue.put(11, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(11));
        this.performanceSRTAttributesToValue.put(15, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(15));
        this.performanceSRTAttributesToValue.put(21, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(21));
        this.performanceSRTAttributesToValue.put(27, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(27));
        this.performanceSRTAttributesToValue.put(33, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(33));
        this.performanceSRTAttributesToValue.put(40, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(40));
    }
}

