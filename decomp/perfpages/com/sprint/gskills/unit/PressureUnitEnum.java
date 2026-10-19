/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.unit.CommonUnitEnum;

public class PressureUnitEnum
extends CommonUnitEnum {
    private final String _resKeyName;
    public static final PressureUnitEnum KPA = PressureUnitEnum.buildPressureUnitEnum(0, "kPa", "unit_M_BoostPressure_PU_Zero");
    public static final PressureUnitEnum BAR = PressureUnitEnum.buildPressureUnitEnum(1, "bar", "unit_M_BoostPressure_PU_One");
    public static final PressureUnitEnum PSI = PressureUnitEnum.buildPressureUnitEnum(2, "psi", "unit_US_OilPressure");
    public static final PressureUnitEnum INHG = PressureUnitEnum.buildPressureUnitEnum(3, "in.Hg", "unit_US_BoostPressure");
    public static final PressureUnitEnum INVALID = PressureUnitEnum.buildPressureUnitEnum(4, "invalid", "unit_M_BoostPressure_PU_Zero");

    private PressureUnitEnum(int unitID, String unitName, String resKeyName) {
        super(unitID, unitName);
        this._resKeyName = resKeyName;
    }

    private static PressureUnitEnum buildPressureUnitEnum(int unitID, String unitName, String resKeyName) {
        PressureUnitEnum pressureUnitEnum = new PressureUnitEnum(unitID, unitName, resKeyName);
        UnitConversionUtility.getInstance().addToPressureUnitEnumMap(pressureUnitEnum);
        return pressureUnitEnum;
    }

    public String getResKey() {
        return this._resKeyName;
    }
}

