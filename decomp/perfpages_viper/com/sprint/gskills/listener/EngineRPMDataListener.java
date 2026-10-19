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

public class EngineRPMDataListener
implements DataListener {
    private Logger logger = LoggerFactory.getLogger(EngineRPMDataListener.class);
    private CommonSensorModel dataModel = null;

    public EngineRPMDataListener(CommonSensorModel dataModel) {
        this.dataModel = dataModel;
    }

    public void dataReceived(SensorConnection sc, Data[] data, boolean bool) {
        try {
            this.logger.trace((Object)("{} Workaround log - Engine RPM update received: " + data[0].getIntValues()[0]));
            this.dataModel.setRPM(data);
        }
        catch (Throwable e2) {
            this.logger.trace((Object)"ignoring Harman data for Engine RPM", e2);
        }
    }
}

