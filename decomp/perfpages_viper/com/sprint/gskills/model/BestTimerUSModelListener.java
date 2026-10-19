/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  kona.performancesrt.PerformanceSRTData
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsPerformanceSRTData;
import com.sprint.gskills.model.CommonTimerModelImpl;
import kona.logger.Log;
import kona.performancesrt.PerformanceSRTData;
import net.sf.microlog.core.Logger;

class BestTimerUSModelListener
extends CommonTimerModelImpl {
    private Logger logger = Log.createLogger((String)this.getClass().getName());

    public BestTimerUSModelListener() {
        super("BestUSTimer");
    }

    protected void initializeAttributeToListenTo() {
        this.performanceSRTAttributesToValue.put(5, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(5));
        this.performanceSRTAttributesToValue.put(9, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(9));
        this.performanceSRTAttributesToValue.put(17, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(17));
        this.performanceSRTAttributesToValue.put(23, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(23));
        this.performanceSRTAttributesToValue.put(29, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(29));
    }

    public String getZeroToSixtyValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(5)).getDoubleValue());
    }

    public String getEighthEValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(9)).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(17)).getIntValue());
    }

    public String getQuarterEtValue() {
        return this.decimalFormat.format(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(23)).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(((PerformanceSRTData)this.performanceSRTAttributesToValue.get(29)).getIntValue());
    }

    public String getBrakeDistValue() {
        this.logger.error((Object)"unimplemented method");
        return "--";
    }

    public String getBrakeSpeedValue() {
        this.logger.error((Object)"unimplemented method");
        return "--";
    }
}

