/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  kona.network.connectivitymanager.ConnectivityManager
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.util;

import kona.logger.Log;
import kona.network.connectivitymanager.ConnectivityManager;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;

public class NetworkUtils {
    protected static Logger _logger = Log.createLogger((String)NetworkUtils.class.getName());

    public static boolean isInternetAvailable() {
        boolean internetAvailable = false;
        try {
            if (PlatformInfo.getPlatformInfo().isEmbeddedPhonePresent()) {
                _logger.debug((Object)"<------ Attempting to connect to internet ------>");
                ConnectivityManager.getConnectivityManager().getConnectivity().connectInternet();
                internetAvailable = true;
                _logger.debug((Object)"<------ SUCCESS: Internet connection available ------>");
            } else {
                _logger.debug((Object)"<------ ERROR: Embedded phone not available ------>");
            }
        }
        catch (Throwable e2) {
            _logger.debug((Object)("<------ ERROR: Failed to connect to internet with error [" + e2.getMessage() + "] ------>"));
        }
        return internetAvailable;
    }
}

