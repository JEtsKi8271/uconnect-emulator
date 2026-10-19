/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import com.wirelesscar.ngtp.dspt.a.a;
import com.wirelesscar.ngtp.dspt.a.aa;
import com.wirelesscar.ngtp.dspt.a.ab;
import com.wirelesscar.ngtp.dspt.a.ad;
import com.wirelesscar.ngtp.dspt.a.ae;
import com.wirelesscar.ngtp.dspt.a.af;
import com.wirelesscar.ngtp.dspt.a.ag;
import com.wirelesscar.ngtp.dspt.a.f;
import com.wirelesscar.ngtp.dspt.a.g;
import com.wirelesscar.ngtp.dspt.a.h;
import com.wirelesscar.ngtp.dspt.a.l;
import com.wirelesscar.ngtp.dspt.a.m;
import com.wirelesscar.ngtp.dspt.a.n;
import com.wirelesscar.ngtp.dspt.a.o;
import com.wirelesscar.ngtp.dspt.a.u;
import com.wirelesscar.ngtp.dspt.a.w;
import com.wirelesscar.ngtp.dspt.a.x;
import com.wirelesscar.ngtp.dspt.api.DecodeException;
import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import com.wirelesscar.ngtp.dspt.api.MessageCount;
import com.wirelesscar.ngtp.dspt.api.MobileDeviceIdentifier;
import com.wirelesscar.ngtp.dspt.api.Timestamp;

