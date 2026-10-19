/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.ac;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.bk;
import com.wirelesscar.ngtp.svc.a.a.cq;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.r;
import com.wirelesscar.ngtp.svc.api.RoRequest;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.b;
import com.wirelesscar.ngtp.svc.b.b.c;
import com.wirelesscar.ngtp.svc.b.b.e;
import com.wirelesscar.ngtp.svc.b.b.j;

final class d
extends com.wirelesscar.ngtp.svc.b.c {
    d(ac aw2) {
        Integer n2;
        Integer n3;
        String string;
        Object object = aw2;
        cq cq2 = ((ac)object).d;
        object = cq2;
        object = aw2;
        object = ((ac)object).d;
        Version version = new Version((int)cq2.a.c(), (int)((cq)object).b.c());
        object = aw2;
        object = ((ac)object).a;
        if (((ap)object).a) {
            object = aw2;
            string = ((ac)object).f.d();
        } else {
            string = null;
        }
        object = aw2;
        object = ((ac)object).b;
        if (((ap)object).a) {
            object = aw2;
            n3 = new Integer((int)((ac)object).g.c());
        } else {
            n3 = null;
        }
        object = aw2;
        object = ((ac)object).c;
        if (((ap)object).a) {
            object = aw2;
            n2 = new Integer((int)((ac)object).h.c());
        } else {
            n2 = null;
        }
        super(version, string, n3, n2);
        object = aw2;
        j j2 = new j(((ac)object).e);
        object = this;
        this.a = j2;
        object = aw2;
        aw2 = ((ac)object).i;
        if (aw2 != null && ((f)(object = aw2)).c() > 0L) {
            int n4 = 0;
            while ((long)n4 < ((f)(object = aw2)).c()) {
                int n5 = n4++;
                object = aw2;
                object = (bk)((r)object).b[n5];
                object = new e((bk)object);
                super.a((RoRequest)object);
            }
        }
    }

    d(Version object, String string, Integer n2, Integer n3) {
        super((Version)object, string, n2, n3);
        v0.a = object = new j();
    }

    public final RoRequest addRemoteOperationRequest(boolean bl2, boolean bl3, int n2, int n3, int n4, int n5, Integer n6) {
        e e2 = new e(bl2, bl3, n2, n3, n4, n5, n6);
        super.a(e2);
        return e2;
    }

    final ac a(ac ac2) {
        try {
            boolean bl2;
            aw aw2;
            cq cq2 = new cq();
            cq2.a(this.getOperationScriptVersion().getMajor());
            cq2.b(this.getOperationScriptVersion().getMinor());
            aw aw3 = cq2;
            Object object = ac2;
            ac2.d = aw3;
            object = (j)this.getExecutionTrigger();
            aw3 = ((j)object).a;
            object = ac2;
            ac2.e = aw3;
            if (this.getName() != null) {
                aw2 = ac2;
                aw2.f.a(this.getName());
                boolean bl3 = true;
                object = ac2;
                bl2 = true;
                aw2 = ((ac)object).a;
                ((ac)object).a.a = bl2;
            }
            if (this.getFrequency() != null) {
                long l2 = this.getFrequency().intValue();
                object = ac2;
                ((ac)object).g.a(l2);
                bl2 = true;
                aw2 = ((ac)object).b;
                ((ac)object).b.a = bl2;
                boolean bl4 = true;
                object = ac2;
                bl2 = true;
                aw2 = ((ac)object).b;
                ((ac)object).b.a = bl2;
            }
            if (this.getOccurs() != null) {
                long l3 = this.getOccurs().intValue();
                object = ac2;
                ((ac)object).h.a(l3);
                bl2 = true;
                aw2 = ((ac)object).c;
                ((ac)object).c.a = bl2;
                boolean bl5 = true;
                object = ac2;
                bl2 = true;
                aw2 = ((ac)object).c;
                ((ac)object).c.a = bl2;
            }
            if ((this = this.getRemoteOperations()) != null && this.length > 0) {
                aw2 = ac2;
                aw2.i.b(this.length);
                int n2 = 0;
                while (n2 < this.length) {
                    object = (e)this[n2];
                    bk bk2 = new bk();
                    com.wirelesscar.ngtp.svc.a.a.b b2 = ((c)((b)object).getOperationDesc()).a();
                    Object object2 = bk2;
                    bk2.b = b2;
                    boolean bl6 = ((b)object).stopIfFail();
                    object2 = bk2;
                    bl2 = bl6;
                    aw2 = ((bk)object2).c;
                    ((bk)object2).c.a = bl2;
                    bl6 = ((b)object).waitForPreviousCommand();
                    object2 = bk2;
                    bl2 = bl6;
                    aw2 = ((bk)object2).d;
                    ((bk)object2).d.a = bl2;
                    long l4 = ((b)object).getOperationTimeout();
                    object2 = bk2;
                    ((bk)object2).e.a(l4);
                    l4 = ((b)object).getInitialWaitTime();
                    object2 = bk2;
                    ((bk)object2).h.a(l4);
                    l4 = ((b)object).getFrequency();
                    object2 = bk2;
                    ((bk)object2).f.a(l4);
                    l4 = ((b)object).getOccurs();
                    object2 = bk2;
                    ((bk)object2).g.a(l4);
                    if (((b)object).getRequiredVehicleStates() != null) {
                        l4 = ((b)object).getRequiredVehicleStates().intValue();
                        object2 = bk2;
                        ((bk)object2).i.a(l4);
                        boolean bl7 = true;
                        object2 = bk2;
                        bl2 = true;
                        aw2 = ((bk)object2).a;
                        ((bk)object2).a.a = bl2;
                    }
                    object = bk2;
                    aw2 = ac2;
                    object2 = object;
                    int n3 = n2++;
                    object = aw2.i;
                    ((r)object).b[n3] = object2;
                }
            }
            return ac2;
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
        }
    }
}

