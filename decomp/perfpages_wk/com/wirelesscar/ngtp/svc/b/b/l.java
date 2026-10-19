/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.ck;
import com.wirelesscar.ngtp.svc.a.a.n;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.api.DecodeException;
import com.wirelesscar.ngtp.svc.api.EncodeException;
import com.wirelesscar.ngtp.svc.api.MessageCoder;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.SvcMessage;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.b.b;
import com.wirelesscar.ngtp.svc.b.b.d;
import com.wirelesscar.ngtp.svc.b.b.f;
import com.wirelesscar.ngtp.svc.b.b.g;
import com.wirelesscar.ngtp.svc.b.b.k;
import java.util.Date;

public final class l
implements MessageCoder {
    private int a = 0;

    public final void setEncodeBufferSize(int n2) {
        this.a = n2;
    }

    public final Version getVersion() {
        return new Version(2, 2);
    }

    public final SvcUplinkMessage createUplinkMessage() {
        return new f();
    }

    public final SvcDownlinkMessage createDownlinkMessage() {
        return new k();
    }

    public final RoRequestList createRemoteOperationRequestList(Version version, String string, Integer n2, Integer n3) {
        return new d(version, string, n2, n3);
    }

    public final RoResponseList createRemoteOperationResponseList(Version version, Integer n2, Date date) {
        return new g(version, n2, date);
    }

    public final SvcUplinkMessage createUplinkMessage(RoResponseList roResponseList, boolean bl2) {
        return new f(roResponseList, bl2);
    }

    public final SvcDownlinkMessage createDownlinkMessage(RoRequestList roRequestList) {
        return new k(roRequestList);
    }

    public final SvcUplinkMessage createUplinkMessage(String string) {
        f f2 = new f();
        f2.setGenericText(string);
        return f2;
    }

    public final SvcDownlinkMessage createDownlinkMessage(String string) {
        k k2 = new k();
        k2.setGenericText(string);
        return k2;
    }

    public final SvcMessage decode(byte[] object) throws DecodeException {
        if (object == null || ((byte[])object).length < 1) {
            throw new DecodeException("Not enough data to decode");
        }
        Object object2 = new n((byte[])object);
        object = new ck();
        try {
            ((ck)object).a((n)object2);
            object2 = object;
            switch (((ck)object2).g.f()) {
                case 1: {
                    return new k((ck)object);
                }
                case 0: {
                    return new f((ck)object);
                }
            }
            object2 = object;
            throw new RuntimeException("Unknown message type: " + ((ck)object2).g.f());
        }
        catch (o o2) {
            throw new DecodeException(o2);
        }
    }

    public final byte[] encode(SvcMessage object) throws EncodeException {
        if (!(object instanceof b)) {
            throw new EncodeException("Cannot encode class: " + object.getClass().getName());
        }
        object = (b)object;
        object = ((b)object).a;
        int n2 = this.a;
        if (n2 <= 0) {
            n2 = (int)((((ck)object).b() + 7L) / 8L);
        }
        Object object2 = new n(n2);
        try {
            ((ck)object).b((n)object2);
            byte[] byArray = ((n)object2).a();
            object2 = byArray;
            return byArray;
        }
        catch (o o2) {
            object2 = o2;
            o2.printStackTrace();
            throw new EncodeException((Throwable)object2);
        }
    }
}

