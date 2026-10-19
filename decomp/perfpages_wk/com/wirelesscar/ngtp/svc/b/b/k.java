/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.ac;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.ay;
import com.wirelesscar.ngtp.svc.a.a.br;
import com.wirelesscar.ngtp.svc.a.a.c;
import com.wirelesscar.ngtp.svc.a.a.cj;
import com.wirelesscar.ngtp.svc.a.a.ck;
import com.wirelesscar.ngtp.svc.a.a.cl;
import com.wirelesscar.ngtp.svc.a.a.f;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.p;
import com.wirelesscar.ngtp.svc.a.a.q;
import com.wirelesscar.ngtp.svc.a.a.s;
import com.wirelesscar.ngtp.svc.api.PersonName;
import com.wirelesscar.ngtp.svc.api.Phone;
import com.wirelesscar.ngtp.svc.api.PointOfInterest;
import com.wirelesscar.ngtp.svc.api.PostalAddress;
import com.wirelesscar.ngtp.svc.api.RoRequestList;
import com.wirelesscar.ngtp.svc.api.SvcDownlinkMessage;
import com.wirelesscar.ngtp.svc.api.Waypoint;
import com.wirelesscar.ngtp.svc.b.b.a;
import com.wirelesscar.ngtp.svc.b.b.b;
import com.wirelesscar.ngtp.svc.b.b.d;
import com.wirelesscar.ngtp.svc.b.b.i;

