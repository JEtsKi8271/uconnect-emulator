/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.model.BestTimerMetricModelListener;
import com.sprint.gskills.model.BestTimerUSModelListener;
import com.sprint.gskills.model.CurrentTimerMetricModelListener;
import com.sprint.gskills.model.CurrentTimerUSModelListener;
import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.model.LastTimerMetricModelListener;
import com.sprint.gskills.model.LastTimerUSModelListener;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.model.sensordata.SensorDataModel;

public class GSkillsDataModelFactory {
    private static final CommonSensorModel sensorDataModel = new SensorDataModel();
    private GSkillsDataModel currentUSTimerModel;
    private GSkillsDataModel lastUSTimerModel;
    private GSkillsDataModel bestUSTimerModel;
    private GSkillsDataModel currentMetricTimerModel;
    private GSkillsDataModel lastMetricTimerModel;
    private GSkillsDataModel bestMetricTimerModel;
    private static final GSkillsDataModelFactory INSTANCE = new GSkillsDataModelFactory();

    private GSkillsDataModelFactory() {
    }

    public static GSkillsDataModelFactory getInstance() {
        return INSTANCE;
    }

    public GSkillsDataModel initializeCurrentTimerUSModel() {
        if (this.currentUSTimerModel == null) {
            this.currentUSTimerModel = new CurrentTimerUSModelListener();
        }
        return this.currentUSTimerModel;
    }

    public GSkillsDataModel initializeLastTimerUSModel() {
        if (this.lastUSTimerModel == null) {
            this.lastUSTimerModel = new LastTimerUSModelListener();
        }
        return this.lastUSTimerModel;
    }

    public GSkillsDataModel initializeBestTimerUSModel() {
        if (this.bestUSTimerModel == null) {
            this.bestUSTimerModel = new BestTimerUSModelListener();
        }
        return this.bestUSTimerModel;
    }

    public GSkillsDataModel initializeCurrentTimerMetricModel() {
        if (this.currentMetricTimerModel == null) {
            this.currentMetricTimerModel = new CurrentTimerMetricModelListener();
        }
        return this.currentMetricTimerModel;
    }

    public GSkillsDataModel initializeLastTimerMetricModel() {
        if (this.lastMetricTimerModel == null) {
            this.lastMetricTimerModel = new LastTimerMetricModelListener();
        }
        return this.lastMetricTimerModel;
    }

    public GSkillsDataModel initializeBestTimerMetricModel() {
        if (this.bestMetricTimerModel == null) {
            this.bestMetricTimerModel = new BestTimerMetricModelListener();
        }
        return this.bestMetricTimerModel;
    }

    public static CommonSensorModel getSensorDataModel() {
        return sensorDataModel;
    }

    public GSkillsDataModel getTimerModelListener(int unit, TimersDisplayStatusEnum timerType) {
        if (unit == 0) {
            if (timerType == TimersDisplayStatusEnum.CURRENT) {
                return this.currentUSTimerModel;
            }
            if (timerType == TimersDisplayStatusEnum.LAST) {
                return this.lastUSTimerModel;
            }
            if (timerType == TimersDisplayStatusEnum.BEST) {
                return this.bestUSTimerModel;
            }
        } else if (unit == 1) {
            if (timerType == TimersDisplayStatusEnum.CURRENT) {
                return this.currentMetricTimerModel;
            }
            if (timerType == TimersDisplayStatusEnum.LAST) {
                return this.lastMetricTimerModel;
            }
            if (timerType == TimersDisplayStatusEnum.BEST) {
                return this.bestMetricTimerModel;
            }
        }
        return null;
    }
}

