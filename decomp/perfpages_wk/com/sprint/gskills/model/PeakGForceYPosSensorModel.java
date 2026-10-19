/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.model.PeakGForceSensorModel;

public class PeakGForceYPosSensorModel
extends PeakGForceSensorModel {
    private static final PeakGForceYPosSensorModel INSTANCE = new PeakGForceYPosSensorModel();

    private PeakGForceYPosSensorModel() {
    }

    public static PeakGForceYPosSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "VehPerfAccelPeak_Y_Pos";
    }
}

