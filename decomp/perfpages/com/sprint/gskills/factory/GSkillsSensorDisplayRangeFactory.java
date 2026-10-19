/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsProperties;
import com.sprint.gskills.view.common.GSkillsStateManager;

public class GSkillsSensorDisplayRangeFactory {
    private static final String KEY_MAX_RPM = "Max_RPM";
    private static final String KEY_MIN_RPM = "Min_RPM";
    private static final String KEY_MAX_TORQUE = "Max_Torque";
    private static final String KEY_MIN_TORQUE = "Min_Torque";
    private static final String KEY_MAX_TORQUE_HELLCAT = "Max_Torque_Hellcat";
    private static final String KEY_MIN_TORQUE_HELLCAT = "Min_Torque_Hellcat";
    private static final String KEY_MAX_HORSEPOWER = "Max_HorsePower";
    private static final String KEY_MIN_HORSEPOWER = "Min_HorsePower";
    private static final String KEY_MAX_HORSEPOWER_HELLCAT = "Max_HorsePower_Hellcat";
    private static final String KEY_MIN_HORSEPOWER_HELLCAT = "Min_HorsePower_Hellcat";
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
    private static final String KEY_MAX_IC_COOLANTTEMP = "Max_IC_CoolantTemp";
    private static final String KEY_MIN_IC_COOLANTTEMP = "Min_IC_CoolantTemp";
    private static final String KEY_MAX_STEERINGWHEELANGLE = "Max_SteeringWheelAngle";
    private static final String KEY_MIN_STEERINGWHEELANGLE = "Min_SteeringWheelAngle";
    private static final String KEY_MAX_GFORCES = "Max_Gforces_forImage";
    private static final String KEY_MIN_GFORCES = "Min_Gforces_forImage";
    private static final String KEY_MAX_GFORCES_VALUE = "Max_Gforces_Value";
    private static final String KEY_MAX_PEAKVALUES = "Max_PeakValues";
    private static final String KEY_MIN_PEAKVALUES = "Min_PeakValues";
    private static final String KEY_MAX_BOOSTPRESSURE = "Max_BoostPressure";
    private static final String KEY_MIN_BOOSTPRESSURE = "Min_BoostPressure";
    private static final String KEY_MAX_AIR_FUEL_RATIO = "Max_AirFuelRatio";
    private static final String KEY_MIN_AIR_FUEL_RATIO = "Min_AirFuelRatio";
    private static final String KEY_MAX_SPEED = "Max_Speed";
    private static final String KEY_MIN_SPEED = "Min_Speed";

    public static double getMaxRPM() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_RPM);
    }

    public static double getMinRPM() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_RPM);
    }

    public static double getMaxTorque() {
        if (VehicleTrimEnum.HELLCAT == GSkillsStateManager.getInstance().getVehicleTrim()) {
            return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_TORQUE_HELLCAT);
        }
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_TORQUE);
    }

    public static double getMinTorque() {
        if (VehicleTrimEnum.HELLCAT == GSkillsStateManager.getInstance().getVehicleTrim()) {
            return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_TORQUE_HELLCAT);
        }
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_TORQUE);
    }

    public static double getMaxHorsePower() {
        if (VehicleTrimEnum.HELLCAT == GSkillsStateManager.getInstance().getVehicleTrim()) {
            return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_HORSEPOWER_HELLCAT);
        }
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_HORSEPOWER);
    }

    public static double getMinHorsePower() {
        if (VehicleTrimEnum.HELLCAT == GSkillsStateManager.getInstance().getVehicleTrim()) {
            return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_HORSEPOWER_HELLCAT);
        }
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_HORSEPOWER);
    }

    public static double getMaxOilTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_OILTEMP);
    }

    public static double getMinOilTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_OILTEMP);
    }

    public static double getMaxBattery() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_BATTERY);
    }

    public static double getMinBattery() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_BATTERY);
    }

    public static double getMaxOilPressure() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_OILPRESSURE);
    }

    public static double getMinOilPressure() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_OILPRESSURE);
    }

    public static double getMaxBoostPressure() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_BOOSTPRESSURE);
    }

    public static double getMinBoostPressure() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_BOOSTPRESSURE);
    }

    public static double getMaxCoolantTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_COOLANTTEMP);
    }

    public static double getMinCoolantTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_COOLANTTEMP);
    }

    public static double getMaxTransTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_TRANSTEMP);
    }

    public static double getMinTransTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_TRANSTEMP);
    }

    public static double getMaxIntakeAirTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_INTAKEAIRTEMP);
    }

    public static double getMinIntakeAirTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_INTAKEAIRTEMP);
    }

    public static double getMaxIcCoolantTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_IC_COOLANTTEMP);
    }

    public static double getMinIcCoolantTemp() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_IC_COOLANTTEMP);
    }

    public static double getMaxSteeringWheelAngle() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_STEERINGWHEELANGLE);
    }

    public static double getMinSteeringWheelAngle() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_STEERINGWHEELANGLE);
    }

    public static double getMaxGForceImages() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_GFORCES);
    }

    public static double getMinGForceImages() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_GFORCES);
    }

    public static double getMaxGForceValue() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_GFORCES_VALUE);
    }

    public static double getMaxPeakValues() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_PEAKVALUES);
    }

    public static double getMinPeakValues() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_PEAKVALUES);
    }

    public static double getMaxAirFuelRatio() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_AIR_FUEL_RATIO);
    }

    public static double getMinAirFuelRatio() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_AIR_FUEL_RATIO);
    }

    public static double getMaxSpeed() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MAX_SPEED);
    }

    public static double getMinSpeed() {
        return GSkillsProperties.getSensorDisplayRangeByKey(KEY_MIN_SPEED);
    }
}

