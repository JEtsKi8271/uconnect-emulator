/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.TemperatureSensorModel;
import java.util.TreeMap;

public class CoolantTempSensorModel
extends TemperatureSensorModel {
    private static final CoolantTempSensorModel INSTANCE = new CoolantTempSensorModel();

    private CoolantTempSensorModel() {
        if (VehicleTrimEnum.RT == _stateManager_.getVehicleTrim()) {
            this._stepIncrementRequired = true;
            this._baseSegmentMap = new TreeMap();
            this._baseSegmentMap.put(new Double(40.0), new Double(0.0));
            this._baseSegmentMap.put(new Double(77.0), new Double(0.45));
            this._baseSegmentMap.put(new Double(107.0), new Double(0.5));
            this._baseSegmentMap.put(new Double(124.0), new Double(0.8));
            this._baseSegmentMap.put(new Double(131.0), new Double(0.9));
            this._baseSegmentMap.put(new Double(132.0), new Double(1.0));
        }
    }

    public static CoolantTempSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "EngineCoolant";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxCoolantTemp();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinCoolantTemp();
    }
}

