/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.unit.CommonUnitEnum;

public class TorqueUnitEnum
extends CommonUnitEnum {
    public static final TorqueUnitEnum NM = TorqueUnitEnum.buildTorqueUnitEnum(0, "nm");
    public static final TorqueUnitEnum FT_LB = TorqueUnitEnum.buildTorqueUnitEnum(1, "ft-lb");
    public static final TorqueUnitEnum INVALID = TorqueUnitEnum.buildTorqueUnitEnum(2, "invalid");

    private TorqueUnitEnum(int unitID, String unitName) {
        super(unitID, unitName);
    }

    private static TorqueUnitEnum buildTorqueUnitEnum(int unitID, String unitName) {
        TorqueUnitEnum torqueUnitEnum = new TorqueUnitEnum(unitID, unitName);
        UnitConversionUtility.getInstance().addToTorqueUnitEnumMap(torqueUnitEnum);
        return torqueUnitEnum;
    }
}

