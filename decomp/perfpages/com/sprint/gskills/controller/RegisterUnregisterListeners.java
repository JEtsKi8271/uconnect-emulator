/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.constants.TransmissionTypeEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.controller.SensorsManager;
import com.sprint.gskills.model.CoolantTempICSensorModel;
import com.sprint.gskills.model.CoolantTempSensorModel;
import com.sprint.gskills.model.GearSensorModel;
import com.sprint.gskills.model.IntakeAirTempICSensorModel;
import com.sprint.gskills.model.IntakeAirTempSensorModel;
import com.sprint.gskills.model.OilTempSensorModel;
import com.sprint.gskills.model.PeakGForceXNegSensorModel;
import com.sprint.gskills.model.PeakGForceXPosSensorModel;
import com.sprint.gskills.model.PeakGForceYNegSensorModel;
import com.sprint.gskills.model.PeakGForceYPosSensorModel;
import com.sprint.gskills.model.TransTempSensorModel;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class RegisterUnregisterListeners {
    Logger _logger = Log.createLogger((String)this.getClass().getName());
    private boolean _hasViewChanged;
    private final SensorsManager _sensorsManager;
    protected List<CommonSensorModel> _registeredListeners = new ArrayList<CommonSensorModel>();
    protected List<CommonSensorModel> _gforceViewListeners = new ArrayList<CommonSensorModel>();
    protected List<CommonSensorModel> _gaugesOneViewListeners = new ArrayList<CommonSensorModel>();
    protected List<CommonSensorModel> _gaugesTwoViewListeners = new ArrayList<CommonSensorModel>();
    protected List<CommonSensorModel> _engineViewListeners = new ArrayList<CommonSensorModel>();
    protected List<CommonSensorModel> _currentViewListeners;
    private static final RegisterUnregisterListeners INSTANCE = new RegisterUnregisterListeners();

    private RegisterUnregisterListeners() {
        this._sensorsManager = SensorsManager.getInstance();
        this.initializeListenersList();
    }

    public static RegisterUnregisterListeners getInstance() {
        return INSTANCE;
    }

    protected void initializeListenersList() {
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        VehicleTrimEnum vehicleTrim = stateManager.getVehicleTrim();
        this._gforceViewListeners.add(PeakGForceXPosSensorModel.getInstance());
        this._gforceViewListeners.add(PeakGForceXNegSensorModel.getInstance());
        this._gforceViewListeners.add(PeakGForceYPosSensorModel.getInstance());
        this._gforceViewListeners.add(PeakGForceYNegSensorModel.getInstance());
        this._gaugesOneViewListeners.add(OilTempSensorModel.getInstance());
        this._gaugesOneViewListeners.add(CoolantTempSensorModel.getInstance());
        if (VehicleTrimEnum.HELLCAT == vehicleTrim) {
            this._gaugesTwoViewListeners.add(CoolantTempICSensorModel.getInstance());
            this._gaugesTwoViewListeners.add(IntakeAirTempICSensorModel.getInstance());
        } else {
            this._gaugesTwoViewListeners.add(IntakeAirTempSensorModel.getInstance());
        }
        if (TransmissionTypeEnum.AUTO == stateManager.getTransType()) {
            this._engineViewListeners.add(GearSensorModel.getInstance());
            if (VehicleTrimEnum.HELLCAT == vehicleTrim) {
                this._gaugesOneViewListeners.add(TransTempSensorModel.getInstance());
            } else {
                this._gaugesTwoViewListeners.add(TransTempSensorModel.getInstance());
            }
        }
    }

    public void regUnregSensorListeners() {
        if (this._hasViewChanged) {
            try {
                this.unregisterListeners();
                this.registerListeners();
                this._hasViewChanged = false;
            }
            catch (Exception e2) {
                this._logger.debug((Object)"Reg/Unreg: exception!!");
                e2.printStackTrace();
            }
        }
    }

    private synchronized void registerListeners() {
        this._logger.debug((Object)"Registering listeners for current view");
        if (this._currentViewListeners != null) {
            for (int i2 = 0; i2 < this._currentViewListeners.size(); ++i2) {
                if (this._registeredListeners.contains(this._currentViewListeners.get(i2))) continue;
                CommonSensorModel sensorModel = this._currentViewListeners.get(i2);
                sensorModel.pollAndSetRawData();
                sensorModel.registerListener();
                this._registeredListeners.add(sensorModel);
            }
        }
    }

    private synchronized void unregisterListeners() {
        this._logger.debug((Object)"Unregistering listeners for previous view");
        ListIterator<CommonSensorModel> iter = this._registeredListeners.listIterator();
        while (iter.hasNext()) {
            CommonSensorModel sensorModel = iter.next();
            if (null != this._currentViewListeners && this._currentViewListeners.contains(sensorModel) && this._hasViewChanged) continue;
            sensorModel.unregisterListener();
            iter.remove();
        }
    }

    public void currentView(ViewEnum viewEnum) {
        this._hasViewChanged = true;
        switch (viewEnum.getViewID()) {
            case 4: {
                this._currentViewListeners = this._gforceViewListeners;
                break;
            }
            case 2: {
                this._currentViewListeners = this._gaugesOneViewListeners;
                break;
            }
            case 3: {
                this._currentViewListeners = this._gaugesTwoViewListeners;
                break;
            }
            case 5: {
                this._currentViewListeners = this._engineViewListeners;
                break;
            }
            default: {
                this._currentViewListeners = null;
            }
        }
    }

    public void pause() {
        GSkillsThreadManager.getInstance().execute(new GSkillsRunnable("RegUnregOnPauseThread"){

            public void run() {
                RegisterUnregisterListeners.this.unregisterListeners();
            }
        });
    }

    public void resumeApplication() {
        this._sensorsManager.registerUnitChangeListeners();
        this._sensorsManager.registerLanguageListener();
    }

    public void destroy() {
        this._logger.trace((Object)"Destroy called. All sensors have been closed, and working is false");
    }
}

