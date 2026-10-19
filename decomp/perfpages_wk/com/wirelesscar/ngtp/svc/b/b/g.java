/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.an;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.at;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.b;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.cn;
import com.wirelesscar.ngtp.svc.a.a.cq;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.api.RoResponse;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.a;
import com.wirelesscar.ngtp.svc.b.b.c;
import com.wirelesscar.ngtp.svc.b.b.h;
import com.wirelesscar.ngtp.svc.b.e;
import java.util.Date;

final class g
extends a {
    g(cn aw2) {
        Date date;
        Integer n2;
        Object object = aw2;
        cq cq2 = ((cn)object).c;
        object = cq2;
        object = aw2;
        object = ((cn)object).c;
        Version version = new Version((int)cq2.a.c(), (int)((cq)object).b.c());
        object = aw2;
        object = ((cn)object).a;
        if (((ap)object).a) {
            object = aw2;
            n2 = new Integer((int)((cn)object).d.c());
        } else {
            n2 = null;
        }
        object = aw2;
        object = ((cn)object).b;
        if (((ap)object).a) {
            object = aw2;
            object = ((cn)object).e;
            date = NgtpUtil.ngtp2Date((int)((bt)object).a.c());
        } else {
            date = null;
        }
        super(version, n2, date);
        object = aw2;
        aw2 = ((cn)object).f;
        if (aw2 != null && ((f)(object = aw2)).c() > 0L) {
            int n3 = 0;
            while ((long)n3 < ((f)(object = aw2)).c()) {
                int n4 = n3++;
                object = aw2;
                object = (an)((at)object).b[n4];
                object = new h((an)object);
                super.a((RoResponse)object);
            }
        }
    }

    g(Version version, Integer n2, Date date) {
        super(version, n2, date);
    }

    public final RoResponse addRemoteServiceResponse(int n2, Date date, String string) {
        h h2 = new h(n2, date, string);
        super.a(h2);
        return h2;
    }

    final cn a(cn cn2) {
        try {
            aw aw2;
            cq cq2 = new cq();
            cq2.a(this.getOperationScriptVersion().getMajor());
            cq2.b(this.getOperationScriptVersion().getMinor());
            bn bn2 = cq2;
            Object object = cn2;
            cn2.c = bn2;
            if (this.getTimesExecuted() != null) {
                long l2 = this.getTimesExecuted().intValue();
                object = cn2;
                ((cn)object).d.a(l2);
                boolean bl2 = true;
                aw2 = ((cn)object).a;
                ((cn)object).a.a = bl2;
                boolean bl3 = true;
                cn cn3 = cn2;
                boolean bl4 = true;
                aw2 = cn3.a;
                cn3.a.a = bl4;
            }
            if (this.getLastExecuted() != null) {
                aw2 = cn2;
                aw2.e.a(NgtpUtil.date2Ngtp(this.getLastExecuted()));
                boolean bl5 = true;
                object = cn2;
                boolean bl6 = true;
                aw2 = ((cn)object).b;
                ((cn)object).b.a = bl6;
            }
            if ((this = this.getRemoteOperationResponse()) != null && this.length > 0) {
                aw2 = cn2;
                aw2.f.b(this.length);
                int n2 = 0;
                while (n2 < this.length) {
                    object = (h)this[n2];
                    bn2 = new an();
                    aw2 = bn2;
                    ((an)bn2).d.a(NgtpUtil.date2Ngtp(((e)object).getLastExecuted()));
                    b b2 = ((c)((e)object).getOperationDesc()).a();
                    Object object2 = bn2;
                    ((an)bn2).b = b2;
                    long l3 = ((e)object).getTimesExecuted();
                    object2 = bn2;
                    ((an)object2).c.a(l3);
                    if (((e)object).getErrorDesc() != null) {
                        aw2 = bn2;
                        ((an)aw2).e.a(((e)object).getErrorDesc());
                        boolean bl7 = true;
                        object2 = bn2;
                        boolean bl8 = true;
                        aw2 = ((an)object2).a;
                        ((an)object2).a.a = bl8;
                    }
                    object = bn2;
                    aw2 = cn2;
                    object2 = object;
                    int n3 = n2++;
                    object = aw2.f;
                    ((at)object).b[n3] = object2;
                }
            }
        }
        catch (o o2) {
            throw new RuntimeException(o2.toString());
        }
        return cn2;
    }
}

