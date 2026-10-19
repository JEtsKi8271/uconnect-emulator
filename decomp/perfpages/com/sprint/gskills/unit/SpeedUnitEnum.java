/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.unit.CommonUnitEnum;

public class SpeedUnitEnum
extends CommonUnitEnum {
    private final String _resKeyName;
    public static final SpeedUnitEnum KMPH = SpeedUnitEnum.buildSpeedUnitEnum(0, "kph", "M_Speed");
    public static final SpeedUnitEnum MPH = SpeedUnitEnum.buildSpeedUnitEnum(1, "mph", "US_Speed");
    public static final SpeedUnitEnum INVALID = SpeedUnitEnum.buildSpeedUnitEnum(2, "invalid", "M_Speed");

    private SpeedUnitEnum(int unitID, String unitName, String resKeyName) {
        super(unitID, unitName);
        this._resKeyName = resKeyName;
    }

    private static SpeedUnitEnum buildSpeedUnitEnum(int unitID, String unitName, String resKeyName) {
        SpeedUnitEnum speedUnitEnum = new SpeedUnitEnum(unitID, unitName, resKeyName);
        UnitConversionUtility.getInstance().addToSpeedUnitEnumMap(speedUnitEnum);
        return speedUnitEnum;
    }

    public String getResKey() {
        return this._resKeyName;
    }
}

