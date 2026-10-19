/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

import com.sprint.gskills.constants.TransmissionTypeEnum;
import com.sprint.gskills.constants.VehicleLineEnum;
import java.util.HashMap;

public class GSkillsBrandConstants {
    public static final int ENGINE_SUPER = 3;
    public static final int SRT_PRESENT = 1;
    public static final String ENGINE_36L = "3.6";
    private static HashMap<Integer, VehicleLineEnum> _mapVehicleLineEnums = new HashMap();
    private static HashMap<Integer, TransmissionTypeEnum> _mapTransTypeEnums = new HashMap();

    public static VehicleLineEnum getVehicleLineEnum(int vehicleLine) {
        VehicleLineEnum vehLine = VehicleLineEnum.UNSUPPORTED;
        if (_mapVehicleLineEnums.containsKey(vehicleLine)) {
            vehLine = _mapVehicleLineEnums.get(vehicleLine);
        }
        return vehLine;
    }

    public static void addToVehicleLineEnumMap(VehicleLineEnum vehicleLineEnum) {
        _mapVehicleLineEnums.put(vehicleLineEnum.getVehicleLine(), vehicleLineEnum);
    }

    public static TransmissionTypeEnum getTransTypeEnum(int transType) {
        return _mapTransTypeEnums.get(transType);
    }

    public static void addToTransTypeEnumMap(TransmissionTypeEnum transTypeEnum) {
        _mapTransTypeEnums.put(transTypeEnum.getTransType(), transTypeEnum);
    }
}

