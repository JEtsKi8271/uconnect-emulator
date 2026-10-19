/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.PlatformException
 *  kona.platform.PlatformInfo
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.constants.SensorConnectionEnum;
import com.sprint.gskills.factory.GSkillsIndicatorDataListenerFactory;
import com.sprint.gskills.factory.GSkillsProperties;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.Locale;
import kona.platform.PlatformException;
import kona.platform.PlatformInfo;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class SensorsManager {
    private Logger logger = LoggerFactory.getLogger(SensorsManager.class);
    private SensorConnection unitSensorConnection = null;
    private PlatformInfo currentPlatformInfo;
    private GSkillsIndicatorDataListenerFactory listenerFactory = GSkillsIndicatorDataListenerFactory.getInstance();
    private CommonSensorModel sensorDataModel = GSkillsDataModelFactory.getSensorDataModel();
    private static final SensorsManager INSTANCE = new SensorsManager();

    private SensorsManager() {
        this.currentPlatformInfo = PlatformInfo.getPlatformInfo();
    }

    public static SensorsManager getInstance() {
        return INSTANCE;
    }

    protected void registerUnitChangeListener(GSkillsStateManager stateManager2) {
        if (this.logger.isDebugEnabled()) {
            this.logger.debug((Object)"Add Unit Listener");
        }
        try {
            if (this.unitSensorConnection == null) {
                this.unitSensorConnection = SensorConnectionEnum.US_Metric.getSensorConnection();
            }
            if (this.unitSensorConnection != null) {
                stateManager2.setCurrentUnit(this.unitSensorConnection.getData(1)[0].getIntValues()[0]);
                this.unitSensorConnection.setDataListener(this.listenerFactory.getUnitListener(), 1);
            }
        }
        catch (Exception e2) {
            this.logger.trace((Object)("add Unit Listener error: " + e2));
        }
    }

    public void unregisterUnitListener() {
        try {
            this.logger.debug((Object)"Removing unit listener ");
            if (this.unitSensorConnection != null) {
                this.unitSensorConnection.removeDataListener();
            }
        }
        catch (Exception e2) {
            this.logger.trace((Object)("remove Unit/Language Listener error:" + e2));
        }
    }

    public void registerLanguageListener() {
        try {
            if (this.logger.isDebugEnabled()) {
                this.logger.debug((Object)"Add Language Listener");
            }
            this.currentPlatformInfo.registerLocaleListener(this.listenerFactory.getLanguagesListener());
        }
        catch (Exception e2) {
            this.logger.trace((Object)"", (Throwable)e2);
        }
    }

    public void unregisterLanguageListener() {
        this.logger.debug((Object)"Removing language listener");
        if (this.currentPlatformInfo != null) {
            try {
                this.currentPlatformInfo.unregisterLocaleListener(this.listenerFactory.getLanguagesListener());
            }
            catch (PlatformException e2) {
                this.logger.trace((Object)"", (Throwable)e2);
            }
        }
    }

    public boolean hasHULanguageChanged() {
        try {
            Locale ds = this.currentPlatformInfo.getCurrentLocale();
            String country_locale = ds.toString();
            this.logger.debug((Object)("country_locale--- " + country_locale));
            return CommonViewResourceManager.getInstance().setCurrentLanguage(country_locale);
        }
        catch (Exception e2) {
            this.logger.error((Object)"Exception in hasHULanguageChanged()", (Throwable)e2);
            return CommonViewResourceManager.getInstance().setCurrentLanguage("en_US");
        }
    }

    public void unregisterListener(SensorConnectionEnum sensorConnectionEnum) {
        try {
            if (sensorConnectionEnum.getSensorConnection() != null) {
                this.logger.trace((Object)("Workaround log - trying to remove DataListener for " + sensorConnectionEnum.toString()));
                sensorConnectionEnum.getSensorConnection().removeDataListener();
                sensorConnectionEnum.closeSensorConnection();
            }
        }
        catch (Exception e2) {
            this.logger.trace((Object)("Failed to unregister " + sensorConnectionEnum.toString()));
        }
    }

    public void registerListener(SensorConnectionEnum sensorConnectionEnum) {
        this.logger.trace((Object)"{} workaround log - SensorsManager.registerListener()");
        SensorConnection sensorConnection = sensorConnectionEnum.getSensorConnection();
        if (sensorConnection != null) {
            try {
                this.logger.trace((Object)("Workaround log - Registering " + sensorConnectionEnum.toString()));
                switch (sensorConnectionEnum.getIntValue()) {
                    case 11: {
                        this.sensorDataModel.setBatteryVolt(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getBatteryVoltDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 12: {
                        this.sensorDataModel.setEngineCoolantTemp(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getCoolantTempDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 7: {
                        this.sensorDataModel.setRPM(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getEngineRPMDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 8: {
                        this.sensorDataModel.setGear(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getGearDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 14: {
                        this.sensorDataModel.setIntakeAirTemp(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getIntakeAirTempDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 10: {
                        this.sensorDataModel.setOilPressure(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getOilPressureDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 9: {
                        this.sensorDataModel.setOilTemp(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getOilTempDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 5: {
                        this.sensorDataModel.setSteeringAngle(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getSteeringWheelAngleDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 6: {
                        this.sensorDataModel.setTorque(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getTorqueDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 3: {
                        this.sensorDataModel.setCurrentSpeed(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getSpeedDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 4: {
                        this.sensorDataModel.setSpeedUnit(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getVehSpdMPHDDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 2: {
                        this.sensorDataModel.setVehAccelData(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getVehAccelDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                        break;
                    }
                    case 13: {
                        this.sensorDataModel.setTransTemp(sensorConnectionEnum.getData(1));
                        sensorConnection.setDataListener(this.listenerFactory.getTransTempDataListener(this.sensorDataModel), GSkillsProperties.getHarmanListenerBufferSize());
                    }
                }
            }
            catch (Exception e2) {
                this.logger.trace((Object)"sensorConnectionEnum.toString()", (Throwable)e2);
            }
        } else {
            this.logger.trace((Object)("sensorConnection null " + sensorConnectionEnum.toString()));
        }
    }

    public void closeSensorConnection() {
        try {
            SensorConnectionEnum.US_Metric.closeSensorConnection();
            SensorConnectionEnum.Veh_Spd_Disp.closeSensorConnection();
            SensorConnectionEnum.VehicleAcceleration.closeSensorConnection();
            SensorConnectionEnum.Steering_Wheel_Angle.closeSensorConnection();
            SensorConnectionEnum.Torque.closeSensorConnection();
            SensorConnectionEnum.EngineRPM.closeSensorConnection();
        }
        catch (Exception e2) {
            this.logger.trace((Object)("closeSensorConnection: " + e2));
        }
    }
}

