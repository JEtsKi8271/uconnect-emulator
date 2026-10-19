/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  konax.sensors.Data
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.model.sensordata;

import com.sprint.gskills.constants.SensorConnectionEnum;
import com.sprint.gskills.constants.SpeedUnitEnum;
import com.sprint.gskills.factory.ValueRangePropertiesFactory;
import com.sprint.gskills.model.sensordata.CommonDataModel;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.text.DecimalFormat;
import kona.logger.Log;
import konax.sensors.Data;
import net.sf.microlog.core.Logger;

public class SensorDataModel
extends CommonDataModel
implements CommonSensorModel {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private boolean hasOilPressureChanged = false;
    private boolean hasGearChanged = false;
    private boolean hasOilTempChanged = false;
    private boolean hasBatteryVoltChanged = false;
    private boolean hasEngineCoolantTempChanged = false;
    private boolean hasIntakeAirTempChanged = false;
    private boolean hasTransTempChanged = false;
    private boolean hasSpeedUnitChanged = false;
    private boolean hasViewChanged = false;
    private boolean isOilPressureAnalog = false;
    private boolean isOilTempAnalog = false;
    private boolean isEngineCoolantTempAnalog = false;
    private boolean isIntakeAirTempAnalog = false;
    private boolean isTransTempAnalog = false;
    private int notInitialized;
    private int oilPressureValue = this.notInitialized = -100;
    private int gearValue = this.notInitialized;
    private int oilTempValue = this.notInitialized;
    private double batteryVoltData;
    private int engineCoolantTempValue = this.notInitialized;
    private int intakeAirTempValue = this.notInitialized;
    private int transTempValue = this.notInitialized;
    private int speedUnit = this.notInitialized;
    private int GFORCE_SNA = Integer.parseInt("3FF", 16);
    private String hardcodedSpeed = "0";
    private String zero_value = "0.00";
    private int currentSpeedPolled = this.notInitialized;
    private double currentTorqueValuePolled = 1548.0;
    private String horsePowerValueString = "--";
    private int currentOilPressurePolled = this.notInitialized;
    private double gForceXDataPolled = this.GFORCE_SNA;
    private double gForceYDataPolled = this.GFORCE_SNA;
    private String gForceTopString = "--";
    private String gForceBottomString = "--";
    private String gForceLeftString = "--";
    private String gForceRightString = "--";
    private double steeringAngleValuePolled = 2048.0;
    private double viperTorqueMultiplier = 1.0;
    private double batteryVoltDataPolled;

    public SensorDataModel() {
        if (43 == GSkillsStateManager.getInstance().getVehicleLine()) {
            this.viperTorqueMultiplier = 1.13;
        }
    }

    public void setCurrentSpeed(Data[] data) {
        this.logger.error((Object)"Not implemented");
    }

    public boolean hasSpeedChangedPolling() {
        try {
            Data[] speedDataArrayPolled = SensorConnectionEnum.Veh_Spd_Disp.getData(1);
            if (speedDataArrayPolled != null) {
                int speed = speedDataArrayPolled[0].getIntValues()[0];
                if (this.currentSpeedPolled != speed) {
                    this.currentSpeedPolled = speed;
                    return true;
                }
                return this.hasViewChanged;
            }
            return false;
        }
        catch (Exception e2) {
            this.logger.trace((Object)"", (Throwable)e2);
            return false;
        }
    }

    public String getCurrentSpeedPolled() {
        return this.getCurrentSpeed(this.currentSpeedPolled);
    }

    private String getCurrentSpeed(int speedValue) {
        if (speedValue != this.notInitialized) {
            if (speedValue < 0 || speedValue > 65534) {
                return "--";
            }
            return Integer.toString(this.rangeControModule(speedValue, (double)this.maxSpeed, (double)this.minSpeed));
        }
        return this.hardcodedSpeed;
    }

    public void setSpeedUnit(Data[] speedUnitFromSensor) {
        int speedUnitFromSensorInt;
        if (speedUnitFromSensor != null && this.speedUnit != (speedUnitFromSensorInt = speedUnitFromSensor[0].getIntValues()[0])) {
            this.speedUnit = speedUnitFromSensorInt;
            this.hasSpeedUnitChanged = true;
            this.maxSpeed = ValueRangePropertiesFactory.getRangeValueByKey("max_" + SpeedUnitEnum.getSpeedUnitString(this.speedUnit));
        }
    }

    public boolean hasSpeedUnitChanged() {
        return this.hasSpeedUnitChanged || this.hasViewChanged;
    }

    public String getSpeedUnit() {
        this.hasSpeedUnitChanged = false;
        if (this.speedUnit == this.notInitialized) {
            return "unit_" + SpeedUnitEnum.getSpeedUnitString(SpeedUnitEnum.MPH.getSensorValue());
        }
        return "unit_" + SpeedUnitEnum.getSpeedUnitString(this.speedUnit);
    }

    public boolean hasOilPressureChanged() {
        return this.hasOilPressureChanged || this.hasViewChanged;
    }

    public void setOilPressure(Data[] data) {
        int oilpressure;
        if (data != null && this.oilPressureValue != (oilpressure = data[0].getIntValues()[0])) {
            this.hasOilPressureChanged = true;
            this.oilPressureValue = oilpressure;
        }
    }

    public int getOilPressureImageNumber(boolean isGaugeImage) {
        this.isOilPressureAnalog = true;
        return this.getOilPressureImageNumber(this.getOilPressure(), isGaugeImage);
    }

    public int getOilPressurePolledImageNumber(boolean isGaugeImage) {
        return this.getOilPressureImageNumber(this.getOilPressurePolled(), isGaugeImage);
    }

    public String getOilPressure() {
        this.hasOilPressureChanged = false;
        return this.getOilPressure(this.oilPressureValue);
    }

    public boolean pollAndCheckOilPressureChange() {
        Data[] oilPressureDataArrayPolled = SensorConnectionEnum.oilPressure.getData(1);
        if (oilPressureDataArrayPolled == null) {
            this.logger.trace((Object)"Oil_Press value is null after getData API. Oil_Press will not update");
            return false;
        }
        try {
            int oilPressure = oilPressureDataArrayPolled[0].getIntValues()[0];
            if (oilPressure != this.currentOilPressurePolled) {
                this.currentOilPressurePolled = oilPressure;
                return true;
            }
            return this.hasViewChanged;
        }
        catch (Exception e2) {
            this.logger.trace((Object)"Oil_Press :: Exception thrown on value.getIntValues. Oil_Press will not update");
            e2.printStackTrace();
            return false;
        }
    }

    public String getOilPressurePolled() {
        return this.getOilPressure(this.currentOilPressurePolled);
    }

    private String getOilPressure(int oilPressure) {
        if (oilPressure != this.notInitialized) {
            if (oilPressure < 0 || oilPressure > 1016) {
                return "--";
            }
            if (this.isOilPressureAnalog) {
                this.isOilPressureAnalog = false;
                return Integer.toString(this.rangeControModule(this.pressureConverter(oilPressure), Max_OilPress, Min_OilPress));
            }
            return Integer.toString(this.pressureConverter(oilPressure));
        }
        return "--";
    }

    public boolean hasGearChanged() {
        return this.hasGearChanged || this.hasViewChanged;
    }

    public void setGear(Data[] data) {
        int gear;
        if (data != null && this.gearValue != (gear = data[0].getIntValues()[0])) {
            this.hasGearChanged = true;
            this.gearValue = gear;
        }
    }

    public String getGear() {
        this.hasGearChanged = false;
        return this.getGearValueToDisplay(this.gearValue);
    }

    private String getGearValueToDisplay(int gearValueFromSensor) {
        if (gearValueFromSensor == 0) {
            return "N";
        }
        if (gearValueFromSensor >= 1 && gearValueFromSensor <= 8) {
            return Integer.toString(gearValueFromSensor);
        }
        if (gearValueFromSensor == Integer.parseInt("B", 16)) {
            return "R";
        }
        if (gearValueFromSensor == Integer.parseInt("D", 16)) {
            return "P";
        }
        return "--";
    }

    public boolean hasOilTempChanged() {
        return this.hasOilTempChanged || this.hasViewChanged;
    }

    public void setOilTemp(Data[] data) {
        int oilTemp;
        if (data != null && this.oilTempValue != (oilTemp = data[0].getIntValues()[0])) {
            this.hasOilTempChanged = true;
            this.oilTempValue = oilTemp;
        }
    }

    public int getOilTempImageNumber() {
        this.isOilTempAnalog = true;
        return this.getImageNumber(this.getOilTemp(), Max_OilTemp, Min_OilTemp, 17);
    }

    public String getOilTemp() {
        this.hasOilTempChanged = false;
        if (this.oilTempValue != this.notInitialized) {
            if (this.isOilTempAnalog) {
                this.isOilTempAnalog = false;
                return Integer.toString(this.rangeControModule(this.temperatureConverter(this.oilTempValue), Max_OilTemp, Min_OilTemp));
            }
            return Integer.toString(this.temperatureConverter(this.oilTempValue));
        }
        return "--";
    }

    public boolean hasBatteryVoltageChanged() {
        return this.hasBatteryVoltChanged || this.hasViewChanged;
    }

    public void setBatteryVolt(Data[] data) {
        double batteryVolt;
        if (data != null && this.batteryVoltData != (batteryVolt = data[0].getDoubleValues()[0])) {
            this.hasBatteryVoltChanged = true;
            this.batteryVoltData = batteryVolt;
        }
    }

    public int getBatteryVoltImageNumber() {
        return this.getImageNumber(this.getBattery(), Max_Battery, Min_Battery, 17);
    }

    public int getBatteryVoltPolledImageNumber() {
        return this.getBatteryImageNumber(this.getBatteryPolled(), Max_Battery, Min_Battery, 17);
    }

    public String getBattery() {
        this.hasBatteryVoltChanged = false;
        if (this.batteryVoltData < 5.0 || this.batteryVoltData > 18.0) {
            return "--";
        }
        DecimalFormat df = new DecimalFormat("#.0");
        return df.format(this.batteryVoltData);
    }

    public String getBatteryPolled() {
        this.hasBatteryVoltChanged = false;
        DecimalFormat df = new DecimalFormat("0.0");
        return df.format(this.batteryVoltDataPolled);
    }

    public boolean pollAndCheckVehAccelChange() {
        Data[] VehicleAccelerationDataArrayPolled = SensorConnectionEnum.VehicleAcceleration.getData(1);
        if (VehicleAccelerationDataArrayPolled == null) {
            this.logger.trace((Object)"VehAccel value is null after getData API. VehAccel will not update");
            return false;
        }
        boolean hasGForceChanged = false;
        try {
            for (int i2 = 0; i2 < VehicleAccelerationDataArrayPolled.length; ++i2) {
                double gforceYfromSensor;
                if (VehicleAccelerationDataArrayPolled[i2].getChannelInfo().getName().equals("VehPerfAccel_X")) {
                    double gforceXfromSensor = VehicleAccelerationDataArrayPolled[i2].getDoubleValues()[0];
                    if (this.gForceXDataPolled == gforceXfromSensor) continue;
                    hasGForceChanged = true;
                    this.gForceXDataPolled = gforceXfromSensor;
                    this.setTopBottomGForceValue();
                    continue;
                }
                if (!VehicleAccelerationDataArrayPolled[i2].getChannelInfo().getName().equals("VehPerfAccel_Y") || this.gForceYDataPolled == (gforceYfromSensor = VehicleAccelerationDataArrayPolled[i2].getDoubleValues()[0])) continue;
                hasGForceChanged = true;
                this.gForceYDataPolled = gforceYfromSensor;
                this.setLeftRightGForceValue();
            }
        }
        catch (Exception e2) {
            this.logger.trace((Object)"VehAccel :: Exception thrown on value.getIntValues. VehAccel will not update");
            return false;
        }
        return hasGForceChanged;
    }

    private void setLeftRightGForceValue() {
        if (this.isGforceValueSNA(this.gForceYDataPolled)) {
            this.gForceLeftString = "--";
            this.gForceRightString = "--";
        } else if (this.gForceYDataPolled < 0.0) {
            double douXValue = this.getGForceValue(this.gForceYDataPolled);
            this.gForceLeftString = this.formatGforceValue(douXValue);
            this.gForceRightString = this.zero_value;
        } else if (this.gForceYDataPolled > 0.0) {
            double douXValue = this.getGForceValue(this.gForceYDataPolled);
            this.gForceRightString = this.formatGforceValue(douXValue);
            this.gForceLeftString = this.zero_value;
        } else if (this.gForceYDataPolled == 0.0) {
            this.gForceRightString = this.zero_value;
            this.gForceLeftString = this.zero_value;
        }
    }

    private void setTopBottomGForceValue() {
        if (this.isGforceValueSNA(this.gForceXDataPolled)) {
            this.gForceTopString = "--";
            this.gForceBottomString = "--";
        } else if (this.gForceXDataPolled > 0.0) {
            double douXValue = this.getGForceValue(this.gForceXDataPolled);
            this.gForceBottomString = this.formatGforceValue(douXValue);
            this.gForceTopString = this.zero_value;
        } else if (this.gForceXDataPolled < 0.0) {
            double douXValue = this.getGForceValue(this.gForceXDataPolled);
            this.gForceTopString = this.formatGforceValue(douXValue);
            this.gForceBottomString = this.zero_value;
        } else if (this.gForceXDataPolled == 0.0) {
            this.gForceTopString = this.zero_value;
            this.gForceBottomString = this.zero_value;
        }
    }

    public void setVehAccelData(Data[] data) {
        this.logger.error((Object)"setVehAccelData NOT IMplemented");
    }

    private double getGForceValue(double gForceData) {
        double douXValue = Math.round(Math.abs(gForceData) * 10.0);
        return this.rangeControModule(douXValue /= 100.0, Max_GForce_Value, Min_GForce);
    }

    public String getBottomGforceValue() {
        return this.gForceBottomString;
    }

    public String getTopGforceValue() {
        return this.gForceTopString;
    }

    public String getGForceFrontRearImageName() {
        String gForceImageName = "image_gindicator_active";
        String imageName = "";
        String imageExtension = ".png";
        double gForceXValue = this.getGForceValue(this.gForceXDataPolled);
        if (this.gForceXDataPolled >= 0.0) {
            if (gForceXValue < 0.1 || this.isGforceValueSNA(this.gForceXDataPolled)) {
                return gForceImageName + imageExtension;
            }
            imageName = "_rear";
        } else if (this.gForceXDataPolled < 0.0) {
            imageName = "_front";
        }
        return gForceImageName + imageName + this.getImageNumber(gForceXValue, Max_GForce, 0.1, 4) + imageExtension;
    }

    private boolean isGforceValueSNA(double gForceValue) {
        return gForceValue < -40.88 || gForceValue > 40.88;
    }

    public String getGForceLeftRightImageName() {
        String gForceImageName = "image_gindicator_active";
        String imageName = "";
        String imageExtension = ".png";
        double gForceYValue = this.getGForceValue(this.gForceYDataPolled);
        if (this.gForceYDataPolled >= 0.0) {
            if (gForceYValue < 0.1 || this.isGforceValueSNA(this.gForceYDataPolled)) {
                return gForceImageName + imageExtension;
            }
            imageName = "_r";
        } else if (this.gForceYDataPolled < 0.0) {
            imageName = "_l";
        }
        return gForceImageName + imageName + this.getImageNumber(gForceYValue, Max_GForce, 0.1, 7) + imageExtension;
    }

    public String getLeftGforceValue() {
        return this.gForceLeftString;
    }

    public String getRightGforceValue() {
        return this.gForceRightString;
    }

    public int getGforceCarImageNumber() {
        return this.getGforceCarNumber(this.getLeftGforceValue(), this.getRightGforceValue());
    }

    public boolean pollAndCheckSteeringWheelAngleChanged() {
        Data[] steeringAngleDataArrayPolled = SensorConnectionEnum.Steering_Wheel_Angle.getData(1);
        if (steeringAngleDataArrayPolled != null) {
            double steeringAngleFromSensor = steeringAngleDataArrayPolled[0].getDoubleValues()[0];
            if (this.steeringAngleValuePolled != steeringAngleFromSensor) {
                this.steeringAngleValuePolled = steeringAngleFromSensor;
                return true;
            }
            return this.hasViewChanged;
        }
        this.logger.trace((Object)"Steering Wheel angle will not update. getData API returned null obj");
        return false;
    }

    public void setSteeringAngle(Data[] data) {
        this.logger.error((Object)"setSteeringAngle not implemented");
    }

    public String getSteeringAngle() {
        if (this.steeringAngleValuePolled < -2048.0 || this.steeringAngleValuePolled > 2047.0) {
            return "--";
        }
        return this.incrementValueInSteps(this.rangeSteeringAngle(this.steeringAngleValuePolled, Max_SteeringWheelAngle, Min_SteeringWheelAngle), 5);
    }

    private String incrementValueInSteps(String rangeSteeringAngle, int step) {
        int sensorvalue = Integer.parseInt(rangeSteeringAngle);
        int sensorValueMod = sensorvalue % step;
        if (sensorValueMod == 0) {
            return Integer.toString(sensorvalue);
        }
        return Integer.toString(sensorvalue - sensorValueMod);
    }

    public boolean hasEngineCoolantTempChanged() {
        return this.hasEngineCoolantTempChanged || this.hasViewChanged;
    }

    public void setEngineCoolantTemp(Data[] engineCoolantTemp) {
        int engineCoolantTempFromSensor;
        if (engineCoolantTemp != null && this.engineCoolantTempValue != (engineCoolantTempFromSensor = engineCoolantTemp[0].getIntValues()[0])) {
            this.hasEngineCoolantTempChanged = true;
            this.engineCoolantTempValue = engineCoolantTempFromSensor;
        }
    }

    public int getEngineCoolantTempImageNumber() {
        this.isEngineCoolantTempAnalog = true;
        return this.getImageNumber(this.getEngineCoolantTemp(), Max_CoolantTemp, Min_CoolantTemp, 17);
    }

    public String getEngineCoolantTemp() {
        this.hasEngineCoolantTempChanged = false;
        if (this.engineCoolantTempValue < -40 || this.engineCoolantTempValue > 214 || this.engineCoolantTempValue == this.notInitialized) {
            return "--";
        }
        if (this.isEngineCoolantTempAnalog) {
            this.isEngineCoolantTempAnalog = false;
            return Integer.toString(this.rangeControModule(this.temperatureConverter(this.engineCoolantTempValue), Max_CoolantTemp, Min_CoolantTemp));
        }
        return Integer.toString(this.temperatureConverter(this.engineCoolantTempValue));
    }

    public boolean hasIntakeAirTempChanged() {
        return this.hasIntakeAirTempChanged || this.hasViewChanged;
    }

    public void setIntakeAirTemp(Data[] intakeAirTemp) {
        int intakeAirTempFromSensor;
        if (intakeAirTemp != null && this.intakeAirTempValue != (intakeAirTempFromSensor = intakeAirTemp[0].getIntValues()[0])) {
            this.hasIntakeAirTempChanged = true;
            this.intakeAirTempValue = intakeAirTempFromSensor;
        }
    }

    public int getIntakeAirTempImageNumber() {
        this.isIntakeAirTempAnalog = true;
        return this.getImageNumber(this.getIntakeAirTemp(), Max_IntakeAirTemp, Min_IntakeAirTemp, 17);
    }

    public String getIntakeAirTemp() {
        this.hasIntakeAirTempChanged = false;
        if (this.intakeAirTempValue < -40 || this.intakeAirTempValue > 214 || this.intakeAirTempValue == this.notInitialized) {
            return "--";
        }
        if (this.isIntakeAirTempAnalog) {
            this.isIntakeAirTempAnalog = false;
            return Integer.toString(this.rangeControModule(this.temperatureConverter(this.intakeAirTempValue), Max_IntakeAirTemp, Min_IntakeAirTemp));
        }
        return Integer.toString(this.temperatureConverter(this.intakeAirTempValue));
    }

    public boolean hasTransTempChanged() {
        return this.hasTransTempChanged || this.hasViewChanged;
    }

    public void setTransTemp(Data[] transTemp) {
        int transTempFromSensor;
        if (transTemp != null && this.transTempValue != (transTempFromSensor = transTemp[0].getIntValues()[0])) {
            this.hasTransTempChanged = true;
            this.transTempValue = transTempFromSensor;
        }
    }

    public int getTransTempImageNumber() {
        this.isTransTempAnalog = true;
        return this.getImageNumber(this.getTransTemp(), Max_TransTemp, Min_TransTemp, 17);
    }

    public String getTransTemp() {
        this.hasTransTempChanged = false;
        if (this.transTempValue < -50 || this.transTempValue > 210) {
            return "--";
        }
        if (this.isTransTempAnalog) {
            this.isTransTempAnalog = false;
            return Integer.toString(this.rangeControModule(this.temperatureConverter(this.transTempValue), Max_TransTemp, Min_TransTemp));
        }
        return Integer.toString(this.temperatureConverter(this.transTempValue));
    }

    public void setTorque(Data[] data) {
        this.logger.error((Object)"Not implemented");
    }

    public boolean PollandCheckTorqueDataChange() {
        Data[] torqueDataArrayPolled = SensorConnectionEnum.Torque.getData(1);
        if (torqueDataArrayPolled != null) {
            Data[] rpm = SensorConnectionEnum.EngineRPM.getData(1);
            double torqueFromSensor = torqueDataArrayPolled[0].getDoubleValues()[0];
            if (this.getRPM(rpm).equals("--")) {
                this.currentTorqueValuePolled = -1000.0;
                return true;
            }
            if (Integer.parseInt(this.getRPM(rpm)) < 500) {
                this.currentTorqueValuePolled = -1000.0;
                return true;
            }
            if (this.currentTorqueValuePolled != torqueFromSensor) {
                this.currentTorqueValuePolled = torqueFromSensor;
                return true;
            }
            return this.hasViewChanged;
        }
        this.logger.trace((Object)"Torque value is null after getData API. Torque will not update");
        return false;
    }

    public String getTorquePolled() {
        return this.getTorque(this.currentTorqueValuePolled);
    }

    private String getTorque(double torque) {
        Data[] rpm = SensorConnectionEnum.EngineRPM.getData(1);
        if (torque < -500.0 || torque > 1547.5) {
            return "--";
        }
        if (Integer.parseInt(this.getRPM(rpm)) < 500) {
            return "--";
        }
        double torqueValueFromSensor = torque * this.viperTorqueMultiplier;
        return Integer.toString(this.rangeControModule(this.converNmToftlb(torqueValueFromSensor), Max_Torque, Min_Torque));
    }

    public void setRPM(Data[] data) {
        this.logger.error((Object)"unimplemented method");
    }

    private String getRPM(Data[] rpm) {
        if (rpm != null) {
            int rpmFromSensor = rpm[0].getIntValues()[0];
            if (rpmFromSensor < 0 || rpmFromSensor > 65534) {
                this.logger.trace((Object)"RPM - out of range. Result = SNA");
                return "--";
            }
            return Integer.toString(this.rangeControModule(rpmFromSensor, Max_RPM, Min_RPM));
        }
        this.logger.trace((Object)"RPM - SNA will be returned. Data[] object was null");
        return "--";
    }

    public boolean pollAndCheckHpChange(String torqueValue) {
        Data[] rpm = SensorConnectionEnum.EngineRPM.getData(1);
        String rpmStringPolled = this.getRPM(rpm);
        String hpStringPolled = this.calculateHorsePower(rpmStringPolled, torqueValue);
        if (!hpStringPolled.equals(this.horsePowerValueString)) {
            this.horsePowerValueString = hpStringPolled;
            return true;
        }
        return this.hasViewChanged;
    }

    public String getHorsePowerPolled() {
        return this.horsePowerValueString;
    }

    public int getHorsePowerImageNumber(String hpValue) {
        return this.getImageNumber(hpValue, Max_HorsePower, Min_HorsePower, 72);
    }

    private String calculateHorsePower(String rpmValue, String torqueValue) {
        if (rpmValue.equals("--") || torqueValue.equals("--")) {
            return "--";
        }
        return Integer.toString(this.rangeControModule(this.getHorsePowerValue(rpmValue, torqueValue), Max_HorsePower, Min_HorsePower));
    }

    public void setViewOrUnitHasChanged(boolean hasViewChanged) {
        this.hasViewChanged = hasViewChanged;
    }

    public boolean pollAndCheckBatteryChange() {
        try {
            Data[] batteryDataArrayPolled = SensorConnectionEnum.battery.getData(1);
            if (batteryDataArrayPolled != null) {
                double batteryValue = batteryDataArrayPolled[0].getDoubleValues()[0];
                if (this.batteryVoltDataPolled != batteryValue) {
                    this.batteryVoltDataPolled = batteryValue;
                    return true;
                }
                return this.hasViewChanged;
            }
            return false;
        }
        catch (Exception e2) {
            this.logger.trace((Object)"", (Throwable)e2);
            return false;
        }
    }
}

