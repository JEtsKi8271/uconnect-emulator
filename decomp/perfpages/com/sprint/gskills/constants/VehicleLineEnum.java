/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

import com.sprint.gskills.constants.GSkillsBrandConstants;

public class VehicleLineEnum {
    private final int _vehicleLine;
    private final String _vehicleLineName;
    private final String _vehicleDisplayName;
    public static final VehicleLineEnum UNKNOWN = VehicleLineEnum.buildVehicleLineEnum(-1, "unknown", "Unknown");
    public static final VehicleLineEnum WK = VehicleLineEnum.buildVehicleLineEnum(1, "wk", "Jeep");
    public static final VehicleLineEnum LX = VehicleLineEnum.buildVehicleLineEnum(2, "lx", "300");
    public static final VehicleLineEnum LD = VehicleLineEnum.buildVehicleLineEnum(41, "ld", "Charger");
    public static final VehicleLineEnum ZD = VehicleLineEnum.buildVehicleLineEnum(43, "zd", "Viper");
    public static final VehicleLineEnum LA = VehicleLineEnum.buildVehicleLineEnum(44, "la", "Challenger");

    private VehicleLineEnum(int vehicleLine, String vehicleLineName, String vehicleDisplayName) {
        this._vehicleLine = vehicleLine;
        this._vehicleLineName = vehicleLineName;
        this._vehicleDisplayName = vehicleDisplayName;
    }

    private static VehicleLineEnum buildVehicleLineEnum(int vehicleLine, String vehicleLineName, String vehicleDisplayName) {
        VehicleLineEnum vehicleLineEnum = new VehicleLineEnum(vehicleLine, vehicleLineName, vehicleDisplayName);
        GSkillsBrandConstants.addToVehicleLineEnumMap(vehicleLineEnum);
        return vehicleLineEnum;
    }

    public int getVehicleLine() {
        return this._vehicleLine;
    }

    public String toString() {
        return this._vehicleLineName;
    }

    public String getDisplayName() {
        return this._vehicleDisplayName;
    }
}

