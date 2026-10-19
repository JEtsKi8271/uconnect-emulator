/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.RPMSensorModel;
import com.sprint.gskills.model.TorqueSensorModel;
import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.util.CommonUtils;

public class HorsePowerSensorModel
extends CommonSensorModel {
    private static final HorsePowerSensorModel INSTANCE = new HorsePowerSensorModel();
    private boolean _prevHPValueValid = true;

    private HorsePowerSensorModel() {
    }

    public static HorsePowerSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxHorsePower();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinHorsePower();
        this._maxMeasurementRange = GSkillsSensorDisplayRangeFactory.getMaxTorque() * GSkillsSensorDisplayRangeFactory.getMaxRPM() / 9549.0;
        this._minMeasurementRange = GSkillsSensorDisplayRangeFactory.getMinTorque() * GSkillsSensorDisplayRangeFactory.getMinRPM() / 9549.0;
    }

    public void pollAndSetRawData() {
        this._valueChanged = false;
        TorqueSensorModel torqueModel = TorqueSensorModel.getInstance();
        RPMSensorModel rpmModel = RPMSensorModel.getInstance();
        double torqueValue = torqueModel.getTorqueValueForHPCalculation();
        double rpmValue = rpmModel.getValueForAnalogDisplay();
        if (-54321.123 != torqueValue && -54321.123 != rpmValue) {
            double calculatedHP = this.calculateHorsePower(rpmValue, torqueValue);
            if (CommonUtils.compareDbl(this._sensorRawValue, calculatedHP)) {
                this._sensorRawValue = calculatedHP;
                this._prevHPValueValid = true;
                this._valueChanged = true;
                this._logger.debug((Object)("Torque:" + torqueValue + ". RPM:" + rpmValue + ". HP:" + this._sensorRawValue));
            }
        } else if (this._prevHPValueValid) {
            this._sensorRawValue = -54321.123;
            this._prevHPValueValid = false;
            this._valueChanged = true;
            this._logger.debug((Object)("Torque:" + torqueValue + ". RPM:" + rpmValue + ". HP:" + this._sensorRawValue));
        }
    }

    private double calculateHorsePower(double rpm, double torque) {
        return torque * rpm / 9549.0;
    }

    protected double getUnitConvertedValue(double sensorValue) {
        return UnitConversionUtility.getInstance().powerConverter(sensorValue);
    }

    public String toString() {
        return "HorsePowerSensorModel";
    }
}

