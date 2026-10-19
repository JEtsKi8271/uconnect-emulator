/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.a.f;
import com.wirelesscar.ngtp.dspt.a.q;
import com.wirelesscar.ngtp.dspt.a.u;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.api.DecodeException;
import com.wirelesscar.ngtp.dspt.api.DsptControlMessage;
import com.wirelesscar.ngtp.dspt.api.DsptDownlinkMessage;
import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import com.wirelesscar.ngtp.dspt.api.DsptUplinkMessage;
import com.wirelesscar.ngtp.dspt.api.EncodeException;
import com.wirelesscar.ngtp.dspt.api.InvalidSignatureException;
import com.wirelesscar.ngtp.dspt.api.MessageCoder;
import com.wirelesscar.ngtp.dspt.api.SecurityProvider;
import com.wirelesscar.ngtp.dspt.api.Timestamp;
import com.wirelesscar.ngtp.dspt.api.a;
import com.wirelesscar.ngtp.dspt.api.b;
import com.wirelesscar.ngtp.dspt.api.c;
import com.wirelesscar.ngtp.dspt.api.e;

final class d
implements MessageCoder {
    private SecurityProvider a = e.a;

    d() {
    }

    public final void setSecurityProvider(SecurityProvider securityProvider) {
        if (securityProvider == null) {
            this.a = e.a;
            return;
        }
        this.a = securityProvider;
    }

    public final DsptDownlinkMessage createDownlinkMessage(int n2, String string, Timestamp timestamp, boolean bl2) {
        return new com.wirelesscar.ngtp.dspt.api.f(n2, string, timestamp, bl2);
    }

    public final DsptUplinkMessage createUplinkMessage(int n2, String string, Timestamp timestamp, boolean bl2) {
        return new a(n2, string, timestamp, bl2);
    }

    public final DsptControlMessage createControlMessage(int n2, String string, Timestamp timestamp, boolean bl2) {
        return new b(n2, string, timestamp, bl2);
    }

    public final DsptMessage decode(byte[] byArray) throws DecodeException, InvalidSignatureException {
        try {
            return this.a(byArray);
        }
        catch (RuntimeException runtimeException) {
            throw new DecodeException(runtimeException);
        }
    }

    private DsptMessage a(byte[] byArray) throws DecodeException, InvalidSignatureException {
        int n2;
        if (byArray == null || byArray.length < 5) {
            throw new DecodeException("Not enough data to decode");
        }
        if (byArray[0] != 32) {
            throw new DecodeException("Unsupported version: " + Integer.toHexString(byArray[0]));
        }
        byte[] byArray2 = new byte[2];
        System.arraycopy(byArray, 1, byArray2, 0, byArray2.length);
        if (byArray[4] != 1) {
            throw new DecodeException("Unsupported header encoding: " + byArray[4]);
        }
        int n3 = byArray[3] & 0xFF;
        if (n3 > byArray.length) {
            throw new DecodeException("Not enough data to decode. Expected length: " + byArray[3] + ". Actual length: " + byArray.length);
        }
        if (n3 < 0) {
            throw new DecodeException("DSPT MessageLength provided in NGTP header is negative: " + n3);
        }
        byte[] byArray3 = new byte[n3];
        System.arraycopy(byArray, 0, byArray3, 0, byArray3.length);
        int n4 = this.a.getNgtpDispatcherSignatureLength(byArray2);
        if (n4 > 0) {
            byte[] byArray4 = new byte[n4];
            System.arraycopy(byArray, byArray3.length, byArray4, 0, n4);
            this.a.verifyNgtpDispatcherSignature(byArray3, byArray2, byArray4);
        }
        if ((n2 = n3 - 5) < 0) {
            throw new DecodeException("Invalid header. NGTPHeaderLength=" + n2);
        }
        Object object = new byte[n2];
        System.arraycopy(byArray, 5, object, 0, n2);
        object = new q((byte[])object);
        u u2 = new u();
        try {
            byte[] byArray5;
            u2.a((q)object);
            int n5 = c.a(u2);
            byArray3 = new byte[byArray3.length + n4 + n5];
            if (byArray3.length > byArray.length) {
                throw new DecodeException("Invalid DSPT data. ServiceDataLength (" + n5 + ") is larger than available data. (" + byArray3.length + ">" + byArray.length + ")");
            }
            System.arraycopy(byArray, 0, byArray3, 0, byArray3.length);
            int n6 = this.a.getNgtpMessageSignatureLength(byArray2);
            if (n6 > 0) {
                byArray5 = new byte[n6];
                System.arraycopy(byArray, byArray3.length, byArray5, 0, n6);
                this.a.verifyNgtpMessageSignature(byArray3, byArray2, byArray5);
            }
            byArray5 = new byte[n5];
            int n7 = n2 + 5 + n4;
            System.arraycopy(byArray, n7, byArray5, 0, n5);
            switch (u2.b()) {
                case 1: {
                    return new com.wirelesscar.ngtp.dspt.api.f(u2, byArray5);
                }
                case 0: {
                    return new a(u2, byArray5);
                }
                case 2: {
                    return new b(u2);
                }
            }
            throw new DecodeException("Unknown message type: " + u2.b());
        }
        catch (w w2) {
            throw new DecodeException(w2);
        }
    }

    public final byte[] encode(DsptMessage dsptMessage) throws EncodeException {
        try {
            return this.a(dsptMessage);
        }
        catch (RuntimeException runtimeException) {
            throw new EncodeException(runtimeException);
        }
    }

    private byte[] a(DsptMessage object) throws EncodeException {
        if (!(object instanceof c)) {
            throw new EncodeException("Cannot encode class: " + object.getClass().getName());
        }
        Object object2 = (c)object;
        Object object3 = ((c)object2).a;
        object2 = ((c)object2).b;
        Object object4 = new q();
        try {
            byte[] byArray;
            int n2;
            ((f)object3).b((q)object4);
            object3 = ((q)object4).a();
            byte[] byArray2 = this.a.getSecurityContext(object.getVin(), object.getServiceType());
            object = byArray2;
            if (byArray2 == null || ((Object)object).length != 2) {
                throw new EncodeException("Invalid SecurityContext from SecurityProvider");
            }
            byte[] byArray3 = new byte[5 + ((Object)object3).length];
            object4 = byArray3;
            byArray3[0] = 32;
            object4[1] = object[0];
            object4[2] = object[1];
            object4[3] = (byte)((Object)object4).length;
            object4[4] = true;
            System.arraycopy(object3, 0, object4, 5, ((Object)object3).length);
            byte[] byArray4 = this.a.getNgtpDispatcherSignature((byte[])object4, (byte[])object);
            object3 = byArray4;
            int n3 = byArray4 != null ? ((Object)object3).length : 0;
            int n4 = object2 != null ? ((Object)object2).length : 0;
            Object object5 = new byte[((Object)object4).length + n3 + n4];
            System.arraycopy(object4, 0, object5, 0, ((Object)object4).length);
            if (n3 > 0) {
                System.arraycopy(object3, 0, object5, ((Object)object4).length, n3);
            }
            if (n4 > 0) {
                int n5 = ((Object)object4).length + n3;
                System.arraycopy(object2, 0, object5, n5, ((Object)object2).length);
            }
            if ((n2 = (byArray = this.a.getNgtpMessageSignature((byte[])object5, (byte[])object)) != null ? byArray.length : 0) > 0) {
                object = new byte[((byte[])object5).length + n2];
                System.arraycopy(object5, 0, object, 0, ((byte[])object5).length);
                System.arraycopy(byArray, 0, object, ((byte[])object5).length, n2);
                object5 = object;
            }
            return object5;
        }
        catch (w w2) {
            throw new EncodeException(w2);
        }
    }
}

