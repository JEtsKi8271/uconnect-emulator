/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.automotive.UnsupportedComponentException
 *  konax.automotive.VehicleComponent
 */
package com.airbiquity.sdp.interfaces;

import konax.automotive.UnsupportedComponentException;
import konax.automotive.VehicleComponent;

public interface AqComponentManager {
    public VehicleComponent getComponent(String var1) throws UnsupportedComponentException;

    public VehicleComponent[] getSupportedComponents();

    public String getVehicleId();
}

