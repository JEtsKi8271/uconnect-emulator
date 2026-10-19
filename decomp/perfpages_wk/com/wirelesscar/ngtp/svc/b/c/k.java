/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.af;
import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bj;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.cn;
import com.wirelesscar.ngtp.svc.a.b.i;
import com.wirelesscar.ngtp.svc.api.PersonName;
import com.wirelesscar.ngtp.svc.api.PointOfInterest;
import com.wirelesscar.ngtp.svc.api.PostalAddress;
import com.wirelesscar.ngtp.svc.b.c.a;

final class k {
    k() {
    }

    static af a(PointOfInterest pointOfInterest) {
        try {
            bf bf2;
            bm bm2;
            Object object;
            af af2 = new af();
            if (pointOfInterest.getAddress() != null) {
                af2.e(true);
                object = pointOfInterest.getAddress();
                bm2 = new bj();
                if (((PostalAddress)object).getCity() != null) {
                    ((bj)bm2).c(true);
                    bf2 = bm2;
                    ((bj)bf2).i.a(((PostalAddress)object).getCity());
                } else {
                    ((bj)bm2).c(false);
                }
                if (((PostalAddress)object).getCountry() != null) {
                    ((bj)bm2).f(true);
                    bf2 = bm2;
                    ((bj)bf2).l.a(((PostalAddress)object).getCountry());
                } else {
                    ((bj)bm2).f(false);
                }
                if (((PostalAddress)object).getHouseNumber() != null) {
                    ((bj)bm2).b(true);
                    bf2 = bm2;
                    ((bj)bf2).h.a(((PostalAddress)object).getHouseNumber());
                } else {
                    ((bj)bm2).b(false);
                }
                if (((PostalAddress)object).getPostalCode() != null) {
                    ((bj)bm2).e(true);
                    bf2 = bm2;
                    ((bj)bf2).k.a(((PostalAddress)object).getPostalCode());
                } else {
                    ((bj)bm2).e(false);
                }
                if (((PostalAddress)object).getRegion() != null) {
                    ((bj)bm2).d(true);
                    bf2 = bm2;
                    ((bj)bf2).j.a(((PostalAddress)object).getRegion());
                } else {
                    ((bj)bm2).d(false);
                }
                if (((PostalAddress)object).getStreet() != null) {
                    ((bj)bm2).a(true);
                    bf2 = bm2;
                    ((bj)bf2).g.a(((PostalAddress)object).getStreet());
                } else {
                    ((bj)bm2).a(false);
                }
                object = af2;
                af2.t = bm2;
            } else {
                af2.e(false);
            }
            if (pointOfInterest.getCategory() != null) {
                af2.a(true);
                bf2 = af2;
                bf2.p.a(pointOfInterest.getCategory());
            } else {
                af2.a(false);
            }
            if (pointOfInterest.getEmail() != null) {
                af2.k(true);
                bf2 = af2;
                bf2.z.a(pointOfInterest.getEmail());
            } else {
                af2.k(false);
            }
            if (pointOfInterest.getEnhPOIurl() != null) {
                af2.m(true);
                bf2 = af2;
                bf2.C.a(pointOfInterest.getEnhPOIurl());
            } else {
                af2.m(false);
            }
            if (pointOfInterest.getFreetext() != null) {
                af2.b(true);
                bf2 = af2;
                bf2.q.a(pointOfInterest.getFreetext());
            } else {
                af2.b(false);
            }
            if (pointOfInterest.getGeoCoordinates() != null) {
                af2.l(true);
                bf2 = af2;
                bf2.A.a(pointOfInterest.getGeoCoordinates().getNgtpLatitude());
                bf2 = af2;
                bf2.A.b(pointOfInterest.getGeoCoordinates().getNgtpLongitude());
            } else {
                af2.l(false);
            }
            if (pointOfInterest.getName() != null) {
                af2.c(true);
                object = pointOfInterest.getName();
                bm2 = new cn();
                if (((PersonName)object).getFirstName() != null) {
                    ((cn)bm2).b(true);
                    bf2 = bm2;
                    ((cn)bf2).g.a(((PersonName)object).getFirstName());
                } else {
                    ((cn)bm2).b(false);
                }
                if (((PersonName)object).getFamilyName() != null) {
                    ((cn)bm2).a(true);
                    bf2 = bm2;
                    ((cn)bf2).f.a(((PersonName)object).getFamilyName());
                } else {
                    ((cn)bm2).a(false);
                }
                if (((PersonName)object).getMiddleName() != null) {
                    ((cn)bm2).c(true);
                    bf2 = bm2;
                    ((cn)bf2).h.a(((PersonName)object).getMiddleName());
                } else {
                    ((cn)bm2).c(false);
                }
                if (((PersonName)object).getPrefix() != null) {
                    ((cn)bm2).d(true);
                    bf2 = bm2;
                    ((cn)bf2).i.a(((PersonName)object).getPrefix());
                } else {
                    ((cn)bm2).d(false);
                }
                if (((PersonName)object).getSuffix() != null) {
                    ((cn)bm2).e(true);
                    bf2 = bm2;
                    ((cn)bf2).j.a(((PersonName)object).getSuffix());
                } else {
                    ((cn)bm2).e(false);
                }
                object = af2;
                af2.r = bm2;
            } else {
                af2.c(false);
            }
            if (pointOfInterest.getOrganization() != null) {
                af2.d(true);
                bf2 = af2;
                bf2.s.a(pointOfInterest.getOrganization());
            } else {
                af2.d(false);
            }
            if (pointOfInterest.getPhone1() != null) {
                af2.f(true);
                bm2 = a.a(pointOfInterest.getPhone1());
                object = af2;
                af2.u = bm2;
            } else {
                af2.f(false);
            }
            if (pointOfInterest.getPhone2() != null) {
                af2.g(true);
                bm2 = a.a(pointOfInterest.getPhone2());
                object = af2;
                af2.v = bm2;
            } else {
                af2.g(false);
            }
            if (pointOfInterest.getPhone3() != null) {
                af2.h(true);
                bm2 = a.a(pointOfInterest.getPhone3());
                object = af2;
                af2.w = bm2;
            } else {
                af2.h(false);
            }
            if (pointOfInterest.getPhone4() != null) {
                af2.i(true);
                bm2 = a.a(pointOfInterest.getPhone4());
                object = af2;
                af2.x = bm2;
            } else {
                af2.i(false);
            }
            bf2 = af2;
            bf2.o.a(pointOfInterest.getSubject());
            if (pointOfInterest.getUrl() != null) {
                af2.j(true);
                bf2 = af2;
                bf2.y.a(pointOfInterest.getUrl());
            } else {
                af2.j(false);
            }
            int n2 = pointOfInterest.getUseAsDestination() == null ? 0 : pointOfInterest.getUseAsDestination();
            object = af2;
            int n3 = n2;
            bf2 = ((af)object).B;
            ((af)object).B.a = n3;
            if (pointOfInterest.getPOIAttributes() != null && pointOfInterest.getPOIAttributes().length > 0) {
                af2.n(true);
                for (n3 = 0; n3 < pointOfInterest.getPOIAttributes().length; ++n3) {
                    bf2 = af2;
                    bf2.D.c_(pointOfInterest.getPOIAttributes().length);
                    bf2 = af2;
                    bf2 = bf2.D.b(n3);
                    ((i)bf2).a.a(pointOfInterest.getPOIAttributes()[n3].getKey());
                    bf2 = af2;
                    bf2 = bf2.D.b(n3);
                    ((i)bf2).b.a(pointOfInterest.getPOIAttributes()[n3].getKey());
                }
            } else {
                af2.n(false);
            }
            return af2;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
        }
    }
}

