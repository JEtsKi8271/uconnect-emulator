/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.f;
import com.wirelesscar.ngtp.svc.a.b.g;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.api.RoTrigger;
import java.util.Date;

final class e
implements RoTrigger {
    f a;

    e() {
        this.a = new f();
    }

    e(f f2) {
        this.a = f2;
    }

    public final int getTrigger() {
        return this.a.g();
    }

    public final void setNow() {
        try {
            this.a.c();
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.toString());
        }
    }

    public final void setAtConvenicence() {
        try {
            this.a.d();
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.toString());
        }
    }

    public final void setNoLaterThan(Date object) {
        Object object2 = object;
        object = new g();
        ((g)object).a(NgtpUtil.date2Ngtp((Date)object2));
        ((e)object2).a.a((g)object);
    }

    public final Date getNoLaterThan() {
        try {
            g g2 = ((e)((Object)g2)).a.e();
            return NgtpUtil.ngtp2Date((int)g2.a.c());
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.toString());
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

