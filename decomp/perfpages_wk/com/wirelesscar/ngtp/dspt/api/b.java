/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.a.a;
import com.wirelesscar.ngtp.dspt.a.af;
import com.wirelesscar.ngtp.dspt.a.ag;
import com.wirelesscar.ngtp.dspt.a.t;
import com.wirelesscar.ngtp.dspt.a.u;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.api.DsptControlMessage;
import com.wirelesscar.ngtp.dspt.api.Timestamp;
import com.wirelesscar.ngtp.dspt.api.c;

final class b
extends c
implements DsptControlMessage {
    b(int n2, String string, Timestamp timestamp, boolean bl2) {
        try {
            ((b)((Object)ag2)).a.h();
            ag ag2 = ((b)((Object)ag2)).a.g();
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
        ag ag3 = ag2;
        ag3.a.a(n2);
        ag3 = ag2;
        ag3 = ag3.a;
        com.wirelesscar.ngtp.dspt.api.b.a(string, ((a)((Object)ag3)).d);
        ag3 = ag2;
        ag3 = ag3.a;
        ((a)((Object)ag3)).e.a(timestamp.getNgtpTime());
        ag3 = ag2;
        ag3 = ag3.a;
        ((a)((Object)ag3)).e.b(timestamp.getNgtpMillis());
        ag3 = ag2;
        ag3.a.b(bl2 ? 1L : 0L);
        Timestamp timestamp2 = Timestamp.now();
        ag3 = ag2;
        ag3 = ag3.a;
        ((a)((Object)ag3)).m.a(timestamp2.getNgtpTime());
        ag3 = ag2;
        ag3 = ag3.a;
        ((a)((Object)ag3)).m.b(timestamp2.getNgtpMillis());
    }

    b(u u2) {
        super(u2, null);
    }

    public final void setMessageType(int n2) {
        switch (n2) {
            case 3: {
                n2 = 4;
                break;
            }
            case 0: {
                n2 = 1;
                break;
            }
            case 2: {
                n2 = 0;
                break;
            }
            case 1: {
                n2 = 5;
                break;
            }
            case 5: {
                n2 = 7;
                break;
            }
            case 4: {
                n2 = 6;
                break;
            }
            default: {
                throw new IllegalArgumentException("Unknown message type: " + n2);
            }
        }
        try {
            ag ag2 = ((b)((Object)ag2)).a.g();
            ag2.a.c(n2);
            return;
        }
        catch (w w2) {
            throw new RuntimeException(w2.getMessage());
        }
    }

    public final int getMessageType() {
        int n2;
        try {
            Object object = ((b)object).a.g();
            object = ((ag)object).a;
            n2 = (int)((a)object).h.b();
        }
        catch (w w2) {
            throw new RuntimeException(w2.getMessage());
        }
        switch (n2) {
            case 1: {
                n2 = 0;
                break;
            }
            case 4: {
                n2 = 3;
                break;
            }
            case 0: {
                n2 = 2;
                break;
            }
            case 5: {
                n2 = 1;
                break;
            }
            case 7: {
                n2 = 5;
                break;
            }
            case 6: {
                n2 = 4;
                break;
            }
            default: {
                throw new RuntimeException("Invalid messageType: " + n2);
            }
        }
        return n2;
    }

    private t a() {
        try {
            ag ag2 = ((b)((Object)ag2)).a.g();
            return ag2.b;
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
    }

    public final void setCrqNumber(String string) {
        t t2 = ((b)((Object)t2)).a();
        if (string != null) {
            Object object = t2;
            ((t)object).b.a(string);
            t2.a(true);
            return;
        }
        t2.a(false);
    }

    public final void setErrorInfo(Integer object) {
        t t2 = ((b)((Object)t2)).a();
        if (object != null) {
            long l2 = ((Integer)object).longValue();
            object = t2;
            ((t)object).d.b(l2);
            t2.c(true);
            return;
        }
        t2.c(false);
    }

    public final void setNotificationData(byte[] object) {
        t t2 = ((b)((Object)t2)).a();
        if (object != null) {
            t t3 = t2;
            byte[] byArray = object;
            object = t3;
            t3.c.a(byArray);
            t2.b(true);
            return;
        }
        t2.b(false);
    }

    public final String getCrqNumber() {
        t t2 = ((b)object).a();
        Object object = t2;
        object = t2;
        return t2.b.c();
    }

    public final Integer getErrorInfo() {
        Object object = this = ((b)this).a();
        object = ((t)this).a;
        if (((af)object).d) {
            object = this;
            return new Integer((int)((t)object).d.b());
        }
        return null;
    }

    public final byte[] getNotificationData() {
        t t2 = ((b)object).a();
        Object object = t2;
        object = t2;
        return t2.c.b();
    }
}

