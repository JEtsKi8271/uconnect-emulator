/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.sensordata;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.model.AirFuelRatioSensorModel;
import com.sprint.gskills.model.BatterySensorModel;
import com.sprint.gskills.model.BoostPressureSensorModel;
import com.sprint.gskills.model.GForceSensorModel;
import com.sprint.gskills.model.HorsePowerSensorModel;
import com.sprint.gskills.model.OilPressureSensorModel;
import com.sprint.gskills.model.RPMSensorModel;
import com.sprint.gskills.model.SpeedSensorModel;
import com.sprint.gskills.model.SteeringAngleSensorModel;
import com.sprint.gskills.model.TorqueSensorModel;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.ArrayList;
import java.util.List;

public class SensorPollManager {
    private static final SensorPollManager INSTANCE = new SensorPollManager();
    private List<CommonSensorModel> _currentViewPollingSensors = null;
    private List<CommonSensorModel> _gaugesOnePollingSensors = new ArrayList<CommonSensorModel>();
    private List<CommonSensorModel> _gaugesTwoPollingSensors = new ArrayList<CommonSensorModel>();
    private List<CommonSensorModel> _gForcePollingSensors = new ArrayList<CommonSensorModel>();
    private List<CommonSensorModel> _enginePollingSensors = new ArrayList<CommonSensorModel>();
    private final Object _syncObject = new Object();

    private SensorPollManager() {
        this.initializePollingList();
    }

    public static SensorPollManager getInstance() {
        return INSTANCE;
    }

    private void initializePollingList() {
        this._gaugesOnePollingSensors.add(OilPressureSensorModel.getInstance());
        if (VehicleTrimEnum.HELLCAT == GSkillsStateManager.getInstance().getVehicleTrim()) {
            this._gaugesOnePollingSensors.add(BatterySensorModel.getInstance());
            this._gaugesTwoPollingSensors.add(AirFuelRatioSensorModel.getInstance());
            this._gaugesTwoPollingSensors.add(BoostPressureSensorModel.getInstance());
        } else {
            this._gaugesTwoPollingSensors.add(BatterySensorModel.getInstance());
        }
        this._gForcePollingSensors.add(SteeringAngleSensorModel.getInstance());
        this._gForcePollingSensors.add(SpeedSensorModel.getInstance());
        this._gForcePollingSensors.add(GForceSensorModel.getInstance());
        this._enginePollingSensors.add(TorqueSensorModel.getInstance());
        this._enginePollingSensors.add(RPMSensorModel.getInstance());
        this._enginePollingSensors.add(HorsePowerSensorModel.getInstance());
        this._enginePollingSensors.add(SpeedSensorModel.getInstance());
        if (VehicleTrimEnum.HELLCAT == GSkillsStateManager.getInstance().getVehicleTrim()) {
            this._enginePollingSensors.add(BoostPressureSensorModel.getInstance());
        } else {
            this._enginePollingSensors.add(OilPressureSensorModel.getInstance());
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void currentView(ViewEnum viewEnum) {
        Object object = this._syncObject;
        synchronized (object) {
            switch (viewEnum.getViewID()) {
                case 4: {
                    this._currentViewPollingSensors = this._gForcePollingSensors;
                    break;
                }
                case 2: {
                    this._currentViewPollingSensors = this._gaugesOnePollingSensors;
                    break;
                }
                case 3: {
                    this._currentViewPollingSensors = this._gaugesTwoPollingSensors;
                    break;
                }
                case 5: {
                    this._currentViewPollingSensors = this._enginePollingSensors;
                    break;
                }
                default: {
                    this._currentViewPollingSensors = null;
                }
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void pollSensors() {
        Object object = this._syncObject;
        synchronized (object) {
            if (this._currentViewPollingSensors != null) {
                for (int i2 = 0; i2 < this._currentViewPollingSensors.size(); ++i2) {
                    this._currentViewPollingSensors.get(i2).pollAndSetRawData();
                }
            }
        }
    }
}

