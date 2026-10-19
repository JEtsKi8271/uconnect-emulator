/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.location.QualifiedCoordinates
 */
package com.airbiquity.sdp.interfaces;

import javax.microedition.location.QualifiedCoordinates;

public interface AqLocation {
    public QualifiedCoordinates getQualifiedCoordinates();

    public long getTimestamp();

    public float getSpeed();

    public float getCourse();
}

