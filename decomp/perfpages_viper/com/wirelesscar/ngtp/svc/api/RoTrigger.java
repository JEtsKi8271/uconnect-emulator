/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import java.util.Date;

public interface RoTrigger {
    public static final int NOW = 0;
    public static final int AT_CONVENIENCE = 1;
    public static final int NO_LATER_THAN = 3;

    public int getTrigger();

    public void setNow();

    public void setAtConvenicence();

    public void setNoLaterThan(Date var1);

    public Date getNoLaterThan();
}

