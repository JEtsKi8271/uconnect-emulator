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

public class TorqueDataListener
implements DataListener {
    private Logger logger = LoggerFactory.getLogger(TorqueDataListener.class);
    private CommonSensorModel dataModel = null;

    public TorqueDataListener(CommonSensorModel dataModel) {
        this.dataModel = dataModel;
    }

    public void dataReceived(SensorConnection sc, Data[] data, boolean bool) {
        try {
            this.logger.trace((Object)("{} Workaround log - torque update received: " + data[0].getDoubleValues()[0]));
            this.dataModel.setTorque(data);
        }
        catch (Throwable e2) {
            this.logger.trace((Object)"ignoring Harman data for torque", e2);
        }
    }
}

