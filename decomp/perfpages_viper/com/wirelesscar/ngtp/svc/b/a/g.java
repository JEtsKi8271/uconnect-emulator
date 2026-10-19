/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ai;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.api.SvcMessage;

abstract class g
implements SvcMessage {
    protected final ai a;

    protected g() {
        this.a = new ai();
    }

    protected g(ai ai2) {
        this.a = ai2;
    }

    public Boolean getApplicationAck() {
        ap ap2 = this.a;
        ap2 = ap2.a;
        if (((aa)ap2).d) {
            ap2 = this.a;
            if (ap2.e.c() == 1L) {
                return Boolean.TRUE;
            }
            return Boolean.FALSE;
        }
        return null;
    }

    public void setApplicationAck(Boolean bl2) {
        if (bl2 != null) {
            this.a.a(bl2.equals(Boolean.TRUE) ? 1L : 0L);
            this.a.a(true);
            return;
        }
        this.a.a(false);
    }

    public boolean isApplicationAckRequired() {
        Object object = ((g)object).a;
        object = ((ai)object).f;
        return ((aa)object).d;
    }

    public void setApplicationAckRequired(boolean bl2) {
        Object object = ((g)object).a;
        object = ((ai)object).f;
        ((ai)object).f.d = bl2;
    }

    public boolean isServiceDataUpdateRequest() {
        Object object = ((g)object).a;
        object = ((ai)object).c;
        return ((aa)object).d;
    }

    public void setServiceDataUpdateRequest(boolean bl2) {
        Object object = ((g)object).a;
        object = ((ai)object).c;
        ((ai)object).c.d = bl2;
    }

    public boolean isServiceDataUpdateResponse() {
        Object object = ((g)object).a;
        object = ((ai)object).d;
        return ((aa)object).d;
    }

    public void setServiceDataUpdateResponse(boolean bl2) {
        Object object = ((g)object).a;
        object = ((ai)object).d;
        ((ai)object).d.d = bl2;
    }

    public boolean isTestCallFlag() {
        Object object = ((g)object).a;
        object = ((ai)object).b;
        return ((aa)object).d;
    }

    public void setTestCallFlag(boolean bl2) {
        Object object = ((g)object).a;
        object = ((ai)object).b;
        ((ai)object).b.d = bl2;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SvcMessageImpl").append(" [");
        stringBuffer.append("svcData=").append(this.a);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

