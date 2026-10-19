/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.timers;

import com.sprint.gskills.model.timers.CommonTimerModel;
import com.sprint.gskills.model.timers.TimerAttribute;

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
        this._timersSpeedKMPHDistKM.put(0, TimerAttribute.SRT_ReactTmB);
        this._timersSpeedKMPHDistKM.put(1, TimerAttribute.SRT_60MPHTMB);
        this._timersSpeedKMPHDistKM.put(2, TimerAttribute.SRT_100MPHTMB);
        this._timersSpeedKMPHDistKM.put(3, TimerAttribute.SRT_EIGHTHTMB);
        this._timersSpeedKMPHDistKM.put(4, TimerAttribute.SRT_ETHSPDB_M);
        this._timersSpeedKMPHDistKM.put(5, TimerAttribute.SRT_QUARTERTMB);
        this._timersSpeedKMPHDistKM.put(6, TimerAttribute.SRT_QRTSPDB_M);
        this._timersSpeedKMPHDistMile.put(0, TimerAttribute.SRT_ReactTmB);
        this._timersSpeedKMPHDistMile.put(1, TimerAttribute.SRT_60MPHTMB);
        this._timersSpeedKMPHDistMile.put(2, TimerAttribute.SRT_100MPHTMB);
        this._timersSpeedKMPHDistMile.put(3, TimerAttribute.SRT_EIGHTHTM_B);
        this._timersSpeedKMPHDistMile.put(4, TimerAttribute.SRT_ETHSPDB_US);
        this._timersSpeedKMPHDistMile.put(5, TimerAttribute.SRT_QUARTERTM_B);
        this._timersSpeedKMPHDistMile.put(6, TimerAttribute.SRT_QRTSPDB_US);
        this._timersSpeedMPHDistKM.put(0, TimerAttribute.SRT_REACTTM_B);
        this._timersSpeedMPHDistKM.put(1, TimerAttribute.SRT_60MPHTM_B);
        this._timersSpeedMPHDistKM.put(2, TimerAttribute.SRT_100MPHTM_B);
        this._timersSpeedMPHDistKM.put(3, TimerAttribute.SRT_EIGHTHTMB);
        this._timersSpeedMPHDistKM.put(4, TimerAttribute.SRT_ETHSPDB_M);
        this._timersSpeedMPHDistKM.put(5, TimerAttribute.SRT_QUARTERTMB);
        this._timersSpeedMPHDistKM.put(6, TimerAttribute.SRT_QRTSPDB_M);
        this._timersSpeedMPHDistMile.put(0, TimerAttribute.SRT_REACTTM_B);
        this._timersSpeedMPHDistMile.put(1, TimerAttribute.SRT_60MPHTM_B);
        this._timersSpeedMPHDistMile.put(2, TimerAttribute.SRT_100MPHTM_B);
        this._timersSpeedMPHDistMile.put(3, TimerAttribute.SRT_EIGHTHTM_B);
        this._timersSpeedMPHDistMile.put(4, TimerAttribute.SRT_ETHSPDB_US);
        this._timersSpeedMPHDistMile.put(5, TimerAttribute.SRT_QUARTERTM_B);
        this._timersSpeedMPHDistMile.put(6, TimerAttribute.SRT_QRTSPDB_US);
        if (this._isMY16Vehicle) {
            this.addAttributeToMap(61);
            this.addAttributeToMap(64);
            this._timersSpeedKMPHDistKM.put(7, TimerAttribute.SRT_60ftTmB);
            this._timersSpeedKMPHDistMile.put(7, TimerAttribute.SRT_60ftTmB);
            this._timersSpeedMPHDistKM.put(7, TimerAttribute.SRT_60ftTm_B);
            this._timersSpeedMPHDistMile.put(7, TimerAttribute.SRT_60ftTm_B);
        }
    }
}

