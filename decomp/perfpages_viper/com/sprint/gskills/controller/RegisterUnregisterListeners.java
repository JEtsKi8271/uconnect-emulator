/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.constants.SensorConnectionEnum;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.controller.SensorsManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import java.util.ArrayList;
import java.util.List;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class RegisterUnregisterListeners
implements Callable {
    Logger logger = Log.createLogger((String)this.getClass().getName());
    private SensorsManager sensorsManager = SensorsManager.getInstance();
    private GSkillsViewController gskillsViewController;
    private boolean hasViewChanged;
    private List<SensorConnectionEnum> registeredListeners = new ArrayList<SensorConnectionEnum>();
    private List<SensorConnectionEnum> currentViewListeners = new ArrayList<SensorConnectionEnum>();
    private List<SensorConnectionEnum> gforceViewListeners = new ArrayList<SensorConnectionEnum>();
    private List<SensorConnectionEnum> gaugesOneViewListeners = new ArrayList<SensorConnectionEnum>();
    private List<SensorConnectionEnum> gaugesTwoViewListeners = new ArrayList<SensorConnectionEnum>();
    private List<SensorConnectionEnum> engineViewListeners = new ArrayList<SensorConnectionEnum>();

    public RegisterUnregisterListeners(GSkillsViewController gskillsViewController) {
        this.gskillsViewController = gskillsViewController;
        this.initializeListenerToViewList();
    }

    private void initializeListenerToViewList() {
        this.gforceViewListeners.add(SensorConnectionEnum.Veh_Spd_MPH);
        this.gaugesOneViewListeners.add(SensorConnectionEnum.oilTemp);
        this.gaugesTwoViewListeners.add(SensorConnectionEnum.engineCoolant);
        this.gaugesTwoViewListeners.add(SensorConnectionEnum.intakeAirTemp);
        if (1 == GSkillsStateManager.getInstance().getVehicleLine()) {
            this.gaugesTwoViewListeners.add(SensorConnectionEnum.transTemp);
        } else {
            this.gaugesTwoViewListeners.add(SensorConnectionEnum.oilTemp);
        }
        this.engineViewListeners.add(SensorConnectionEnum.Veh_Spd_MPH);
        if (1 == GSkillsStateManager.getInstance().getTransType()) {
            this.engineViewListeners.add(SensorConnectionEnum.PresentGear);
        }
    }

    public Object call() throws Exception {
        if (this.hasViewChanged) {
            this.unregisterListeners();
            this.registerListeners();
            this.hasViewChanged = false;
            this.gskillsViewController.resetRefreshView();
        }
        return null;
    }

    private synchronized void registerListeners() {
        if (this.currentViewListeners != null) {
            for (int i2 = 0; i2 < this.currentViewListeners.size(); ++i2) {
                this.sensorsManager.registerListener(this.currentViewListeners.get(i2));
                this.registeredListeners.add(this.currentViewListeners.get(i2));
            }
        }
    }

    private synchronized void unregisterListeners() {
        while (this.registeredListeners.size() > 0) {
            this.sensorsManager.unregisterListener(this.registeredListeners.remove(0));
        }
    }

    public void currentView(int viewType) {
        this.hasViewChanged = true;
        switch (viewType) {
            case 2: {
                this.currentViewListeners = this.gforceViewListeners;
                break;
            }
            case 3: {
                this.currentViewListeners = this.gaugesOneViewListeners;
                break;
            }
            case 4: {
                this.currentViewListeners = this.gaugesTwoViewListeners;
                break;
            }
            case 5: {
                this.currentViewListeners = this.engineViewListeners;
                break;
            }
            default: {
                this.currentViewListeners = null;
            }
        }
    }

    public void pause() {
        new Thread(new Runnable(){

            public void run() {
                RegisterUnregisterListeners.this.unregisterListeners();
                RegisterUnregisterListeners.this.sensorsManager.unregisterUnitListener();
                RegisterUnregisterListeners.this.sensorsManager.unregisterLanguageListener();
            }
        }).start();
    }

    public void resumeApplication(GSkillsStateManager stateManager) {
        this.sensorsManager.registerUnitChangeListener(stateManager);
        this.sensorsManager.registerLanguageListener();
    }

    public void destroy() {
        this.logger.trace((Object)"Destroy called. All sensors have been closed");
    }
}

