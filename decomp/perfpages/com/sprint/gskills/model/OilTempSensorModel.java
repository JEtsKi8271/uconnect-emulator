/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.TemperatureSensorModel;
import java.util.TreeMap;

public class OilTempSensorModel
extends TemperatureSensorModel {
    private static final OilTempSensorModel INSTANCE = new OilTempSensorModel();

    private OilTempSensorModel() {
        if (VehicleTrimEnum.RT == _stateManager_.getVehicleTrim()) {
            this._stepIncrementRequired = true;
            this._baseSegmentMap = new TreeMap();
            this._baseSegmentMap.put(new Double(40.0), new Double(0.0));
            this._baseSegmentMap.put(new Double(100.0), new Double(0.5));
            this._baseSegmentMap.put(new Double(135.0), new Double(0.75));
            this._baseSegmentMap.put(new Double(150.0), new Double(1.0));
        }
    }

    public static OilTempSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "OilTemp";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxOilTemp();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinOilTemp();
    }
}

