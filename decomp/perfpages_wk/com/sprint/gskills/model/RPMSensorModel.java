/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;

public class RPMSensorModel
extends CommonSensorModel {
    private static final RPMSensorModel INSTANCE = new RPMSensorModel();

    private RPMSensorModel() {
    }

    public static RPMSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "EngineRPM";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxRPM();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinRPM();
    }
}

