/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.model.BatterySensorModel;
import com.sprint.gskills.view.gaugespage.DashboardViewContainer;

public class BatteryDashboardView
extends DashboardViewContainer {
    private static final BatteryDashboardView INSTANCE = new BatteryDashboardView();

    private BatteryDashboardView() {
    }

    public static BatteryDashboardView getInstance() {
        return INSTANCE;
    }

    protected void setSensorModel() {
        this._sensorModel = BatterySensorModel.getInstance();
    }

    public void updateViewOnLanguageChange() {
        this.setUnit("unit_US_batteryVoltage");
        this.setTitle("gauges_title_batteryVolt");
    }

    public void updateViewOnUnitChange() {
        this.setGuageBgImageContainer("-battery-voltage");
    }
}

