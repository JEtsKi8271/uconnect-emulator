/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.network.NetworkConfiguration
 *  konax.sensors.Data
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.constants.GSkillsBrandConstants;
import com.sprint.gskills.constants.SensorConnectionEnum;
import com.sprint.gskills.constants.TransmissionTypeEnum;
import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.text.DecimalFormat;
import kona.network.NetworkConfiguration;
import konax.sensors.Data;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsVehicleInfo {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private final GSkillsStateManager _gSkillsStateManager = GSkillsStateManager.getInstance();
    private static final GSkillsVehicleInfo INSTANCE = new GSkillsVehicleInfo();
    private static final int INVALID_INT_VAL = -111111;
    private static final double INVALID_DBL_VAL = -111111.111111;

    private GSkillsVehicleInfo() {
    }

    public static GSkillsVehicleInfo getInstance() {
        return INSTANCE;
    }

    public void setVehicleInfo() {
        VehicleLineEnum vehicleLineEnum = VehicleLineEnum.LA;
        int vehicleLineSensorVal = this.getSensorIntValue(SensorConnectionEnum.VEH_LINE_SENSOR);
        if (-111111 != vehicleLineSensorVal) {
            vehicleLineEnum = GSkillsBrandConstants.getVehicleLineEnum(vehicleLineSensorVal);
        }
        this._logger.debug((Object)("Vehicle Line:" + vehicleLineEnum.toString()));
        this._gSkillsStateManager.setVehicleLine(vehicleLineEnum);
        int isSrt = this.getSensorIntValue(SensorConnectionEnum.SRT_PRSNT_SENSOR);
        this._logger.debug((Object)("Is SRT:" + isSrt));
        VehicleTrimEnum vehicleTrim = VehicleTrimEnum.RT;
        if (1 == isSrt) {
            if (this.isEngineSuperCharged(vehicleLineEnum)) {
                vehicleTrim = VehicleTrimEnum.HELLCAT;
            } else {
                vehicleTrim = VehicleTrimEnum.SRT;
                if (this.isSRTPremium()) {
                    vehicleTrim = VehicleTrimEnum.SRT_PREMIUM;
                }
            }
        } else {
            this.readAndSetDisplacement();
        }
        this._gSkillsStateManager.setVehicleTrim(vehicleTrim);
        this._gSkillsStateManager.setVehicleBrand();
        this.readAndSetTransType();
        this._logger.debug((Object)"*********************************************************************************************");
        this._logger.debug((Object)("************************************ VEHICLE:" + vehicleLineEnum.toString().toUpperCase() + "_" + vehicleTrim.getHomeImageSuffix().toUpperCase() + " ***********************************"));
        this._logger.debug((Object)"*********************************************************************************************");
    }

    private boolean isEngineSuperCharged(VehicleLineEnum vehicleLineEnum) {
        boolean isSuperCharged = false;
        if (VehicleLineEnum.LA == vehicleLineEnum || VehicleLineEnum.LD == vehicleLineEnum) {
            int engAsp = this.getSensorIntValue(SensorConnectionEnum.ENG_ASP_SENSOR);
            this._logger.debug((Object)("Engine Aspiration:" + engAsp));
            if (3 == engAsp) {
                isSuperCharged = true;
            }
        }
        return isSuperCharged;
    }

    private void readAndSetTransType() {
        TransmissionTypeEnum transType = TransmissionTypeEnum.AUTO;
        if (VehicleLineEnum.LA == this._gSkillsStateManager.getVehicleLine()) {
            this._logger.debug((Object)"Vehicle line is LA. Reading the transmission type sensor");
            int transTypeSensorVal = this.getSensorIntValue(SensorConnectionEnum.TRANS_TYPE_SENSOR);
            if (-111111 != transTypeSensorVal) {
                transType = GSkillsBrandConstants.getTransTypeEnum(transTypeSensorVal);
            }
        }
        this._logger.debug((Object)("TRANS_TYPE:" + transType.toString()));
        this._gSkillsStateManager.setTransType(transType);
    }

    private boolean isSRTPremium() {
        boolean isADCMPresent = false;
        try {
            if (VehicleLineEnum.LX == this._gSkillsStateManager.getVehicleLine()) {
                if (1 == NetworkConfiguration.getInstance().getNetworkConfigurationStatus(28)) {
                    isADCMPresent = true;
                }
                this._logger.debug((Object)("ADCM Present:" + isADCMPresent));
            }
        }
        catch (Exception e2) {
            e2.printStackTrace();
        }
        return isADCMPresent;
    }

    private void readAndSetDisplacement() {
        String displacement = "3.6";
        double displacementDbl = this.getSensorDblValue(SensorConnectionEnum.DISPLACEMENT_SENSOR);
        if (CommonUtils.compareDbl(-111111.111111, displacementDbl)) {
            DecimalFormat df = new DecimalFormat("0.0");
            displacement = df.format(displacementDbl);
        }
        this._logger.debug((Object)("ENGINE_DISPLACEMENT:" + displacement));
        this._gSkillsStateManager.setEngineDisplacement(displacement);
    }

    private int getSensorIntValue(SensorConnectionEnum sensorEnum) {
        int sensorValue = -111111;
        try {
            SensorConnection sensorConnection = sensorEnum.getSensorConnection();
            Data[] data = sensorConnection.getData(1);
            if (data != null) {
                sensorValue = data[0].getIntValues()[0];
                this._logger.debug((Object)(sensorEnum.toString() + ":" + sensorValue));
            }
            sensorEnum.closeSensorConnection();
        }
        catch (Exception ex) {
            this._logger.error((Object)"Error in get Line :", (Throwable)ex);
        }
        return sensorValue;
    }

    private double getSensorDblValue(SensorConnectionEnum sensorEnum) {
        double sensorValue = -111111.111111;
        try {
            SensorConnection sensorConnection = sensorEnum.getSensorConnection();
            Data[] data = sensorConnection.getData(1);
            if (data != null) {
                sensorValue = data[0].getDoubleValues()[0];
                this._logger.debug((Object)(sensorEnum.toString() + ":" + sensorValue));
            }
            sensorEnum.closeSensorConnection();
        }
        catch (Exception ex) {
            this._logger.error((Object)"Error in get Line :", (Throwable)ex);
        }
        return sensorValue;
    }
}

