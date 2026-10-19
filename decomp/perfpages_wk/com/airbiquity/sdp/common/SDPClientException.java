/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

public class SDPClientException
extends Exception {
    private static final long serialVersionUID = -8403600050642096794L;

    public SDPClientException() {
    }

    public SDPClientException(String message) {
        super(message);
    }

    public SDPClientException(String message, Throwable cause) {
        super(message, cause);
    }

    public SDPClientException(Throwable cause) {
        super(cause);
    }
}

