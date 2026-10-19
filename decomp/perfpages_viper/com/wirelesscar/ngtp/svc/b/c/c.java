/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bg;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bv;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.t;
import com.wirelesscar.ngtp.svc.a.b.y;
import com.wirelesscar.ngtp.svc.api.RoRequest;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.b;
import com.wirelesscar.ngtp.svc.b.c.e;
import com.wirelesscar.ngtp.svc.b.c.f;
import com.wirelesscar.ngtp.svc.b.c.g;

final class c
extends com.wirelesscar.ngtp.svc.b.c {
    c(com.wirelesscar.ngtp.svc.a.b.c bf2) {
        Integer n2;
        Integer n3;
        String string;
        Object object = bf2;
        bv bv2 = ((com.wirelesscar.ngtp.svc.a.b.c)object).d;
        object = bv2;
        object = bf2;
        object = ((com.wirelesscar.ngtp.svc.a.b.c)object).d;
        Version version = new Version((int)bv2.a.c(), (int)((bv)object).b.c());
        object = bf2;
        object = ((com.wirelesscar.ngtp.svc.a.b.c)object).a;
        if (((cf)object).a) {
            object = bf2;
            string = ((com.wirelesscar.ngtp.svc.a.b.c)object).f.e();
        } else {
            string = null;
        }
        object = bf2;
        object = ((com.wirelesscar.ngtp.svc.a.b.c)object).b;
        if (((cf)object).a) {
            object = bf2;
            n3 = new Integer((int)((com.wirelesscar.ngtp.svc.a.b.c)object).g.c());
        } else {
            n3 = null;
        }
        object = bf2;
        object = ((com.wirelesscar.ngtp.svc.a.b.c)object).c;
        if (((cf)object).a) {
            object = bf2;
            n2 = new Integer((int)((com.wirelesscar.ngtp.svc.a.b.c)object).h.c());
        } else {
            n2 = null;
        }
        super(version, string, n3, n2);
        object = bf2;
        e e2 = new e(((com.wirelesscar.ngtp.svc.a.b.c)object).e);
        object = this;
        this.a = e2;
        object = bf2;
        bf2 = ((com.wirelesscar.ngtp.svc.a.b.c)object).i;
        if (bf2 != null && ((bo)(object = bf2)).c() > 0L) {
            int n4 = 0;
            while ((long)n4 < ((bo)(object = bf2)).c()) {
                int n5 = n4++;
                object = bf2;
                object = (bg)((y)object).a[n5];
                object = new f((bg)object);
                super.a((RoRequest)object);
            }
        }
    }

    c(Version object, String string, Integer n2, Integer n3) {
        super((Version)object, string, n2, n3);
        v0.a = object = new e();
    }

    public final RoRequest addRemoteOperationRequest(boolean bl2, boolean bl3, int n2, int n3, int n4, int n5, Integer n6) {
        f f2 = new f(bl2, bl3, n2, n3, n4, n5, n6);
        super.a(f2);
        return f2;
    }

    final com.wirelesscar.ngtp.svc.a.b.c a(com.wirelesscar.ngtp.svc.a.b.c c2) {
        try {
            boolean bl2;
            bf bf2;
            bv bv2 = new bv();
            bv2.a(this.getOperationScriptVersion().getMajor());
            bv2.b(this.getOperationScriptVersion().getMinor());
            bf bf3 = bv2;
            Object object = c2;
            c2.d = bf3;
            object = (e)this.getExecutionTrigger();
            bf3 = ((e)object).a;
            object = c2;
            c2.e = bf3;
            if (this.getName() != null) {
                bf2 = c2;
                bf2.f.a(this.getName());
                boolean bl3 = true;
                object = c2;
                bl2 = true;
                bf2 = ((com.wirelesscar.ngtp.svc.a.b.c)object).a;
                ((com.wirelesscar.ngtp.svc.a.b.c)object).a.a = bl2;
            }
            if (this.getFrequency() != null) {
                long l2 = this.getFrequency().intValue();
                object = c2;
                ((com.wirelesscar.ngtp.svc.a.b.c)object).g.b(l2);
                bl2 = true;
                bf2 = ((com.wirelesscar.ngtp.svc.a.b.c)object).b;
                ((com.wirelesscar.ngtp.svc.a.b.c)object).b.a = bl2;
                boolean bl4 = true;
                object = c2;
                bl2 = true;
                bf2 = ((com.wirelesscar.ngtp.svc.a.b.c)object).b;
                ((com.wirelesscar.ngtp.svc.a.b.c)object).b.a = bl2;
            }
            if (this.getOccurs() != null) {
                long l3 = this.getOccurs().intValue();
                object = c2;
                ((com.wirelesscar.ngtp.svc.a.b.c)object).h.b(l3);
                bl2 = true;
                bf2 = ((com.wirelesscar.ngtp.svc.a.b.c)object).c;
                ((com.wirelesscar.ngtp.svc.a.b.c)object).c.a = bl2;
                boolean bl5 = true;
                object = c2;
                bl2 = true;
                bf2 = ((com.wirelesscar.ngtp.svc.a.b.c)object).c;
                ((com.wirelesscar.ngtp.svc.a.b.c)object).c.a = bl2;
            }
            if ((this = this.getRemoteOperations()) != null && this.length > 0) {
                bf2 = c2;
                bf2.i.c_(this.length);
                int n2 = 0;
                while (n2 < this.length) {
                    object = (f)this[n2];
                    bg bg2 = new bg();
                    t t2 = ((g)((b)object).getOperationDesc()).a();
                    Object object2 = bg2;
                    bg2.b = t2;
                    boolean bl6 = ((b)object).stopIfFail();
                    object2 = bg2;
                    bl2 = bl6;
                    bf2 = ((bg)object2).c;
                    ((bg)object2).c.a = bl2;
                    bl6 = ((b)object).waitForPreviousCommand();
                    object2 = bg2;
                    bl2 = bl6;
                    bf2 = ((bg)object2).d;
                    ((bg)object2).d.a = bl2;
                    long l4 = ((b)object).getOperationTimeout();
                    object2 = bg2;
                    ((bg)object2).e.b(l4);
                    l4 = ((b)object).getInitialWaitTime();
                    object2 = bg2;
                    ((bg)object2).h.b(l4);
                    l4 = ((b)object).getFrequency();
                    object2 = bg2;
                    ((bg)object2).f.b(l4);
                    l4 = ((b)object).getOccurs();
                    object2 = bg2;
                    ((bg)object2).g.b(l4);
                    if (((b)object).getRequiredVehicleStates() != null) {
                        l4 = ((b)object).getRequiredVehicleStates().intValue();
                        object2 = bg2;
                        ((bg)object2).i.b(l4);
                        boolean bl7 = true;
                        object2 = bg2;
                        bl2 = true;
                        bf2 = ((bg)object2).a;
                        ((bg)object2).a.a = bl2;
                    }
                    object = bg2;
                    bf2 = c2;
                    object2 = object;
                    int n3 = n2++;
                    object = bf2.i;
                    ((y)object).a[n3] = object2;
                }
            }
            return c2;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
        }
    }
}

