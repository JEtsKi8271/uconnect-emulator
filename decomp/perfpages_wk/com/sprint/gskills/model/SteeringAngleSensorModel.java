/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;

public class SteeringAngleSensorModel
extends CommonSensorModel {
    private static final SteeringAngleSensorModel INSTANCE = new SteeringAngleSensorModel();
    private static final int STEERING_ANGLE_STEP_INCREMENT = 5;

    public static SteeringAngleSensorModel getInstance() {
        return INSTANCE;
    }

    private SteeringAngleSensorModel() {
    }

    protected void setSensorURL() {
        this._sensorURL = "SteeringWheelAngle";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxSteeringWheelAngle();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinSteeringWheelAngle();
    }

    public String getValueForDigitalDisplay() {
        String steeringAngle = "--";
        if (this._sensorRawValue >= this._minMeasurementRange && this._sensorRawValue <= this._maxMeasurementRange) {
            this._sensorRawValue = Math.abs(this._sensorRawValue);
            steeringAngle = this.incrementValueInSteps((int)this.getRangeControlledValue());
        }
        return steeringAngle;
    }

    private String incrementValueInSteps(int sensorValue) {
        int sensorValueMod = sensorValue % 5;
        if (sensorValueMod == 0) {
            return Integer.toString(sensorValue);
        }
        return Integer.toString(sensorValue - sensorValueMod);
    }
}

