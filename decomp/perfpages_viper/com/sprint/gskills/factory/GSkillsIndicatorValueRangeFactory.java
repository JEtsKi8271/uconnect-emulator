/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.factory.ValueRangePropertiesFactory;

public class GSkillsIndicatorValueRangeFactory {
    private static final String KEY_MAX_RPM = "Max_RPM";
    private static final String KEY_MIN_RPM = "Min_RPM";
    private static final String KEY_MAX_TORQUE = "Max_Torque";
    private static final String KEY_MIN_TORQUE = "Min_Torque";
    private static final String KEY_MAX_HORSEPOWER = "Max_HorsePower";
    private static final String KEY_MIN_HORSEPOWER = "Min_HorsePower";
    private static final String KEY_MAX_OILTEMP = "Max_OilTemp";
    private static final String KEY_MIN_OILTEMP = "Min_OilTemp";
    private static final String KEY_MAX_BATTERY = "Max_Battery";
    private static final String KEY_MIN_BATTERY = "Min_Battery";
    private static final String KEY_MAX_OILPRESSURE = "Max_OilPressure";
    private static final String KEY_MIN_OILPRESSURE = "Min_OilPressure";
    private static final String KEY_MAX_COOLANTTEMP = "Max_CoolantTemp";
    private static final String KEY_MIN_COOLANTTEMP = "Min_CoolantTemp";
    private static final String KEY_MAX_TRANSTEMP = "Max_TransTemp";
    private static final String KEY_MIN_TRANSTEMP = "Min_TransTemp";
    private static final String KEY_MAX_INTAKEAIRTEMP = "Max_IntakeAirTemp";
    private static final String KEY_MIN_INTAKEAIRTEMP = "Min_IntakeAirTemp";
    private static final String KEY_MAX_STEERINGWHEELANGLE = "Max_SteeringWheelAngle";
    private static final String KEY_MIN_STEERINGWHEELANGLE = "Min_SteeringWheelAngle";
    private static final String KEY_MAX_GFORCES = "Max_Gforces_forImage";
    private static final String KEY_MIN_GFORCES = "Min_Gforces_forImage";
    private static final String KEY_MAX_GFORCES_VALUE = "Max_Gforces_Value";

    public static double getMaxRPM() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_RPM);
    }

    public static double getMinRPM() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_RPM);
    }

    public static double getMaxTorque() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_TORQUE);
    }

    public static double getMinTorque() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_TORQUE);
    }

    public static double getMaxHorsePower() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_HORSEPOWER);
    }

    public static double getMinHorsePower() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_HORSEPOWER);
    }

    public static double getMaxOilTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_OILTEMP);
    }

    public static double getMinOilTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_OILTEMP);
    }

    public static double getMaxBattery() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_BATTERY);
    }

    public static double getMinBattery() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_BATTERY);
    }

    public static double getMaxOilPressure() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_OILPRESSURE);
    }

    public static double getMinOilPressure() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_OILPRESSURE);
    }

    public static double getMaxCoolantTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_COOLANTTEMP);
    }

    public static double getMinCoolantTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_COOLANTTEMP);
    }

    public static double getMaxTransTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_TRANSTEMP);
    }

    public static double getMinTransTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_TRANSTEMP);
    }

    public static double getMaxIntakeAirTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_INTAKEAIRTEMP);
    }

    public static double getMinIntakeAirTemp() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_INTAKEAIRTEMP);
    }

    public static double getMaxSteeringWheelAngle() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_STEERINGWHEELANGLE);
    }

    public static double getMinSteeringWheelAngle() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_STEERINGWHEELANGLE);
    }

    public static double getMaxGforces() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_GFORCES);
    }

    public static double getMinGforces() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MIN_GFORCES);
    }

    public static double getMaxGforceValue() {
        return ValueRangePropertiesFactory.getValueByKey(KEY_MAX_GFORCES_VALUE);
    }
}

