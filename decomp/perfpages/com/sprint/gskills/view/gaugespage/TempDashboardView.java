/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.unit.TempUnitEnum;
import com.sprint.gskills.view.gaugespage.DashboardViewContainer;

public abstract class TempDashboardView
extends DashboardViewContainer {
    protected String _gaugeImageName;
    protected String _gaugeTitleKey;

    protected TempDashboardView() {
        this.setGaugeInfo();
    }

    protected abstract void setGaugeInfo();

    public void updateViewOnLanguageChange() {
        String currentTempUnit = this._stateManager.getTempUnit() == TempUnitEnum.FAHRENHEIT ? "US" : "M";
        this.setTitle(this._gaugeTitleKey);
        this.setUnit("unit_" + currentTempUnit + "_Temp");
    }

    public void updateViewOnTempUnitChange() {
        TempUnitEnum tempUnit = this._stateManager.getTempUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on temperature unit change to " + tempUnit.toString()));
        if (VehicleTrimEnum.RT == this._stateManager.getVehicleTrim()) {
            this.setGuageBgImageContainer(this._gaugeImageName);
        } else {
            String currentUnit = tempUnit == TempUnitEnum.FAHRENHEIT ? "us" : "m";
            this.setGuageBgImageContainer(this._gaugeImageName + "-" + currentUnit);
        }
    }
}

