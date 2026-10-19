/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.ag;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.au;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.l;
import com.wirelesscar.ngtp.svc.a.c.s;
import com.wirelesscar.ngtp.svc.a.c.v;
import com.wirelesscar.ngtp.svc.api.RoRequest;
import com.wirelesscar.ngtp.svc.api.Version;
import com.wirelesscar.ngtp.svc.b.a.d;
import com.wirelesscar.ngtp.svc.b.a.f;
import com.wirelesscar.ngtp.svc.b.a.i;
import com.wirelesscar.ngtp.svc.b.b;
import com.wirelesscar.ngtp.svc.b.c;

final class e
extends c {
    e(l ap2) {
        Integer n2;
        Integer n3;
        String string;
        Object object = ap2;
        s s2 = ((l)object).d;
        object = s2;
        object = ap2;
        object = ((l)object).d;
        Version version = new Version((int)s2.a.c(), (int)((s)object).b.c());
        object = ap2;
        object = ((l)object).a;
        if (((aa)object).d) {
            object = ap2;
            string = ((l)object).f.e();
        } else {
            string = null;
        }
        object = ap2;
        object = ((l)object).b;
        if (((aa)object).d) {
            object = ap2;
            n3 = new Integer((int)((l)object).g.c());
        } else {
            n3 = null;
        }
        object = ap2;
        object = ((l)object).c;
        if (((aa)object).d) {
            object = ap2;
            n2 = new Integer((int)((l)object).h.c());
        } else {
            n2 = null;
        }
        super(version, string, n3, n2);
        object = ap2;
        f f2 = new f(((l)object).e);
        object = this;
        this.a = f2;
        object = ap2;
        ap2 = ((l)object).i;
        if (ap2 != null && ((bf)(object = ap2)).c() > 0L) {
            int n4 = 0;
            while ((long)n4 < ((bf)(object = ap2)).c()) {
                int n5 = n4++;
                object = ap2;
                object = (au)((v)object).d[n5];
                object = new d((au)object);
                super.a((RoRequest)object);
            }
        }
    }

    e(Version object, String string, Integer n2, Integer n3) {
        super((Version)object, string, n2, n3);
        v0.a = object = new f();
    }

    public final RoRequest addRemoteOperationRequest(boolean bl2, boolean bl3, int n2, int n3, int n4, int n5, Integer n6) {
        d d2 = new d(bl2, bl3, n2, n3, n4, n5, n6);
        super.a(d2);
        return d2;
    }

    final l a(l l2) {
        try {
            boolean bl2;
            ap ap2;
            s s2 = new s();
            s2.a(this.getOperationScriptVersion().getMajor());
            s2.b(this.getOperationScriptVersion().getMinor());
            ap ap3 = s2;
            Object object = l2;
            l2.d = ap3;
            object = (f)this.getExecutionTrigger();
            ap3 = ((f)object).a;
            object = l2;
            l2.e = ap3;
            if (this.getName() != null) {
                ap2 = l2;
                ap2.f.a(this.getName());
                boolean bl3 = true;
                object = l2;
                bl2 = true;
                ap2 = ((l)object).a;
                ((l)object).a.d = bl2;
            }
            if (this.getFrequency() != null) {
                long l3 = this.getFrequency().intValue();
                object = l2;
                ((l)object).g.b(l3);
                bl2 = true;
                ap2 = ((l)object).b;
                ((l)object).b.d = bl2;
                boolean bl4 = true;
                object = l2;
                bl2 = true;
                ap2 = ((l)object).b;
                ((l)object).b.d = bl2;
            }
            if (this.getOccurs() != null) {
                long l4 = this.getOccurs().intValue();
                object = l2;
                ((l)object).h.b(l4);
                bl2 = true;
                ap2 = ((l)object).c;
                ((l)object).c.d = bl2;
                boolean bl5 = true;
                object = l2;
                bl2 = true;
                ap2 = ((l)object).c;
                ((l)object).c.d = bl2;
            }
            if ((this = this.getRemoteOperations()) != null && this.length > 0) {
                ap2 = l2;
                ap2.i.a_(this.length);
                int n2 = 0;
                while (n2 < this.length) {
                    object = (d)this[n2];
                    au au2 = new au();
                    ag ag2 = ((i)((b)object).getOperationDesc()).a();
                    Object object2 = au2;
                    au2.b = ag2;
                    boolean bl6 = ((b)object).stopIfFail();
                    object2 = au2;
                    bl2 = bl6;
                    ap2 = ((au)object2).c;
                    ((au)object2).c.d = bl2;
                    bl6 = ((b)object).waitForPreviousCommand();
                    object2 = au2;
                    bl2 = bl6;
                    ap2 = ((au)object2).d;
                    ((au)object2).d.d = bl2;
                    long l5 = ((b)object).getOperationTimeout();
                    object2 = au2;
                    ((au)object2).e.b(l5);
                    l5 = ((b)object).getInitialWaitTime();
                    object2 = au2;
                    ((au)object2).h.b(l5);
                    l5 = ((b)object).getFrequency();
                    object2 = au2;
                    ((au)object2).f.b(l5);
                    l5 = ((b)object).getOccurs();
                    object2 = au2;
                    ((au)object2).g.b(l5);
                    if (((b)object).getRequiredVehicleStates() != null) {
                        l5 = ((b)object).getRequiredVehicleStates().intValue();
                        object2 = au2;
                        ((au)object2).i.b(l5);
                        boolean bl7 = true;
                        object2 = au2;
                        bl2 = true;
                        ap2 = ((au)object2).a;
                        ((au)object2).a.d = bl2;
                    }
                    object = au2;
                    ap2 = l2;
                    object2 = object;
                    int n3 = n2++;
                    object = ap2.i;
                    ((v)object).d[n3] = object2;
                }
            }
            return l2;
        }
        catch (j j2) {
            throw new RuntimeException(j2.getMessage());
        }
    }
}

