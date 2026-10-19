/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 *  konax.sensors.DataListener
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.listener;

import com.sprint.gskills.model.sensordata.CommonSensorModel;
import konax.sensors.Data;
import konax.sensors.DataListener;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class SteeringWheelAngleDataListener
implements DataListener {
    private Logger logger = LoggerFactory.getLogger(SteeringWheelAngleDataListener.class);
    private CommonSensorModel dataModel = null;

    public SteeringWheelAngleDataListener(CommonSensorModel dataModel) {
        this.dataModel = dataModel;
    }

    public void dataReceived(SensorConnection sensor, Data[] data, boolean bool) {
        try {
            this.logger.trace((Object)("{} Workaround log - steering angle update received: " + data[0].getDoubleValues()[0]));
            this.dataModel.setSteeringAngle(data);
        }
        catch (Throwable e2) {
            this.logger.trace((Object)"ignoring Harman data for steering angle", e2);
        }
    }
}

