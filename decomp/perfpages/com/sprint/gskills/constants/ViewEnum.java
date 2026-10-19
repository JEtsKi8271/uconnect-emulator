/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

public class ViewEnum {
    private final int _viewID;
    private final String _viewName;
    public static final int HOME = 0;
    public static final int TIMERS = 1;
    public static final int GAUGES_ONE = 2;
    public static final int GAUGES_TWO = 3;
    public static final int GFORCE = 4;
    public static final int ENGINE = 5;
    public static final int TIMERS_BEST = 6;
    public static final int TIMERS_LAST = 7;
    public static final int TIMERS_CURRENT = 8;
    public static final ViewEnum HOME_VIEW = new ViewEnum(0, "Home");
    public static final ViewEnum TIMERS_VIEW = new ViewEnum(1, "Timers");
    public static final ViewEnum GAUGESONE_VIEW = new ViewEnum(2, "GaugesOne");
    public static final ViewEnum GAUGESTWO_VIEW = new ViewEnum(3, "GaugesTwo");
    public static final ViewEnum GFORCE_VIEW = new ViewEnum(4, "GForce");
    public static final ViewEnum ENGINE_VIEW = new ViewEnum(5, "Engine");
    public static final ViewEnum TIMERS_BEST_VIEW = new ViewEnum(6, "BestTimer");
    public static final ViewEnum TIMERS_LAST_VIEW = new ViewEnum(7, "LastTimer");
    public static final ViewEnum TIMERS_CURRENT_VIEW = new ViewEnum(8, "CurrentTimer");

    private ViewEnum(int viewID, String viewName) {
        this._viewID = viewID;
        this._viewName = viewName;
    }

    public int getViewID() {
        return this._viewID;
    }

    public String toString() {
        return this._viewName;
    }
}

