/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.TemperatureSensorModel;

public class IntakeAirTempSensorModel
extends TemperatureSensorModel {
    private static final IntakeAirTempSensorModel INSTANCE = new IntakeAirTempSensorModel();

    private IntakeAirTempSensorModel() {
    }

    public static IntakeAirTempSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "IntakeAirTemp";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxIntakeAirTemp();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinIntakeAirTemp();
    }
}

