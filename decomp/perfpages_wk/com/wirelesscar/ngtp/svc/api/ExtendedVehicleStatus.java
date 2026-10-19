/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class ExtendedVehicleStatus {
    public static final int LIQUIDLEVEL_NORMAL = 0;
    public static final int LIQUIDLEVEL_LOW = 1;
    public static final int LIQUIDLEVEL_VERY_LOW = 2;
    public static final int LIQUIDLEVEL_HIGH = 3;
    public static final int LIQUIDLEVEL_VERY_HIGH = 4;
    public static final int LIQUIDLEVEL_UNKNOWN = 7;
    public static final int PRESSURE_NORMAL = 0;
    public static final int PRESSURE_LOW = 1;
    public static final int PRESSURE_UNKNOWN = 7;
    public static final int SERVICE_STATUS_NORMAL = 0;
    public static final int SERVICE_STATUS_ALMOST_TIME_FOR_SERVICE = 1;
    public static final int SERVICE_STATUS_TIME_FOR_SERVICE = 2;
    public static final int SERVICE_STATUS_TIME_EXCEEDED = 3;
    public static final int SERVICE_STATUS_UNKNOWN = 7;
    public static final int SERVICE_TRIGGER_CALENDAR_TIME = 0;
    public static final int SERVICE_TRIGGER_DISTANCE = 1;
    public static final int SERVICE_TRIGGER_ENGINE_HOURS = 2;
    public static final int SERVICE_TRIGGER_ENGINE_REQ = 3;
    public static final int SERVICE_TRIGGER_UNKNOWN = 7;
    public static final int BULB_LEFT_TURN_ANY = 0;
    public static final int BULB_RIGHT_TURN_ANY = 1;
    public static final int BULB_LOW_BEAM_ANY = 2;
    public static final int BULB_LOW_BEAM_LEFT = 3;
    public static final int BULB_LOW_BEAM_RIGHT = 4;
    public static final int BULB_HIGH_BEAM_ANY = 5;
    public static final int BULB_HIGH_BEAM_LEFT = 6;
    public static final int BULB_HIGH_BEAM_RIGHT = 7;
    public static final int BULB_FOG_FRONT_ANY = 8;
    public static final int BULB_FOG_REAR_ANY = 9;
    public static final int BULB_STOP_ANY = 10;
    public static final int BULB_POSITION_ANY = 11;
    public static final int BULB_DAY_RUNNING_ANY = 12;
    public static final int BULB_TRAILER_TURN_ANY = 13;
    public static final int BULB_TRAILER_TURN_LEFT_ANY = 14;
    public static final int BULB_TRAILER_TURN_RIGHT_ANY = 15;
    public static final int BULB_TRAILER_STOP_ANY = 16;
    public static final int BULB_TRAILER_EL_FAILURE = 17;
    public static final int BULB_MULTIPLE = 31;
    public static final int IGNITION_KEY_LOCK = 0;
    public static final int IGNITION_KEY_OFF = 1;
    public static final int IGNITION_KEY_ACCESSORY = 2;
    public static final int IGNITION_KEY_OFF_ACCESSORY = 3;
    public static final int IGNITION_KEY_RUN = 4;
    public static final int IGNITION_KEY_START = 5;
    public static final int IGNITION_KEY_UNKNOWN = 7;
    private Integer a;
    private Integer b;
    private Integer c;
    private Integer d;
    private Integer e;
    private Integer f;
    private Integer g;
    private int h = 7;
    private int i = 7;
    private int j = 7;
    private int k = 7;
    private int l = 7;
    private int m = 7;
    private int n = 7;
    private int o = 7;
    private int[] p;
    private Integer q;

    public Integer getExternalTemp() {
        return this.a;
    }

    public void setExternalTemp(Integer n2) {
        this.a = n2;
    }

    public Integer getInternalTemp() {
        return this.b;
    }

    public void setInternalTemp(Integer n2) {
        this.b = n2;
    }

    public Integer getEngineHoursToService() {
        return this.c;
    }

    public void setEngineHoursToService(Integer n2) {
        this.c = n2;
    }

    public Integer getKilometersToService() {
        return this.d;
    }

    public void setKilometersToService(Integer n2) {
        this.d = n2;
    }

    public Integer getMonthsToService() {
        return this.e;
    }

    public void setMonthsToService(Integer n2) {
        this.e = n2;
    }

    public Integer getEchoGradePropulsion() {
        return this.f;
    }

    public void setEchoGradePropulsion(Integer n2) {
        this.f = n2;
    }

    public Integer getEchoGradeBraking() {
        return this.g;
    }

    public void setEchoGradeBraking(Integer n2) {
        this.g = n2;
    }

    public int getBrakeFluidWarn() {
        return this.h;
    }

    public void setBrakeFluidWarn(int n2) {
        this.h = n2;
    }

    public int getEngCoolantLevelWarn() {
        return this.i;
    }

    public void setEngCoolantLevelWarn(int n2) {
        this.i = n2;
    }

    public int getOilLevelWarn() {
        return this.j;
    }

    public void setOilLevelWarn(int n2) {
        this.j = n2;
    }

    public int getWasherFluidWarn() {
        return this.k;
    }

    public void setWasherFluidWarn(int n2) {
        this.k = n2;
    }

    public int getOilPressureWarn() {
        return this.m;
    }

    public void setOilPressureWarn(int n2) {
        this.m = n2;
    }

    public int getServiceWarningStatus() {
        return this.n;
    }

    public void setServiceWarningStatus(int n2) {
        this.n = n2;
    }

    public int getServiceWarningTrigger() {
        return this.o;
    }

    public void setServiceWarningTrigger(int n2) {
        this.o = n2;
    }

    public int[] getBulbFailures() {
        return this.p;
    }

    public void setBulbFailures(int[] nArray) {
        this.p = nArray;
    }

    public Integer getIgnitionOffMeter() {
        return this.q;
    }

    public void setIgnitionOffMeter(Integer n2) {
        this.q = n2;
    }

    public int getIgnitionKeyState() {
        return this.l;
    }

    public void setIgnitionKeyState(int n2) {
        this.l = n2;
    }
}

