/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.model.sensordata.CommonDataModel;

public class GSkillsStateManager {
    private int currentRunningState = 0;
    private int currentUnit = 0;
    private TimersDisplayStatusEnum currentTimersType = TimersDisplayStatusEnum.CURRENT;
    private TimersDisplayStatusEnum currentSaveType = null;
    private int currentView = 0;
    private int vehicleLine = 1;
    private int transType = 1;
    private static final GSkillsStateManager INSTANCE = new GSkillsStateManager();

    private GSkillsStateManager() {
    }

    public static GSkillsStateManager getInstance() {
        return INSTANCE;
    }

    public int getCurrentRunningState() {
        return this.currentRunningState;
    }

    public void setCurrentRunningState(int runningState) {
        this.currentRunningState = runningState;
    }

    public int getCurrentUnit() {
        return this.currentUnit;
    }

    public void setCurrentUnit(int currentUnit) {
        if (this.currentUnit != currentUnit) {
            this.currentUnit = currentUnit;
            CommonDataModel.setValueRange();
            GSkillsViewController.getInstance().notifyUnitChanged(this.currentView);
        }
    }

    public TimersDisplayStatusEnum getTimersType() {
        return this.currentTimersType;
    }

    public void setTimersType(TimersDisplayStatusEnum currentTimersType) {
        this.currentTimersType = currentTimersType;
    }

    public TimersDisplayStatusEnum getCurrentSaveType() {
        return this.currentSaveType;
    }

    public void setCurrentSaveType(TimersDisplayStatusEnum currentSaveType) {
        this.currentSaveType = currentSaveType;
    }

    public int getCurrentView() {
        return this.currentView;
    }

    public void setCurrentView(int currentView) {
        this.currentView = currentView;
    }

    public void setVehicleLine(int vehicleLine) {
        this.vehicleLine = vehicleLine;
    }

    public int getVehicleLine() {
        return this.vehicleLine;
    }

    public void setTransType(int transType) {
        this.transType = transType;
    }

    public int getTransType() {
        return this.transType;
    }
}

