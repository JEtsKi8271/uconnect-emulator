/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.timers;

import com.sprint.gskills.model.timers.CommonTimerModel;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.util.GSkillsLogger;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.ArrayList;

public class BestTimerModel
extends CommonTimerModel {
    private static final BestTimerModel INSTANCE = new BestTimerModel();

    private BestTimerModel() {
        super("BestTimerModel");
    }

    public static BestTimerModel getInstance() {
        return INSTANCE;
    }

    protected void initializeAttributeToListenTo() {
        this.addAttributeToMap(46);
        this.addAttributeToMap(45);
        this.addAttributeToMap(4);
        this.addAttributeToMap(8);
        this.addAttributeToMap(16);
        this.addAttributeToMap(22);
        this.addAttributeToMap(28);
        this.addAttributeToMap(52);
        this.addAttributeToMap(51);
        this.addAttributeToMap(5);
        this.addAttributeToMap(9);
        this.addAttributeToMap(17);
        this.addAttributeToMap(23);
        this.addAttributeToMap(29);
        if (this._is60ftTimerAvailable) {
            this.addAttributeToMap(61);
            this.addAttributeToMap(64);
        }
    }

    public synchronized void updateSRTAttributesOnUnitChange() {
        if (SpeedUnitEnum.KMPH == GSkillsStateManager.getInstance().getSpeedUnit()) {
            this._performanceSRTAttribEnumMap.put(0, 46);
            this._performanceSRTAttribEnumMap.put(1, 4);
            this._performanceSRTAttribEnumMap.put(2, 45);
            this._performanceSRTAttribEnumMap.put(3, 8);
            this._performanceSRTAttribEnumMap.put(4, 16);
            this._performanceSRTAttribEnumMap.put(5, 22);
            this._performanceSRTAttribEnumMap.put(6, 28);
            if (this._is60ftTimerAvailable) {
                this._performanceSRTAttribEnumMap.put(7, 61);
            }
            if (null == this._unregisteredMetricTimers) {
                GSkillsLogger.debug("Initializing list of unregistered Metric timer attributes for " + this.toString());
                this._unregisteredMetricTimers = new ArrayList();
                this._unregisteredMetricTimers.addAll(this._performanceSRTAttribEnumMap.values());
            }
        } else {
            this._performanceSRTAttribEnumMap.put(0, 52);
            this._performanceSRTAttribEnumMap.put(1, 5);
            this._performanceSRTAttribEnumMap.put(2, 51);
            this._performanceSRTAttribEnumMap.put(3, 9);
            this._performanceSRTAttribEnumMap.put(4, 17);
            this._performanceSRTAttribEnumMap.put(5, 23);
            this._performanceSRTAttribEnumMap.put(6, 29);
            if (this._is60ftTimerAvailable) {
                this._performanceSRTAttribEnumMap.put(7, 64);
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

