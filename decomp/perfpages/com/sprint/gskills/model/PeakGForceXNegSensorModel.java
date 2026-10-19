/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.model.PeakGForceSensorModel;

public class PeakGForceXNegSensorModel
extends PeakGForceSensorModel {
    private static final PeakGForceXNegSensorModel INSTANCE = new PeakGForceXNegSensorModel();

    private PeakGForceXNegSensorModel() {
    }

    public static PeakGForceXNegSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "VehPerfAccelPeak_X_Neg";
    }
}

