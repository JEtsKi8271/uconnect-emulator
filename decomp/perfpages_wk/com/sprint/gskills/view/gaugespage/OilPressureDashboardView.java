/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.model.OilPressureSensorModel;
import com.sprint.gskills.view.gaugespage.DashboardViewContainer;

public class OilPressureDashboardView
extends DashboardViewContainer {
    private static final OilPressureDashboardView INSTANCE = new OilPressureDashboardView();

    private OilPressureDashboardView() {
    }

    public static OilPressureDashboardView getInstance() {
        return INSTANCE;
    }

    public void updateViewOnLanguageChange() {
        this.setUnit(this._stateManager.getPressureUnit().getResKey());
        this.setTitle("gauges_title_oilPreessure");
    }

    public void updateViewOnPressureUnitChange() {
        if (VehicleTrimEnum.RT == this._stateManager.getVehicleTrim()) {
            this.setGuageBgImageContainer("-oil-pressure");
        } else {
            this.setGuageBgImageContainer("-oil-pressure-" + this._stateManager.getPressureUnit().toString());
        }
    }

    protected void setSensorModel() {
        this._sensorModel = OilPressureSensorModel.getInstance();
    }
}

