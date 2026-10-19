/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.timers;

import com.sprint.gskills.model.timers.CommonTimerModel;
import com.sprint.gskills.model.timers.TimerAttribute;

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
        this._timersSpeedKMPHDistKM.put(0, TimerAttribute.SRT_REACTTML);
        this._timersSpeedKMPHDistKM.put(1, TimerAttribute.SRT_60MPHTML);
        this._timersSpeedKMPHDistKM.put(2, TimerAttribute.SRT_100MPHTML);
        this._timersSpeedKMPHDistKM.put(3, TimerAttribute.SRT_EIGHTHTML);
        this._timersSpeedKMPHDistKM.put(4, TimerAttribute.SRT_ETHSPDL_M);
        this._timersSpeedKMPHDistKM.put(5, TimerAttribute.SRT_QUARTERTML);
        this._timersSpeedKMPHDistKM.put(6, TimerAttribute.SRT_QRTSPDL_M);
        this._timersSpeedKMPHDistKM.put(8, TimerAttribute.SRT_BRKDISTL_M);
        this._timersSpeedKMPHDistKM.put(9, TimerAttribute.SRT_BRKSPDL_M);
        this._timersSpeedKMPHDistMile.put(0, TimerAttribute.SRT_REACTTML);
        this._timersSpeedKMPHDistMile.put(1, TimerAttribute.SRT_60MPHTML);
        this._timersSpeedKMPHDistMile.put(2, TimerAttribute.SRT_100MPHTML);
        this._timersSpeedKMPHDistMile.put(3, TimerAttribute.SRT_EIGHTHTM_L);
        this._timersSpeedKMPHDistMile.put(4, TimerAttribute.SRT_ETHSPDL_US);
        this._timersSpeedKMPHDistMile.put(5, TimerAttribute.SRT_QUARTERTM_L);
        this._timersSpeedKMPHDistMile.put(6, TimerAttribute.SRT_QRTSPDL_US);
        this._timersSpeedKMPHDistMile.put(8, TimerAttribute.SRT_BRKDISTL_US);
        this._timersSpeedKMPHDistMile.put(9, TimerAttribute.SRT_BRKSPDL_M);
        this._timersSpeedMPHDistKM.put(0, TimerAttribute.SRT_REACTTM_L);
        this._timersSpeedMPHDistKM.put(1, TimerAttribute.SRT_60MPHTM_L);
        this._timersSpeedMPHDistKM.put(2, TimerAttribute.SRT_100MPHTM_L);
        this._timersSpeedMPHDistKM.put(3, TimerAttribute.SRT_EIGHTHTML);
        this._timersSpeedMPHDistKM.put(4, TimerAttribute.SRT_ETHSPDL_M);
        this._timersSpeedMPHDistKM.put(5, TimerAttribute.SRT_QUARTERTML);
        this._timersSpeedMPHDistKM.put(6, TimerAttribute.SRT_QRTSPDL_M);
        this._timersSpeedMPHDistKM.put(8, TimerAttribute.SRT_BRKDISTL_M);
        this._timersSpeedMPHDistKM.put(9, TimerAttribute.SRT_BRKSPDL_US);
        this._timersSpeedMPHDistMile.put(0, TimerAttribute.SRT_REACTTM_L);
        this._timersSpeedMPHDistMile.put(1, TimerAttribute.SRT_60MPHTM_L);
        this._timersSpeedMPHDistMile.put(2, TimerAttribute.SRT_100MPHTM_L);
        this._timersSpeedMPHDistMile.put(3, TimerAttribute.SRT_EIGHTHTM_L);
        this._timersSpeedMPHDistMile.put(4, TimerAttribute.SRT_ETHSPDL_US);
        this._timersSpeedMPHDistMile.put(5, TimerAttribute.SRT_QUARTERTM_L);
        this._timersSpeedMPHDistMile.put(6, TimerAttribute.SRT_QRTSPDL_US);
        this._timersSpeedMPHDistMile.put(8, TimerAttribute.SRT_BRKDISTL_US);
        this._timersSpeedMPHDistMile.put(9, TimerAttribute.SRT_BRKSPDL_US);
        if (this._isMY16Vehicle) {
            this.addAttributeToMap(62);
            this.addAttributeToMap(65);
            this._timersSpeedKMPHDistKM.put(7, TimerAttribute.SRT_60ftTmL);
            this._timersSpeedKMPHDistMile.put(7, TimerAttribute.SRT_60ftTmL);
            this._timersSpeedMPHDistKM.put(7, TimerAttribute.SRT_60ftTm_L);
            this._timersSpeedMPHDistMile.put(7, TimerAttribute.SRT_60ftTm_L);
        }
    }
}

