/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.timers;

import com.sprint.gskills.model.timers.CommonTimerModel;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.util.GSkillsLogger;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.ArrayList;

public class CurrentTimerModel
extends CommonTimerModel {
    private static final CurrentTimerModel INSTANCE = new CurrentTimerModel();

    private CurrentTimerModel() {
        super("CurrentTimerModel");
    }

    public static CurrentTimerModel getInstance() {
        return INSTANCE;
    }

    protected void initializeAttributeToListenTo() {
        this.addAttributeToMap(44);
        this.addAttributeToMap(0);
        this.addAttributeToMap(43);
        this.addAttributeToMap(6);
        this.addAttributeToMap(12);
        this.addAttributeToMap(18);
        this.addAttributeToMap(24);
        this.addAttributeToMap(30);
        this.addAttributeToMap(36);
        this.addAttributeToMap(50);
        this.addAttributeToMap(1);
        this.addAttributeToMap(49);
        this.addAttributeToMap(7);
        this.addAttributeToMap(13);
        this.addAttributeToMap(19);
        this.addAttributeToMap(25);
        this.addAttributeToMap(35);
        this.addAttributeToMap(39);
        if (this._is60ftTimerAvailable) {
            this.addAttributeToMap(60);
            this.addAttributeToMap(63);
        }
    }

    public synchronized void updateSRTAttributesOnUnitChange() {
        if (SpeedUnitEnum.KMPH == GSkillsStateManager.getInstance().getSpeedUnit()) {
            this._performanceSRTAttribEnumMap.put(0, 44);
            this._performanceSRTAttribEnumMap.put(1, 0);
            this._performanceSRTAttribEnumMap.put(2, 43);
            this._performanceSRTAttribEnumMap.put(3, 6);
            this._performanceSRTAttribEnumMap.put(4, 12);
            this._performanceSRTAttribEnumMap.put(5, 18);
            this._performanceSRTAttribEnumMap.put(6, 24);
            this._performanceSRTAttribEnumMap.put(8, 30);
            this._performanceSRTAttribEnumMap.put(9, 36);
            if (this._is60ftTimerAvailable) {
                this._performanceSRTAttribEnumMap.put(7, 60);
            }
            if (null == this._unregisteredMetricTimers) {
                GSkillsLogger.debug("Initializing list of unregistered Metric timer attributes for " + this.toString());
                this._unregisteredMetricTimers = new ArrayList();
                this._unregisteredMetricTimers.addAll(this._performanceSRTAttribEnumMap.values());
            }
        } else {
            this._performanceSRTAttribEnumMap.put(0, 50);
            this._performanceSRTAttribEnumMap.put(1, 1);
            this._performanceSRTAttribEnumMap.put(2, 49);
            this._performanceSRTAttribEnumMap.put(3, 7);
            this._performanceSRTAttribEnumMap.put(4, 13);
            this._performanceSRTAttribEnumMap.put(5, 19);
            this._performanceSRTAttribEnumMap.put(6, 25);
            this._performanceSRTAttribEnumMap.put(8, 35);
            this._performanceSRTAttribEnumMap.put(9, 39);
            if (this._is60ftTimerAvailable) {
                this._performanceSRTAttribEnumMap.put(7, 63);
            }
            if (null == this._unregisteredUSTimers) {
                GSkillsLogger.debug("Initializing list of unregistered US timer attributes for " + this.toString());
                this._unregisteredUSTimers = new ArrayList();
                this._unregisteredUSTimers.addAll(this._performanceSRTAttribEnumMap.values());
            }
        }
        this._hasValueChanged = true;
    }
}

