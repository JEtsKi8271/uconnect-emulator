/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  konax.io.Connector
 *  konax.sensors.Data
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.constants;

import com.sprint.gskills.controller.SensorsManager;
import kona.logger.Log;
import konax.io.Connector;
import konax.sensors.Data;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;

public class SensorConnectionEnum {
    Logger _logger = Log.createLogger((String)this.getClass().getName());
    private SensorConnection _sensorConnection = null;
    private String _sensorURL;
    private Data[] _sensorDataHardcoded = null;
    public static final SensorConnectionEnum VEH_LINE_SENSOR = new SensorConnectionEnum("VC_VEH_LINE");
    public static final SensorConnectionEnum SRT_PRSNT_SENSOR = new SensorConnectionEnum("VC_SRT_PRSNT");
    public static final SensorConnectionEnum VEH_BRAND_SENSOR = new SensorConnectionEnum("VC_VEH_BRAND");
    public static final SensorConnectionEnum ENG_ASP_SENSOR = new SensorConnectionEnum("EngineAspiration");
    public static final SensorConnectionEnum TRANS_TYPE_SENSOR = new SensorConnectionEnum("TransmissionType");
    public static final SensorConnectionEnum DISPLACEMENT_SENSOR = new SensorConnectionEnum("Displacement");
    public static final SensorConnectionEnum PRESSURE_UNIT_SENSOR = new SensorConnectionEnum("PressureUnit");
    public static final SensorConnectionEnum POWER_UNIT_SENSOR = new SensorConnectionEnum("PowerUnit");
    public static final SensorConnectionEnum TEMP_UNIT_SENSOR = new SensorConnectionEnum("TemperatureUnit");
    public static final SensorConnectionEnum SPEED_UNIT_SENSOR = new SensorConnectionEnum("SpeedUnit");
    public static final SensorConnectionEnum TORQUE_UNIT_SENSOR = new SensorConnectionEnum("TorqueUnit");
    public static final SensorConnectionEnum DISTANCE_UNIT_SENSOR = new SensorConnectionEnum("DistanceUnit");

    private SensorConnectionEnum(String sensorURL) {
        this._sensorURL = sensorURL;
    }

    public SensorConnection getSensorConnection() {
        if (this._sensorConnection == null) {
            try {
                this._sensorConnection = (SensorConnection)Connector.open((String)("sensor:" + this._sensorURL));
                SensorsManager.getInstance().addToListOfOpenSensors(this);
            }
            catch (Exception e2) {
                this._logger.error((Object)(this._sensorURL + e2));
                e2.printStackTrace();
            }
        }
        return this._sensorConnection;
    }

    public String toString() {
        return this._sensorURL;
    }

    public void closeSensorConnection() {
        if (this._sensorConnection != null) {
            try {
                if (this._sensorConnection.getState() != 4) {
                    this._logger.trace((Object)("Closing sensor " + this._sensorURL));
                    this._sensorConnection.close();
                }
                this._sensorConnection = null;
            }
            catch (Exception e2) {
                this._logger.trace((Object)(this._sensorURL + e2));
            }
        }
    }

    public Data[] getData(int bufferSize) {
        this.getSensorConnection();
        try {
            Data[] data = null;
            for (int i2 = 0; i2 < 5; ++i2) {
                try {
                    if (this._sensorConnection.getState() == 1) {
                        data = this._sensorConnection.getData(bufferSize);
                        i2 = 5;
                    }
                }
                catch (Exception e2) {
                    data = this._sensorDataHardcoded;
                }
                try {
                    if (i2 >= 5) continue;
                    Thread.sleep(100L);
                    continue;
                }
                catch (Exception ee) {
                    this._logger.error((Object)("sleep failed.. CPU / memory must be in bad shape" + ee));
                }
            }
            return data;
        }
        catch (Exception e3) {
            this._logger.trace((Object)("Workaround log - exception occurred in getData.. probably _sensorConnection was null.." + this._sensorURL + e3));
            return this._sensorDataHardcoded;
        }
    }
}

