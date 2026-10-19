/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.model.sensordata.CommonSensorModel;

public class GearSensorModel
extends CommonSensorModel {
    private static final GearSensorModel INSTANCE = new GearSensorModel();

    private GearSensorModel() {
        this._logger.debug((Object)"Inside the GearSensorModel constructor");
    }

    public static GearSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "TargetGear";
    }

    public void setSensorAnalogRange() {
    }

    public synchronized String getValueForDigitalDisplay() {
        this._valueChanged = false;
        String strGearVal = "--";
        int sensorValueInt = (int)this._sensorRawValue;
        if (sensorValueInt == 0) {
            strGearVal = "N";
        } else if (sensorValueInt >= 1 && sensorValueInt <= 8) {
            strGearVal = Integer.toString(sensorValueInt);
        } else if (sensorValueInt == 11) {
            strGearVal = "R";
        } else if (sensorValueInt == 13) {
            strGearVal = "P";
        }
        this._logger.debug((Object)("Gear set to " + strGearVal));
        return strGearVal;
    }
}

