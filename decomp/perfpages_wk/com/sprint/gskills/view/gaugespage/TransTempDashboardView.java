/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.model.TransTempSensorModel;
import com.sprint.gskills.view.gaugespage.TempDashboardView;

public class TransTempDashboardView
extends TempDashboardView {
    private static final TransTempDashboardView INSTANCE = new TransTempDashboardView();

    private TransTempDashboardView() {
    }

    public static TransTempDashboardView getInstance() {
        return INSTANCE;
    }

    protected void setSensorModel() {
        this._sensorModel = TransTempSensorModel.getInstance();
    }

    protected void setGaugeInfo() {
        this._gaugeImageName = "-trans-oil-temp";
        this._gaugeTitleKey = "gauges_title_transTemp";
    }
}

