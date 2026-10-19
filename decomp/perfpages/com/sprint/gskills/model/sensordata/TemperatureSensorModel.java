/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.sensordata;

import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.model.sensordata.CommonSensorModel;

public abstract class TemperatureSensorModel
extends CommonSensorModel {
    protected double getUnitConvertedValue(double sensorValue) {
        return UnitConversionUtility.getInstance().temperatureConverter(sensorValue);
    }
}

