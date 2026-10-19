/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ad;
import com.wirelesscar.ngtp.svc.a.c.ag;
import com.wirelesscar.ngtp.svc.a.c.am;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bc;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.g;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.n;
import com.wirelesscar.ngtp.svc.a.c.s;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.api.RoResponse;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.a;
import com.wirelesscar.ngtp.svc.b.a.b;
import com.wirelesscar.ngtp.svc.b.a.i;
import com.wirelesscar.ngtp.svc.b.e;
import java.util.Date;

final class c
extends a {
    c(n ap2) {
        Date date;
        Integer n2;
        Object object = ap2;
        s s2 = ((n)object).c;
        object = s2;
        object = ap2;
        object = ((n)object).c;
        Version version = new Version((int)s2.a.c(), (int)((s)object).b.c());
        object = ap2;
        object = ((n)object).a;
        if (((aa)object).d) {
            object = ap2;
            n2 = new Integer((int)((n)object).d.c());
        } else {
            n2 = null;
        }
        object = ap2;
        object = ((n)object).b;
        if (((aa)object).d) {
            object = ap2;
            object = ((n)object).e;
            date = NgtpUtil.ngtp2Date((int)((bc)object).a.c());
        } else {
            date = null;
        }
        super(version, n2, date);
        object = ap2;
        ap2 = ((n)object).f;
        if (ap2 != null && ((bf)(object = ap2)).c() > 0L) {
            int n3 = 0;
            while ((long)n3 < ((bf)(object = ap2)).c()) {
                int n4 = n3++;
                object = ap2;
                object = (ad)((am)object).d[n4];
                object = new b((ad)object);
                super.a((RoResponse)object);
            }
        }
    }

    c(Version version, Integer n2, Date date) {
        super(version, n2, date);
    }

    public final RoResponse addRemoteServiceResponse(int n2, Date date, String string) {
        b b2 = new b(n2, date, string);
        super.a(b2);
        return b2;
    }

    final n a(n n2) {
        try {
            ap ap2;
            s s2 = new s();
            s2.a(this.getOperationScriptVersion().getMajor());
            s2.b(this.getOperationScriptVersion().getMinor());
            g g2 = s2;
            Object object = n2;
            n2.c = g2;
            if (this.getTimesExecuted() != null) {
                long l2 = this.getTimesExecuted().intValue();
                object = n2;
                ((n)object).d.b(l2);
                boolean bl2 = true;
                ap2 = ((n)object).a;
                ((n)object).a.d = bl2;
                boolean bl3 = true;
                n n3 = n2;
                boolean bl4 = true;
                ap2 = n3.a;
                n3.a.d = bl4;
            }
            if (this.getLastExecuted() != null) {
                ap2 = n2;
                ap2.e.a(NgtpUtil.date2Ngtp(this.getLastExecuted()));
                boolean bl5 = true;
                object = n2;
                boolean bl6 = true;
                ap2 = ((n)object).b;
                ((n)object).b.d = bl6;
            }
            if ((this = this.getRemoteOperationResponse()) != null && this.length > 0) {
                ap2 = n2;
                ap2.f.a_(this.length);
                int n4 = 0;
                while (n4 < this.length) {
                    object = (b)this[n4];
                    g2 = new ad();
                    ap2 = g2;
                    ((ad)g2).d.a(NgtpUtil.date2Ngtp(((e)object).getLastExecuted()));
                    ag ag2 = ((i)((e)object).getOperationDesc()).a();
                    Object object2 = g2;
                    ((ad)g2).b = ag2;
                    long l3 = ((e)object).getTimesExecuted();
                    object2 = g2;
                    ((ad)object2).c.b(l3);
                    if (((e)object).getErrorDesc() != null) {
                        ap2 = g2;
                        ((ad)ap2).e.a(((e)object).getErrorDesc());
                        boolean bl7 = true;
                        object2 = g2;
                        boolean bl8 = true;
                        ap2 = ((ad)object2).a;
                        ((ad)object2).a.d = bl8;
                    }
                    object = g2;
                    ap2 = n2;
                    object2 = object;
                    int n5 = n4++;
                    object = ap2.f;
                    ((am)object).d[n5] = object2;
                }
            }
        }
        catch (j j2) {
            throw new RuntimeException(j2.toString());
        }
        return n2;
    }
}

