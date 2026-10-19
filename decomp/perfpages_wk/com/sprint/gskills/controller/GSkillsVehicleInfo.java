/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.network.NetworkConfiguration
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
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsVehicleInfo {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private final GSkillsStateManager _gSkillsStateManager = GSkillsStateManager.getInstance();
    private static final GSkillsVehicleInfo INSTANCE = new GSkillsVehicleInfo();

    private GSkillsVehicleInfo() {
    }

    public static GSkillsVehicleInfo getInstance() {
        return INSTANCE;
    }

    public void setVehicleInfo() {
        VehicleLineEnum vehicleLineEnum = VehicleLineEnum.UNSUPPORTED;
        int vehicleLineSensorVal = CommonUtils.getSensorIntValue(SensorConnectionEnum.VEH_LINE_SENSOR);
        if (-111111 != vehicleLineSensorVal) {
            vehicleLineEnum = GSkillsBrandConstants.getVehicleLineEnum(vehicleLineSensorVal);
        }
        this._gSkillsStateManager.setVehicleLine(vehicleLineEnum);
        if (VehicleLineEnum.UNSUPPORTED == vehicleLineEnum) {
            this._logger.debug((Object)("Vehicle Line:" + vehicleLineSensorVal + " is not supported. Only  WK(1), LX(2), LD(41), ZD(43) and LA (44) are supported"));
        } else {
            this._logger.debug((Object)("Vehicle Line:" + vehicleLineEnum.toString()));
            int isSrt = CommonUtils.getSensorIntValue(SensorConnectionEnum.SRT_PRSNT_SENSOR);
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
    }

    private boolean isEngineSuperCharged(VehicleLineEnum vehicleLineEnum) {
        boolean isSuperCharged = false;
        if (VehicleLineEnum.LA == vehicleLineEnum || VehicleLineEnum.LD == vehicleLineEnum) {
            int engAsp = CommonUtils.getSensorIntValue(SensorConnectionEnum.ENG_ASP_SENSOR);
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
            int transTypeSensorVal = CommonUtils.getSensorIntValue(SensorConnectionEnum.TRANS_TYPE_SENSOR);
            if (-111111 != transTypeSensorVal) {
                transType = GSkillsBrandConstants.getTransTypeEnum(transTypeSensorVal);
            }
        }
        this._logger.debug((Object)("TRANS_TYPE:" + transType.toString()));
        this._gSkillsStateManager.setTransType(transType);
    }

    private boolean isSRTPremium() {
        boolean isADCMPresent = false;
        if (VehicleLineEnum.LX == this._gSkillsStateManager.getVehicleLine()) {
            try {
                this._logger.debug((Object)"Vehicle line is LX. Reading NET_CFG_ADCM");
                if (1 == NetworkConfiguration.getInstance().getNetworkConfigurationStatus(28)) {
                    isADCMPresent = true;
                }
                this._logger.debug((Object)("ADCM Present:" + isADCMPresent));
            }
            catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return isADCMPresent;
    }

    private void readAndSetDisplacement() {
        this._logger.debug((Object)"Vehicle trim is RT. Reading DISPLACEMENT sensor");
        String displacement = "3.6";
        double displacementDbl = CommonUtils.getSensorDblValue(SensorConnectionEnum.DISPLACEMENT_SENSOR);
        if (CommonUtils.compareDbl(-111111.111111, displacementDbl)) {
            DecimalFormat df = new DecimalFormat("0.0");
            displacement = df.format(displacementDbl);
        }
        this._logger.debug((Object)("ENGINE_DISPLACEMENT:" + displacement));
        this._gSkillsStateManager.setEngineDisplacement(displacement);
    }
}

