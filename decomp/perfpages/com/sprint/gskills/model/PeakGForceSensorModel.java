/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import java.text.DecimalFormat;

public abstract class PeakGForceSensorModel
extends CommonSensorModel {
    public void setSensorAnalogRange() {
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinGForceImages();
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxGForceValue();
    }

    public synchronized String getValueForDigitalDisplay() {
        this._valueChanged = false;
        String sensorValue = "--";
        if (this._sensorRawValue >= this._minMeasurementRange && this._sensorRawValue <= this._maxMeasurementRange) {
            double roundedValue = (double)((int)(Math.abs(this._sensorRawValue) * 10.0)) / 100.0;
            sensorValue = this.formatSensorValue(this.getRangeControlledValue(roundedValue, this._maxAnalogValue, this._minAnalogValue));
        }
        this._logger.debug((Object)(this._sensorURL + " - RawValue:" + this._sensorRawValue + " DisplayValue:" + sensorValue));
        return sensorValue;
    }

    protected String formatSensorValue(double sensorValue) {
        DecimalFormat df = new DecimalFormat("0.00");
        return df.format(sensorValue);
    }
}

