/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.model.IntakeAirTempICSensorModel;
import com.sprint.gskills.model.IntakeAirTempSensorModel;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.gaugespage.TempDashboardView;

public class IntakeAirTempDashboardView
extends TempDashboardView {
    private static final IntakeAirTempDashboardView INSTANCE = new IntakeAirTempDashboardView();

    private IntakeAirTempDashboardView() {
    }

    public static IntakeAirTempDashboardView getInstance() {
        return INSTANCE;
    }

    protected void setSensorModel() {
        this._sensorModel = VehicleTrimEnum.HELLCAT == GSkillsStateManager.getInstance().getVehicleTrim() ? IntakeAirTempICSensorModel.getInstance() : IntakeAirTempSensorModel.getInstance();
    }

    protected void setGaugeInfo() {
        this._gaugeImageName = "-intake-air-temp";
        this._gaugeTitleKey = "gauges_title_intakeAirTemp";
    }
}

