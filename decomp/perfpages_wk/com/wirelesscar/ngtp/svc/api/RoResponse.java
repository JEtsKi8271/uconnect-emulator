/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.SimpleRo;
import java.util.Date;

public interface RoResponse {
    public void addOperationDescription(String var1, int var2, String var3);

    public SimpleRo getOperationDesc();

    public int getTimesExecuted();

    public Date getLastExecuted();

    public boolean existsErrorDesc();

    public String getErrorDesc();
}

