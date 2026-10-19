/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.a.ab;
import com.wirelesscar.ngtp.dspt.a.ac;
import com.wirelesscar.ngtp.dspt.a.af;
import com.wirelesscar.ngtp.dspt.a.e;
import com.wirelesscar.ngtp.dspt.a.g;
import com.wirelesscar.ngtp.dspt.a.k;
import com.wirelesscar.ngtp.dspt.a.s;
import com.wirelesscar.ngtp.dspt.a.u;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.api.DsptUplinkMessage;
import com.wirelesscar.ngtp.dspt.api.Position;
import com.wirelesscar.ngtp.dspt.api.Timestamp;
import com.wirelesscar.ngtp.dspt.api.Version;
import com.wirelesscar.ngtp.dspt.api.c;

final class a
extends c
implements DsptUplinkMessage {
    a(int n2, String string, Timestamp timestamp, boolean bl2) {
        Object object;
        try {
            ((a)this).a.d();
            object = this = ((a)this).a.c();
            object = ((ab)this).b;
            ((g)object).g.b(0L);
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
        object = this;
        ((ab)object).a.a(n2);
        object = this;
        object = ((ab)object).a;
        com.wirelesscar.ngtp.dspt.api.a.a(string, ((com.wirelesscar.ngtp.dspt.a.a)object).d);
        object = this;
        object = ((ab)object).a;
        ((com.wirelesscar.ngtp.dspt.a.a)object).e.a(timestamp.getNgtpTime());
        object = this;
        object = ((ab)object).a;
        ((com.wirelesscar.ngtp.dspt.a.a)object).e.b(timestamp.getNgtpMillis());
        object = this;
        ((ab)object).a.c(2L);
        object = this;
        ((ab)object).a.b(bl2 ? 1L : 0L);
        Timestamp timestamp2 = Timestamp.now();
        object = this;
        object = ((ab)object).a;
        ((com.wirelesscar.ngtp.dspt.a.a)object).m.a(timestamp2.getNgtpTime());
        object = this;
        object = ((ab)object).a;
        ((com.wirelesscar.ngtp.dspt.a.a)object).m.b(timestamp2.getNgtpMillis());
    }

    a(u u2, byte[] byArray) {
        super(u2, byArray);
    }

    private g a() {
        try {
            ab ab2 = ((a)((Object)ab2)).a.c();
            return ab2.b;
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
    }

    public final Version getServiceDataVersion() {
        Object object = ((a)this).a();
        Object object2 = this = ((g)object).i;
        object = object2;
        object = this;
        return new Version((int)((s)object2).a.b(), (int)((s)object).b.b());
    }

    public final int getServiceDataEncodingType() {
        Object object = ((a)object).a();
        object = ((g)object).h;
        return (int)((k)object).a.b();
    }

    public final byte[] getServiceData() {
        return this.b;
    }

    public final void setServiceData(byte[] byArray, Version version, int n2) {
        g g2;
        ac ac2 = g2 = this.a();
        g2.i.a(version.getMajor());
        ac2 = g2;
        ac2.i.b(version.getMinor());
        ac2 = g2;
        ac2 = ac2.h;
        ((k)ac2).b.a(2L);
        ac2 = g2;
        ac2 = ac2.h;
        ((k)ac2).b.b(0L);
        ac2 = g2;
        ac2.h.a(n2);
        ac2 = g2;
        com.wirelesscar.ngtp.dspt.api.a.a(byArray, ac2.g);
        this.b = byArray;
    }

    public final void setBasicPosition(Position position) {
        Object object = this = ((a)this).a();
        long l2 = position.getNgtpLatitude();
        object = ((g)this).c;
        ((e)object).a.b(l2);
        object = this;
        l2 = position.getNgtpLongitude();
        object = ((g)object).c;
        ((e)object).b.b(l2);
    }

    public final void setHMILanguage(int n2) {
        g g2 = ((a)object).a();
        Object object = g2;
        long l2 = n2;
        object = g2;
        g2.f.b(l2);
        n2 = 1;
        object = ((g)object).a;
        ((g)object).a.d = n2;
    }

    public final Position getBasicPosition() {
        Object object = this = ((a)this).a();
        e e2 = ((g)object).c;
        object = e2;
        object = this;
        object = ((g)object).c;
        return new Position((int)e2.a.b(), (int)((e)object).b.b());
    }

    public final int getHMILanguage() {
        g g2 = ((a)object).a();
        Object object = g2;
        object = g2;
        return (int)g2.f.b();
    }

    public final void setCrqmRequest(boolean bl2) {
        Object object = ((a)object).a();
        object = ((g)object).b;
        ((g)object).b.d = bl2;
    }

    public final boolean isCrqmRequest() {
        Object object = ((a)object).a();
        object = ((g)object).b;
        return ((af)object).d;
    }

    public final void setCurrentNetwork(String string) {
        g g2 = ((a)((Object)g2)).a();
        if (string != null) {
            g2.a(true);
            g2.d.a(string);
            return;
        }
        g2.a(false);
    }

    public final String getCurrentNetwork() {
        if ((this = ((a)this).a()) != null) {
            Object object = this;
            if (((g)object).d != null) {
                object = this;
                return ((g)object).d.c();
            }
        }
        return null;
    }

    public final void setHomeNetwork(String string) {
        g g2 = ((a)((Object)g2)).a();
        if (string != null) {
            g2.b(true);
            g2.e.a(string);
            return;
        }
        g2.b(false);
    }

    public final String getHomeNetwork() {
        if ((this = ((a)this).a()) != null) {
            Object object = this;
            if (((g)object).e != null) {
                object = this;
                return ((g)object).e.c();
            }
        }
        return null;
    }
}

