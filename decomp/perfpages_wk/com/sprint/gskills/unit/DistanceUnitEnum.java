/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.unit.CommonUnitEnum;

public class DistanceUnitEnum
extends CommonUnitEnum {
    public static final DistanceUnitEnum KM = DistanceUnitEnum.buildDistanceUnitEnum(0, "km");
    public static final DistanceUnitEnum MILES = DistanceUnitEnum.buildDistanceUnitEnum(1, "miles");
    public static final DistanceUnitEnum INVALID = DistanceUnitEnum.buildDistanceUnitEnum(2, "invalid");

    private DistanceUnitEnum(int unitID, String unitName) {
        super(unitID, unitName);
    }

    private static DistanceUnitEnum buildDistanceUnitEnum(int unitID, String unitName) {
        DistanceUnitEnum distanceUnitEnum = new DistanceUnitEnum(unitID, unitName);
        UnitConversionUtility.getInstance().addToDistanceUnitEnumMap(distanceUnitEnum);
        return distanceUnitEnum;
    }
}

