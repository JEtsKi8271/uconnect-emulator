/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import java.io.Serializable;
import java.util.Date;

public interface EventHandle
extends Serializable {
    public int getServiceType();

    public Date getDate();

    public boolean isEventBackendInitiated();
}

