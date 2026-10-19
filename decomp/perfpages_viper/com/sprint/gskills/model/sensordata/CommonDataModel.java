/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.model.sensordata;

import com.sprint.gskills.constants.SpeedUnitEnum;
import com.sprint.gskills.factory.GSkillsIndicatorValueRangeFactory;
import com.sprint.gskills.factory.ValueRangePropertiesFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.text.DecimalFormat;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public abstract class CommonDataModel {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    protected static double Max_RPM;
    protected static double Min_RPM;
    protected static double Max_Torque;
    protected static double Min_Torque;
    protected static double Max_HorsePower;
    protected static double Min_HorsePower;
    protected static double Max_OilTemp;
    protected static double Min_OilTemp;
    protected static double Max_Battery;
    protected static double Min_Battery;
    protected static double Max_OilPress;
    protected static double Min_OilPress;
    protected static double Max_CoolantTemp;
    protected static double Min_CoolantTemp;
    protected static double Max_TransTemp;
    protected static double Min_TransTemp;
    protected static double Max_IntakeAirTemp;
    protected static double Min_IntakeAirTemp;
    protected static double Max_SteeringWheelAngle;
    protected static double Min_SteeringWheelAngle;
    protected static double Max_GForce;
    protected static double Min_GForce;
    protected static double Max_GForce_Value;
    protected int maxSpeed;
    protected int minSpeed;
    protected final int NUMBER_OF_GAUGES_IMAGES = 17;
    protected final int NUMBER_OF_HP_IMAGES = 72;
    protected final String SNAString = "--";
    protected static GSkillsStateManager stateManager;

    public CommonDataModel() {
        this.setSpeedValueRange();
    }

    private void setSpeedValueRange() {
        this.maxSpeed = ValueRangePropertiesFactory.getRangeValueByKey("max_" + SpeedUnitEnum.getSpeedUnitString(SpeedUnitEnum.MPH.getSensorValue()));
    }

    protected int getHorsePowerValue(String rpmValue, String torqueValue) {
        double horsePower = 0.0;
        double rpm = Double.parseDouble(rpmValue);
        double torque = Double.parseDouble(torqueValue);
        horsePower = stateManager.getCurrentUnit() == 0 ? torque * rpm / 5252.0 : torque * rpm / 9549.0;
        return (int)horsePower;
    }

    protected int temperatureConverter(int oilTempFromSensor) {
        double dataValue = oilTempFromSensor;
        if (stateManager.getCurrentUnit() == 0) {
            dataValue = dataValue * 1.8 + 32.0;
        }
        return (int)dataValue;
    }

    protected int pressureConverter(int oilPressureFromSensor) {
        double convertedOilPressure = 0.0;
        convertedOilPressure = stateManager.getCurrentUnit() == 0 ? (double)oilPressureFromSensor * 0.145037738 : (double)oilPressureFromSensor;
        return (int)convertedOilPressure;
    }

    protected int converNmToftlb(double torquevalue) {
        double dataValue = torquevalue;
        if (stateManager.getCurrentUnit() == 0) {
            dataValue = torquevalue * 0.7376;
        }
        return (int)dataValue;
    }

    protected int rangeControModule(int value, double maxValue, double minValue) {
        if ((double)value < minValue) {
            return (int)minValue;
        }
        if ((double)value > maxValue) {
            return (int)maxValue;
        }
        return value;
    }

    protected double rangeControModule(double value, double maxValue, double minValue) {
        if (value <= minValue) {
            return minValue;
        }
        if (value >= maxValue) {
            return maxValue;
        }
        return value;
    }

    protected String formatGforceValue(double doubleValue) {
        DecimalFormat formatter = doubleValue < 1.0 ? new DecimalFormat("0.00") : new DecimalFormat("0.00");
        if (doubleValue == Max_GForce_Value) {
            return Double.toString(Max_GForce_Value - 0.01);
        }
        return formatter.format(doubleValue);
    }

    protected String rangeSteeringAngle(double angleValue, double max, double min) {
        double oldValue = Math.abs(angleValue);
        if (oldValue >= max) {
            oldValue = max;
        } else if (oldValue <= min) {
            oldValue = min;
        }
        return String.valueOf((int)oldValue);
    }

    public static void setValueRange() {
        Max_RPM = GSkillsIndicatorValueRangeFactory.getMaxRPM();
        Min_RPM = GSkillsIndicatorValueRangeFactory.getMinRPM();
        Max_Torque = GSkillsIndicatorValueRangeFactory.getMaxTorque();
        Min_Torque = GSkillsIndicatorValueRangeFactory.getMinTorque();
        Max_HorsePower = GSkillsIndicatorValueRangeFactory.getMaxHorsePower();
        Min_HorsePower = GSkillsIndicatorValueRangeFactory.getMinHorsePower();
        Max_OilTemp = GSkillsIndicatorValueRangeFactory.getMaxOilTemp();
        Min_OilTemp = GSkillsIndicatorValueRangeFactory.getMinOilTemp();
        Max_Battery = GSkillsIndicatorValueRangeFactory.getMaxBattery();
        Min_Battery = GSkillsIndicatorValueRangeFactory.getMinBattery();
        Max_OilPress = GSkillsIndicatorValueRangeFactory.getMaxOilPressure();
        Min_OilPress = GSkillsIndicatorValueRangeFactory.getMinOilPressure();
        Max_CoolantTemp = GSkillsIndicatorValueRangeFactory.getMaxCoolantTemp();
        Min_CoolantTemp = GSkillsIndicatorValueRangeFactory.getMinCoolantTemp();
        Max_TransTemp = GSkillsIndicatorValueRangeFactory.getMaxTransTemp();
        Min_TransTemp = GSkillsIndicatorValueRangeFactory.getMinTransTemp();
        Max_IntakeAirTemp = GSkillsIndicatorValueRangeFactory.getMaxIntakeAirTemp();
        Min_IntakeAirTemp = GSkillsIndicatorValueRangeFactory.getMinIntakeAirTemp();
        Max_SteeringWheelAngle = GSkillsIndicatorValueRangeFactory.getMaxSteeringWheelAngle();
        Min_SteeringWheelAngle = GSkillsIndicatorValueRangeFactory.getMinSteeringWheelAngle();
        Max_GForce = GSkillsIndicatorValueRangeFactory.getMaxGforces();
        Min_GForce = GSkillsIndicatorValueRangeFactory.getMinGforces();
        Max_GForce_Value = GSkillsIndicatorValueRangeFactory.getMaxGforceValue();
    }

    protected double getRoundDecimal(double orginD) {
        double roundD = 0.0;
        DecimalFormat decimalFormat = new DecimalFormat("#0.00");
        roundD = orginD * 1000.0 % 10.0 >= 5.0 ? Double.valueOf(decimalFormat.format(orginD)).doubleValue() : Double.valueOf(decimalFormat.format(orginD)).doubleValue();
        return roundD;
    }

    public int getOilPressureImageNumber(String oilPressureValue, boolean isGaugeImage) {
        if (isGaugeImage) {
            return this.getImageNumber(oilPressureValue, Max_OilPress, Min_OilPress, 17);
        }
        return this.getImageNumber(oilPressureValue, Max_OilPress, Min_OilPress, 24);
    }

    public int getTorqueImageNumber(String torqueValue) {
        return this.getImageNumber(torqueValue, Max_Torque, Min_Torque, 72);
    }

    protected int getBatteryImageNumber(String receivedData, double maxValue, double minValue, int imgsCount) {
        int imageIndexInt = 1;
        if (receivedData == null || receivedData.equals("--") || receivedData.equals("") || Double.parseDouble(receivedData) < 10.0) {
            return imageIndexInt;
        }
        double receivedValue = Double.parseDouble(receivedData);
        return this.getImageNumber(receivedValue, maxValue, minValue, imgsCount);
    }

    protected int getImageNumber(String receivedData, double maxValue, double minValue, int imgsCount) {
        int imageIndexInt = 1;
        if (receivedData == null || receivedData.equals("--")) {
            return imageIndexInt;
        }
        double receivedValue = Double.parseDouble(receivedData);
        return this.getImageNumber(receivedValue, maxValue, minValue, imgsCount);
    }

    protected int getImageNumber(double receivedValue, double maxValue, double minValue, int imgsCount) {
        int imageIndexInt = 1;
        double slotSize = new Double((maxValue - minValue) / (double)imgsCount);
        if (receivedValue >= maxValue) {
            return imgsCount;
        }
        double imageIndex = (receivedValue - minValue) / slotSize;
        imageIndexInt = (int)(imageIndex + 1.0);
        return imageIndexInt;
    }

    protected int getGforceCarNumber(String negativeGforceStr, String positiveGforceStr) {
        int interval = 0;
        if (negativeGforceStr != "--" && positiveGforceStr != "--") {
            String str = positiveGforceStr;
            int inter = -3;
            if (Double.valueOf(positiveGforceStr) == 0.0) {
                str = negativeGforceStr;
                inter = 1;
            }
            if (str != null) {
                double gforceDoub = Double.parseDouble(str);
                interval = gforceDoub > 0.1 && gforceDoub <= 0.3 ? inter + 2 : (gforceDoub > 0.3 && gforceDoub <= 0.8 ? inter + 1 : (gforceDoub > 0.8 ? inter + 0 : 0));
            }
        }
        return interval;
    }

    static {
        CommonDataModel.setValueRange();
        stateManager = GSkillsStateManager.getInstance();
    }
}

