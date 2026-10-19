/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.TemperatureSensorModel;

public class IntakeAirTempICSensorModel
extends TemperatureSensorModel {
    private static final IntakeAirTempICSensorModel INSTANCE = new IntakeAirTempICSensorModel();

    private IntakeAirTempICSensorModel() {
    }

    public static IntakeAirTempICSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "IntkAirTempIntrClr";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxIntakeAirTemp();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinIntakeAirTemp();
    }
}

