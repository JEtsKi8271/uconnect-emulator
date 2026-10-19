/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public interface SimpleRo {
    public String getComponent();

    public int getRemoteOperationType();

    public boolean existsState();

    public String getState();
}

