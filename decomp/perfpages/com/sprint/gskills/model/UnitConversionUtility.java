/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.unit.PowerUnitEnum;
import com.sprint.gskills.unit.PressureUnitEnum;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.unit.TempUnitEnum;
import com.sprint.gskills.unit.TorqueUnitEnum;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.HashMap;

public class UnitConversionUtility {
    private static final UnitConversionUtility INSTANCE = new UnitConversionUtility();
    private HashMap<Integer, PressureUnitEnum> _mapPressureUnitEnum = new HashMap();
    private HashMap<Integer, TempUnitEnum> _mapTempUnitEnum = new HashMap();
    private HashMap<Integer, TorqueUnitEnum> _mapTorqueUnitEnum = new HashMap();
    private HashMap<Integer, PowerUnitEnum> _mapPowerUnitEnum = new HashMap();
    private HashMap<Integer, SpeedUnitEnum> _mapSpeedUnitEnum = new HashMap();

    private UnitConversionUtility() {
    }

    public static UnitConversionUtility getInstance() {
        return INSTANCE;
    }

    public double pressureConverter(double oilPressureInKiloPascals) {
        PressureUnitEnum pressureUnit = GSkillsStateManager.getInstance().getPressureUnit();
        double convertedOilPressure = oilPressureInKiloPascals;
        if (PressureUnitEnum.PSI == pressureUnit) {
            convertedOilPressure = oilPressureInKiloPascals * 0.145037738;
        } else if (PressureUnitEnum.BAR == pressureUnit) {
            convertedOilPressure = oilPressureInKiloPascals * 0.01;
        }
        return convertedOilPressure;
    }

    public double temperatureConverter(double tempInCelcius) {
        double tempValue = tempInCelcius;
        if (TempUnitEnum.FAHRENHEIT == GSkillsStateManager.getInstance().getTempUnit()) {
            tempValue = tempInCelcius * 1.8 + 32.0;
        }
        return tempValue;
    }

    public double torqueConverter(double torqueInNm) {
        double torqueValue = torqueInNm;
        if (TorqueUnitEnum.FT_LB == GSkillsStateManager.getInstance().getTorqueUnit()) {
            torqueValue = torqueInNm * 0.7376;
        }
        return torqueValue;
    }

    public double powerConverter(double powerInkW) {
        double powerValue = powerInkW;
        if (PowerUnitEnum.KW != GSkillsStateManager.getInstance().getPowerUnit()) {
            powerValue = powerInkW * 1.341;
        }
        return powerValue;
    }

    public double boostPressureConverter(double sensorValue) {
        PressureUnitEnum pressureUnit = GSkillsStateManager.getInstance().getPressureUnit();
        double midBoostPressureValue = 100.0;
        double boostPressureValue = sensorValue;
        boostPressureValue = sensorValue < 100.0 ? 100.0 - sensorValue : sensorValue - 100.0;
        double convertedValue = boostPressureValue;
        if (PressureUnitEnum.PSI == pressureUnit) {
            convertedValue = sensorValue < 100.0 ? boostPressureValue * 0.295301 : boostPressureValue * 0.145037;
        } else if (PressureUnitEnum.BAR == pressureUnit) {
            convertedValue = boostPressureValue * 0.01;
        }
        return convertedValue;
    }

    public TempUnitEnum getTempUnitEnum(int tempUnit) {
        return this._mapTempUnitEnum.get(tempUnit);
    }

    public PressureUnitEnum getPressureUnitEnum(int pressureUnit) {
        return this._mapPressureUnitEnum.get(pressureUnit);
    }

    public PowerUnitEnum getPowerUnitEnum(int powerUnit) {
        return this._mapPowerUnitEnum.get(powerUnit);
    }

    public TorqueUnitEnum getTorqueUnitEnum(int torqueUnit) {
        return this._mapTorqueUnitEnum.get(torqueUnit);
    }

    public SpeedUnitEnum getSpeedUnitEnum(int speedUnit) {
        return this._mapSpeedUnitEnum.get(speedUnit);
    }

    public void addToPressureUnitEnumMap(PressureUnitEnum pressureUnitEnum) {
        this._mapPressureUnitEnum.put(pressureUnitEnum.getID(), pressureUnitEnum);
    }

    public void addToTempUnitEnumMap(TempUnitEnum tempUnitEnum) {
        this._mapTempUnitEnum.put(tempUnitEnum.getID(), tempUnitEnum);
    }

    public void addToTorqueUnitEnumMap(TorqueUnitEnum torqueUnitEnum) {
        this._mapTorqueUnitEnum.put(torqueUnitEnum.getID(), torqueUnitEnum);
    }

    public void addToPowerUnitEnumMap(PowerUnitEnum powerUnitEnum) {
        this._mapPowerUnitEnum.put(powerUnitEnum.getID(), powerUnitEnum);
    }

    public void addToSpeedUnitEnumMap(SpeedUnitEnum speedUnitEnum) {
        this._mapSpeedUnitEnum.put(speedUnitEnum.getID(), speedUnitEnum);
    }
}

