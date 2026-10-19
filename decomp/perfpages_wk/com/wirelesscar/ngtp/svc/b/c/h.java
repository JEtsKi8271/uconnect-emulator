/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.cd;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.api.SvcMessage;

abstract class h
implements SvcMessage {
    protected final cd a;

    protected h() {
        this.a = new cd();
    }

    protected h(cd cd2) {
        this.a = cd2;
    }

    public Boolean getApplicationAck() {
        bf bf2 = this.a;
        bf2 = bf2.a;
        if (((cf)bf2).a) {
            bf2 = this.a;
            if (bf2.e.c() == 1L) {
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
        Object object = ((h)object).a;
        object = ((cd)object).f;
        return ((cf)object).a;
    }

    public void setApplicationAckRequired(boolean bl2) {
        Object object = ((h)object).a;
        object = ((cd)object).f;
        ((cd)object).f.a = bl2;
    }

    public boolean isServiceDataUpdateRequest() {
        Object object = ((h)object).a;
        object = ((cd)object).c;
        return ((cf)object).a;
    }

    public void setServiceDataUpdateRequest(boolean bl2) {
        Object object = ((h)object).a;
        object = ((cd)object).c;
        ((cd)object).c.a = bl2;
    }

    public boolean isServiceDataUpdateResponse() {
        Object object = ((h)object).a;
        object = ((cd)object).d;
        return ((cf)object).a;
    }

    public void setServiceDataUpdateResponse(boolean bl2) {
        Object object = ((h)object).a;
        object = ((cd)object).d;
        ((cd)object).d.a = bl2;
    }

    public boolean isTestCallFlag() {
        Object object = ((h)object).a;
        object = ((cd)object).b;
        return ((cf)object).a;
    }

    public void setTestCallFlag(boolean bl2) {
        Object object = ((h)object).a;
        object = ((cd)object).b;
        ((cd)object).b.a = bl2;
    }

    public String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SvcMessageImpl").append(" [");
        stringBuffer.append("svcData=").append(this.a);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }
}

