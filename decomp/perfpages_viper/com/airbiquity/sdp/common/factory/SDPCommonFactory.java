/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.factory;

import com.wirelesscar.ngtp.dspt.api.Timestamp;
import java.util.Date;

public class SDPCommonFactory {
    private SDPCommonFactory() {
    }

    public static long getCurrentTimeMs() {
        return System.currentTimeMillis();
    }

    public static Date getCurrentDate() {
        return new Date(SDPCommonFactory.getCurrentTimeMs());
    }

    public static Timestamp getNGTPTimestamp() {
        long time = SDPCommonFactory.getCurrentTimeMs();
        return Timestamp.fromJavaMillis(time);
    }
}

