/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.MessageCoder;
import com.wirelesscar.ngtp.dspt.api.Version;
import com.wirelesscar.ngtp.dspt.api.d;

public class MessageCoderFactory {
    private MessageCoderFactory() {
    }

    public static MessageCoder getMessageCoder(Version version) {
        if (version.getMajor() == 2 && version.getMinor() == 0) {
            return new d();
        }
        throw new IllegalArgumentException("Unknown coder version: " + version);
    }
}