final class k
extends b
implements SvcDownlinkMessage {
    private RoRequestList b;

    k(ck bn2) {
        super((ck)bn2);
        this.b = null;
        try {
            aw aw2 = bn2;
            aw2 = aw2.g.e();
            aw2 = ((cj)aw2).b;
            if (((ap)aw2).a) {
                aw2 = bn2;
                aw2 = aw2.g.e();
                bn2 = ((cj)aw2).e;
                this.b = new d((ac)bn2);
            }
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
        }
    }

    k(RoRequestList roRequestList) {
        ((k)((Object)cj2)).b = null;
        try {
            ((k)((Object)cj2)).a.b(true);
            ck ck2 = ((k)((Object)cj2)).a;
            ck2.g.g();
            ck2 = ((k)((Object)cj2)).a;
            cj cj2 = ck2.g.e();
            boolean bl2 = true;
            Object object = cj2;
            boolean bl3 = true;
            object = cj2.b;
            cj2.b.a = bl3;
            object = cj2;
            ((d)roRequestList).a(((cj)object).e);
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.toString());
        }
    }

    k() {
        ((k)((Object)ck2)).b = null;
        try {
            ((k)((Object)ck2)).a.b(true);
            ck ck2 = ((k)((Object)ck2)).a;
            ck2.g.g();
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.toString());
        }
    }

    public final boolean isRemoteOperationUpdateRequest() {
        return this.b != null;
    }

    public final RoRequestList getRemoteOperationRequestList() {
        return this.b;
    }

    public final String getGenericText() {
        aw aw2 = this.a();
        aw2 = aw2.c;
        if (((ap)aw2).a) {
            aw2 = this.a();
            aw2 = aw2.f;
            return ((cl)aw2).a.d();
        }
        return null;
    }

    public final void setGenericText(String string) {
        if (string != null) {
            ((k)object).a().b(true);
            Object object = ((k)object).a();
            object = ((cj)object).f;
            ((cl)object).a.a(string);
            return;
        }
        ((k)object).a().b(false);
    }

    public final String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SvcDownlinkMessageImpl").append(" [");
        stringBuffer.append(super.toString());
        stringBuffer.append("]");
        return stringBuffer.toString();
    }

    private cj a() {
        try {
            ck ck2 = ((k)((Object)ck2)).a;
            return ck2.g.e();
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
        }
    }

    public final PointOfInterest[] getPointOfInterests() {
        PointOfInterest[] pointOfInterestArray = null;
        Object object = this = ((k)this).a();
        Object object2 = ((cj)this).a;
        if (((ap)object2).a) {
            object2 = this;
            object2 = this = ((cj)object2).d;
            pointOfInterestArray = new PointOfInterest[(int)((f)this).c()];
            for (int i2 = 0; i2 < pointOfInterestArray.length; ++i2) {
                Object object3;
                String string;
                String string2;
                String string3;
                String string4;
                String string5;
                int n2 = i2;
                object = this;
                object = (p)((br)object).b[n2];
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
                object2 = ((p)object5).e;
                if (((ap)object2).a) {
                    object5 = object;
                    object5 = ((p)object5).t;
                    string5 = null;
                    string4 = null;
                    string3 = null;
                    string2 = null;
                    string = null;
                    object3 = null;
                    object4 = object5;
                    object2 = ((q)object4).b;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string5 = ((q)object2).h.d();
                    }
                    object4 = object5;
                    object2 = ((q)object4).c;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string4 = ((q)object2).i.d();
                    }
                    object4 = object5;
                    object2 = ((q)object4).f;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string3 = ((q)object2).l.d();
                    }
                    object4 = object5;
                    object2 = ((q)object4).e;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string2 = ((q)object2).k.d();
                    }
                    object4 = object5;
                    object2 = ((q)object4).d;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string = ((q)object2).j.d();
                    }
                    object4 = object5;
                    object2 = ((q)object4).a;
                    if (((ap)object2).a) {
                        object2 = object5;
                        object3 = ((q)object2).g.d();
                    }
                    object4 = new PostalAddress((String)object3, string5, string4, string, string2, string3);
                }
                object5 = object;
                object2 = ((p)object5).a;
                if (((ap)object2).a) {
                    object2 = object;
                    string6 = ((p)object2).p.d();
                }
                object5 = object;
                object2 = ((p)object5).k;
                if (((ap)object2).a) {
                    object2 = object;
                    string7 = ((p)object2).z.d();
                }
                object5 = object;
                object2 = ((p)object5).m;
                if (((ap)object2).a) {
                    object2 = object;
                    string8 = ((p)object2).C.d();
                }
                object5 = object;
                object2 = ((p)object5).b;
                if (((ap)object2).a) {
                    object2 = object;
                    string9 = ((p)object2).q.d();
                }
                object5 = object;
                object2 = ((p)object5).l;
                if (((ap)object2).a) {
                    object2 = object;
                    c c2 = ((p)object2).A;
                    object2 = c2;
                    object2 = object;
                    object2 = ((p)object2).A;
                    waypoint = new Waypoint((int)c2.a.c(), (int)((c)object2).b.c());
                }
                object5 = object;
                object2 = ((p)object5).c;
                if (((ap)object2).a) {
                    object5 = object;
                    object5 = ((p)object5).r;
                    string5 = null;
                    string4 = null;
                    string3 = null;
                    string2 = null;
                    string = null;
                    object3 = object5;
                    object2 = ((s)object3).a;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string5 = ((s)object2).f.d();
                    }
                    object3 = object5;
                    object2 = ((s)object3).b;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string4 = ((s)object2).g.d();
                    }
                    object3 = object5;
                    object2 = ((s)object3).c;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string3 = ((s)object2).h.d();
                    }
                    object3 = object5;
                    object2 = ((s)object3).d;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string2 = ((s)object2).i.d();
                    }
                    object3 = object5;
                    object2 = ((s)object3).e;
                    if (((ap)object2).a) {
                        object2 = object5;
                        string = ((s)object2).j.d();
                    }
                    personName = new PersonName(string5, string4, string3, string2, string);
                }
                object5 = object;
                object2 = ((p)object5).d;
                if (((ap)object2).a) {
                    object2 = object;
                    string10 = ((p)object2).s.d();
                }
                object5 = object;
                object2 = ((p)object5).f;
                if (((ap)object2).a) {
                    object5 = object;
                    phone = i.a(((p)object5).u);
                }
                object5 = object;
                object2 = ((p)object5).g;
                if (((ap)object2).a) {
                    object5 = object;
                    phone2 = i.a(((p)object5).v);
                }
                object5 = object;
                object2 = ((p)object5).h;
                if (((ap)object2).a) {
                    object5 = object;
                    phone3 = i.a(((p)object5).w);
                }
                object5 = object;
                object2 = ((p)object5).i;
                if (((ap)object2).a) {
                    object5 = object;
                    phone4 = i.a(((p)object5).x);
                }
                object2 = object;
                string5 = ((p)object2).o.d();
                object5 = object;
                object2 = ((p)object5).j;
                if (((ap)object2).a) {
                    object2 = object;
                    string11 = ((p)object2).y.d();
                }
                object5 = object;
                object2 = ((p)object5).B;
                object5 = new Boolean(((ap)object2).a);
                object4 = new PointOfInterest(string5, string6, string9, personName, string10, (PostalAddress)object4, phone, phone2, phone3, phone4, string11, string7, waypoint, (Boolean)object5, string8);
                object5 = object;
                object2 = ((p)object5).n;
                if (((ap)object2).a) {
                    int n3 = 0;
                    while (true) {
                        object2 = object;
                        object2 = ((p)object2).D;
                        if ((long)n3 >= ((f)object2).c()) break;
                        object2 = object;
                        ay ay2 = ((p)object2).D.b(n3);
                        object2 = ay2;
                        object2 = object;
                        object2 = ((p)object2).D.b(n3);
                        ((PointOfInterest)object4).addPOIAttribute(ay2.a.d(), ((ay)object2).b.d());
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
            aw aw2 = this.a();
            aw2 = ((cj)aw2).d;
            try {
                ((com.wirelesscar.ngtp.svc.a.a.i)aw2).b(pointOfInterestArray.length);
            }
            catch (o o2) {
                throw new RuntimeException(o2.toString());
            }
            int n2 = 0;
            while (n2 < pointOfInterestArray.length) {
                p p2 = com.wirelesscar.ngtp.svc.b.b.a.a(pointOfInterestArray[n2]);
                int n3 = n2++;
                aw aw3 = aw2;
                ((br)aw3).b[n3] = p2;
            }
            this.a().a(true);
            return;
        }
        this.a().a(false);
    }
}

