/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.RPMSensorModel;
import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.util.CommonUtils;
import konax.sensors.Data;

public class TorqueSensorModel
extends CommonSensorModel {
    private static final TorqueSensorModel INSTANCE = new TorqueSensorModel();
    private boolean _prevTorqueValValid = true;

    private TorqueSensorModel() {
    }

    public static TorqueSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "Torque";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxTorque();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinTorque();
    }

    public synchronized double getTorqueValueForHPCalculation() {
        double sensorValueForAnalogDisplay = -54321.123;
        if (this._sensorRawValue >= this._minMeasurementRange && this._sensorRawValue <= this._maxMeasurementRange) {
            sensorValueForAnalogDisplay = this.getRangeControlledValue();
        }
        return sensorValueForAnalogDisplay;
    }

    public void pollAndSetRawData() {
        String engineRPM = RPMSensorModel.getInstance().getValueForDigitalDisplay();
        int rpm = Integer.parseInt(engineRPM);
        if (engineRPM.equals("--") || rpm < 500 || rpm > 65534) {
            if (this._prevTorqueValValid) {
                this._sensorRawValue = -54321.123;
                this._prevTorqueValValid = false;
                this._valueChanged = true;
                this._logger.debug((Object)("Torque:SNA. EngineRPM:" + engineRPM));
            }
        } else {
            double torqueFromSensor;
            Data[] torqueDataArrayPolled = this.getRawData();
            if (torqueDataArrayPolled != null && CommonUtils.compareDbl(this._sensorRawValue, torqueFromSensor = torqueDataArrayPolled[0].getDoubleValues()[0])) {
                this._sensorRawValue = torqueFromSensor;
                this._prevTorqueValValid = true;
                this._valueChanged = true;
                this._logger.debug((Object)("Torque:" + this._sensorRawValue + ". EngineRPM:" + engineRPM));
            }
        }
    }

    protected double getUnitConvertedValue(double sensorValue) {
        return UnitConversionUtility.getInstance().torqueConverter(sensorValue);
    }
}

