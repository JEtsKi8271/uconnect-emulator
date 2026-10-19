/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import java.text.DecimalFormat;
import java.util.TreeMap;

public class BatterySensorModel
extends CommonSensorModel {
    private static final BatterySensorModel INSTANCE = new BatterySensorModel();

    private BatterySensorModel() {
        if (VehicleTrimEnum.RT == _stateManager_.getVehicleTrim()) {
            this._stepIncrementRequired = true;
            this._baseSegmentMap = new TreeMap();
            this._baseSegmentMap.put(new Double(8.0), new Double(0.0));
            this._baseSegmentMap.put(new Double(14.0), new Double(0.5));
            this._baseSegmentMap.put(new Double(18.0), new Double(1.0));
        }
    }

    public static BatterySensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "Battery";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxBattery();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinBattery();
    }

    protected String formatSensorValue(double sensorValue) {
        DecimalFormat df = new DecimalFormat("0.0");
        return df.format(sensorValue);
    }
}

