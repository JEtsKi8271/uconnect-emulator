/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.a.a;
import com.wirelesscar.ngtp.dspt.a.ac;
import com.wirelesscar.ngtp.dspt.a.ad;
import com.wirelesscar.ngtp.dspt.a.k;
import com.wirelesscar.ngtp.dspt.a.o;
import com.wirelesscar.ngtp.dspt.a.s;
import com.wirelesscar.ngtp.dspt.a.u;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.api.DsptDownlinkMessage;
import com.wirelesscar.ngtp.dspt.api.Timestamp;
import com.wirelesscar.ngtp.dspt.api.Version;
import com.wirelesscar.ngtp.dspt.api.c;

final class f
extends c
implements DsptDownlinkMessage {
    f(int n2, String string, Timestamp timestamp, boolean bl2) {
        Object object;
        try {
            ((f)this).a.f();
            object = this = ((f)this).a.e();
            object = ((ad)this).b;
            ((o)object).a.b(0L);
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
        object = this;
        ((ad)object).a.a(n2);
        object = this;
        object = ((ad)object).a;
        f.a(string, ((a)object).d);
        object = this;
        object = ((ad)object).a;
        ((a)object).e.a(timestamp.getNgtpTime());
        object = this;
        object = ((ad)object).a;
        ((a)object).e.b(timestamp.getNgtpMillis());
        object = this;
        ((ad)object).a.c(3L);
        object = this;
        ((ad)object).a.b(bl2 ? 1L : 0L);
        Timestamp timestamp2 = Timestamp.now();
        object = this;
        object = ((ad)object).a;
        ((a)object).m.a(timestamp2.getNgtpTime());
        object = this;
        object = ((ad)object).a;
        ((a)object).m.b(timestamp2.getNgtpMillis());
    }

    f(u u2, byte[] byArray) {
        super(u2, byArray);
    }

    private o a() {
        try {
            ad ad2 = ((f)((Object)ad2)).a.e();
            return ad2.b;
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
    }

    public final Version getServiceDataVersion() {
        Object object = ((f)this).a();
        Object object2 = this = ((o)object).c;
        object = object2;
        object = this;
        return new Version((int)((s)object2).a.b(), (int)((s)object).b.b());
    }

    public final int getServiceDataEncodingType() {
        Object object = ((f)object).a();
        object = ((o)object).b;
        return (int)((k)object).a.b();
    }

    public final byte[] getServiceData() {
        return this.b;
    }

    public final void setServiceData(byte[] byArray, Version version, int n2) {
        o o2;
        ac ac2 = o2 = this.a();
        o2.c.a(version.getMajor());
        ac2 = o2;
        ac2.c.b(version.getMinor());
        ac2 = o2;
        ac2 = ac2.b;
        ((k)ac2).b.a(2L);
        ac2 = o2;
        ac2 = ac2.b;
        ((k)ac2).b.b(0L);
        ac2 = o2;
        ac2.b.a(n2);
        ac2 = o2;
        f.a(byArray, ac2.a);
        this.b = byArray;
    }
}

