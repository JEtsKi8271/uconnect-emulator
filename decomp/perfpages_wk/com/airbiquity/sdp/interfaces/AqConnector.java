/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.SensorConnection
 */
package com.airbiquity.sdp.interfaces;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import konax.sensors.SensorConnection;

public interface AqConnector {
    public SensorConnection open(String var1) throws IOException;

    public SensorConnection open(String var1, int var2) throws IOException;

    public SensorConnection open(String var1, int var2, boolean var3) throws IOException;

    public DataInputStream openDataInputStream(String var1) throws IOException;

    public DataOutputStream openDataOutputStream(String var1) throws IOException;

    public InputStream openInputStream(String var1) throws IOException;

    public OutputStream openOutputStream(String var1) throws IOException;
}

