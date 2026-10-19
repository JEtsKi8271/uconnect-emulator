/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  konax.sensors.Data
 *  konax.sensors.DataListener
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.listener;

import com.sprint.gskills.model.sensordata.CommonSensorModel;
import kona.logger.Log;
import konax.sensors.Data;
import konax.sensors.DataListener;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;

public class IntakeAirTempDataListener
implements DataListener {
    private CommonSensorModel dataModel = null;
    private Logger logger = Log.createLogger((String)this.getClass().getName());

    public IntakeAirTempDataListener(CommonSensorModel dataModel) {
        this.dataModel = dataModel;
    }

    public void dataReceived(SensorConnection arg0, Data[] data, boolean isDataLost) {
        try {
            this.logger.trace((Object)("{} Workaround log - Intake Air Temp update received: " + data[0].getIntValues()[0]));
            this.dataModel.setIntakeAirTemp(data);
        }
        catch (Throwable e2) {
            this.logger.trace((Object)"ignoring Harman data for Intake Air Temp", e2);
        }
    }
}

