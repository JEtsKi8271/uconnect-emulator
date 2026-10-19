/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.util.CommonUtils;
import java.text.DecimalFormat;
import konax.sensors.Data;

public class AirFuelRatioSensorModel
extends CommonSensorModel {
    private static final AirFuelRatioSensorModel INSTANCE = new AirFuelRatioSensorModel();

    private AirFuelRatioSensorModel() {
    }

    public static AirFuelRatioSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "AirFuelRatio";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxAirFuelRatio();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinAirFuelRatio();
    }

    public void pollAndSetRawData() {
        Data[] data = this.getRawData();
        try {
            if (null != data) {
                double airFuelRatio = data[0].getDoubleValues()[0];
                if (CommonUtils.compareDbl(airFuelRatio += 5.5, this._sensorRawValue)) {
                    this._sensorRawValue = airFuelRatio;
                    this._valueChanged = true;
                }
            }
        }
        catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    protected String formatSensorValue(double sensorValue) {
        DecimalFormat df = new DecimalFormat("0.0");
        return df.format(sensorValue);
    }
}

