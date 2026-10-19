/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.model.CoolantTempSensorModel;
import com.sprint.gskills.view.gaugespage.TempDashboardView;

public class CoolantTempDashboardView
extends TempDashboardView {
    private static final CoolantTempDashboardView INSTANCE = new CoolantTempDashboardView();

    private CoolantTempDashboardView() {
    }

    public static CoolantTempDashboardView getInstance() {
        return INSTANCE;
    }

    protected void setSensorModel() {
        this._sensorModel = CoolantTempSensorModel.getInstance();
    }

    protected void setGaugeInfo() {
        this._gaugeImageName = "-coolant-temp";
        this._gaugeTitleKey = "gauges_title_coolantTemp";
    }
}

