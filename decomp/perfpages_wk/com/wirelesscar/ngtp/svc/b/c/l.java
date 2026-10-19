/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.ab;
import com.wirelesscar.ngtp.svc.a.b.af;
import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.ax;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bj;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.cd;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.ci;
import com.wirelesscar.ngtp.svc.a.b.cn;
import com.wirelesscar.ngtp.svc.a.b.i;
import com.wirelesscar.ngtp.svc.a.b.n;
import com.wirelesscar.ngtp.svc.a.b.p;
import com.wirelesscar.ngtp.svc.api.PersonName;
import com.wirelesscar.ngtp.svc.api.Phone;
import com.wirelesscar.ngtp.svc.api.PointOfInterest;
import com.wirelesscar.ngtp.svc.api.PostalAddress;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.Waypoint;
import com.wirelesscar.ngtp.svc.b.c.a;
import com.wirelesscar.ngtp.svc.b.c.c;
import com.wirelesscar.ngtp.svc.b.c.h;
import com.wirelesscar.ngtp.svc.b.c.k;

final class l
extends h
implements SvcDownlinkMessage {
    private RoRequestList b;

    l(cd bm2) {
        super((cd)bm2);
        this.b = null;
        try {
            bf bf2 = bm2;
            bf2 = bf2.g.e();
            bf2 = ((p)bf2).b;
            if (((cf)bf2).a) {
                bf2 = bm2;
                bf2 = bf2.g.e();
                bm2 = ((p)bf2).e;
                this.b = new c((com.wirelesscar.ngtp.svc.a.b.c)bm2);
            }
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
        }
    }

    l(RoRequestList roRequestList) {
        ((l)((Object)p2)).b = null;
        try {
            ((l)((Object)p2)).a.b(true);
            cd cd2 = ((l)((Object)p2)).a;
            cd2.g.f();
            cd2 = ((l)((Object)p2)).a;
            p p2 = cd2.g.e();
            boolean bl2 = true;
            Object object = p2;
            boolean bl3 = true;
            object = p2.b;
            p2.b.a = bl3;
            object = p2;
            ((c)roRequestList).a(((p)object).e);
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.toString());
        }
    }

    l() {
        ((l)((Object)cd2)).b = null;
        try {
            ((l)((Object)cd2)).a.b(true);
            cd cd2 = ((l)((Object)cd2)).a;
            cd2.g.f();
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.toString());
        }
    }

    public final boolean isRemoteOperationUpdateRequest() {
        return this.b != null;
    }

    public final RoRequestList getRemoteOperationRequestList() {
        return this.b;
    }

    public final String getGenericText() {
        bf bf2 = this.a();
        bf2 = bf2.c;
        if (((cf)bf2).a) {
            bf2 = this.a();
            bf2 = bf2.f;
            return ((ci)bf2).a.e();
        }
        return null;
    }

    public final void setGenericText(String string) {
        if (string != null) {
            ((l)object).a().b(true);
            Object object = ((l)object).a();
            object = ((p)object).f;
            ((ci)object).a.a(string);
            return;
        }
        ((l)object).a().b(false);
    }

    public final String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SvcDownlinkMessageImpl").append(" [");
        stringBuffer.append(super.toString());
        stringBuffer.append("]");
        return stringBuffer.toString();
    }

    private p a() {
        try {
            cd cd2 = ((l)((Object)cd2)).a;
            return cd2.g.e();
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
        }
    }

    public final PointOfInterest[] getPointOfInterests() {
        PointOfInterest[] pointOfInterestArray = null;
        Object object = this = ((l)this).a();
        Object object2 = ((p)this).a;
        if (((cf)object2).a) {
            object2 = this;
            object2 = this = ((p)object2).d;
            pointOfInterestArray = new PointOfInterest[(int)((bo)this).c()];
            for (int i2 = 0; i2 < pointOfInterestArray.length; ++i2) {
                Object object3;
                String string;
                String string2;
                String string3;
                String string4;
                String string5;
                int n2 = i2;
                object = this;
                object = (af)((n)object).a[n2];
                Object object4 = null;
                String string6 = null;
                String string7 = null;
                String string8 = null;
                String string9 = null;
                Waypoint waypoint = null;
                PersonName personName = null;
                String string10 = null;
                Phone phone = null;
                Phone phone2 = null;
                Phone phone3 = null;
                Phone phone4 = null;
                String string11 = null;
                Object object5 = object;
                object2 = ((af)object5).e;
                if (((cf)object2).a) {
                    object5 = object;
                    object5 = ((af)object5).t;
                    string5 = null;
                    string4 = null;
                    string3 = null;
                    string2 = null;
                    string = null;
                    object3 = null;
                    object4 = object5;
                    object2 = ((bj)object4).b;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string5 = ((bj)object2).h.e();
                    }
                    object4 = object5;
                    object2 = ((bj)object4).c;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string4 = ((bj)object2).i.e();
                    }
                    object4 = object5;
                    object2 = ((bj)object4).f;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string3 = ((bj)object2).l.e();
                    }
                    object4 = object5;
                    object2 = ((bj)object4).e;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string2 = ((bj)object2).k.e();
                    }
                    object4 = object5;
                    object2 = ((bj)object4).d;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string = ((bj)object2).j.e();
                    }
                    object4 = object5;
                    object2 = ((bj)object4).a;
                    if (((cf)object2).a) {
                        object2 = object5;
                        object3 = ((bj)object2).g.e();
                    }
                    object4 = new PostalAddress((String)object3, string5, string4, string, string2, string3);
                }
                object5 = object;
                object2 = ((af)object5).a;
                if (((cf)object2).a) {
                    object2 = object;
                    string6 = ((af)object2).p.e();
                }
                object5 = object;
                object2 = ((af)object5).k;
                if (((cf)object2).a) {
                    object2 = object;
                    string7 = ((af)object2).z.e();
                }
                object5 = object;
                object2 = ((af)object5).m;
                if (((cf)object2).a) {
                    object2 = object;
                    string8 = ((af)object2).C.e();
                }
                object5 = object;
                object2 = ((af)object5).b;
                if (((cf)object2).a) {
                    object2 = object;
                    string9 = ((af)object2).q.e();
                }
                object5 = object;
                object2 = ((af)object5).l;
                if (((cf)object2).a) {
                    object2 = object;
                    ab ab2 = ((af)object2).A;
                    object2 = ab2;
                    object2 = object;
                    object2 = ((af)object2).A;
                    waypoint = new Waypoint((int)ab2.a.c(), (int)((ab)object2).b.c());
                }
                object5 = object;
                object2 = ((af)object5).c;
                if (((cf)object2).a) {
                    object5 = object;
                    object5 = ((af)object5).r;
                    string5 = null;
                    string4 = null;
                    string3 = null;
                    string2 = null;
                    string = null;
                    object3 = object5;
                    object2 = ((cn)object3).a;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string5 = ((cn)object2).f.e();
                    }
                    object3 = object5;
                    object2 = ((cn)object3).b;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string4 = ((cn)object2).g.e();
                    }
                    object3 = object5;
                    object2 = ((cn)object3).c;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string3 = ((cn)object2).h.e();
                    }
                    object3 = object5;
                    object2 = ((cn)object3).d;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string2 = ((cn)object2).i.e();
                    }
                    object3 = object5;
                    object2 = ((cn)object3).e;
                    if (((cf)object2).a) {
                        object2 = object5;
                        string = ((cn)object2).j.e();
                    }
                    personName = new PersonName(string5, string4, string3, string2, string);
                }
                object5 = object;
                object2 = ((af)object5).d;
                if (((cf)object2).a) {
                    object2 = object;
                    string10 = ((af)object2).s.e();
                }
                object5 = object;
                object2 = ((af)object5).f;
                if (((cf)object2).a) {
                    object5 = object;
                    phone = com.wirelesscar.ngtp.svc.b.c.a.a(((af)object5).u);
                }
                object5 = object;
                object2 = ((af)object5).g;
                if (((cf)object2).a) {
                    object5 = object;
                    phone2 = com.wirelesscar.ngtp.svc.b.c.a.a(((af)object5).v);
                }
                object5 = object;
                object2 = ((af)object5).h;
                if (((cf)object2).a) {
                    object5 = object;
                    phone3 = com.wirelesscar.ngtp.svc.b.c.a.a(((af)object5).w);
                }
                object5 = object;
                object2 = ((af)object5).i;
                if (((cf)object2).a) {
                    object5 = object;
                    phone4 = com.wirelesscar.ngtp.svc.b.c.a.a(((af)object5).x);
                }
                object2 = object;
                string5 = ((af)object2).o.e();
                object5 = object;
                object2 = ((af)object5).j;
                if (((cf)object2).a) {
                    object2 = object;
                    string11 = ((af)object2).y.e();
                }
                object5 = object;
                object2 = ((af)object5).B;
                object5 = new Boolean(((cf)object2).a);
                object4 = new PointOfInterest(string5, string6, string9, personName, string10, (PostalAddress)object4, phone, phone2, phone3, phone4, string11, string7, waypoint, (Boolean)object5, string8);
                object5 = object;
                object2 = ((af)object5).n;
                if (((cf)object2).a) {
                    int n3 = 0;
                    while (true) {
                        object2 = object;
                        object2 = ((af)object2).D;
                        if ((long)n3 >= ((bo)object2).c()) break;
                        object2 = object;
                        i i3 = ((af)object2).D.b(n3);
                        object2 = i3;
                        object2 = object;
                        object2 = ((af)object2).D.b(n3);
                        ((PointOfInterest)object4).addPOIAttribute(i3.a.e(), ((i)object2).b.e());
                        ++n3;
                    }
                }
                pointOfInterestArray[i2] = object4;
            }
        }
        return pointOfInterestArray;
    }

    public final void setPointOfInterests(PointOfInterest[] pointOfInterestArray) {
        if (pointOfInterestArray != null) {
            bf bf2 = this.a();
            bf2 = ((p)bf2).d;
            try {
                ((ax)bf2).c_(pointOfInterestArray.length);
            }
            catch (ai ai2) {
                throw new RuntimeException(ai2.toString());
            }
            int n2 = 0;
            while (n2 < pointOfInterestArray.length) {
                af af2 = k.a(pointOfInterestArray[n2]);
                int n3 = n2++;
                bf bf3 = bf2;
                ((n)bf3).a[n3] = af2;
            }
            this.a().a(true);
            return;
        }
        this.a().a(false);
    }
}

