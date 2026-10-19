/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.timers;

import com.sprint.gskills.model.timers.CommonTimerModel;
import com.sprint.gskills.model.timers.TimerAttribute;

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
        this._timersSpeedKMPHDistKM.put(0, TimerAttribute.SRT_REACTTMC);
        this._timersSpeedKMPHDistKM.put(1, TimerAttribute.SRT_60MPHTMC);
        this._timersSpeedKMPHDistKM.put(2, TimerAttribute.SRT_100MPHTMC);
        this._timersSpeedKMPHDistKM.put(3, TimerAttribute.SRT_EIGHTHTMC);
        this._timersSpeedKMPHDistKM.put(4, TimerAttribute.SRT_ETHSPDC_M);
        this._timersSpeedKMPHDistKM.put(5, TimerAttribute.SRT_QUARTERTMC);
        this._timersSpeedKMPHDistKM.put(6, TimerAttribute.SRT_QRTSPDC_M);
        this._timersSpeedKMPHDistKM.put(8, TimerAttribute.SRT_BRKDISTC_M);
        this._timersSpeedKMPHDistKM.put(9, TimerAttribute.SRT_BRKSPDC_M);
        this._timersSpeedKMPHDistMile.put(0, TimerAttribute.SRT_REACTTMC);
        this._timersSpeedKMPHDistMile.put(1, TimerAttribute.SRT_60MPHTMC);
        this._timersSpeedKMPHDistMile.put(2, TimerAttribute.SRT_100MPHTMC);
        this._timersSpeedKMPHDistMile.put(3, TimerAttribute.SRT_EIGHTHTM_C);
        this._timersSpeedKMPHDistMile.put(4, TimerAttribute.SRT_ETHSPDC_US);
        this._timersSpeedKMPHDistMile.put(5, TimerAttribute.SRT_QUARTERTM_C);
        this._timersSpeedKMPHDistMile.put(6, TimerAttribute.SRT_QRTSPDC_US);
        this._timersSpeedKMPHDistMile.put(8, TimerAttribute.SRT_BRKDISTC_US);
        this._timersSpeedKMPHDistMile.put(9, TimerAttribute.SRT_BRKSPDC_M);
        this._timersSpeedMPHDistKM.put(0, TimerAttribute.SRT_REACTTM_C);
        this._timersSpeedMPHDistKM.put(1, TimerAttribute.SRT_60MPHTM_C);
        this._timersSpeedMPHDistKM.put(2, TimerAttribute.SRT_100MPHTM_C);
        this._timersSpeedMPHDistKM.put(3, TimerAttribute.SRT_EIGHTHTMC);
        this._timersSpeedMPHDistKM.put(4, TimerAttribute.SRT_ETHSPDC_M);
        this._timersSpeedMPHDistKM.put(5, TimerAttribute.SRT_QUARTERTMC);
        this._timersSpeedMPHDistKM.put(6, TimerAttribute.SRT_QRTSPDC_M);
        this._timersSpeedMPHDistKM.put(8, TimerAttribute.SRT_BRKDISTC_M);
        this._timersSpeedMPHDistKM.put(9, TimerAttribute.SRT_BRKSPDC_US);
        this._timersSpeedMPHDistMile.put(0, TimerAttribute.SRT_REACTTM_C);
        this._timersSpeedMPHDistMile.put(1, TimerAttribute.SRT_60MPHTM_C);
        this._timersSpeedMPHDistMile.put(2, TimerAttribute.SRT_100MPHTM_C);
        this._timersSpeedMPHDistMile.put(3, TimerAttribute.SRT_EIGHTHTM_C);
        this._timersSpeedMPHDistMile.put(4, TimerAttribute.SRT_ETHSPDC_US);
        this._timersSpeedMPHDistMile.put(5, TimerAttribute.SRT_QUARTERTM_C);
        this._timersSpeedMPHDistMile.put(6, TimerAttribute.SRT_QRTSPDC_US);
        this._timersSpeedMPHDistMile.put(8, TimerAttribute.SRT_BRKDISTC_US);
        this._timersSpeedMPHDistMile.put(9, TimerAttribute.SRT_BRKSPDC_US);
        if (this._isMY16Vehicle) {
            this.addAttributeToMap(60);
            this.addAttributeToMap(63);
            this._timersSpeedKMPHDistKM.put(7, TimerAttribute.SRT_60ftTmC);
            this._timersSpeedKMPHDistMile.put(7, TimerAttribute.SRT_60ftTmC);
            this._timersSpeedMPHDistKM.put(7, TimerAttribute.SRT_60ftTm_C);
            this._timersSpeedMPHDistMile.put(7, TimerAttribute.SRT_60ftTm_C);
        }
    }
}

