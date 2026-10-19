/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aw;
import com.wirelesscar.ngtp.svc.a.c.bc;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.api.RoTrigger;
import java.util.Date;

final class f
implements RoTrigger {
    aw a;

    f() {
        this.a = new aw();
    }

    f(aw aw2) {
        this.a = aw2;
    }

    public final int getTrigger() {
        return this.a.g();
    }

    public final void setNow() {
        try {
            this.a.c();
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.toString());
        }
    }

    public final void setAtConvenicence() {
        try {
            this.a.d();
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.toString());
        }
    }

    public final void setNoLaterThan(Date object) {
        Object object2 = object;
        object = new bc();
        ((bc)object).a(NgtpUtil.date2Ngtp((Date)object2));
        ((f)object2).a.a((bc)object);
    }

    public final Date getNoLaterThan() {
        try {
            bc bc2 = ((f)((Object)bc2)).a.e();
            return NgtpUtil.ngtp2Date((int)bc2.a.c());
        }
        catch (j j2) {
            throw new RuntimeException(j2.toString());
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

