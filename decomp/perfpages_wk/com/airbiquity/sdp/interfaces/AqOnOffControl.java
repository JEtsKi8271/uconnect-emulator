/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.onoffcontrol.OnOffControlException
 */
package com.airbiquity.sdp.interfaces;

import kona.onoffcontrol.OnOffControlException;

public interface AqOnOffControl {
    public boolean registerSMSbusy() throws OnOffControlException;

    public boolean busySMSDone() throws OnOffControlException;

    public boolean registerSDPsyncBusy() throws OnOffControlException;

    public boolean busySdpSyncDone() throws OnOffControlException;
}

