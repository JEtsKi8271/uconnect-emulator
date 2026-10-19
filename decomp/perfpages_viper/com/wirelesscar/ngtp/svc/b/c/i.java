/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.c;

import com.wirelesscar.ngtp.svc.a.b.aa;
import com.wirelesscar.ngtp.svc.a.b.ab;
import com.wirelesscar.ngtp.svc.a.b.ac;
import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.ao;
import com.wirelesscar.ngtp.svc.a.b.ax;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bm;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.bs;
import com.wirelesscar.ngtp.svc.a.b.cd;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.cg;
import com.wirelesscar.ngtp.svc.a.b.ci;
import com.wirelesscar.ngtp.svc.a.b.k;
import com.wirelesscar.ngtp.svc.a.b.q;
import com.wirelesscar.ngtp.svc.a.b.u;
import com.wirelesscar.ngtp.svc.api.PositionQuality;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.TyreStatus;
import com.wirelesscar.ngtp.svc.api.VehicleStatus;
import com.wirelesscar.ngtp.svc.api.Waypoint;
import com.wirelesscar.ngtp.svc.b.c.h;
import com.wirelesscar.ngtp.svc.b.c.j;

final class i
extends h
implements SvcUplinkMessage {
    private RoResponseList b;

    i(cd bm2) {
        super((cd)bm2);
        this.b = null;
        try {
            bf bf2 = this.a();
            bf2 = bf2.c;
            if (((cf)bf2).a) {
                bf2 = bm2;
                bf2 = ((cd)bf2).g.c();
                bm2 = bf2.f;
                this.b = new j((com.wirelesscar.ngtp.svc.a.b.h)bm2);
            }
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
        }
    }

    i(RoResponseList roResponseList, boolean bl2) {
        ((i)((Object)u2)).b = null;
        try {
            ((i)((Object)u2)).a.b(true);
            Object object = ((i)((Object)u2)).a;
            ((cd)object).g.d();
            ((i)((Object)u2)).a.a(bl2 ? 1L : 0L);
            ((i)((Object)u2)).a.a(true);
            object = ((i)((Object)u2)).a;
            u u2 = ((cd)object).g.c();
            bl2 = true;
            u u3 = u2;
            boolean bl3 = true;
            object = u2.c;
            u2.c.a = bl3;
            object = u2;
            ((j)roResponseList).a(((u)object).f);
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.toString());
        }
    }

    i() {
        this.b = null;
        try {
            cd cd2 = this.a;
            cd2.g.d();
            this.a.b(true);
            return;
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
        }
    }

    public final boolean isRemoteOperationUpdateResponse() {
        return this.b != null;
    }

    public final RoResponseList getRemoteOperationResponseList() {
        return this.b;
    }

    public final boolean isGenericText() {
        return this.a().c();
    }

    public final String getGenericText() {
        if (((i)object).a().c()) {
            Object object = ((i)object).a();
            object = ((u)object).g;
            return ((ci)object).a.e();
        }
        return null;
    }

    public final void setGenericText(String string) {
        if (string != null) {
            ((i)object).a().c(true);
            Object object = ((i)object).a();
            object = ((u)object).g;
            ((ci)object).a.a(string);
            return;
        }
        ((i)object).a().c(false);
    }

    public final void setWaypoints(Waypoint[] waypointArray) {
        bf bf2 = this.a();
        if (waypointArray == null) {
            ((u)bf2).b(false);
            return;
        }
        ((u)bf2).b(true);
        Object object = bf2;
        bf2 = ((u)object).e;
        try {
            ((ax)bf2).c_(waypointArray.length);
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
        }
        for (int i2 = 0; i2 < waypointArray.length; ++i2) {
            long l2;
            Waypoint waypoint = waypointArray[i2];
            Object object2 = ((bs)bf2).b(i2);
            object = this;
            object = object2;
            ((k)object).a.a(waypoint.getNgtpLatitude());
            object = object2;
            ((k)object).a.b(waypoint.getNgtpLongitude());
            if (waypoint.getAltitude() != null) {
                object = object2;
                ((k)object).b.a(true);
                object = object2;
                l2 = waypoint.getAltitude().intValue();
                com.wirelesscar.ngtp.svc.a.b.j j2 = ((k)object).b;
                j2.d.b(l2);
                boolean bl2 = true;
                object = j2.a;
                j2.a.a = bl2;
            } else {
                object = object2;
                ((k)object).b.a(false);
            }
            if (waypoint.getHeading() != null) {
                object = object2;
                ((k)object).b.b(true);
                object = object2;
                l2 = waypoint.getHeading().intValue();
                com.wirelesscar.ngtp.svc.a.b.j j3 = ((k)object).b;
                j3.e.b(l2);
                boolean bl3 = true;
                object = j3.b;
                j3.b.a = bl3;
            } else {
                object = object2;
                ((k)object).b.b(false);
            }
            if (waypoint.getQuality() != null) {
                object = object2;
                ((k)object).b.c(true);
                object = object2;
                object = ((k)object).b;
                object = ((com.wirelesscar.ngtp.svc.a.b.j)object).f;
                object2 = waypoint.getQuality();
                l2 = i.a(((PositionQuality)object2).getCalibrated());
                Object object3 = object;
                ((cg)object3).g.b(l2);
                l2 = i.a(((PositionQuality)object2).getDeadReckoning());
                object3 = object;
                ((cg)object3).c.b(l2);
                l2 = i.a(((PositionQuality)object2).getDifferentialGPSAvailable());
                object3 = object;
                ((cg)object3).b.b(l2);
                l2 = i.a(((PositionQuality)object2).getFullyDigitizedArea());
                object3 = object;
                ((cg)object3).e.b(l2);
                l2 = i.a(((PositionQuality)object2).getGps2DFix());
                object3 = object;
                ((cg)object3).i.b(l2);
                l2 = i.a(((PositionQuality)object2).getGps3DFix());
                object3 = object;
                ((cg)object3).j.b(l2);
                l2 = i.a(((PositionQuality)object2).getGpsPositionFixAvailable());
                object3 = object;
                ((cg)object3).a.b(l2);
                l2 = i.a(((PositionQuality)object2).getGpsTimeFix());
                object3 = object;
                ((cg)object3).h.b(l2);
                l2 = i.a(((PositionQuality)object2).getInsideDigitizedArea());
                object3 = object;
                ((cg)object3).d.b(l2);
                l2 = i.a(((PositionQuality)object2).getMatchedToDigitalMap());
                object3 = object;
                ((cg)object3).f.b(l2);
                continue;
            }
            object = object2;
            ((k)object).b.c(false);
        }
    }

    public final Waypoint[] getWaypoints() {
        bf bf2 = this.a();
        Waypoint[] waypointArray = null;
        Object object = bf2;
        bf bf3 = ((u)object).b;
        if (bf3.a) {
            bf3 = bf2;
            bf2 = ((u)bf3).e;
            if (bf2 != null) {
                bf3 = bf2;
                waypointArray = new Waypoint[(int)((bo)bf3).c()];
                for (int i2 = 0; i2 < waypointArray.length; ++i2) {
                    bm bm2 = ((bs)bf2).b(i2);
                    object = this;
                    bf3 = bm2;
                    ab ab2 = ((k)bf3).a;
                    bf3 = ab2;
                    bf3 = bm2;
                    bf3 = ((k)bf3).a;
                    object = new Waypoint((int)ab2.a.c(), (int)((ab)bf3).b.c());
                    bf3 = bm2;
                    bm2 = ((k)bf3).b;
                    bf3 = bm2;
                    bf3 = ((com.wirelesscar.ngtp.svc.a.b.j)bm2).a;
                    if (bf3.a) {
                        bf3 = bm2;
                        ((Waypoint)object).setAltitude(new Integer((int)((com.wirelesscar.ngtp.svc.a.b.j)bf3).d.c()));
                    }
                    bf3 = bm2;
                    bf3 = ((com.wirelesscar.ngtp.svc.a.b.j)bf3).b;
                    if (bf3.a) {
                        bf3 = bm2;
                        ((Waypoint)object).setHeading(new Integer((int)((com.wirelesscar.ngtp.svc.a.b.j)bf3).e.c()));
                    }
                    bf3 = bm2;
                    bf3 = ((com.wirelesscar.ngtp.svc.a.b.j)bf3).c;
                    if (bf3.a) {
                        PositionQuality positionQuality = new PositionQuality();
                        bf3 = bm2;
                        bm2 = ((com.wirelesscar.ngtp.svc.a.b.j)bf3).f;
                        bf3 = bm2;
                        positionQuality.setCalibrated(i.a(((cg)bf3).g.c()));
                        bf3 = bm2;
                        positionQuality.setDeadReckoning(i.a(((cg)bf3).c.c()));
                        bf3 = bm2;
                        positionQuality.setDifferentialGPSAvailable(i.a(((cg)bf3).b.c()));
                        bf3 = bm2;
                        positionQuality.setFullyDigitizedArea(i.a(((cg)bf3).e.c()));
                        bf3 = bm2;
                        positionQuality.setGps2DFix(i.a(((cg)bf3).i.c()));
                        bf3 = bm2;
                        positionQuality.setGps3DFix(i.a(((cg)bf3).j.c()));
                        bf3 = bm2;
                        positionQuality.setGpsPositionFixAvailable(i.a(((cg)bf3).a.c()));
                        bf3 = bm2;
                        positionQuality.setGpsTimeFix(i.a(((cg)bf3).h.c()));
                        bf3 = bm2;
                        positionQuality.setInsideDigitizedArea(i.a(((cg)bf3).d.c()));
                        bf3 = bm2;
                        positionQuality.setMatchedToDigitalMap(i.a(((cg)bf3).f.c()));
                        ((Waypoint)object).setQuality(positionQuality);
                    }
                    waypointArray[i2] = object;
                }
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

    private u a() {
        try {
            cd cd2 = ((i)((Object)cd2)).a;
            return cd2.g.c();
        }
        catch (ai ai2) {
            throw new RuntimeException(ai2.getMessage());
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
        VehicleStatus vehicleStatus = null;
        Object object = object3 = ((i)object3).a();
        Object object2 = ((u)object3).a;
        if (((cf)object2).a) {
            vehicleStatus = new VehicleStatus();
            object = object3;
            object = object3 = ((u)object).d;
            object2 = ((ao)object3).b;
            if (((cf)object2).a) {
                object = object3;
                vehicleStatus.setFuelAmount(new Float((float)((ao)object).f.c() / 10.0f));
            }
            object = object3;
            object2 = ((ao)object).a;
            if (((cf)object2).a) {
                object = object3;
                vehicleStatus.setBatteryVoltage(new Float((float)((ao)object).e.c() / 10.0f));
            }
            object = object3;
            object2 = ((ao)object).c;
            if (((cf)object2).a) {
                object = object3;
                object = ((ao)object).g;
                vehicleStatus.setOdometer(new Integer((int)((ac)object).b.c()));
            }
            object = object3;
            object2 = ((ao)object).d;
            if (((cf)object2).a) {
                object = object3;
                object = ((ao)object).h;
                Object object3 = new TyreStatus();
                object2 = object;
                object2 = ((q)object2).a;
                ((TyreStatus)object3).setFrontLeftPressure((int)((aa)object2).b.c());
                object2 = object;
                object2 = ((q)object2).a;
                ((TyreStatus)object3).setFrontLeftStatus((int)((aa)object2).a.c());
                object2 = object;
                object2 = ((q)object2).b;
                ((TyreStatus)object3).setFrontRightPressure((int)((aa)object2).b.c());
                object2 = object;
                object2 = ((q)object2).b;
                ((TyreStatus)object3).setFrontRightStatus((int)((aa)object2).a.c());
                object2 = object;
                object2 = ((q)object2).c;
                ((TyreStatus)object3).setRearLeftPressure((int)((aa)object2).b.c());
                object2 = object;
                object2 = ((q)object2).c;
                ((TyreStatus)object3).setRearLeftStatus((int)((aa)object2).a.c());
                object2 = object;
                object2 = ((q)object2).d;
                ((TyreStatus)object3).setRearRightPressure((int)((aa)object2).b.c());
                object2 = object;
                object2 = ((q)object2).d;
                ((TyreStatus)object3).setRearRightStatus((int)((aa)object2).a.c());
                vehicleStatus.setTyreStatus((TyreStatus)object3);
            }
        }
        return vehicleStatus;
    }

    public final void setVehicleStatus(VehicleStatus object) {
        if (object != null) {
            Object object2;
            cf cf2;
            boolean bl2;
            long l2;
            ao ao2 = new ao();
            Object object3 = ((VehicleStatus)object).getFuelAmount();
            if (object3 != null) {
                l2 = (int)((double)(((Float)object3).floatValue() * 10.0f) + 0.5);
                object3 = ao2;
                ((ao)object3).f.b(l2);
                bl2 = true;
                cf2 = ((ao)object3).b;
                ((ao)object3).b.a = bl2;
                ao2.b(true);
            } else {
                ao2.b(false);
            }
            object3 = ((VehicleStatus)object).getBatteryVoltage();
            if (object3 != null) {
                l2 = (int)((double)(((Float)object3).floatValue() * 10.0f) + 0.5);
                object3 = ao2;
                ((ao)object3).e.b(l2);
                bl2 = true;
                cf2 = ((ao)object3).a;
                ((ao)object3).a.a = bl2;
                ao2.a(true);
            } else {
                ao2.a(false);
            }
            object3 = ((VehicleStatus)object).getOdometer();
            Object object4 = null;
            if (object3 != null) {
                object4 = new ac();
                boolean bl3 = true;
                object2 = object4;
                bl2 = true;
                cf2 = ((ac)object4).a;
                ((ac)object4).a.a = bl2;
                long l3 = ((Integer)object3).longValue();
                object2 = object4;
                ((ac)object2).b.b(l3);
            }
            if ((object3 = object4) != null) {
                object4 = object3;
                object3 = ao2;
                ao2.g = object4;
                ao2.c(true);
            } else {
                ao2.c(false);
            }
            object4 = ((VehicleStatus)object).getTyreStatus();
            object3 = this;
            object2 = null;
            if (object4 != null) {
                object2 = new q();
                aa aa2 = i.a(((TyreStatus)object4).getFrontLeftPressure(), ((TyreStatus)object4).getFrontLeftStatus());
                Object object5 = object2;
                ((q)object2).a = aa2;
                aa2 = i.a(((TyreStatus)object4).getFrontRightPressure(), ((TyreStatus)object4).getFrontRightStatus());
                object5 = object2;
                ((q)object2).b = aa2;
                aa2 = i.a(((TyreStatus)object4).getRearLeftPressure(), ((TyreStatus)object4).getRearLeftStatus());
                object5 = object2;
                ((q)object2).c = aa2;
                aa2 = i.a(((TyreStatus)object4).getRearRightPressure(), ((TyreStatus)object4).getRearRightStatus());
                object5 = object2;
                ((q)object2).d = aa2;
            }
            if ((object = object2) != null) {
                object4 = object;
                object3 = ao2;
                ao2.h = object4;
                ao2.d(true);
            } else {
                ao2.d(false);
            }
            object4 = ao2;
            object3 = this.a();
            this.a().d = object4;
            this.a().a(true);
            return;
        }
        this.a().a(false);
    }

    private static aa a(int n2, int n3) {
        aa aa2 = new aa();
        long l2 = n2;
        aa aa3 = aa2;
        aa2.b.b(l2);
        l2 = n3;
        aa3 = aa2;
        aa3.a.b(l2);
        return aa2;
    }
}

