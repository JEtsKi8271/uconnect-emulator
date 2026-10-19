/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

import java.util.HashMap;
import java.util.Map;

public class SpeedUnitEnum {
    private static Map sensorToStringMap = new HashMap();
    private int valueFromSensor;
    public static final SpeedUnitEnum MPH = new SpeedUnitEnum(1, "US_Speed");
    public static final SpeedUnitEnum KMPH = new SpeedUnitEnum(0, "M_Speed");

    private SpeedUnitEnum(int valueFromSensor, String resourceFileMapping) {
        this.valueFromSensor = valueFromSensor;
        sensorToStringMap.put(valueFromSensor, resourceFileMapping);
    }

    public static String getSpeedUnitString(int valueFromSensor) {
        return (String)sensorToStringMap.get(valueFromSensor);
    }

    public int getSensorValue() {
        return this.valueFromSensor;
    }

    public int hashCode() {
        return this.getSensorValue();
    }
}

