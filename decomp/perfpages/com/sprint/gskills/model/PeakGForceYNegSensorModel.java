/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.model.PeakGForceSensorModel;

public class PeakGForceYNegSensorModel
extends PeakGForceSensorModel {
    private static final PeakGForceYNegSensorModel INSTANCE = new PeakGForceYNegSensorModel();

    private PeakGForceYNegSensorModel() {
    }

    public static PeakGForceYNegSensorModel getInstance() {
        return INSTANCE;
    }

    protected void setSensorURL() {
        this._sensorURL = "VehPerfAccelPeak_Y_Neg";
    }
}

