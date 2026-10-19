/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.model.AirFuelRatioSensorModel;
import com.sprint.gskills.view.gaugespage.DashboardViewContainer;

public class AirFuelRatioDashboardView
extends DashboardViewContainer {
    private static final AirFuelRatioDashboardView INSTANCE = new AirFuelRatioDashboardView();

    private AirFuelRatioDashboardView() {
    }

    public static AirFuelRatioDashboardView getInstance() {
        return INSTANCE;
    }

    public void updateViewOnLanguageChange() {
        this.setTitle("gauges_title_AirFuelRatio");
    }

    public void updateViewOnUnitChange() {
        this.setGuageBgImageContainer("-air-fuel-ratio");
    }

    protected void setSensorModel() {
        this._sensorModel = AirFuelRatioSensorModel.getInstance();
    }
}

