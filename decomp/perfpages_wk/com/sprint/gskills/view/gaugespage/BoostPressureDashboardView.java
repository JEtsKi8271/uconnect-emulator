/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.model.BoostPressureSensorModel;
import com.sprint.gskills.unit.PressureUnitEnum;
import com.sprint.gskills.view.gaugespage.DashboardViewContainer;

public class BoostPressureDashboardView
extends DashboardViewContainer {
    private static final BoostPressureDashboardView INSTANCE = new BoostPressureDashboardView();

    private BoostPressureDashboardView() {
    }

    public static BoostPressureDashboardView getInstance() {
        return INSTANCE;
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean valueChanged;
        boolean bl2 = valueChanged = this._sensorModel.hasSensorValueChanged() || forceUpdate;
        if (valueChanged) {
            this.setGaugeLabelValue(this._sensorModel.getValueForDigitalDisplay());
            if (PressureUnitEnum.PSI == this._stateManager.getPressureUnit()) {
                double boostPressureValue = BoostPressureSensorModel.getInstance().getValueForAnalogDisplay();
                if (boostPressureValue >= 0.0 && boostPressureValue < 100.0) {
                    this.setUnit("unit_US_BoostPressure");
                } else {
                    this.setUnit("unit_US_OilPressure");
                }
            }
            this._gaugeNeedle.set(this._sensorModel.getUnifiedValue());
        }
        return valueChanged;
    }

    public void updateViewOnLanguageChange() {
        double boostPressureValue;
        this.setTitle("gauges_title_BoostPressure");
        PressureUnitEnum pressureUnit = this._stateManager.getPressureUnit();
        String pressureUnitResKey = pressureUnit.getResKey();
        if (PressureUnitEnum.PSI == pressureUnit && (boostPressureValue = BoostPressureSensorModel.getInstance().getValueForAnalogDisplay()) >= 0.0 && boostPressureValue < 100.0) {
            pressureUnitResKey = "unit_US_BoostPressure";
        }
        this.setUnit(pressureUnitResKey);
    }

    public void updateViewOnPressureUnitChange() {
        this._logger.debug((Object)"BoostPressureDashBoardView::updateViewOnPressureUnitChange() called");
        this.setGuageBgImageContainer("-boost-pressure-" + this._stateManager.getPressureUnit().toString());
    }

    protected void setSensorModel() {
        this._sensorModel = BoostPressureSensorModel.getInstance();
    }
}

