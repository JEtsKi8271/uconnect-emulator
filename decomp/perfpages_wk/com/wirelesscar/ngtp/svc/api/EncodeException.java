/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class EncodeException
extends Exception {
    public EncodeException(Throwable throwable) {
        super(throwable != null ? throwable.getMessage() + " [" + throwable.getClass().getName() + "]" : "NULL");
    }

    public EncodeException(String string) {
        super(string);
    }
}

