/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.SRTTimerManager;
import com.sprint.gskills.constants.GSkillsRunningStateEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.constants.TransmissionTypeEnum;
import com.sprint.gskills.constants.VehicleBrandEnum;
import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.unit.PowerUnitEnum;
import com.sprint.gskills.unit.PressureUnitEnum;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.unit.TempUnitEnum;
import com.sprint.gskills.unit.TorqueUnitEnum;
import com.sprint.gskills.unit.UnitsOfMeasurementEnum;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsStateManager {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private GSkillsRunningStateEnum _currentRunningState = GSkillsRunningStateEnum.PRE_INIT;
    private TimersDisplayStatusEnum _currentTimersType = null;
    private TimersDisplayStatusEnum _currentSaveType = null;
    private ViewEnum _currentView = ViewEnum.HOME_VIEW;
    private VehicleLineEnum _vehicleLine = VehicleLineEnum.LA;
    private VehicleTrimEnum _vehicleTrim = VehicleTrimEnum.RT;
    private VehicleBrandEnum _vehicleBrand = VehicleBrandEnum.DODGE;
    private String _displacement = "3.6";
    private UnitsOfMeasurementEnum _changedUnit;
    private PressureUnitEnum _pressureUnit = PressureUnitEnum.INVALID;
    private TempUnitEnum _tempUnit = TempUnitEnum.INVALID;
    private TorqueUnitEnum _torqueUnit = TorqueUnitEnum.INVALID;
    private SpeedUnitEnum _speedUnit = SpeedUnitEnum.INVALID;
    private PowerUnitEnum _powerUnit = PowerUnitEnum.INVALID;
    private TransmissionTypeEnum _transType = TransmissionTypeEnum.AUTO;
    private static final GSkillsStateManager INSTANCE = new GSkillsStateManager();

    private GSkillsStateManager() {
    }

    public static GSkillsStateManager getInstance() {
        return INSTANCE;
    }

    public GSkillsRunningStateEnum getCurrentRunningState() {
        return this._currentRunningState;
    }

    public void setCurrentRunningState(GSkillsRunningStateEnum runningState) {
        this._currentRunningState = runningState;
    }

    public TimersDisplayStatusEnum getTimersType() {
        return this._currentTimersType;
    }

    public void setTimersType(TimersDisplayStatusEnum currentTimersType) {
        this._currentTimersType = currentTimersType;
    }

    public TimersDisplayStatusEnum getCurrentSaveType() {
        return this._currentSaveType;
    }

    public void setCurrentSaveType(TimersDisplayStatusEnum currentSaveType) {
        this._currentSaveType = currentSaveType;
    }

    public ViewEnum getCurrentView() {
        return this._currentView;
    }

    public void setCurrentView(ViewEnum currentView) {
        this._currentView = currentView;
    }

    public VehicleLineEnum getVehicleLine() {
        return this._vehicleLine;
    }

    public void setVehicleLine(VehicleLineEnum vehicleLine) {
        this._vehicleLine = vehicleLine;
    }

    public VehicleTrimEnum getVehicleTrim() {
        return this._vehicleTrim;
    }

    public void setVehicleTrim(VehicleTrimEnum vehicleTrim) {
        this._vehicleTrim = vehicleTrim;
    }

    public VehicleBrandEnum getVehicleBrand() {
        return this._vehicleBrand;
    }

    public void setEngineDisplacement(String displacement) {
        this._displacement = displacement;
    }

    public String getEngineDisplacement() {
        return this._displacement;
    }

    public void setVehicleBrand() {
        this._vehicleBrand = VehicleTrimEnum.RT == this._vehicleTrim ? (VehicleLineEnum.LX == this._vehicleLine ? VehicleBrandEnum.CHRYSLER : VehicleBrandEnum.DODGE) : VehicleBrandEnum.SRT;
    }

    public TransmissionTypeEnum getTransType() {
        return this._transType;
    }

    public void setTransType(TransmissionTypeEnum transType) {
        this._transType = transType;
    }

    public void setTempUnit(TempUnitEnum tempUnit) {
        if (this._tempUnit != tempUnit) {
            this._logger.debug((Object)("TemperatureUnit sensor set to " + tempUnit.toString()));
            this._tempUnit = tempUnit;
            this._changedUnit = UnitsOfMeasurementEnum.TEMP;
        }
    }

    public TempUnitEnum getTempUnit() {
        return this._tempUnit;
    }

    public void setTorqueUnit(TorqueUnitEnum torqueUnit) {
        if (this._torqueUnit != torqueUnit) {
            this._logger.debug((Object)("TorqueUnit sensor set to " + torqueUnit.toString()));
            this._torqueUnit = torqueUnit;
            this._changedUnit = UnitsOfMeasurementEnum.TORQUE;
        }
    }

    public TorqueUnitEnum getTorqueUnit() {
        return this._torqueUnit;
    }

    public void setSpeedUnit(SpeedUnitEnum speedUnit) {
        if (this._speedUnit != speedUnit) {
            this._logger.debug((Object)("SpeedUnit sensor set to " + speedUnit.toString()));
            this._speedUnit = speedUnit;
            this._changedUnit = UnitsOfMeasurementEnum.SPEED;
            SRTTimerManager.getInstance().updateTimersOnUnitChange();
        }
    }

    public SpeedUnitEnum getSpeedUnit() {
        return this._speedUnit;
    }

    public void setPowerUnit(PowerUnitEnum powerUnit) {
        if (this._powerUnit != powerUnit) {
            this._logger.debug((Object)("PowerUnit sensor set to " + powerUnit.toString()));
            this._powerUnit = powerUnit;
            this._changedUnit = UnitsOfMeasurementEnum.POWER;
        }
    }

    public PowerUnitEnum getPowerUnit() {
        return this._powerUnit;
    }

    public void setPressureUnit(PressureUnitEnum pressureUnit) {
        if (this._pressureUnit != pressureUnit) {
            this._logger.debug((Object)("PressureUnit sensor set to " + pressureUnit.toString()));
            this._pressureUnit = pressureUnit;
            this._changedUnit = UnitsOfMeasurementEnum.PRESSURE;
        }
    }

    public PressureUnitEnum getPressureUnit() {
        return this._pressureUnit;
    }

    public UnitsOfMeasurementEnum getChangedUnit() {
        return this._changedUnit;
    }

    public void forceUpdateAllUnits() {
        this._logger.debug((Object)"Force update all units of measure");
        this._changedUnit = UnitsOfMeasurementEnum.ALL;
    }

    public boolean isLSeriesVehicle() {
        return VehicleLineEnum.LA == this._vehicleLine || VehicleLineEnum.LD == this._vehicleLine || VehicleLineEnum.LX == this._vehicleLine;
    }
}

