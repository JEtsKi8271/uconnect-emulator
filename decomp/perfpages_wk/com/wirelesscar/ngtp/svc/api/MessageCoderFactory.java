/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.MessageCoder;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.a.j;
import com.wirelesscar.ngtp.svc.b.b.l;
import com.wirelesscar.ngtp.svc.b.c.b;

public class MessageCoderFactory {
    private MessageCoderFactory() {
    }

    public static MessageCoder getDefaultMessageCoder() {
        return MessageCoderFactory.getMessageCoderByVersion(new Version(2, 2));
    }

    public static MessageCoder getMessageCoder(Version version) {
        return MessageCoderFactory.getMessageCoderByVersion(version);
    }

    public static MessageCoder getMessageCoderByVersion(Version version) {
        if (version.getMajor() == 2 && version.getMinor() == 0) {
            return new j();
        }
        if (version.getMajor() == 2 && version.getMinor() == 1) {
            return new b();
        }
        if (version.getMajor() == 2 && version.getMinor() == 2) {
            return new l();
        }
        throw new IllegalArgumentException("Unknown coder version: " + version);
    }
}

