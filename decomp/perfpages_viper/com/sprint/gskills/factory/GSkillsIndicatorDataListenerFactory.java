/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.LocaleChangeListener
 *  konax.sensors.DataListener
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.listener.BatteryVoltageDataListener;
import com.sprint.gskills.listener.CoolantTempDataListener;
import com.sprint.gskills.listener.EngineRPMDataListener;
import com.sprint.gskills.listener.GearDataListener;
import com.sprint.gskills.listener.IntakeAirTempDataListener;
import com.sprint.gskills.listener.LanguagesListener;
import com.sprint.gskills.listener.OilPressureDataListener;
import com.sprint.gskills.listener.OilTempDataListener;
import com.sprint.gskills.listener.SpeedDataListener;
import com.sprint.gskills.listener.SteeringWheelAngleDataListener;
import com.sprint.gskills.listener.TorqueDataListener;
import com.sprint.gskills.listener.TransTempDataListener;
import com.sprint.gskills.listener.UnitListener;
import com.sprint.gskills.listener.VehAccelDataListener;
import com.sprint.gskills.listener.VehSpdMPHDataListener;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import kona.platform.LocaleChangeListener;
import konax.sensors.DataListener;

public class GSkillsIndicatorDataListenerFactory {
    private static LocaleChangeListener languagelistener = new LanguagesListener();
    private DataListener unitListener;
    private DataListener vehSpdMPHDataListener;
    private DataListener oilPressureDataListener;
    private DataListener speedDataListener;
    private DataListener oilTempDataListener;
    private DataListener coolantTempDataListener;
    private DataListener intakeAirTempDataListener;
    private DataListener vehAccelDataListener;
    private DataListener steeringWheelAngleDataListener;
    private DataListener engineRPMDataListener;
    private DataListener gearDataListener;
    private DataListener torqueDataListener;
    private DataListener transTempDataListener;

    public static GSkillsIndicatorDataListenerFactory getInstance() {
        return new GSkillsIndicatorDataListenerFactory();
    }

    private GSkillsIndicatorDataListenerFactory() {
    }

    public DataListener getUnitListener() {
        if (this.unitListener == null) {
            this.unitListener = new UnitListener();
        }
        return this.unitListener;
    }

    public LocaleChangeListener getLanguagesListener() {
        return languagelistener;
    }

    public DataListener getVehSpdMPHDDataListener(CommonSensorModel dataModel) {
        if (this.vehSpdMPHDataListener == null) {
            this.vehSpdMPHDataListener = new VehSpdMPHDataListener(dataModel);
        }
        return this.vehSpdMPHDataListener;
    }

    public DataListener getOilPressureDataListener(CommonSensorModel dataModel) {
        if (this.oilPressureDataListener == null) {
            this.oilPressureDataListener = new OilPressureDataListener(dataModel);
        }
        return this.oilPressureDataListener;
    }

    public DataListener getSpeedDataListener(CommonSensorModel dataModel) {
        if (this.speedDataListener == null) {
            this.speedDataListener = new SpeedDataListener(dataModel);
        }
        return this.speedDataListener;
    }

    public DataListener getOilTempDataListener(CommonSensorModel dataModel) {
        if (this.oilTempDataListener == null) {
            this.oilTempDataListener = new OilTempDataListener(dataModel);
        }
        return this.oilTempDataListener;
    }

    public DataListener getBatteryVoltDataListener(CommonSensorModel dataModel) {
        return new BatteryVoltageDataListener(dataModel);
    }

    public DataListener getCoolantTempDataListener(CommonSensorModel dataModel) {
        if (this.coolantTempDataListener == null) {
            this.coolantTempDataListener = new CoolantTempDataListener(dataModel);
        }
        return this.coolantTempDataListener;
    }

    public DataListener getIntakeAirTempDataListener(CommonSensorModel dataModel) {
        if (this.intakeAirTempDataListener == null) {
            this.intakeAirTempDataListener = new IntakeAirTempDataListener(dataModel);
        }
        return this.intakeAirTempDataListener;
    }

    public DataListener getTransTempDataListener(CommonSensorModel dataModel) {
        if (this.transTempDataListener == null) {
            this.transTempDataListener = new TransTempDataListener(dataModel);
        }
        return this.transTempDataListener;
    }

    public DataListener getVehAccelDataListener(CommonSensorModel dataModel) {
        if (this.vehAccelDataListener == null) {
            this.vehAccelDataListener = new VehAccelDataListener(dataModel);
        }
        return this.vehAccelDataListener;
    }

    public DataListener getSteeringWheelAngleDataListener(CommonSensorModel dataModel) {
        if (this.steeringWheelAngleDataListener == null) {
            this.steeringWheelAngleDataListener = new SteeringWheelAngleDataListener(dataModel);
        }
        return this.steeringWheelAngleDataListener;
    }

    public DataListener getEngineRPMDataListener(CommonSensorModel dataModel) {
        if (this.engineRPMDataListener == null) {
            this.engineRPMDataListener = new EngineRPMDataListener(dataModel);
        }
        return this.engineRPMDataListener;
    }

    public DataListener getGearDataListener(CommonSensorModel dataModel) {
        if (this.gearDataListener == null) {
            this.gearDataListener = new GearDataListener(dataModel);
        }
        return this.gearDataListener;
    }

    public DataListener getTorqueDataListener(CommonSensorModel dataModel) {
        if (this.torqueDataListener == null) {
            this.torqueDataListener = new TorqueDataListener(dataModel);
        }
        return this.torqueDataListener;
    }
}

