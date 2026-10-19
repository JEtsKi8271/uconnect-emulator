/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.api.InvalidSignatureException;

public interface SecurityProvider {
    public byte[] getSecurityContext(String var1, int var2);

    public byte[] getNgtpDispatcherSignature(byte[] var1, byte[] var2);

    public byte[] getNgtpMessageSignature(byte[] var1, byte[] var2);

    public int getNgtpDispatcherSignatureLength(byte[] var1);

    public void verifyNgtpDispatcherSignature(byte[] var1, byte[] var2, byte[] var3) throws InvalidSignatureException;

    public int getNgtpMessageSignatureLength(byte[] var1);

    public void verifyNgtpMessageSignature(byte[] var1, byte[] var2, byte[] var3) throws InvalidSignatureException;
}

