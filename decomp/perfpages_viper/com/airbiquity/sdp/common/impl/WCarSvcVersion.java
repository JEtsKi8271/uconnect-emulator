/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.impl;

import com.wirelesscar.ngtp.svc.api.MessageCoderFactory;
import java.io.Serializable;

public class WCarSvcVersion
implements Serializable {
    private static final long serialVersionUID = 1L;
    private int major;
    private int minor;

    public WCarSvcVersion(int major, int minor) {
        this.major = major;
        this.minor = minor;
    }

    public static WCarSvcVersion getDefaultWCarSvcVersion() {
        return new WCarSvcVersion(MessageCoderFactory.getDefaultMessageCoder().getVersion().getMajor(), MessageCoderFactory.getDefaultMessageCoder().getVersion().getMinor());
    }

    public int getMajor() {
        return this.major;
    }

    public int getMinor() {
        return this.minor;
    }
}

