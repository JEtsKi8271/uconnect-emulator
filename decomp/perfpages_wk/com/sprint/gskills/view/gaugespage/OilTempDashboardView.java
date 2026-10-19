/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.model.OilTempSensorModel;
import com.sprint.gskills.view.gaugespage.TempDashboardView;

public class OilTempDashboardView
extends TempDashboardView {
    private static final OilTempDashboardView INSTANCE = new OilTempDashboardView();

    private OilTempDashboardView() {
    }

    public static OilTempDashboardView getInstance() {
        return INSTANCE;
    }

    protected void setSensorModel() {
        this._sensorModel = OilTempSensorModel.getInstance();
    }

    protected void setGaugeInfo() {
        this._gaugeImageName = "-oil-temp";
        this._gaugeTitleKey = "gauges_title_oilTemp";
    }
}

