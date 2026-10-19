/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bd;
import com.wirelesscar.ngtp.svc.a.b.cd;
import com.wirelesscar.ngtp.svc.api.DecodeException;
import com.wirelesscar.ngtp.svc.api.EncodeException;
import com.wirelesscar.ngtp.svc.api.MessageCoder;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.SvcMessage;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.c.c;
import com.wirelesscar.ngtp.svc.b.c.h;
import com.wirelesscar.ngtp.svc.b.c.i;
import com.wirelesscar.ngtp.svc.b.c.j;
import com.wirelesscar.ngtp.svc.b.c.l;
import java.util.Date;

public final class b
implements MessageCoder {
    private int a = 0;

    public final void setEncodeBufferSize(int n2) {
        this.a = n2;
    }

    public final Version getVersion() {
        return new Version(2, 1);
    }

    public final SvcUplinkMessage createUplinkMessage() {
        return new i();
    }

    public final SvcDownlinkMessage createDownlinkMessage() {
        return new l();
    }

    public final RoRequestList createRemoteOperationRequestList(Version version, String string, Integer n2, Integer n3) {
        return new c(version, string, n2, n3);
    }

    public final RoResponseList createRemoteOperationResponseList(Version version, Integer n2, Date date) {
        return new j(version, n2, date);
    }

    public final SvcUplinkMessage createUplinkMessage(RoResponseList roResponseList, boolean bl2) {
        return new i(roResponseList, bl2);
    }

    public final SvcDownlinkMessage createDownlinkMessage(RoRequestList roRequestList) {
        return new l(roRequestList);
    }

    public final SvcUplinkMessage createUplinkMessage(String string) {
        i i2 = new i();
        i2.setGenericText(string);
        return i2;
    }

    public final SvcDownlinkMessage createDownlinkMessage(String string) {
        l l2 = new l();
        l2.setGenericText(string);
        return l2;
    }

    public final SvcMessage decode(byte[] object) throws DecodeException {
        if (object == null || ((byte[])object).length < 1) {
            throw new DecodeException("Not enough data to decode");
        }
        Object object2 = new bd((byte[])object);
        object = new cd();
        try {
            ((cd)object).a((bd)object2);
            object2 = object;
            switch (((cd)object2).g.g()) {
                case 1: {
                    return new l((cd)object);
                }
                case 0: {
                    return new i((cd)object);
                }
            }
            object2 = object;
            throw new RuntimeException("Unknown message type: " + ((cd)object2).g.g());
        }
        catch (ai ai2) {
            throw new DecodeException(ai2);
        }
    }

    public final byte[] encode(SvcMessage object) throws EncodeException {
        if (!(object instanceof h)) {
            throw new EncodeException("Cannot encode class: " + object.getClass().getName());
        }
        object = (h)object;
        object = ((h)object).a;
        int n2 = this.a;
        if (n2 <= 0) {
            n2 = (int)((((cd)object).a() + 7L) / 8L);
        }
        Object object2 = new bd(n2);
        try {
            ((cd)object).b((bd)object2);
            byte[] byArray = ((bd)object2).a();
            object2 = byArray;
            return byArray;
        }
        catch (ai ai2) {
            object2 = ai2;
            ai2.printStackTrace();
            throw new EncodeException((Throwable)object2);
        }
    }
}

