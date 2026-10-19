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

class CurrentTimerUSModelListener
extends CommonTimerModelImpl {
    public CurrentTimerUSModelListener() {
        super("CurrentUSTimer");
    }

    public String getZeroToSixtyValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(1)).getDoubleValue());
    }

    public String getEighthEValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(7)).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(13)).getIntValue());
    }

    public String getQuarterEtValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(19)).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(25)).getIntValue());
    }

    public String getBrakeDistValue() {
        return this.convertYardtoFeet(Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(35)).getIntValue()));
    }

    public String getBrakeSpeedValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(39)).getIntValue());
    }

    protected void initializeAttributeToListenTo() {
        this.performanceSRTAttributesToValue.put(1, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(1));
        this.performanceSRTAttributesToValue.put(7, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(7));
        this.performanceSRTAttributesToValue.put(13, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(13));
        this.performanceSRTAttributesToValue.put(19, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(19));
        this.performanceSRTAttributesToValue.put(25, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(25));
        this.performanceSRTAttributesToValue.put(35, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(35));
        this.performanceSRTAttributesToValue.put(39, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(39));
    }
}

