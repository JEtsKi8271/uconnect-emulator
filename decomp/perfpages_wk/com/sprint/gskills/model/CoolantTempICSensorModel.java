/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.TemperatureSensorModel;

public class CoolantTempICSensorModel
extends TemperatureSensorModel {
    private static final CoolantTempICSensorModel INSTANCE = new CoolantTempICSensorModel();

    private CoolantTempICSensorModel() {
    }

    public static CoolantTempICSensorModel getInstance() {
        return INSTANCE;
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxIcCoolantTemp();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinIcCoolantTemp();
    }

    protected void setSensorURL() {
        this._sensorURL = "LTR_CoolantTemp";
    }
}

