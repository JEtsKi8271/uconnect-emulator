/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class ElectricVehicleStatus {
    public static final int CHARGETYPE_UNKNOWN = 0;
    public static final int CHARGETYPE_110V = 1;
    public static final int CHARGETYPE_240V = 2;
    public static final int CHARGETYPE_LEVEL3 = 3;
    private String a;
    private int b = 3;
    private int c = 3;
    private int d = 3;
    private Integer e;
    private Integer f;
    private Integer g;
    private Float h;
    private Float i;
    private Float j;
    private Float k;
    private int l;

    public Integer getStateOfCharge() {
        return this.f;
    }

    public void setStateOfCharge(Integer n2) {
        this.f = n2;
    }

    public Integer getDistanceToEmpty() {
        return this.e;
    }

    public void setDistanceToEmpty(Integer n2) {
        this.e = n2;
    }

    public String getChargingProfile() {
        return this.a;
    }

    public void setChargingProfile(String string) {
        this.a = string;
    }

    public int getIsPreconditioning() {
        return this.b;
    }

    public void setIsPreconditioning(int n2) {
        this.b = n2;
    }

    public int getIsCharging() {
        return this.c;
    }

    public void setIsCharging(int n2) {
        this.c = n2;
    }

    public int getIsPluggedIn() {
        return this.d;
    }

    public void setIsPluggedIn(int n2) {
        this.d = n2;
    }

    public Integer getTimeToFullyCharged() {
        return this.g;
    }

    public void setTimeToFullyCharged(Integer n2) {
        this.g = n2;
    }

    public int getChargeType() {
        return this.l;
    }

    public void setChargeType(int n2) {
        this.l = n2;
    }

    public Float getTrip1AverageEnergyUsed() {
        return this.h;
    }

    public void setTrip1AverageEnergyUsed(Float f2) {
        this.h = f2;
    }

    public Float getTrip2AverageEnergyUsed() {
        return this.i;
    }

    public void setTrip2AverageEnergyUsed(Float f2) {
        this.i = f2;
    }

    public Float getTotalAverageEnergyUsed() {
        return this.j;
    }

    public void setTotalAverageEnergyUsed(Float f2) {
        this.j = f2;
    }

    public Float getIgnitionOffAverageEnergyUsed() {
        return this.k;
    }

    public void setIgnitionOffAverageEnergyUsed(Float f2) {
        this.k = f2;
    }
}

