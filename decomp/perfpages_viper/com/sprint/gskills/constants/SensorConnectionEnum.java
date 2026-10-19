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

import kona.logger.Log;
import konax.io.Connector;
import konax.sensors.Data;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;

public class SensorConnectionEnum {
    Logger logger = Log.createLogger((String)this.getClass().getName());
    private SensorConnection sensorConnection = null;
    private int intvalue;
    private String sensorURL;
    private Data[] sensorDataHardcoded = null;
    public static final SensorConnectionEnum US_Metric = new SensorConnectionEnum(0, "sensor:US_Metric");
    public static final SensorConnectionEnum VC_VEH_LINE = new SensorConnectionEnum(1, "sensor:VC_VEH_LINE");
    public static final SensorConnectionEnum TRANS_TYPE = new SensorConnectionEnum(16, "sensor:TransmissionType");
    public static final SensorConnectionEnum VehicleAcceleration = new SensorConnectionEnum(2, "sensor:VehicleAcceleration");
    public static final SensorConnectionEnum Veh_Spd_Disp = new SensorConnectionEnum(3, "sensor:VehSpdDisp");
    public static final SensorConnectionEnum Veh_Spd_MPH = new SensorConnectionEnum(4, "sensor:VehSpd_MPH");
    public static final SensorConnectionEnum Steering_Wheel_Angle = new SensorConnectionEnum(5, "sensor:SteeringWheelAngle");
    public static final SensorConnectionEnum Torque = new SensorConnectionEnum(6, "sensor:Torque");
    public static final SensorConnectionEnum EngineRPM = new SensorConnectionEnum(7, "sensor:EngineRPM");
    public static final SensorConnectionEnum PresentGear = new SensorConnectionEnum(8, "sensor:PresentGear");
    public static final SensorConnectionEnum oilTemp = new SensorConnectionEnum(9, "sensor:OilTemp");
    public static final SensorConnectionEnum oilPressure = new SensorConnectionEnum(10, "sensor:OilPressure");
    public static final SensorConnectionEnum battery = new SensorConnectionEnum(11, "sensor:Battery");
    public static final SensorConnectionEnum engineCoolant = new SensorConnectionEnum(12, "sensor:EngineCoolant");
    public static final SensorConnectionEnum transTemp = new SensorConnectionEnum(13, "sensor:TX_TEMP");
    public static final SensorConnectionEnum intakeAirTemp = new SensorConnectionEnum(14, "sensor:IntakeAirTemp");

    private SensorConnectionEnum(int intvalue, String sensorURL) {
        this.intvalue = intvalue;
        this.sensorURL = sensorURL;
    }

    public int getIntValue() {
        return this.intvalue;
    }

    public int hashCode() {
        return this.getIntValue();
    }

    public SensorConnection getSensorConnection() {
        if (this.sensorConnection == null) {
            try {
                this.sensorConnection = (SensorConnection)Connector.open((String)this.sensorURL);
            }
            catch (Exception e2) {
                this.logger.error((Object)(this.sensorURL + e2));
            }
        }
        return this.sensorConnection;
    }

    public String toString() {
        return this.sensorURL;
    }

    public void closeSensorConnection() {
        if (this.sensorConnection != null) {
            try {
                if (this.sensorConnection.getState() != 4) {
                    this.logger.trace((Object)("Workaround log - closing " + this.sensorURL));
                    this.sensorConnection.close();
                }
                this.sensorConnection = null;
            }
            catch (Exception e2) {
                this.logger.trace((Object)(this.sensorURL + e2));
            }
        }
    }

    public Data[] getData(int bufferSize) {
        this.getSensorConnection();
        try {
            Data[] data = null;
            for (int i2 = 0; i2 < 5; ++i2) {
                try {
                    if (this.sensorConnection.getState() == 1) {
                        data = this.sensorConnection.getData(bufferSize);
                        i2 = 5;
                    }
                }
                catch (Exception e2) {
                    data = this.sensorDataHardcoded;
                }
                try {
                    if (i2 >= 5) continue;
                    Thread.sleep(100L);
                    continue;
                }
                catch (Exception ee) {
                    this.logger.error((Object)("sleep failed.. CPU / memory must be in bad shape" + ee));
                }
            }
            return data;
        }
        catch (Exception e3) {
            this.logger.trace((Object)("Workaround log - exception occurred in getData.. probably sensorConnection was null.." + this.sensorURL + e3));
            return this.sensorDataHardcoded;
        }
    }

    public void setData(Data[] testData) {
        this.sensorDataHardcoded = testData;
    }
}

