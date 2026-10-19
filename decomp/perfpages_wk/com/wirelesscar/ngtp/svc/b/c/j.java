/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.aw;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bv;
import com.wirelesscar.ngtp.svc.a.b.cb;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.h;
import com.wirelesscar.ngtp.svc.a.b.t;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.api.RoResponse;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.a;
import com.wirelesscar.ngtp.svc.b.c.d;
import com.wirelesscar.ngtp.svc.b.c.g;
import com.wirelesscar.ngtp.svc.b.e;
import java.util.Date;

final class j
extends a {
    j(h bf2) {
        Date date;
        Integer n2;
        Object object = bf2;
        bv bv2 = ((h)object).c;
        object = bv2;
        object = bf2;
        object = ((h)object).c;
        Version version = new Version((int)bv2.a.c(), (int)((bv)object).b.c());
        object = bf2;
        object = ((h)object).a;
        if (((cf)object).a) {
            object = bf2;
            n2 = new Integer((int)((h)object).d.c());
        } else {
            n2 = null;
        }
        object = bf2;
        object = ((h)object).b;
        if (((cf)object).a) {
            object = bf2;
            object = ((h)object).e;
            date = NgtpUtil.ngtp2Date((int)((com.wirelesscar.ngtp.svc.a.b.g)object).a.c());
        } else {
            date = null;
        }
        super(version, n2, date);
        object = bf2;
        bf2 = ((h)object).f;
        if (bf2 != null && ((bo)(object = bf2)).c() > 0L) {
            int n3 = 0;
            while ((long)n3 < ((bo)(object = bf2)).c()) {
                int n4 = n3++;
                object = bf2;
                object = (aw)((cb)object).a[n4];
                object = new d((aw)object);
                super.a((RoResponse)object);
            }
        }
    }

    j(Version version, Integer n2, Date date) {
        super(version, n2, date);
    }

    public final RoResponse addRemoteServiceResponse(int n2, Date date, String string) {
        d d2 = new d(n2, date, string);
        super.a(d2);
        return d2;
    }

    final h a(h h2) {
        try {
            bf bf2;
            bv bv2 = new bv();
            bv2.a(this.getOperationScriptVersion().getMajor());
            bv2.b(this.getOperationScriptVersion().getMinor());
            bm bm2 = bv2;
            Object object = h2;
            h2.c = bm2;
            if (this.getTimesExecuted() != null) {
                long l2 = this.getTimesExecuted().intValue();
                object = h2;
                ((h)object).d.b(l2);
                boolean bl2 = true;
                bf2 = ((h)object).a;
                ((h)object).a.a = bl2;
                boolean bl3 = true;
                h h3 = h2;
                boolean bl4 = true;
                bf2 = h3.a;
                h3.a.a = bl4;
            }
            if (this.getLastExecuted() != null) {
                bf2 = h2;
                bf2.e.a(NgtpUtil.date2Ngtp(this.getLastExecuted()));
                boolean bl5 = true;
                object = h2;
                boolean bl6 = true;
                bf2 = ((h)object).b;
                ((h)object).b.a = bl6;
            }
            if ((this = this.getRemoteOperationResponse()) != null && this.length > 0) {
                bf2 = h2;
                bf2.f.c_(this.length);
                int n2 = 0;
                while (n2 < this.length) {
                    object = (d)this[n2];
                    bm2 = new aw();
                    bf2 = bm2;
                    ((aw)bm2).d.a(NgtpUtil.date2Ngtp(((e)object).getLastExecuted()));
                    t t2 = ((g)((e)object).getOperationDesc()).a();
                    Object object2 = bm2;
                    ((aw)bm2).b = t2;
                    long l3 = ((e)object).getTimesExecuted();
                    object2 = bm2;
                    ((aw)object2).c.b(l3);
                    if (((e)object).getErrorDesc() != null) {
                        bf2 = bm2;
                        ((aw)bf2).e.a(((e)object).getErrorDesc());
                        boolean bl7 = true;
                        object2 = bm2;
                        boolean bl8 = true;
                        bf2 = ((aw)object2).a;
                        ((aw)object2).a.a = bl8;
                    }
                    object = bm2;
                    bf2 = h2;
                    object2 = object;
                    int n3 = n2++;
                    object = bf2.f;
                    ((cb)object).a[n3] = object2;
                }
            }
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.toString());
        }
        return h2;
    }
}

