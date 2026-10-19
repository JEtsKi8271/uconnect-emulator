/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.ck;
import com.wirelesscar.ngtp.svc.api.SvcMessage;

abstract class b
implements SvcMessage {
    protected final ck a;

    protected b() {
        this.a = new ck();
    }

    protected b(ck ck2) {
        this.a = ck2;
    }

    public Boolean getApplicationAck() {
        aw aw2 = this.a;
        aw2 = aw2.a;
        if (((ap)aw2).a) {
            aw2 = this.a;
            if (aw2.e.c() == 1L) {
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
        Object object = ((b)object).a;
        object = ((ck)object).f;
        return ((ap)object).a;
    }

    public void setApplicationAckRequired(boolean bl2) {
        Object object = ((b)object).a;
        object = ((ck)object).f;
        ((ck)object).f.a = bl2;
    }

    public boolean isServiceDataUpdateRequest() {
        Object object = ((b)object).a;
        object = ((ck)object).c;
        return ((ap)object).a;
    }

    public void setServiceDataUpdateRequest(boolean bl2) {
        Object object = ((b)object).a;
        object = ((ck)object).c;
        ((ck)object).c.a = bl2;
    }

    public boolean isServiceDataUpdateResponse() {
        Object object = ((b)object).a;
        object = ((ck)object).d;
        return ((ap)object).a;
    }

    public void setServiceDataUpdateResponse(boolean bl2) {
        Object object = ((b)object).a;
        object = ((ck)object).d;
        ((ck)object).d.a = bl2;
    }

    public boolean isTestCallFlag() {
        Object object = ((b)object).a;
        object = ((ck)object).b;
        return ((ap)object).a;
    }

    public void setTestCallFlag(boolean bl2) {
        Object object = ((b)object).a;
        object = ((ck)object).b;
        ((ck)object).b.a = bl2;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SvcMessageImpl").append(" [");
        stringBuffer.append("svcData=").append(this.a);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

