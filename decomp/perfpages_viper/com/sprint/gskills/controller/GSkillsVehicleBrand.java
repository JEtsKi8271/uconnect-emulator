/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.constants.SensorConnectionEnum;
import com.sprint.gskills.view.common.GSkillsStateManager;
import konax.sensors.Data;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsVehicleBrand {
    private Logger logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private static final GSkillsVehicleBrand INSTANCE = new GSkillsVehicleBrand();

    private GSkillsVehicleBrand() {
    }

    public static GSkillsVehicleBrand getInstance() {
        return INSTANCE;
    }

    public void defineCarBrand() {
        GSkillsStateManager gSkillsStateManager = GSkillsStateManager.getInstance();
        int vehicleLine = this.getSensorValue(SensorConnectionEnum.VC_VEH_LINE);
        int transType = this.getSensorValue(SensorConnectionEnum.TRANS_TYPE);
        gSkillsStateManager.setVehicleLine(vehicleLine);
        gSkillsStateManager.setTransType(transType);
        if (1 != vehicleLine && 43 != vehicleLine) {
            this.logger.debug((Object)"***********************************************************************");
            this.logger.debug((Object)("WARNING!! THIS APPLICATION DOES NOT SUPPORT VEHICLE LINE " + vehicleLine));
            this.logger.debug((Object)"SEVERAL FUNCTIONALITIES MAY NOT WORK AS EXPECTED");
            this.logger.debug((Object)"***********************************************************************");
        }
        this.logger.debug((Object)("*************** VC_VEH_LINE:" + vehicleLine + " ******************"));
        this.logger.debug((Object)("*************** TRANS_TYPE:" + transType + " *******************"));
    }

    private int getSensorValue(SensorConnectionEnum sensorEnum) {
        int sensorValue = 0;
        try {
            SensorConnection vehLineSensorConnection = sensorEnum.getSensorConnection();
            Data[] data = vehLineSensorConnection.getData(1);
            if (data != null) {
                sensorValue = data[0].getIntValues()[0];
            }
            sensorEnum.closeSensorConnection();
        }
        catch (Exception ex) {
            this.logger.error((Object)"Error in get Line :", (Throwable)ex);
        }
        return sensorValue;
    }
}

