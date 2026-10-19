/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.appManager.AppManagerException
 */
package com.airbiquity.sdp.interfaces;

import kona.appManager.AppManagerException;

public interface AqAppManager {
    public String getDRM(String var1) throws AppManagerException;

    public String getAllDRM(String var1) throws AppManagerException;
}

