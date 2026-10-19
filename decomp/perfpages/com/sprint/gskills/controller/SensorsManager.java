/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.LocaleChangeListener
 *  kona.platform.PlatformException
 *  kona.platform.PlatformInfo
 *  konax.sensors.DataListener
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.constants.SensorConnectionEnum;
import com.sprint.gskills.listener.LanguagesListener;
import com.sprint.gskills.listener.UnitListener;
import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import kona.platform.LocaleChangeListener;
import kona.platform.PlatformException;
import kona.platform.PlatformInfo;
import konax.sensors.DataListener;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class SensorsManager {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private SensorConnection _pressureUnitSensorConnection = null;
    private SensorConnection _powerUnitSensorConnection = null;
    private SensorConnection _speedUnitSensorConnection = null;
    private SensorConnection _torqueUnitSensorConnection = null;
    private SensorConnection _tempUnitSensorConnection = null;
    private PlatformInfo _currentPlatformInfo;
    private ArrayList<SensorConnectionEnum> _openSensorsList = new ArrayList();
    private static final SensorsManager INSTANCE = new SensorsManager();
    private final int SENSOR_BUFFER_SIZE = 1;

    public static SensorsManager getInstance() {
        return INSTANCE;
    }

    private SensorsManager() {
        this._currentPlatformInfo = PlatformInfo.getPlatformInfo();
    }

    protected void registerUnitChangeListeners() {
        this._logger.debug((Object)"Registering unit change listeners");
        UnitListener unitListener = UnitListener.getInstance();
        if (null == this._pressureUnitSensorConnection) {
            this._logger.debug((Object)"Opening sensor PressureUnit");
            this._pressureUnitSensorConnection = SensorConnectionEnum.PRESSURE_UNIT_SENSOR.getSensorConnection();
            if (null != this._pressureUnitSensorConnection) {
                GSkillsStateManager.getInstance().setPressureUnit(UnitConversionUtility.getInstance().getPressureUnitEnum(this.getSensorValue(this._pressureUnitSensorConnection)));
                this._pressureUnitSensorConnection.setDataListener((DataListener)unitListener, 1);
            }
        }
        if (null == this._powerUnitSensorConnection) {
            this._logger.debug((Object)"Opening sensor PowerUnit");
            this._powerUnitSensorConnection = SensorConnectionEnum.POWER_UNIT_SENSOR.getSensorConnection();
            if (null != this._powerUnitSensorConnection) {
                GSkillsStateManager.getInstance().setPowerUnit(UnitConversionUtility.getInstance().getPowerUnitEnum(this.getSensorValue(this._powerUnitSensorConnection)));
                this._powerUnitSensorConnection.setDataListener((DataListener)unitListener, 1);
            }
        }
        if (null == this._torqueUnitSensorConnection) {
            this._logger.debug((Object)"Opening sensor TorqueUnit");
            this._torqueUnitSensorConnection = SensorConnectionEnum.TORQUE_UNIT_SENSOR.getSensorConnection();
            if (null != this._torqueUnitSensorConnection) {
                GSkillsStateManager.getInstance().setTorqueUnit(UnitConversionUtility.getInstance().getTorqueUnitEnum(this.getSensorValue(this._torqueUnitSensorConnection)));
                this._torqueUnitSensorConnection.setDataListener((DataListener)unitListener, 1);
            }
        }
        if (null == this._tempUnitSensorConnection) {
            this._logger.debug((Object)"Opening sensor TemperatureUnit");
            this._tempUnitSensorConnection = SensorConnectionEnum.TEMP_UNIT_SENSOR.getSensorConnection();
            if (null != this._tempUnitSensorConnection) {
                GSkillsStateManager.getInstance().setTempUnit(UnitConversionUtility.getInstance().getTempUnitEnum(this.getSensorValue(this._tempUnitSensorConnection)));
                this._tempUnitSensorConnection.setDataListener((DataListener)unitListener, 1);
            }
        }
        if (null == this._speedUnitSensorConnection) {
            this._logger.debug((Object)"Opening sensor SpeedUnit");
            this._speedUnitSensorConnection = SensorConnectionEnum.SPEED_UNIT_SENSOR.getSensorConnection();
            if (null != this._speedUnitSensorConnection) {
                GSkillsStateManager.getInstance().setSpeedUnit(UnitConversionUtility.getInstance().getSpeedUnitEnum(this.getSensorValue(this._speedUnitSensorConnection)));
                this._speedUnitSensorConnection.setDataListener((DataListener)unitListener, 1);
            }
        }
    }

    private int getSensorValue(SensorConnection sensorConnection) {
        int sensorValue = 0;
        try {
            sensorValue = sensorConnection.getData(1)[0].getIntValues()[0];
        }
        catch (IOException e2) {
            this._logger.debug((Object)("Failed to get sensor value with error " + e2));
        }
        return sensorValue;
    }

    public void registerLanguageListener() {
        try {
            this._logger.trace((Object)"Registering language listener");
            this._currentPlatformInfo.registerLocaleListener((LocaleChangeListener)LanguagesListener.getInstance());
        }
        catch (Exception e2) {
            this._logger.debug((Object)"", (Throwable)e2);
        }
    }

    public void unregisterLanguageListener() {
        this._logger.trace((Object)"Unregistering language listener");
        if (this._currentPlatformInfo != null) {
            try {
                this._currentPlatformInfo.unregisterLocaleListener((LocaleChangeListener)LanguagesListener.getInstance());
            }
            catch (PlatformException e2) {
                this._logger.trace((Object)"", (Throwable)e2);
            }
            this._currentPlatformInfo = null;
        }
    }

    public void unregisterListener(SensorConnectionEnum sensorConnectionEnum) {
        try {
            if (sensorConnectionEnum.getSensorConnection() != null) {
                this._logger.trace((Object)("Unregistering DataListener for " + sensorConnectionEnum.toString()));
                sensorConnectionEnum.getSensorConnection().removeDataListener();
            }
        }
        catch (Exception e2) {
            this._logger.trace((Object)("Failed to unregister " + sensorConnectionEnum.toString()));
        }
    }

    public void addToListOfOpenSensors(SensorConnectionEnum sensorEnum) {
        if (!this._openSensorsList.contains(sensorEnum)) {
            this._openSensorsList.add(sensorEnum);
        }
    }

    public void closeAllSensorConnections() {
        Iterator<SensorConnectionEnum> iter = this._openSensorsList.iterator();
        while (iter.hasNext()) {
            iter.next().closeSensorConnection();
        }
    }
}

