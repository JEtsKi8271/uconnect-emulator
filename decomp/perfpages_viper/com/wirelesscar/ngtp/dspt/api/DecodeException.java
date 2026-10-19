/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

public class DecodeException
extends Exception {
    public DecodeException(Throwable throwable) {
        super(throwable != null ? throwable.toString() : "NULL");
    }

    public DecodeException(String string) {
        super(string);
    }
}

