/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ab;
import com.wirelesscar.ngtp.svc.a.c.ai;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bb;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.l;
import com.wirelesscar.ngtp.svc.api.PointOfInterest;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.b.a.e;
import com.wirelesscar.ngtp.svc.b.a.g;

final class h
extends g
implements SvcDownlinkMessage {
    private RoRequestList b;

    h(ai g2) {
        super((ai)g2);
        this.b = null;
        try {
            ap ap2 = g2;
            ap2 = ap2.g.e();
            ap2 = ((ab)ap2).a;
            if (((aa)ap2).d) {
                ap2 = g2;
                ap2 = ap2.g.e();
                g2 = ((ab)ap2).c;
                this.b = new e((l)g2);
            }
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.getMessage());
        }
    }

    h(RoRequestList roRequestList) {
        ((h)((Object)ab2)).b = null;
        try {
            ((h)((Object)ab2)).a.b(true);
            ai ai2 = ((h)((Object)ab2)).a;
            ai2.g.f();
            ai2 = ((h)((Object)ab2)).a;
            ab ab2 = ai2.g.e();
            boolean bl2 = true;
            Object object = ab2;
            boolean bl3 = true;
            object = ab2.a;
            ab2.a.d = bl3;
            object = ab2;
            ((e)roRequestList).a(((ab)object).c);
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.toString());
        }
    }

    h() {
        ((h)((Object)ai2)).b = null;
        try {
            ((h)((Object)ai2)).a.b(true);
            ai ai2 = ((h)((Object)ai2)).a;
            ai2.g.f();
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.toString());
        }
    }

    public final boolean isRemoteOperationUpdateRequest() {
        return this.b != null;
    }

    public final RoRequestList getRemoteOperationRequestList() {
        return this.b;
    }

    public final String getGenericText() {
        ap ap2 = this.a();
        ap2 = ap2.b;
        if (((aa)ap2).d) {
            ap2 = this.a();
            ap2 = ap2.d;
            return ((bb)ap2).a.e();
        }
        return null;
    }

    public final void setGenericText(String string) {
        if (string != null) {
            ((h)object).a().a(true);
            Object object = ((h)object).a();
            object = ((ab)object).d;
            ((bb)object).a.a(string);
            return;
        }
        ((h)object).a().a(false);
    }

    public final String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SvcDownlinkMessageImpl").append(" [");
        stringBuffer.append(super.toString());
        stringBuffer.append("]");
        return stringBuffer.toString();
    }

    private ab a() {
        try {
            ai ai2 = ((h)((Object)ai2)).a;
            return ai2.g.e();
        }
        catch (j j2) {
            throw new RuntimeException(j2.getMessage());
        }
    }

    public final PointOfInterest[] getPointOfInterests() {
        return null;
    }

    public final void setPointOfInterests(PointOfInterest[] pointOfInterestArray) {
    }
}

