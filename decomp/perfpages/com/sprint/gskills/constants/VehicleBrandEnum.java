/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

public class VehicleBrandEnum {
    private final int _vehicleBrand;
    private final String _vehicleBrandName;
    public static final VehicleBrandEnum CHRYSLER = new VehicleBrandEnum(1, "chrysler");
    public static final VehicleBrandEnum DODGE = new VehicleBrandEnum(2, "dodge");
    public static final VehicleBrandEnum SRT = new VehicleBrandEnum(3, "srt");
    public static final VehicleBrandEnum JEEP = new VehicleBrandEnum(4, "jeep");

    private VehicleBrandEnum(int vehicleBrand, String vehicleBrandName) {
        this._vehicleBrand = vehicleBrand;
        this._vehicleBrandName = vehicleBrandName;
    }

    public String toString() {
        return this._vehicleBrandName;
    }

    public int getBrand() {
        return this._vehicleBrand;
    }
}

