/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

public class EncodeException
extends Exception {
    public EncodeException(Throwable throwable) {
        super(throwable != null ? throwable.toString() : "NULL");
    }

    public EncodeException(String string) {
        super(string);
    }
}

