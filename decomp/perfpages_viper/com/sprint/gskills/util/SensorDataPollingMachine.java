/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.util;

import com.sprint.gskills.constants.SensorConnectionEnum;
import konax.sensors.Data;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class SensorDataPollingMachine {
    private Logger logger = LoggerFactory.getLogger(SensorDataPollingMachine.class);

    public int getVehLine() {
        int vehLine = 0;
        try {
            SensorConnection vehLineSensorConnection = SensorConnectionEnum.VC_VEH_LINE.getSensorConnection();
            Data[] datas = vehLineSensorConnection.getData(1);
            SensorConnectionEnum.VC_VEH_LINE.closeSensorConnection();
            if (datas != null) {
                int[] intData = datas[0].getIntValues();
                vehLine = intData[0];
                if (this.logger.isInfoEnabled()) {
                    this.logger.info((Object)("get vehicle Line  : " + vehLine));
                }
            }
        }
        catch (Exception ex) {
            this.logger.error((Object)"Error in get Line :", (Throwable)ex);
        }
        return vehLine;
    }
}

