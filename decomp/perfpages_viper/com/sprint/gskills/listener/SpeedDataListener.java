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

public class SpeedDataListener
implements DataListener {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private CommonSensorModel dataModel = null;

    public SpeedDataListener(CommonSensorModel dataModel) {
        this.dataModel = dataModel;
    }

    public void dataReceived(SensorConnection sensor, Data[] data, boolean bool) {
        try {
            this.logger.trace((Object)("{} Workaround log - speed update received: " + data[0].getIntValues()[0]));
            this.dataModel.setCurrentSpeed(data);
        }
        catch (Throwable e2) {
            this.logger.trace((Object)"ignoring Harman data for speed", e2);
        }
    }
}

