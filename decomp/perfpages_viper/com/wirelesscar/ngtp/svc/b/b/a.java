/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.ay;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.p;
import com.wirelesscar.ngtp.svc.a.a.q;
import com.wirelesscar.ngtp.svc.a.a.s;
import com.wirelesscar.ngtp.svc.api.PersonName;
import com.wirelesscar.ngtp.svc.api.PointOfInterest;
import com.wirelesscar.ngtp.svc.api.PostalAddress;
import com.wirelesscar.ngtp.svc.b.b.i;

final class a {
    a() {
    }

    static p a(PointOfInterest pointOfInterest) {
        try {
            aw aw2;
            bn bn2;
            Object object;
            p p2 = new p();
            if (pointOfInterest.getAddress() != null) {
                p2.e(true);
                object = pointOfInterest.getAddress();
                bn2 = new q();
                if (((PostalAddress)object).getCity() != null) {
                    ((q)bn2).c(true);
                    aw2 = bn2;
                    ((q)aw2).i.a(((PostalAddress)object).getCity());
                } else {
                    ((q)bn2).c(false);
                }
                if (((PostalAddress)object).getCountry() != null) {
                    ((q)bn2).f(true);
                    aw2 = bn2;
                    ((q)aw2).l.a(((PostalAddress)object).getCountry());
                } else {
                    ((q)bn2).f(false);
                }
                if (((PostalAddress)object).getHouseNumber() != null) {
                    ((q)bn2).b(true);
                    aw2 = bn2;
                    ((q)aw2).h.a(((PostalAddress)object).getHouseNumber());
                } else {
                    ((q)bn2).b(false);
                }
                if (((PostalAddress)object).getPostalCode() != null) {
                    ((q)bn2).e(true);
                    aw2 = bn2;
                    ((q)aw2).k.a(((PostalAddress)object).getPostalCode());
                } else {
                    ((q)bn2).e(false);
                }
                if (((PostalAddress)object).getRegion() != null) {
                    ((q)bn2).d(true);
                    aw2 = bn2;
                    ((q)aw2).j.a(((PostalAddress)object).getRegion());
                } else {
                    ((q)bn2).d(false);
                }
                if (((PostalAddress)object).getStreet() != null) {
                    ((q)bn2).a(true);
                    aw2 = bn2;
                    ((q)aw2).g.a(((PostalAddress)object).getStreet());
                } else {
                    ((q)bn2).a(false);
                }
                object = p2;
                p2.t = bn2;
            } else {
                p2.e(false);
            }
            if (pointOfInterest.getCategory() != null) {
                p2.a(true);
                aw2 = p2;
                aw2.p.a(pointOfInterest.getCategory());
            } else {
                p2.a(false);
            }
            if (pointOfInterest.getEmail() != null) {
                p2.k(true);
                aw2 = p2;
                aw2.z.a(pointOfInterest.getEmail());
            } else {
                p2.k(false);
            }
            if (pointOfInterest.getEnhPOIurl() != null) {
                p2.m(true);
                aw2 = p2;
                aw2.C.a(pointOfInterest.getEnhPOIurl());
            } else {
                p2.m(false);
            }
            if (pointOfInterest.getFreetext() != null) {
                p2.b(true);
                aw2 = p2;
                aw2.q.a(pointOfInterest.getFreetext());
            } else {
                p2.b(false);
            }
            if (pointOfInterest.getGeoCoordinates() != null) {
                p2.l(true);
                aw2 = p2;
                aw2.A.a(pointOfInterest.getGeoCoordinates().getNgtpLatitude());
                aw2 = p2;
                aw2.A.b(pointOfInterest.getGeoCoordinates().getNgtpLongitude());
            } else {
                p2.l(false);
            }
            if (pointOfInterest.getName() != null) {
                p2.c(true);
                object = pointOfInterest.getName();
                bn2 = new s();
                if (((PersonName)object).getFirstName() != null) {
                    ((s)bn2).b(true);
                    aw2 = bn2;
                    ((s)aw2).g.a(((PersonName)object).getFirstName());
                } else {
                    ((s)bn2).b(false);
                }
                if (((PersonName)object).getFamilyName() != null) {
                    ((s)bn2).a(true);
                    aw2 = bn2;
                    ((s)aw2).f.a(((PersonName)object).getFamilyName());
                } else {
                    ((s)bn2).a(false);
                }
                if (((PersonName)object).getMiddleName() != null) {
                    ((s)bn2).c(true);
                    aw2 = bn2;
                    ((s)aw2).h.a(((PersonName)object).getMiddleName());
                } else {
                    ((s)bn2).c(false);
                }
                if (((PersonName)object).getPrefix() != null) {
                    ((s)bn2).d(true);
                    aw2 = bn2;
                    ((s)aw2).i.a(((PersonName)object).getPrefix());
                } else {
                    ((s)bn2).d(false);
                }
                if (((PersonName)object).getSuffix() != null) {
                    ((s)bn2).e(true);
                    aw2 = bn2;
                    ((s)aw2).j.a(((PersonName)object).getSuffix());
                } else {
                    ((s)bn2).e(false);
                }
                object = p2;
                p2.r = bn2;
            } else {
                p2.c(false);
            }
            if (pointOfInterest.getOrganization() != null) {
                p2.d(true);
                aw2 = p2;
                aw2.s.a(pointOfInterest.getOrganization());
            } else {
                p2.d(false);
            }
            if (pointOfInterest.getPhone1() != null) {
                p2.f(true);
                bn2 = i.a(pointOfInterest.getPhone1());
                object = p2;
                p2.u = bn2;
            } else {
                p2.f(false);
            }
            if (pointOfInterest.getPhone2() != null) {
                p2.g(true);
                bn2 = i.a(pointOfInterest.getPhone2());
                object = p2;
                p2.v = bn2;
            } else {
                p2.g(false);
            }
            if (pointOfInterest.getPhone3() != null) {
                p2.h(true);
                bn2 = i.a(pointOfInterest.getPhone3());
                object = p2;
                p2.w = bn2;
            } else {
                p2.h(false);
            }
            if (pointOfInterest.getPhone4() != null) {
                p2.i(true);
                bn2 = i.a(pointOfInterest.getPhone4());
                object = p2;
                p2.x = bn2;
            } else {
                p2.i(false);
            }
            aw2 = p2;
            aw2.o.a(pointOfInterest.getSubject());
            if (pointOfInterest.getUrl() != null) {
                p2.j(true);
                aw2 = p2;
                aw2.y.a(pointOfInterest.getUrl());
            } else {
                p2.j(false);
            }
            int n2 = pointOfInterest.getUseAsDestination() == null ? 0 : pointOfInterest.getUseAsDestination();
            object = p2;
            int n3 = n2;
            aw2 = ((p)object).B;
            ((p)object).B.a = n3;
            if (pointOfInterest.getPOIAttributes() != null && pointOfInterest.getPOIAttributes().length > 0) {
                p2.n(true);
                for (n3 = 0; n3 < pointOfInterest.getPOIAttributes().length; ++n3) {
                    aw2 = p2;
                    aw2.D.b((long)pointOfInterest.getPOIAttributes().length);
                    aw2 = p2;
                    aw2 = aw2.D.b(n3);
                    ((ay)aw2).a.a(pointOfInterest.getPOIAttributes()[n3].getKey());
                    aw2 = p2;
                    aw2 = aw2.D.b(n3);
                    ((ay)aw2).b.a(pointOfInterest.getPOIAttributes()[n3].getKey());
                }
            } else {
                p2.n(false);
            }
            return p2;
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
        }
    }
}

