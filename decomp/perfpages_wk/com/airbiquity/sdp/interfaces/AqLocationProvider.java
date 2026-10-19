/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.location.LocationException
 */
package com.airbiquity.sdp.interfaces;

import com.airbiquity.sdp.interfaces.AqLocation;
import javax.microedition.location.LocationException;

public interface AqLocationProvider {
    public AqLocation getLocation(int var1) throws SecurityException, IllegalArgumentException, LocationException;

    public AqLocation getLastKnownLocation();
}

