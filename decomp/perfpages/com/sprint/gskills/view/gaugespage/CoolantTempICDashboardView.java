/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.model.CoolantTempICSensorModel;
import com.sprint.gskills.view.gaugespage.TempDashboardView;

public class CoolantTempICDashboardView
extends TempDashboardView {
    private static final CoolantTempICDashboardView INSTANCE = new CoolantTempICDashboardView();

    private CoolantTempICDashboardView() {
    }

    public static CoolantTempICDashboardView getInstance() {
        return INSTANCE;
    }

    protected void setSensorModel() {
        this._sensorModel = CoolantTempICSensorModel.getInstance();
    }

    protected void setGaugeInfo() {
        this._gaugeImageName = "-intercooler-temp";
        this._gaugeTitleKey = "gauges_title_I/CCoolantTemp";
    }
}

