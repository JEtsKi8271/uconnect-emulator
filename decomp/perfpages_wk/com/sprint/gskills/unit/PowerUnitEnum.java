/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.unit.CommonUnitEnum;

public class PowerUnitEnum
extends CommonUnitEnum {
    public static final PowerUnitEnum KW = PowerUnitEnum.buildPowerUnitEnum(0, "kw");
    public static final PowerUnitEnum HP_UK = PowerUnitEnum.buildPowerUnitEnum(1, "hp_uk");
    public static final PowerUnitEnum HP_US = PowerUnitEnum.buildPowerUnitEnum(2, "hp_us");
    public static final PowerUnitEnum INVALID = PowerUnitEnum.buildPowerUnitEnum(3, "invalid");

    private PowerUnitEnum(int unitID, String unitName) {
        super(unitID, unitName);
    }

    private static PowerUnitEnum buildPowerUnitEnum(int unitID, String unitName) {
        PowerUnitEnum powerUnitEnum = new PowerUnitEnum(unitID, unitName);
        UnitConversionUtility.getInstance().addToPowerUnitEnumMap(powerUnitEnum);
        return powerUnitEnum;
    }
}

