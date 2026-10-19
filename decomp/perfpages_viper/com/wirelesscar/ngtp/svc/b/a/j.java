/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.ai;
import com.wirelesscar.ngtp.svc.a.c.u;
import com.wirelesscar.ngtp.svc.api.DecodeException;
import com.wirelesscar.ngtp.svc.api.EncodeException;
import com.wirelesscar.ngtp.svc.api.MessageCoder;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.SvcMessage;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.a.a;
import com.wirelesscar.ngtp.svc.b.a.c;
import com.wirelesscar.ngtp.svc.b.a.e;
import com.wirelesscar.ngtp.svc.b.a.g;
import com.wirelesscar.ngtp.svc.b.a.h;
import java.util.Date;

public final class j
implements MessageCoder {
    private int a;

    public final Version getVersion() {
        return new Version(2, 0);
    }

    public final SvcUplinkMessage createUplinkMessage() {
        return new a();
    }

    public final SvcDownlinkMessage createDownlinkMessage() {
        return new h();
    }

    public final RoRequestList createRemoteOperationRequestList(Version version, String string, Integer n2, Integer n3) {
        return new e(version, string, n2, n3);
    }

    public final RoResponseList createRemoteOperationResponseList(Version version, Integer n2, Date date) {
        return new c(version, n2, date);
    }

    public final SvcUplinkMessage createUplinkMessage(RoResponseList roResponseList, boolean bl2) {
        return new a(roResponseList, bl2);
    }

    public final SvcDownlinkMessage createDownlinkMessage(RoRequestList roRequestList) {
        return new h(roRequestList);
    }

    public final SvcUplinkMessage createUplinkMessage(String string) {
        a a2 = new a();
        a2.setGenericText(string);
        return a2;
    }

    public final SvcDownlinkMessage createDownlinkMessage(String string) {
        h h2 = new h();
        h2.setGenericText(string);
        return h2;
    }

    public final SvcMessage decode(byte[] object) throws DecodeException {
        if (object == null || ((byte[])object).length < 1) {
            throw new DecodeException("Not enough data to decode");
        }
        Object object2 = new u((byte[])object);
        object = new ai();
        try {
            ((ai)object).b((u)object2);
            object2 = object;
            switch (((ai)object2).g.g()) {
                case 1: {
                    return new h((ai)object);
                }
                case 0: {
                    return new a((ai)object);
                }
            }
            object2 = object;
            throw new RuntimeException("Unknown message type: " + ((ai)object2).g.g());
        }
        catch (com.wirelesscar.ngtp.svc.a.c.j j2) {
            object2 = j2;
            j2.printStackTrace();
            throw new DecodeException((Throwable)object2);
        }
    }

    public final byte[] encode(SvcMessage object) throws EncodeException {
        if (!(object instanceof g)) {
            throw new EncodeException("Cannot encode class: " + object.getClass().getName());
        }
        object = (g)object;
        object = ((g)object).a;
        int n2 = this.a;
        if (n2 <= 0) {
            n2 = (int)((((ai)object).b() + 7L) / 8L);
        }
        Object object2 = new u(n2);
        try {
            ((ai)object).a((u)object2);
            byte[] byArray = ((u)object2).a();
            object2 = byArray;
            return byArray;
        }
        catch (com.wirelesscar.ngtp.svc.a.c.j j2) {
            throw new EncodeException(j2);
        }
    }

    public final void setEncodeBufferSize(int n2) {
        this.a = n2;
    }
}

