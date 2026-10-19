/*
 * Decompiled with CFR 0.152.
 */
package org.json;

public class JSONException
extends Exception {
    private Throwable cause;

    public JSONException(String message) {
        super(message);
    }

    public JSONException(Throwable t2) {
        super(t2.getMessage());
        this.cause = t2;
    }

    @Override
    public Throwable getCause() {
        return this.cause;
    }
}

