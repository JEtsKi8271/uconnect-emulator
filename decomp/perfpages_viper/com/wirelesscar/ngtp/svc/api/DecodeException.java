/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class DecodeException
extends Exception {
    public DecodeException(Throwable throwable) {
        super(throwable != null ? throwable.getMessage() + " [" + throwable.getClass().getName() + "]" : "NULL");
    }

    public DecodeException(String string) {
        super(string);
    }
}

