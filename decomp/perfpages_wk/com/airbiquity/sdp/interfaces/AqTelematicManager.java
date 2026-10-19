/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.automotive.TelematicException
 */
package com.airbiquity.sdp.interfaces;

import kona.automotive.TelematicException;

public interface AqTelematicManager {
    public String getDataLog() throws TelematicException;

    public String getHistogram() throws TelematicException;

    public void clearHistogram() throws TelematicException;

    public String getESN() throws TelematicException;

    public int getsubStatus() throws TelematicException;

    public String getMDN() throws TelematicException;

    public String getMEID() throws TelematicException;

    public String getMIN() throws TelematicException;

    public String getIccId();
}

