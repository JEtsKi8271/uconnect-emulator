/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import java.io.Serializable;

public interface DsptMessageWrapper
extends Serializable {
    public DsptMessage getDsptMessage();
}

