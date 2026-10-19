/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 */
package com.sprint.gskills.model.sensordata;

import konax.sensors.Data;

public interface CommonSensorModel {
    public void setCurrentSpeed(Data[] var1);

    public boolean hasSpeedChangedPolling();

    public String getCurrentSpeedPolled();

    public boolean hasOilPressureChanged();

    public void setOilPressure(Data[] var1);

    public int getOilPressureImageNumber(boolean var1);

    public String getOilPressure();

    public boolean hasGearChanged();

    public void setGear(Data[] var1);

    public String getGear();

    public boolean hasOilTempChanged();

    public void setOilTemp(Data[] var1);

    public int getOilTempImageNumber();

    public String getOilTemp();

    public boolean hasBatteryVoltageChanged();

    public void setBatteryVolt(Data[] var1);

    public int getBatteryVoltImageNumber();

    public String getBattery();

    public void setVehAccelData(Data[] var1);

    public String getTopGforceValue();

    public String getRightGforceValue();

    public String getBottomGforceValue();

    public String getLeftGforceValue();

    public int getGforceCarImageNumber();

    public boolean pollAndCheckSteeringWheelAngleChanged();

    public void setSteeringAngle(Data[] var1);

    public String getSteeringAngle();

    public boolean hasEngineCoolantTempChanged();

    public void setEngineCoolantTemp(Data[] var1);

    public int getEngineCoolantTempImageNumber();

    public String getEngineCoolantTemp();

    public boolean hasIntakeAirTempChanged();

    public void setIntakeAirTemp(Data[] var1);

    public int getIntakeAirTempImageNumber();

    public String getIntakeAirTemp();

    public boolean hasTransTempChanged();

    public void setTransTemp(Data[] var1);

    public int getTransTempImageNumber();

    public String getTransTemp();

    public void setTorque(Data[] var1);

    public boolean PollandCheckTorqueDataChange();

    public String getTorquePolled();

    public int getTorqueImageNumber(String var1);

    public void setRPM(Data[] var1);

    public boolean pollAndCheckHpChange(String var1);

    public String getHorsePowerPolled();

    public int getHorsePowerImageNumber(String var1);

    public void setSpeedUnit(Data[] var1);

    public boolean hasSpeedUnitChanged();

    public String getSpeedUnit();

    public void setViewOrUnitHasChanged(boolean var1);

    public String getGForceFrontRearImageName();

    public String getGForceLeftRightImageName();

    public boolean pollAndCheckOilPressureChange();

    public String getOilPressurePolled();

    public int getOilPressureImageNumber(String var1, boolean var2);

    public boolean pollAndCheckVehAccelChange();

    public int getOilPressurePolledImageNumber(boolean var1);

    public boolean pollAndCheckBatteryChange();

    public String getBatteryPolled();

    public int getBatteryVoltPolledImageNumber();
}

