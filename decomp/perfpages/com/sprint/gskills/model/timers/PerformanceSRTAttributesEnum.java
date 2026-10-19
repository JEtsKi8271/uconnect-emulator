/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.model.timers;

import java.util.HashMap;
import java.util.Map;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class PerformanceSRTAttributesEnum {
    private int _timerID;
    private String _timerTitle;
    private static Logger _logger = Log.createLogger((String)"PerformanceSRTAttributesEnum");
    public static final PerformanceSRTAttributesEnum SRT_60MPHTM_US = new PerformanceSRTAttributesEnum(100, "timer_title_sixtyET");
    public static final PerformanceSRTAttributesEnum SRT_100MPHTM_US = new PerformanceSRTAttributesEnum(101, "timer_title_hundredET");
    public static final PerformanceSRTAttributesEnum SRT_EIGHTHTM_US = new PerformanceSRTAttributesEnum(102, "timer_title_eighthET");
    public static final PerformanceSRTAttributesEnum SRT_ETHSPD_US = new PerformanceSRTAttributesEnum(103, "timer_title_eighthMph");
    public static final PerformanceSRTAttributesEnum SRT_QUARTERTM_US = new PerformanceSRTAttributesEnum(104, "timer_title_quarterET");
    public static final PerformanceSRTAttributesEnum SRT_QRTSPD_US = new PerformanceSRTAttributesEnum(105, "timer_title_quarterMph");
    public static final PerformanceSRTAttributesEnum SRT_BRKDIST_US = new PerformanceSRTAttributesEnum(106, "timer_title_BrakeDis");
    public static final PerformanceSRTAttributesEnum SRT_BRKSPD_US = new PerformanceSRTAttributesEnum(107, "timer_title_BrakeSpeed");
    public static final PerformanceSRTAttributesEnum SRT_60MPHTM_M = new PerformanceSRTAttributesEnum(100, "timer_title_sixtyET_M");
    public static final PerformanceSRTAttributesEnum SRT_100MPHTM_M = new PerformanceSRTAttributesEnum(101, "timer_title_hundredET_M");
    public static final PerformanceSRTAttributesEnum SRT_EIGHTHTM_M = new PerformanceSRTAttributesEnum(102, "timer_title_eighthET_M");
    public static final PerformanceSRTAttributesEnum SRT_ETHSPD_M = new PerformanceSRTAttributesEnum(103, "timer_title_eighthMph_M");
    public static final PerformanceSRTAttributesEnum SRT_QUARTERTM_M = new PerformanceSRTAttributesEnum(104, "timer_title_quarterET_M");
    public static final PerformanceSRTAttributesEnum SRT_QRTSPD_M = new PerformanceSRTAttributesEnum(105, "timer_title_quarterMph_M");
    public static final PerformanceSRTAttributesEnum SRT_BRKDIST_M = new PerformanceSRTAttributesEnum(106, "timer_title_BrakeDis_M");
    public static final PerformanceSRTAttributesEnum SRT_BRKSPD_M = new PerformanceSRTAttributesEnum(107, "timer_title_BrakeSpeed_M");
    public static final PerformanceSRTAttributesEnum SRT_REACTION_TIME = new PerformanceSRTAttributesEnum(108, "timer_title_ReactionTime");
    public static final PerformanceSRTAttributesEnum SRT_60FTTM = new PerformanceSRTAttributesEnum(109, "timer_title_sixtyFeet");
    private static Map<Integer, String> PerformanceSRTAttributesToNamesMap = new HashMap<Integer, String>();

    public PerformanceSRTAttributesEnum(int timerID, String timerTitle) {
        this._timerID = timerID;
        this._timerTitle = timerTitle;
    }

    private int getIntegerValue() {
        return this._timerID;
    }

    public int hashCode() {
        return this.getIntegerValue();
    }

    public String getTimerPageTitle() {
        return this._timerTitle;
    }

    public static String getName(int attribute) {
        return PerformanceSRTAttributesToNamesMap.get(attribute);
    }

    public static void printMap() {
        for (int i2 : PerformanceSRTAttributesToNamesMap.keySet()) {
            _logger.debug((Object)("<" + i2 + " , " + PerformanceSRTAttributesToNamesMap.get(i2) + ">"));
        }
    }

    static {
        PerformanceSRTAttributesToNamesMap.put(50, "REACT_TM_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(1, "60MPH_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(49, "100MPH_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(7, "ETH_TM_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(19, "QRT_TM_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(13, "ETH_SPD_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(25, "QRT_SPD_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(63, "60_FT_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(35, "BRK_DIST_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(39, "BRK_SPD_CURRENT_US");
        PerformanceSRTAttributesToNamesMap.put(44, "REACT_TM_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(0, "60MPH_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(43, "100MPH_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(6, "ETH_TM_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(18, "QRT_TM_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(12, "ETH_SPD_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(24, "QRT_SPD_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(60, "60_FT_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(30, "BRK_DIST_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(36, "BRK_SPD_CURRENT_METRIC");
        PerformanceSRTAttributesToNamesMap.put(54, "REACT_TM_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(3, "60MPH_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(53, "100MPH_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(11, "ETH_TM_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(15, "ETH_SPD_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(21, "QRT_TM_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(27, "QRT_SPD_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(65, "60_FT_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(33, "BRK_DIST_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(40, "BRK_SPD_LAST_US");
        PerformanceSRTAttributesToNamesMap.put(48, "REACT_TM_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(2, "60MPH_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(47, "100MPH_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(10, "ETH_TM_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(14, "ETH_SPD_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(20, "QRT_TM_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(26, "QRT_SPD_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(62, "60_FT_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(31, "BRK_DIST_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(37, "BRK_SPD_LAST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(52, "REACT_TM_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(5, "60MPH_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(51, "100MPH_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(9, "ETH_TM_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(17, "ETH_SPD_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(23, "QRT_TM_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(29, "QRT_SPD_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(64, "60_FT_BEST_US");
        PerformanceSRTAttributesToNamesMap.put(46, "REACT_TM_BEST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(4, "60MPH_BEST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(45, "100MPH_BEST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(8, "ETH_TM_BEST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(16, "ETH_SPD_BEST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(22, "QRT_TM_BEST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(28, "QRT_SPD_BEST_METRIC");
        PerformanceSRTAttributesToNamesMap.put(61, "60_FT_BEST_METRIC");
        PerformanceSRTAttributesEnum.printMap();
    }
}

