/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.network.connectivitymanager.ConnectivityManagerException
 *  kona.network.connectivitymanager.NetworkInfo
 */
package com.airbiquity.sdp.interfaces;

import com.airbiquity.sdp.common.SDPClientException;
import com.airbiquity.sdp.interfaces.AqConnectionListener;
import kona.network.connectivitymanager.ConnectivityManagerException;
import kona.network.connectivitymanager.NetworkInfo;

public interface AqConnectivityManager {
    public void connectInternet() throws ConnectivityManagerException, SDPClientException;

    public void connectInternet(AqConnectionListener var1) throws ConnectivityManagerException;

    public void connectInternet(NetworkInfo var1) throws ConnectivityManagerException;

    public void disconnectInternet(NetworkInfo var1) throws ConnectivityManagerException;

    public void setConnectAttemptCount(int var1);

    public NetworkInfo getConnectedNetwork() throws ConnectivityManagerException;
}

