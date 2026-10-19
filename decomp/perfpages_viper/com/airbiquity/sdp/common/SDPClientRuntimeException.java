/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

public class SDPClientRuntimeException
extends RuntimeException {
    private static final long serialVersionUID = -3462124117142195006L;

    public SDPClientRuntimeException(String message) {
        super(message);
    }

    public SDPClientRuntimeException(String message, Throwable cause) {
        super(message, cause);
    }

    public SDPClientRuntimeException(Throwable cause) {
        super(cause);
    }
}

