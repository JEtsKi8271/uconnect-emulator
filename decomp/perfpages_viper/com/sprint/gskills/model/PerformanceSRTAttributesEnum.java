/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import java.util.HashMap;
import java.util.Map;

public class PerformanceSRTAttributesEnum {
    private int timerLabelInt;
    private String timerAttributeName;
    private String timerPageTitle;
    public static final PerformanceSRTAttributesEnum SRT_60MPHTM_US = new PerformanceSRTAttributesEnum(100, "SRT_60MPHTM_US", "timer_title_sixtyET");
    public static final PerformanceSRTAttributesEnum SRT_EIGHTHTM_US = new PerformanceSRTAttributesEnum(101, "SRT_EIGHTHTM_US", "timer_title_eighthET");
    public static final PerformanceSRTAttributesEnum SRT_ETHSPD_US = new PerformanceSRTAttributesEnum(102, "SRT_ETHSPD_US", "timer_title_eighthMph");
    public static final PerformanceSRTAttributesEnum SRT_QUARTERTM_US = new PerformanceSRTAttributesEnum(103, "SRT_QUARTERTM_US", "timer_title_quarterET");
    public static final PerformanceSRTAttributesEnum SRT_QRTSPD_US = new PerformanceSRTAttributesEnum(104, "SRT_QRTSPD_US", "timer_title_quarterMph");
    public static final PerformanceSRTAttributesEnum SRT_BRKDIST_US = new PerformanceSRTAttributesEnum(105, "SRT_BRKDIST_US", "timer_title_BrakeDis");
    public static final PerformanceSRTAttributesEnum SRT_BRKSPD_US = new PerformanceSRTAttributesEnum(106, "SRT_BRKSPD_US", "timer_title_BrakeSpeed");
    public static final PerformanceSRTAttributesEnum SRT_60MPHTM_M = new PerformanceSRTAttributesEnum(100, "SRT_60MPHTM_M", "timer_title_sixtyET_M");
    public static final PerformanceSRTAttributesEnum SRT_EIGHTHTM_M = new PerformanceSRTAttributesEnum(101, "SRT_EIGHTHTM_M", "timer_title_eighthET_M");
    public static final PerformanceSRTAttributesEnum SRT_ETHSPD_M = new PerformanceSRTAttributesEnum(102, "SRT_ETHSPD_M", "timer_title_eighthMph_M");
    public static final PerformanceSRTAttributesEnum SRT_QUARTERTM_M = new PerformanceSRTAttributesEnum(103, "SRT_QUARTERTM_M", "timer_title_quarterET_M");
    public static final PerformanceSRTAttributesEnum SRT_QRTSPD_M = new PerformanceSRTAttributesEnum(104, "SRT_QRTSPD_M", "timer_title_quarterMph_M");
    public static final PerformanceSRTAttributesEnum SRT_BRKDIST_M = new PerformanceSRTAttributesEnum(105, "SRT_BRKDIST_M", "timer_title_BrakeDis_M");
    public static final PerformanceSRTAttributesEnum SRT_BRKSPD_M = new PerformanceSRTAttributesEnum(106, "SRT_BRKSPD_M", "timer_title_BrakeSpeed_M");
    private static Map PerformanceSRTAttributesToNamesMap = new HashMap();

    public PerformanceSRTAttributesEnum(int timerLabelInt, String timerAttributeName, String timerPageTitle) {
        this.timerLabelInt = timerLabelInt;
        this.timerAttributeName = timerAttributeName;
        this.timerPageTitle = timerPageTitle;
    }

    private int getIntegerValue() {
        return this.timerLabelInt;
    }

    public int hashCode() {
        return this.getIntegerValue();
    }

    public String getTimerPageTitle() {
        return this.timerPageTitle;
    }

    public static String getName(int attribute) {
        return (String)PerformanceSRTAttributesToNamesMap.get(attribute);
    }

