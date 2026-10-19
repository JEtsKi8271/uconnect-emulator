/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.e;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.api.RoTrigger;
import java.util.Date;

final class j
implements RoTrigger {
    e a;

    j() {
        this.a = new e();
    }

    j(e e2) {
        this.a = e2;
    }

    public final int getTrigger() {
        return this.a.f();
    }

    public final void setNow() {
        try {
            this.a.c();
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.toString());
        }
    }

    public final void setAtConvenicence() {
        try {
            this.a.d();
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.toString());
        }
    }

    public final void setNoLaterThan(Date object) {
        Object object2 = object;
        object = new bt();
        ((bt)object).a(NgtpUtil.date2Ngtp((Date)object2));
        ((j)object2).a.a((bt)object);
    }

    public final Date getNoLaterThan() {
        try {
            bt bt2 = ((j)((Object)bt2)).a.e();
            return NgtpUtil.ngtp2Date((int)bt2.a.c());
        }
        catch (o o2) {
            throw new RuntimeException(o2.toString());
        }
    }

    public final String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("RoTriggerImpl").append(" [");
        stringBuffer.append("rot").append(this.a);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

