/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.unit.CommonUnitEnum;

public class TempUnitEnum
extends CommonUnitEnum {
    public static final TempUnitEnum CELSIUS = TempUnitEnum.buildTempUnitEnum(0, "celsius");
    public static final TempUnitEnum FAHRENHEIT = TempUnitEnum.buildTempUnitEnum(1, "fahrenheit");
    public static final TempUnitEnum INVALID = TempUnitEnum.buildTempUnitEnum(2, "invalid");

    private TempUnitEnum(int unitID, String unitName) {
        super(unitID, unitName);
    }

    private static TempUnitEnum buildTempUnitEnum(int unitID, String unitName) {
        TempUnitEnum tempUnitEnum = new TempUnitEnum(unitID, unitName);
        UnitConversionUtility.getInstance().addToTempUnitEnumMap(tempUnitEnum);
        return tempUnitEnum;
    }
}

