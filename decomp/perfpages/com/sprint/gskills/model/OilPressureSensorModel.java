/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.unit.PressureUnitEnum;
import java.text.DecimalFormat;
import java.util.TreeMap;

public class OilPressureSensorModel
extends CommonSensorModel {
    private static final OilPressureSensorModel INSTANCE = new OilPressureSensorModel();

    private OilPressureSensorModel() {
        if (VehicleTrimEnum.RT == _stateManager_.getVehicleTrim()) {
            this._stepIncrementRequired = true;
            this._baseSegmentMap = new TreeMap();
            if (_stateManager_.getEngineDisplacement().equals("3.6")) {
                this._baseSegmentMap.put(new Double(68.0), new Double(0.25));
                this._baseSegmentMap.put(new Double(208.0), new Double(0.5));
                this._baseSegmentMap.put(new Double(276.0), new Double(0.625));
                this._baseSegmentMap.put(new Double(688.0), new Double(0.75));
                this._baseSegmentMap.put(new Double(760.0), new Double(1.0));
            } else {
                this._baseSegmentMap.put(new Double(68.0), new Double(0.25));
                this._baseSegmentMap.put(new Double(208.0), new Double(0.5));
                this._baseSegmentMap.put(new Double(344.0), new Double(0.625));
                this._baseSegmentMap.put(new Double(412.0), new Double(0.75));
                this._baseSegmentMap.put(new Double(552.0), new Double(0.875));
                this._baseSegmentMap.put(new Double(760.0), new Double(1.0));
            }
        }
    }

    public static OilPressureSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "OilPressure";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxOilPressure();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinOilPressure();
    }

    protected String formatSensorValue(double sensorValue) {
        String formattedValue;
        if (PressureUnitEnum.BAR == _stateManager_.getPressureUnit()) {
            DecimalFormat df = new DecimalFormat("0.0");
            formattedValue = df.format(sensorValue);
        } else {
            formattedValue = Integer.toString((int)sensorValue);
        }
        return formattedValue;
    }

    protected double getUnitConvertedValue(double sensorValue) {
        return UnitConversionUtility.getInstance().pressureConverter(sensorValue);
    }
}

