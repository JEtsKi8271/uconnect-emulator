/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.a;

import com.wirelesscar.ngtp.svc.a.c.aa;
import com.wirelesscar.ngtp.svc.a.c.af;
import com.wirelesscar.ngtp.svc.a.c.ai;
import com.wirelesscar.ngtp.svc.a.c.ap;
import com.wirelesscar.ngtp.svc.a.c.bb;
import com.wirelesscar.ngtp.svc.a.c.be;
import com.wirelesscar.ngtp.svc.a.c.bf;
import com.wirelesscar.ngtp.svc.a.c.bg;
import com.wirelesscar.ngtp.svc.a.c.bi;
import com.wirelesscar.ngtp.svc.a.c.bl;
import com.wirelesscar.ngtp.svc.a.c.j;
import com.wirelesscar.ngtp.svc.a.c.m;
import com.wirelesscar.ngtp.svc.a.c.n;
import com.wirelesscar.ngtp.svc.api.PositionQuality;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.VehicleStatus;
import com.wirelesscar.ngtp.svc.api.Waypoint;
import com.wirelesscar.ngtp.svc.b.a.c;
import com.wirelesscar.ngtp.svc.b.a.g;

final class a
extends g
implements SvcUplinkMessage {
    private RoResponseList b;

    a(ai g2) {
        super((ai)g2);
        this.b = null;
        try {
            ap ap2 = this.a();
            ap2 = ap2.a;
            if (((aa)ap2).d) {
                ap2 = g2;
                ap2 = ((ai)ap2).g.c();
                g2 = ap2.d;
                this.b = new c((n)g2);
            }
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.getMessage());
        }
    }

    a(RoResponseList roResponseList, boolean bl2) {
        ((a)((Object)be2)).b = null;
        try {
            ((a)((Object)be2)).a.b(true);
            Object object = ((a)((Object)be2)).a;
            ((ai)object).g.d();
            ((a)((Object)be2)).a.a(bl2 ? 1L : 0L);
            ((a)((Object)be2)).a.a(true);
            object = ((a)((Object)be2)).a;
            be be2 = ((ai)object).g.c();
            bl2 = true;
            be be3 = be2;
            boolean bl3 = true;
            object = be2.a;
            be2.a.d = bl3;
            object = be2;
            ((c)roResponseList).a(((be)object).d);
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.toString());
        }
    }

    a() {
        this.b = null;
        try {
            ai ai2 = this.a;
            ai2.g.d();
            this.a.b(true);
            return;
        }
        catch (j j2) {
            throw new RuntimeException(j2.getMessage());
        }
    }

    public final boolean isRemoteOperationUpdateResponse() {
        return this.b != null;
    }

    public final RoResponseList getRemoteOperationResponseList() {
        return this.b;
    }

    public final boolean isGenericText() {
        Object object = ((a)object).a();
        object = ((be)object).b;
        return ((aa)object).d;
    }

    public final String getGenericText() {
        ap ap2 = this.a();
        ap2 = ap2.b;
        if (((aa)ap2).d) {
            ap2 = this.a();
            ap2 = ap2.e;
            return ((bb)ap2).a.e();
        }
        return null;
    }

    public final void setGenericText(String string) {
        if (string != null) {
            ((a)object).a().b(true);
            Object object = ((a)object).a();
            object = ((be)object).e;
            ((bb)object).a.a(string);
            return;
        }
        ((a)object).a().b(false);
    }

    public final void setWaypoints(Waypoint[] waypointArray) {
        ap ap2 = this.a();
        if (waypointArray == null) {
            ((be)ap2).a(false);
            return;
        }
        ((be)ap2).a(true);
        Object object = ap2;
        ap2 = ((be)object).c;
        try {
            ((af)ap2).a_(waypointArray.length);
        }
        catch (j j2) {
            throw new RuntimeException(j2.getMessage());
        }
        for (int i2 = 0; i2 < waypointArray.length; ++i2) {
            Waypoint waypoint = waypointArray[i2];
            Object object2 = ((com.wirelesscar.ngtp.svc.a.c.a)ap2).a(i2);
            object = this;
            object = object2;
            long l2 = waypoint.getNgtpLatitude();
            com.wirelesscar.ngtp.svc.a.c.g g2 = ((bl)object).a;
            g2.a.b(l2);
            object = object2;
            l2 = waypoint.getNgtpLongitude();
            g2 = ((bl)object).a;
            g2.b.b(l2);
            if (waypoint.getAltitude() != null) {
                object = object2;
                ((bl)object).b.a(true);
                object = object2;
                l2 = waypoint.getAltitude().intValue();
                g2 = ((bl)object).b;
                ((bg)g2).d.b(l2);
                boolean bl2 = true;
                object = ((bg)g2).a;
                ((bg)g2).a.d = bl2;
            } else {
                object = object2;
                ((bl)object).b.a(false);
            }
            if (waypoint.getHeading() != null) {
                object = object2;
                ((bl)object).b.b(true);
                object = object2;
                l2 = waypoint.getHeading().intValue();
                bg bg2 = ((bl)object).b;
                bg2.e.b(l2);
                boolean bl3 = true;
                object = bg2.b;
                bg2.b.d = bl3;
            } else {
                object = object2;
                ((bl)object).b.b(false);
            }
            if (waypoint.getQuality() != null) {
                object = object2;
                ((bl)object).b.c(true);
                object = object2;
                object = ((bl)object).b;
                object = ((bg)object).f;
                object2 = waypoint.getQuality();
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getCalibrated());
                Object object3 = object;
                ((m)object3).g.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getDeadReckoning());
                object3 = object;
                ((m)object3).c.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getDifferentialGPSAvailable());
                object3 = object;
                ((m)object3).b.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getFullyDigitizedArea());
                object3 = object;
                ((m)object3).e.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getGps2DFix());
                object3 = object;
                ((m)object3).i.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getGps3DFix());
                object3 = object;
                ((m)object3).j.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getGpsPositionFixAvailable());
                object3 = object;
                ((m)object3).a.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getGpsTimeFix());
                object3 = object;
                ((m)object3).h.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getInsideDigitizedArea());
                object3 = object;
                ((m)object3).d.b(l2);
                l2 = com.wirelesscar.ngtp.svc.b.a.a.a(((PositionQuality)object2).getMatchedToDigitalMap());
                object3 = object;
                ((m)object3).f.b(l2);
                continue;
            }
            object = object2;
            ((bl)object).b.c(false);
        }
    }

    public final Waypoint[] getWaypoints() {
        ap ap2 = this.a();
        ap ap3 = ap2;
        ap2 = ((be)ap2).c;
        Waypoint[] waypointArray = null;
        if (ap2 != null) {
            ap3 = ap2;
            waypointArray = new Waypoint[(int)((bf)ap3).c()];
            for (int i2 = 0; i2 < waypointArray.length; ++i2) {
                com.wirelesscar.ngtp.svc.a.c.g g2 = ((com.wirelesscar.ngtp.svc.a.c.a)ap2).a(i2);
                Object object = this;
                ap3 = g2;
                bi bi2 = ((bl)ap3).a;
                ap3 = bi2;
                ap3 = g2;
                ap3 = ((bl)ap3).a;
                object = new Waypoint((int)bi2.a.c(), (int)((bi)ap3).b.c());
                ap3 = g2;
                g2 = ((bl)ap3).b;
                ap3 = g2;
                ap3 = ((bg)g2).a;
                if (((aa)ap3).d) {
                    ap3 = g2;
                    ((Waypoint)object).setAltitude(new Integer((int)((bg)ap3).d.c()));
                }
                ap3 = g2;
                ap3 = ((bg)ap3).b;
                if (((aa)ap3).d) {
                    ap3 = g2;
                    ((Waypoint)object).setHeading(new Integer((int)((bg)ap3).e.c()));
                }
                ap3 = g2;
                ap3 = ((bg)ap3).c;
                if (((aa)ap3).d) {
                    PositionQuality positionQuality = new PositionQuality();
                    ap3 = g2;
                    g2 = ((bg)ap3).f;
                    ap3 = g2;
                    positionQuality.setCalibrated(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).g.c()));
                    ap3 = g2;
                    positionQuality.setDeadReckoning(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).c.c()));
                    ap3 = g2;
                    positionQuality.setDifferentialGPSAvailable(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).b.c()));
                    ap3 = g2;
                    positionQuality.setFullyDigitizedArea(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).e.c()));
                    ap3 = g2;
                    positionQuality.setGps2DFix(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).i.c()));
                    ap3 = g2;
                    positionQuality.setGps3DFix(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).j.c()));
                    ap3 = g2;
                    positionQuality.setGpsPositionFixAvailable(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).a.c()));
                    ap3 = g2;
                    positionQuality.setGpsTimeFix(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).h.c()));
                    ap3 = g2;
                    positionQuality.setInsideDigitizedArea(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).d.c()));
                    ap3 = g2;
                    positionQuality.setMatchedToDigitalMap(com.wirelesscar.ngtp.svc.b.a.a.a(((m)ap3).f.c()));
                    ((Waypoint)object).setQuality(positionQuality);
                }
                waypointArray[i2] = object;
            }
        }
        return waypointArray;
    }

    private static long a(int n2) {
        switch (n2) {
            case 0: {
                return 1L;
            }
            case 1: {
                return 0L;
            }
            case 2: {
                return 2L;
            }
            case 3: {
                return 3L;
            }
        }
        throw new RuntimeException("Unkwnon flag value: " + n2);
    }

    private static int a(long l2) {
        switch ((int)l2) {
            case 1: {
                return 0;
            }
            case 0: {
                return 1;
            }
            case 2: {
                return 2;
            }
        }
        return 3;
    }

    private be a() {
        try {
            ai ai2 = ((a)((Object)ai2)).a;
            return ai2.g.c();
        }
        catch (j j2) {
            throw new RuntimeException(j2.getMessage());
        }
    }

    public final String toString() {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("SvcUplinkMessageImpl").append(" [");
        stringBuffer.append(super.toString());
        stringBuffer.append(", roResponseList=").append(this.b);
        stringBuffer.append("]");
        return stringBuffer.toString();
    }

    public final VehicleStatus getVehicleStatus() {
        return null;
    }

    public final void setVehicleStatus(VehicleStatus vehicleStatus) {
    }
}

