/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.network.connectivitymanager.Connectivity
 *  kona.network.connectivitymanager.OnConnectionChangeListener
 */
package com.airbiquity.sdp.interfaces;

import kona.network.connectivitymanager.Connectivity;
import kona.network.connectivitymanager.OnConnectionChangeListener;

public interface AqConnectionListener
extends OnConnectionChangeListener {
    public void setSource(Connectivity var1);
}

