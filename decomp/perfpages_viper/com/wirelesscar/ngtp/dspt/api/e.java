/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.SecurityProvider;

final class e
implements SecurityProvider {
    private static final byte[] b = new byte[]{0, 0};
    static final e a = new e();

    private e() {
    }

    public final byte[] getSecurityContext(String string, int n2) {
        return b;
    }

    public final byte[] getNgtpDispatcherSignature(byte[] byArray, byte[] byArray2) {
        return null;
    }

    public final byte[] getNgtpMessageSignature(byte[] byArray, byte[] byArray2) {
        return null;
    }

    public final int getNgtpDispatcherSignatureLength(byte[] byArray) {
        return 0;
    }

    public final void verifyNgtpDispatcherSignature(byte[] byArray, byte[] byArray2, byte[] byArray3) {
    }

    public final int getNgtpMessageSignatureLength(byte[] byArray) {
        return 0;
    }

    public final void verifyNgtpMessageSignature(byte[] byArray, byte[] byArray2, byte[] byArray3) {
    }
}

