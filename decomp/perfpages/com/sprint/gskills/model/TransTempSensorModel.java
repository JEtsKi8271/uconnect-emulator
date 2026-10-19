/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.TemperatureSensorModel;
import java.util.TreeMap;

public class TransTempSensorModel
extends TemperatureSensorModel {
    private static final TransTempSensorModel INSTANCE = new TransTempSensorModel();

    private TransTempSensorModel() {
        if (VehicleTrimEnum.RT == _stateManager_.getVehicleTrim()) {
            this._stepIncrementRequired = true;
            this._baseSegmentMap = new TreeMap();
            this._baseSegmentMap.put(new Double(40.0), new Double(0.0));
            this._baseSegmentMap.put(new Double(60.0), new Double(0.25));
            this._baseSegmentMap.put(new Double(75.0), new Double(0.375));
            this._baseSegmentMap.put(new Double(95.0), new Double(0.5));
            this._baseSegmentMap.put(new Double(105.0), new Double(0.625));
            this._baseSegmentMap.put(new Double(110.0), new Double(0.75));
            this._baseSegmentMap.put(new Double(125.0), new Double(0.875));
            this._baseSegmentMap.put(new Double(150.0), new Double(1.0));
        }
    }

    public static TransTempSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "TX_TEMP";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxTransTemp();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinTransTemp();
    }
}

