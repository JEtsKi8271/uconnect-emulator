/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.model.PeakGForceSensorModel;

public class PeakGForceXPosSensorModel
extends PeakGForceSensorModel {
    private static final PeakGForceXPosSensorModel INSTANCE = new PeakGForceXPosSensorModel();

    private PeakGForceXPosSensorModel() {
    }

    public static PeakGForceXPosSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "VehPerfAccelPeak_X_Pos";
    }
}

