/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.DoorStatus;
import com.wirelesscar.ngtp.svc.api.ElectricVehicleStatus;
import com.wirelesscar.ngtp.svc.api.ExtendedVehicleStatus;
import com.wirelesscar.ngtp.svc.api.TyreStatus;
import com.wirelesscar.ngtp.svc.api.WindowStatus;
import java.util.Date;

public class VehicleStatus {
    public static final int SRS_NO_INFO = 0;
    public static final int SRS_NOT_DEPLOYED = 1;
    public static final int SRS_DEPLOYED = 2;
    public static final int ALARM_NO_INFO = 0;
    public static final int ALARM_OFF = 1;
    public static final int ALARM_ARMED = 2;
    public static final int ALARM_TRIG = 3;
    public static final int ALARM_TRIG_MMS = 4;
    public static final int ALARM_TRIG_IS = 5;
    public static final int ALARM_SENSOR_FAULT = 7;
    private Float a;
    private Float b;
    private Integer c;
    private TyreStatus d;
    private int e = 3;
    private int f = 3;
    private int g = 3;
    private int h = 3;
    private int i;
    private int j;
    private int k = 3;
    private Integer l;
    private Integer m;
    private Integer n;
    private WindowStatus o;
    private DoorStatus p;
    private int q = 3;
    private int r = 3;
    private Float s;
    private Integer t;
    private Integer u;
    private Integer v;
    private Integer w;
    private int x = 3;
    private Date y;
    private ExtendedVehicleStatus z;
    private ElectricVehicleStatus A;

    public Float getBatteryVoltage() {
        return this.a;
    }

    public void setBatteryVoltage(Float f2) {
        this.a = f2;
    }

    public Float getFuelAmount() {
        return this.b;
    }

    public void setFuelAmount(Float f2) {
        this.b = f2;
    }

    public Integer getOdometer() {
        return this.c;
    }

    public void setOdometer(Integer n2) {
        this.c = n2;
    }

    public Integer getTripMeter1() {
        return this.m;
    }

    public void setTripMeter1(Integer n2) {
        this.m = n2;
    }

    public Integer getTripMeter2() {
        return this.n;
    }

    public void setTripMeter2(Integer n2) {
        this.n = n2;
    }

    public Integer getBatteryStatus() {
        return this.l;
    }

    public void setBatteryStatus(Integer n2) {
        this.l = n2;
    }

    public TyreStatus getTyreStatus() {
        return this.d;
    }

    public void setTyreStatus(TyreStatus tyreStatus) {
        this.d = tyreStatus;
    }

    public int getSrs() {
        return this.i;
    }

    public void setSrs(int n2) {
        this.i = n2;
    }

    public int getTheftAlarm() {
        return this.j;
    }

    public void setTheftAlarm(int n2) {
        this.j = n2;
    }

    public WindowStatus getWindowStatus() {
        return this.o;
    }

    public void setWindowStatus(WindowStatus windowStatus) {
        this.o = windowStatus;
    }

    public DoorStatus getDoorStatus() {
        return this.p;
    }

    public void setDoorStatus(DoorStatus doorStatus) {
        this.p = doorStatus;
    }

    public Float getAvgFuelConsumption() {
        return this.s;
    }

    public void setAvgFuelConsumption(Float f2) {
        this.s = f2;
    }

    public Integer getAvgSpeedKmph() {
        return this.t;
    }

    public void setAvgSpeedKmph(Integer n2) {
        this.t = n2;
    }

    public Integer getDistToEmptyFuel() {
        return this.u;
    }

    public void setDistToEmptyFuel(Integer n2) {
        this.u = n2;
    }

    public Integer getFuelLevel() {
        return this.v;
    }

    public void setFuelLevel(Integer n2) {
        this.v = n2;
    }

    public Integer getEngineCoolantTemp() {
        return this.w;
    }

    public void setEngineCoolantTemp(Integer n2) {
        this.w = n2;
    }

    public int getMovingFlag() {
        return this.e;
    }

    public void setMovingFlag(int n2) {
        this.e = n2;
    }

    public int getIgnitionOnStatus() {
        return this.f;
    }

    public void setIgnitionOnStatus(int n2) {
        this.f = n2;
    }

    public int getIgnitionKeyInStatus() {
        return this.g;
    }

    public void setIgnitionKeyInStatus(int n2) {
        this.g = n2;
    }

    public int getEngineOnStatus() {
        return this.h;
    }

    public void setEngineOnStatus(int n2) {
        this.h = n2;
    }

    public int getPanicAlarmTriggered() {
        return this.k;
    }

    public void setPanicAlarmTriggered(int n2) {
        this.k = n2;
    }

    public int getCabOpenStatus() {
        return this.q;
    }

    public void setCabOpenStatus(int n2) {
        this.q = n2;
    }

    public int getSunroofOpenStatus() {
        return this.r;
    }

    public void setSunroofOpenStatus(int n2) {
        this.r = n2;
    }

    public int getHeadLightOn() {
        return this.x;
    }

    public void setHeadLightOn(int n2) {
        this.x = n2;
    }

    public Date getVehicleDateTime() {
        return this.y;
    }

    public void setVehicleDateTime(Date date) {
        this.y = date;
    }

    public ExtendedVehicleStatus getExtendedVehicleStatus() {
        return this.z;
    }

    public void setExtendedVehicleStatus(ExtendedVehicleStatus extendedVehicleStatus) {
        this.z = extendedVehicleStatus;
    }

    public ElectricVehicleStatus getElectricVehicleStatus() {
        return this.A;
    }

    public void setElectricVehicleStatus(ElectricVehicleStatus electricVehicleStatus) {
        this.A = electricVehicleStatus;
    }
}

