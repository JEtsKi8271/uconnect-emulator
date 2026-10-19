/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

public class VehicleTrimEnum {
    private final String _vehicleTrim;
    private final String _homeImgSuffix;
    public static final VehicleTrimEnum RT = new VehicleTrimEnum("rt");
    public static final VehicleTrimEnum SRT = new VehicleTrimEnum("srt");
    public static final VehicleTrimEnum SRT_PREMIUM = new VehicleTrimEnum("srt", "srt_premium");
    public static final VehicleTrimEnum HELLCAT = new VehicleTrimEnum("hellcat");

    private VehicleTrimEnum(String vehicleTrim) {
        this._vehicleTrim = vehicleTrim;
        this._homeImgSuffix = vehicleTrim;
    }

    private VehicleTrimEnum(String vehicleTrim, String homeImgSuffix) {
        this._vehicleTrim = vehicleTrim;
        this._homeImgSuffix = homeImgSuffix;
    }

    public String toString() {
        return this._vehicleTrim;
    }

    public String getHomeImageSuffix() {
        return this._homeImgSuffix;
    }
}

