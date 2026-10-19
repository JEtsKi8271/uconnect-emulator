/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import java.util.Date;

public class NgtpUtil {
    public static int date2Ngtp(Date date) {
        long l2 = date.getTime();
        if (l2 < 946684800000L) {
            throw new IllegalArgumentException("Supplied timestamp is not a valid NGTP time: " + l2);
        }
        return (int)((l2 - 946684800000L) / 1000L);
    }

    public static Date ngtp2Date(int n2) {
        return new Date((long)n2 * 1000L + 946684800000L);
    }
}

