/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

import com.sprint.gskills.unit.CommonUnitEnum;

public class UnitsOfMeasurementEnum
extends CommonUnitEnum {
    public static final int INVALID_UNIT = -1;
    public static final int NO_UNIT = 0;
    public static final int TEMP_UNIT = 1;
    public static final int PRESSURE_UNIT = 2;
    public static final int POWER_UNIT = 3;
    public static final int SPEED_UNIT = 4;
    public static final int TORQUE_UNIT = 5;
    public static final int DISTANCE_UNIT = 6;
    public static final int ALL_UNITS = 7;
    public static final UnitsOfMeasurementEnum INVALID = new UnitsOfMeasurementEnum(-1, "invalid");
    public static final UnitsOfMeasurementEnum NONE = new UnitsOfMeasurementEnum(0, "none");
    public static final UnitsOfMeasurementEnum TEMP = new UnitsOfMeasurementEnum(1, "temp");
    public static final UnitsOfMeasurementEnum PRESSURE = new UnitsOfMeasurementEnum(2, "pressure");
    public static final UnitsOfMeasurementEnum POWER = new UnitsOfMeasurementEnum(3, "power");
    public static final UnitsOfMeasurementEnum SPEED = new UnitsOfMeasurementEnum(4, "speed");
    public static final UnitsOfMeasurementEnum TORQUE = new UnitsOfMeasurementEnum(5, "torque");
    public static final UnitsOfMeasurementEnum DISTANCE = new UnitsOfMeasurementEnum(6, "speed");
    public static final UnitsOfMeasurementEnum ALL = new UnitsOfMeasurementEnum(7, "all");

    private UnitsOfMeasurementEnum(int unitID, String unitName) {
        super(unitID, unitName);
    }
}

