/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.unit.PressureUnitEnum;
import java.text.DecimalFormat;

public class BoostPressureSensorModel
extends CommonSensorModel {
    private static final BoostPressureSensorModel INSTANCE = new BoostPressureSensorModel();
    public static final double MIN_BOOST = 0.0;
    public static final double MID_BOOST = 100.0;
    public static final double MAX_BOOST = 240.0;

    private BoostPressureSensorModel() {
    }

    public static BoostPressureSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "BoostVacGauge";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxBoostPressure();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinBoostPressure();
    }

    protected double getUnitConvertedValue(double sensorValue) {
        return UnitConversionUtility.getInstance().boostPressureConverter(sensorValue);
    }

    public double getUnifiedValue() {
        double unifiedValue = 0.0;
        double sensorValue = this.getValueForAnalogDisplay();
        if (-54321.123 != sensorValue) {
            if (sensorValue >= 0.0 && sensorValue < 100.0) {
                unifiedValue = (sensorValue - 0.0) / 100.0 / 2.0;
            } else if (sensorValue >= 100.0 && sensorValue <= 240.0) {
                unifiedValue = 0.5 + (sensorValue - 100.0) / 140.0 / 2.0;
            }
        }
        return unifiedValue;
    }

    protected String formatSensorValue(double sensorValue) {
        String formattedValue = "";
        if (PressureUnitEnum.BAR == _stateManager_.getPressureUnit()) {
            DecimalFormat df = new DecimalFormat("0.0");
            formattedValue = df.format(sensorValue);
        } else {
            formattedValue = Integer.toString((int)sensorValue);
        }
        return formattedValue;
    }
}

