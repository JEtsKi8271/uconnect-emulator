/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;

public class SpeedSensorModel
extends CommonSensorModel {
    private static final SpeedSensorModel INSTANCE = new SpeedSensorModel();

    private SpeedSensorModel() {
    }

    public static SpeedSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "VehSpdDisp";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxSpeed();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinSpeed();
    }
}