    static {
        PerformanceSRTAttributesToNamesMap.put(1, "SRT_60MPHTM_C_US");
        PerformanceSRTAttributesToNamesMap.put(7, "SRT_EIGHTHTM_C_US");
        PerformanceSRTAttributesToNamesMap.put(19, "SRT_QUARTERTM_C_US");
        PerformanceSRTAttributesToNamesMap.put(13, "SRT_ETHSPDC_US");
        PerformanceSRTAttributesToNamesMap.put(25, "SRT_QRTSPDC_US");
        PerformanceSRTAttributesToNamesMap.put(35, "SRT_BRKDISTC_US");
        PerformanceSRTAttributesToNamesMap.put(39, "SRT_BRKSPDC_US");
        PerformanceSRTAttributesToNamesMap.put(0, "SRT_60MPHTMC_Metric");
        PerformanceSRTAttributesToNamesMap.put(6, "SRT_EIGHTHTMC_Metric");
        PerformanceSRTAttributesToNamesMap.put(18, "SRT_QUARTERTMC");
        PerformanceSRTAttributesToNamesMap.put(12, "SRT_ETHSPDC_M");
        PerformanceSRTAttributesToNamesMap.put(24, "SRT_QRTSPDC_M");
        PerformanceSRTAttributesToNamesMap.put(30, "SRT_BRKDISTC_M");
        PerformanceSRTAttributesToNamesMap.put(36, "SRT_BRKSPDC_M");
        PerformanceSRTAttributesToNamesMap.put(3, "SRT_60MPHTM_L_US");
        PerformanceSRTAttributesToNamesMap.put(11, "SRT_EIGHTHTM_L_US");
        PerformanceSRTAttributesToNamesMap.put(15, "SRT_ETHSPDL_US");
        PerformanceSRTAttributesToNamesMap.put(21, "SRT_QUARTERTM_L_US");
        PerformanceSRTAttributesToNamesMap.put(27, "SRT_QRTSPDL_US");
        PerformanceSRTAttributesToNamesMap.put(33, "SRT_BRKDISTL_US");
        PerformanceSRTAttributesToNamesMap.put(40, "SRT_BRKSPDL_US");
        PerformanceSRTAttributesToNamesMap.put(2, "SRT_60MPHTML");
        PerformanceSRTAttributesToNamesMap.put(10, "SRT_EIGHTHTML");
        PerformanceSRTAttributesToNamesMap.put(14, "SRT_ETHSPDL_M");
        PerformanceSRTAttributesToNamesMap.put(20, "SRT_QUARTERTML");
        PerformanceSRTAttributesToNamesMap.put(26, "SRT_QRTSPDL_M");
        PerformanceSRTAttributesToNamesMap.put(31, "SRT_BRKDISTL_M");
        PerformanceSRTAttributesToNamesMap.put(37, "SRT_BRKSPDL_M");
        PerformanceSRTAttributesToNamesMap.put(5, "SRT_60MPHTM_B_US");
        PerformanceSRTAttributesToNamesMap.put(9, "SRT_EIGHTHTM_B_US");
        PerformanceSRTAttributesToNamesMap.put(17, "SRT_ETHSPDB_US");
        PerformanceSRTAttributesToNamesMap.put(23, "SRT_QUARTERTM_B_US");
        PerformanceSRTAttributesToNamesMap.put(29, "SRT_QRTSPDB_US");
        PerformanceSRTAttributesToNamesMap.put(34, "SRT_BRKDISTB_US");
        PerformanceSRTAttributesToNamesMap.put(41, "SRT_BRKSPDB_US");
        PerformanceSRTAttributesToNamesMap.put(4, "SRT_60MPHTMB");
        PerformanceSRTAttributesToNamesMap.put(8, "SRT_EIGHTHTMB");
        PerformanceSRTAttributesToNamesMap.put(16, "SRT_ETHSPDB_M");
        PerformanceSRTAttributesToNamesMap.put(22, "SRT_QUARTERTMB");
        PerformanceSRTAttributesToNamesMap.put(28, "SRT_QRTSPDB_M");
    }
}

