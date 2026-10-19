/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.timers;

import com.sprint.gskills.model.timers.CommonTimerModel;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.util.GSkillsLogger;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.ArrayList;

public class LastTimerModel
extends CommonTimerModel {
    private static final LastTimerModel INSTANCE = new LastTimerModel();

    private LastTimerModel() {
        super("LastTimerModel");
    }

    public static LastTimerModel getInstance() {
        return INSTANCE;
    }

    protected void initializeAttributeToListenTo() {
        this.addAttributeToMap(48);
        this.addAttributeToMap(2);
        this.addAttributeToMap(47);
        this.addAttributeToMap(10);
        this.addAttributeToMap(14);
        this.addAttributeToMap(20);
        this.addAttributeToMap(26);
        this.addAttributeToMap(31);
        this.addAttributeToMap(37);
        this.addAttributeToMap(54);
        this.addAttributeToMap(3);
        this.addAttributeToMap(53);
        this.addAttributeToMap(11);
        this.addAttributeToMap(15);
        this.addAttributeToMap(21);
        this.addAttributeToMap(27);
        this.addAttributeToMap(33);
        this.addAttributeToMap(40);
        if (this._is60ftTimerAvailable) {
            this.addAttributeToMap(62);
            this.addAttributeToMap(65);
        }
    }

    public synchronized void updateSRTAttributesOnUnitChange() {
        if (SpeedUnitEnum.KMPH == GSkillsStateManager.getInstance().getSpeedUnit()) {
            this._performanceSRTAttribEnumMap.put(0, 48);
            this._performanceSRTAttribEnumMap.put(1, 2);
            this._performanceSRTAttribEnumMap.put(2, 47);
            this._performanceSRTAttribEnumMap.put(3, 10);
            this._performanceSRTAttribEnumMap.put(4, 14);
            this._performanceSRTAttribEnumMap.put(5, 20);
            this._performanceSRTAttribEnumMap.put(6, 26);
            this._performanceSRTAttribEnumMap.put(8, 31);
            this._performanceSRTAttribEnumMap.put(9, 37);
            if (this._is60ftTimerAvailable) {
                this._performanceSRTAttribEnumMap.put(7, 62);
            }
            if (null == this._unregisteredMetricTimers) {
                GSkillsLogger.debug("Initializing list of unregistered Metric timer attributes for " + this.toString());
                this._unregisteredMetricTimers = new ArrayList();
                this._unregisteredMetricTimers.addAll(this._performanceSRTAttribEnumMap.values());
            }
        } else {
            this._performanceSRTAttribEnumMap.put(0, 54);
            this._performanceSRTAttribEnumMap.put(1, 3);
            this._performanceSRTAttribEnumMap.put(2, 53);
            this._performanceSRTAttribEnumMap.put(3, 11);
            this._performanceSRTAttribEnumMap.put(4, 15);
            this._performanceSRTAttribEnumMap.put(5, 21);
            this._performanceSRTAttribEnumMap.put(6, 27);
            this._performanceSRTAttribEnumMap.put(8, 33);
            this._performanceSRTAttribEnumMap.put(9, 40);
            if (this._is60ftTimerAvailable) {
                this._performanceSRTAttribEnumMap.put(7, 65);
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