abstract class c
implements DsptMessage {
    protected final u a;
    protected byte[] b;

    protected c() {
        this.a = new u();
    }

    protected c(u u2, byte[] byArray) {
        this.a = u2;
        this.b = byArray;
    }

    static int a(u m2) throws DecodeException {
        try {
            switch (((f)m2).b()) {
                case 1: {
                    m2 = ((u)m2).e();
                    m2 = ((ad)m2).b;
                    return c.a(((o)m2).a);
                }
                case 0: {
                    m2 = ((u)m2).c();
                    m2 = ((ab)m2).b;
                    return c.a(((g)m2).g);
                }
                case 2: {
                    return 0;
                }
            }
        }
        catch (w w2) {
            throw new DecodeException(w2);
        }
        throw new DecodeException("Unknown message type: " + ((f)m2).b());
    }

    private static int a(x x2) throws DecodeException {
        if (x2 != null) {
            try {
                switch (x2.b()) {
                    case 0: {
                        return (int)x2.c();
                    }
                    case 1: {
                        return (int)x2.d();
                    }
                    case 2: {
                        return (int)x2.e();
                    }
                }
                throw new DecodeException("Invalid MessageLength: " + x2.b());
            }
            catch (w w2) {
                throw new DecodeException(w2);
            }
        }
        return 0;
    }

    protected static void a(String string, n m2) {
        if (string == null || string.length() < 7) {
            throw new IllegalArgumentException("VIN is too short: '" + string + "'. Need at least 7 characters.");
        }
        try {
            m2.d();
            m2 = m2.c();
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
        int n2 = string.length();
        m m3 = m2;
        ((h)m3).g.a(string.substring(n2 - 7));
        if (n2 > 7) {
            m3 = m2;
            ((h)m3).f.a(String.valueOf(string.charAt(n2 - 8)));
            boolean bl2 = true;
            m m4 = m2;
            boolean bl3 = true;
            m4 = ((h)m4).c;
            ((h)m4).c.d = bl3;
            if (n2 > 13) {
                m4 = m2;
                ((h)m4).e.a(string.substring(n2 - 14, n2 - 8));
                boolean bl4 = true;
                m m5 = m2;
                bl3 = true;
                m5 = ((h)m5).b;
                ((h)m5).b.d = bl3;
                if (n2 > 16) {
                    m5 = m2;
                    ((h)m5).d.a(string.substring(0, 3));
                    boolean bl5 = true;
                    m m6 = m2;
                    bl3 = true;
                    m6 = ((h)m6).a;
                    ((h)m6).a.d = bl3;
                }
            }
        }
    }

    protected static void a(byte[] byArray, x x2) {
        block5: {
            int n2 = byArray != null ? byArray.length : 0;
            try {
                if (n2 < 256) {
                    x2.b((long)n2);
                    break block5;
                }
                if (n2 < 65536) {
                    x2.c(n2);
                    break block5;
                }
                if (n2 < 0x1000000) {
                    x2.d(n2);
                    break block5;
                }
                throw new IllegalArgumentException("Data too long: " + n2);
            }
            catch (w w2) {
                throw new RuntimeException(w2.toString());
            }
        }
    }

    private a a() {
        try {
            switch (((c)object).a.b()) {
                case 1: {
                    Object object = ((c)object).a.e();
                    return ((ad)object).a;
                }
                case 0: {
                    Object object = ((c)object).a.c();
                    return ((ab)object).a;
                }
                case 2: {
                    Object object = ((c)object).a.g();
                    return ((ag)object).a;
                }
            }
            throw new RuntimeException("Unknown message type: " + ((c)object).a.b());
        }
        catch (w w2) {
            throw new RuntimeException(w2.toString());
        }
    }

    public String getVin() {
        Object object = ((c)object2).a();
        Object object2 = ((a)object).d;
        if (object2 != null && ((f)object2).b() == 0) {
            try {
                object2 = ((n)object2).c();
                StringBuffer stringBuffer = new StringBuffer();
                object = object2;
                object = ((h)object).a;
                if (((af)object).d) {
                    object = object2;
                    stringBuffer.append(((h)object).d.c());
                }
                object = object2;
                object = ((h)object).b;
                if (((af)object).d) {
                    object = object2;
                    stringBuffer.append(((h)object).e.c());
                }
                object = object2;
                object = ((h)object).c;
                if (((af)object).d) {
                    object = object2;
                    stringBuffer.append(((h)object).f.c());
                }
                object = object2;
                stringBuffer.append(((h)object).g.c());
                return stringBuffer.toString();
            }
            catch (w w2) {
                throw new RuntimeException(w2.toString());
            }
        }
        return null;
    }

    public int getServiceType() {
        a a2 = ((c)((Object)a2)).a();
        return (int)a2.c.b();
    }

    public Timestamp getEventCreationTime() {
        Object object = ((c)this).a();
        Object object2 = this = ((a)object).e;
        object = object2;
        object = this;
        return new Timestamp((int)((aa)object2).a.b(), (int)((aa)object).b.b());
    }

    public void setAckRequired(boolean bl2) {
        Object object = ((c)object).a();
        object = ((a)object).j;
        ((a)object).j.d = bl2;
    }

    public boolean isAckRequired() {
        Object object = ((c)object).a();
        object = ((a)object).j;
        return ((af)object).d;
    }

    public void setStateless(boolean bl2) {
        Object object = ((c)object).a();
        object = ((a)object).k;
        ((a)object).k.d = bl2;
    }

    public boolean isStateless() {
        Object object = ((c)object).a();
        object = ((a)object).k;
        return ((af)object).d;
    }

    public void setMessageCount(MessageCount messageCount) {
        if (messageCount != null) {
            Object object = this = ((c)this).a();
            long l2 = messageCount.getUplinkCount();
            object = ((a)this).i;
            ((ae)object).a.b(l2);
            object = this;
            l2 = messageCount.getDownlinkCount();
            object = ((a)object).i;
            ((ae)object).b.b(l2);
        }
    }

    public MessageCount getMessageCount() {
        Object object = this = ((c)this).a();
        ae ae2 = ((a)object).i;
        object = ae2;
        object = this;
        object = ((a)object).i;
        return new MessageCount((int)ae2.a.b(), (int)((ae)object).b.b());
    }

    public void setBackendEventId(byte[] byArray) {
        a a2 = ((c)((Object)a2)).a();
        if (byArray != null && byArray.length > 0) {
            a2.a(true);
            a2.g.a(byArray);
            return;
        }
        a2.a(false);
    }

    public byte[] getBackendEventId() {
        a a2 = ((c)((Object)a2)).a();
        byte[] byArray = null;
        a a3 = a2;
        a3 = a3.a;
        if (((af)((Object)a3)).d) {
            a3 = a2;
            byArray = a3.g.b();
        }
        if (byArray != null && byArray.length > 0) {
            return byArray;
        }
        return null;
    }

    public boolean isEventBackendInitiated() {
        a a2 = ((c)((Object)a2)).a();
        return a2.f.b() == 1L;
    }

    public void setMessageCreationTime(Timestamp timestamp) {
        if (timestamp != null) {
            a a2 = this.a();
            a2.m.a(timestamp.getNgtpTime());
            a2 = this.a();
            a2.m.b(timestamp.getNgtpMillis());
        }
    }

    public Timestamp getMessageCreationTime() {
        Object object = ((c)this).a();
        Object object2 = this = ((a)object).m;
        object = object2;
        object = this;
        return new Timestamp((int)((aa)object2).a.b(), (int)((aa)object).b.b());
    }

    /*
     * Enabled aggressive block sorting
     */
    public void setMobileDeviceIdentifier(MobileDeviceIdentifier mobileDeviceIdentifier) {
        Object object = ((c)object).a();
        if (mobileDeviceIdentifier == null) {
            ((a)object).b(false);
            return;
        }
        ((a)object).b(true);
        Object object2 = object;
        object = ((a)object2).l;
        if (c.a(mobileDeviceIdentifier.getEquipmentIdentifier())) {
            object2 = object;
            ((l)object2).f.a(mobileDeviceIdentifier.getEquipmentIdentifier());
            ((l)object).b(true);
        } else {
            ((l)object).b(false);
        }
        if (c.a(mobileDeviceIdentifier.getIccId())) {
            object2 = object;
            ((l)object2).h.a(mobileDeviceIdentifier.getIccId());
            ((l)object).d(true);
        } else {
            ((l)object).d(false);
        }
        if (c.a(mobileDeviceIdentifier.getPublicAddress())) {
            object2 = object;
            ((l)object2).e.a(mobileDeviceIdentifier.getPublicAddress());
            ((l)object).a(true);
        } else {
            ((l)object).a(false);
        }
        if (c.a(mobileDeviceIdentifier.getSubscriberIdentity())) {
            object2 = object;
            ((l)object2).g.a(mobileDeviceIdentifier.getSubscriberIdentity());
            ((l)object).c(true);
            return;
        }
        ((l)object).c(false);
    }

    public MobileDeviceIdentifier getMobileDeviceIdentifier() {
        MobileDeviceIdentifier mobileDeviceIdentifier = null;
        Object object = ((c)this).a();
        object = ((a)object).b;
        if (((af)object).d) {
            mobileDeviceIdentifier = new MobileDeviceIdentifier();
            object = ((c)this).a();
            object = this = ((a)object).l;
            object = ((l)this).b;
            if (((af)object).d) {
                object = this;
                mobileDeviceIdentifier.setEquipmentIdentifier(((l)object).f.c());
            }
            object = this;
            object = ((l)object).d;
            if (((af)object).d) {
                object = this;
                mobileDeviceIdentifier.setIccId(((l)object).h.c());
            }
            object = this;
            object = ((l)object).a;
            if (((af)object).d) {
                object = this;
                mobileDeviceIdentifier.setPublicAddress(((l)object).e.c());
            }
            object = this;
            object = ((l)object).c;
            if (((af)object).d) {
                object = this;
                mobileDeviceIdentifier.setSubscriberIdentity(((l)object).g.c());
            }
        }
        return mobileDeviceIdentifier;
    }

    private static boolean a(String string) {
        return string != null && string.trim().length() > 0;
    }
}

