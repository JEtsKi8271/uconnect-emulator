/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.b.b;

import com.wirelesscar.ngtp.svc.a.a.ae;
import com.wirelesscar.ngtp.svc.a.a.ag;
import com.wirelesscar.ngtp.svc.a.a.ai;
import com.wirelesscar.ngtp.svc.a.a.ap;
import com.wirelesscar.ngtp.svc.a.a.au;
import com.wirelesscar.ngtp.svc.a.a.aw;
import com.wirelesscar.ngtp.svc.a.a.az;
import com.wirelesscar.ngtp.svc.a.a.bb;
import com.wirelesscar.ngtp.svc.a.a.bc;
import com.wirelesscar.ngtp.svc.a.a.bn;
import com.wirelesscar.ngtp.svc.a.a.bq;
import com.wirelesscar.ngtp.svc.a.a.bt;
import com.wirelesscar.ngtp.svc.a.a.c;
import com.wirelesscar.ngtp.svc.a.a.cb;
import com.wirelesscar.ngtp.svc.a.a.cg;
import com.wirelesscar.ngtp.svc.a.a.ci;
import com.wirelesscar.ngtp.svc.a.a.ck;
import com.wirelesscar.ngtp.svc.a.a.cl;
import com.wirelesscar.ngtp.svc.a.a.cn;
import com.wirelesscar.ngtp.svc.a.a.cp;
import com.wirelesscar.ngtp.svc.a.a.cr;
import com.wirelesscar.ngtp.svc.a.a.h;
import com.wirelesscar.ngtp.svc.a.a.i;
import com.wirelesscar.ngtp.svc.a.a.k;
import com.wirelesscar.ngtp.svc.a.a.o;
import com.wirelesscar.ngtp.svc.a.a.v;
import com.wirelesscar.ngtp.svc.a.a.y;
import com.wirelesscar.ngtp.svc.api.DoorStatus;
import com.wirelesscar.ngtp.svc.api.ElectricVehicleStatus;
import com.wirelesscar.ngtp.svc.api.ExtendedVehicleStatus;
import com.wirelesscar.ngtp.svc.api.NgtpUtil;
import com.wirelesscar.ngtp.svc.api.PositionQuality;
import com.wirelesscar.ngtp.svc.api.RoResponseList;
import com.wirelesscar.ngtp.svc.api.SvcUplinkMessage;
import com.wirelesscar.ngtp.svc.api.TyreStatus;
import com.wirelesscar.ngtp.svc.api.VehicleStatus;
import com.wirelesscar.ngtp.svc.api.Waypoint;
import com.wirelesscar.ngtp.svc.api.WindowStatus;
import com.wirelesscar.ngtp.svc.b.b.b;
import com.wirelesscar.ngtp.svc.b.b.g;
import java.util.Date;

final class f
extends b
implements SvcUplinkMessage {
    private RoResponseList b;

    f(ck bn2) {
        super((ck)bn2);
        this.b = null;
        try {
            aw aw2 = this.a();
            aw2 = aw2.e;
            if (((ap)aw2).a) {
                aw2 = bn2;
                aw2 = ((ck)aw2).g.c();
                bn2 = aw2.k;
                this.b = new g((cn)bn2);
            }
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
        }
    }

    f(RoResponseList roResponseList, boolean bl2) {
        ((f)((Object)cp2)).b = null;
        try {
            ((f)((Object)cp2)).a.b(true);
            Object object = ((f)((Object)cp2)).a;
            ((ck)object).g.d();
            ((f)((Object)cp2)).a.a(bl2 ? 1L : 0L);
            ((f)((Object)cp2)).a.a(true);
            object = ((f)((Object)cp2)).a;
            cp cp2 = ((ck)object).g.c();
            bl2 = true;
            cp cp3 = cp2;
            boolean bl3 = true;
            object = cp2.e;
            cp2.e.a = bl3;
            object = cp2;
            ((g)roResponseList).a(((cp)object).k);
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.toString());
        }
    }

    f() {
        this.b = null;
        try {
            ck ck2 = this.a;
            ck2.g.d();
            this.a.b(true);
            return;
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
        }
    }

    public final boolean isRemoteOperationUpdateResponse() {
        return this.b != null;
    }

    public final RoResponseList getRemoteOperationResponseList() {
        return this.b;
    }

    public final boolean isGenericText() {
        Object object = ((f)object).a();
        object = ((cp)object).f;
        return ((ap)object).a;
    }

    public final String getGenericText() {
        aw aw2 = this.a();
        aw2 = aw2.f;
        if (((ap)aw2).a) {
            aw2 = this.a();
            aw2 = aw2.l;
            return ((cl)aw2).a.d();
        }
        return null;
    }

    public final void setGenericText(String string) {
        if (string != null) {
            ((f)object).a().e(true);
            Object object = ((f)object).a();
            object = ((cp)object).l;
            ((cl)object).a.a(string);
            return;
        }
        ((f)object).a().e(false);
    }

    public final void setWaypoints(Waypoint[] waypointArray) {
        aw aw2 = this.a();
        if (waypointArray == null) {
            ((cp)aw2).d(false);
            return;
        }
        ((cp)aw2).d(true);
        Object object = aw2;
        aw2 = ((cp)object).j;
        try {
            ((i)aw2).b(waypointArray.length);
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
        }
        for (int i2 = 0; i2 < waypointArray.length; ++i2) {
            long l2;
            Waypoint waypoint = waypointArray[i2];
            Object object2 = ((ae)aw2).b(i2);
            object = this;
            object = object2;
            ((y)object).a.a(waypoint.getNgtpLatitude());
            object = object2;
            ((y)object).a.b(waypoint.getNgtpLongitude());
            if (waypoint.getAltitude() != null) {
                object = object2;
                ((y)object).b.a(true);
                object = object2;
                l2 = waypoint.getAltitude().intValue();
                v v2 = ((y)object).b;
                v2.f.a(l2);
                boolean bl2 = true;
                object = v2.a;
                v2.a.a = bl2;
            } else {
                object = object2;
                ((y)object).b.a(false);
            }
            if (waypoint.getHeading() != null) {
                object = object2;
                ((y)object).b.b(true);
                object = object2;
                l2 = waypoint.getHeading().intValue();
                v v3 = ((y)object).b;
                v3.g.a(l2);
                boolean bl3 = true;
                object = v3.b;
                v3.b.a = bl3;
            } else {
                object = object2;
                ((y)object).b.b(false);
            }
            if (waypoint.getSpeed() != null) {
                object = object2;
                l2 = waypoint.getSpeed().intValue();
                v v4 = ((y)object).b;
                v4.i.a(l2);
                boolean bl4 = true;
                object = v4.d;
                v4.d.a = bl4;
                object = object2;
                ((y)object).b.d(true);
            } else {
                object = object2;
                ((y)object).b.d(false);
            }
            if (waypoint.getTimestamp() != null) {
                object = object2;
                object = ((y)object).b;
                ((v)object).j.a(NgtpUtil.date2Ngtp(waypoint.getTimestamp()));
                object = object2;
                ((y)object).b.e(true);
            } else {
                object = object2;
                ((y)object).b.e(false);
            }
            if (waypoint.getQuality() != null) {
                object = object2;
                ((y)object).b.c(true);
                object = object2;
                object = ((y)object).b;
                object = ((v)object).h;
                object2 = waypoint.getQuality();
                l2 = f.a(((PositionQuality)object2).getCalibrated());
                Object object3 = object;
                ((ci)object3).g.a(l2);
                l2 = f.a(((PositionQuality)object2).getDeadReckoning());
                object3 = object;
                ((ci)object3).c.a(l2);
                l2 = f.a(((PositionQuality)object2).getDifferentialGPSAvailable());
                object3 = object;
                ((ci)object3).b.a(l2);
                l2 = f.a(((PositionQuality)object2).getFullyDigitizedArea());
                object3 = object;
                ((ci)object3).e.a(l2);
                l2 = f.a(((PositionQuality)object2).getGps2DFix());
                object3 = object;
                ((ci)object3).i.a(l2);
                l2 = f.a(((PositionQuality)object2).getGps3DFix());
                object3 = object;
                ((ci)object3).j.a(l2);
                l2 = f.a(((PositionQuality)object2).getGpsPositionFixAvailable());
                object3 = object;
                ((ci)object3).a.a(l2);
                l2 = f.a(((PositionQuality)object2).getGpsTimeFix());
                object3 = object;
                ((ci)object3).h.a(l2);
                l2 = f.a(((PositionQuality)object2).getInsideDigitizedArea());
                object3 = object;
                ((ci)object3).d.a(l2);
                l2 = f.a(((PositionQuality)object2).getMatchedToDigitalMap());
                object3 = object;
                ((ci)object3).f.a(l2);
                continue;
            }
            object = object2;
            ((y)object).b.c(false);
        }
    }

    public final Waypoint[] getWaypoints() {
        aw aw2 = this.a();
        Waypoint[] waypointArray = null;
        Object object = aw2;
        aw aw3 = ((cp)object).d;
        if (aw3.a) {
            aw3 = aw2;
            aw2 = ((cp)aw3).j;
            if (aw2 != null) {
                aw3 = aw2;
                waypointArray = new Waypoint[(int)((com.wirelesscar.ngtp.svc.a.a.f)aw3).c()];
                for (int i2 = 0; i2 < waypointArray.length; ++i2) {
                    bn bn2 = ((ae)aw2).b(i2);
                    object = this;
                    aw3 = bn2;
                    c c2 = ((y)aw3).a;
                    aw3 = c2;
                    aw3 = bn2;
                    aw3 = ((y)aw3).a;
                    object = new Waypoint((int)c2.a.c(), (int)((c)aw3).b.c());
                    aw3 = bn2;
                    bn2 = ((y)aw3).b;
                    aw3 = bn2;
                    aw3 = ((v)bn2).a;
                    if (aw3.a) {
                        aw3 = bn2;
                        ((Waypoint)object).setAltitude(new Integer((int)((v)aw3).f.c()));
                    }
                    aw3 = bn2;
                    aw3 = ((v)aw3).b;
                    if (aw3.a) {
                        aw3 = bn2;
                        ((Waypoint)object).setHeading(new Integer((int)((v)aw3).g.c()));
                    }
                    aw3 = bn2;
                    aw3 = ((v)aw3).d;
                    if (aw3.a) {
                        aw3 = bn2;
                        ((Waypoint)object).setSpeed(new Integer((int)((v)aw3).i.c()));
                    }
                    aw3 = bn2;
                    aw3 = ((v)aw3).e;
                    if (aw3.a) {
                        aw3 = bn2;
                        aw3 = ((v)aw3).j;
                        ((Waypoint)object).setTimestamp(NgtpUtil.ngtp2Date((int)((bt)aw3).a.c()));
                    }
                    aw3 = bn2;
                    aw3 = ((v)aw3).c;
                    if (aw3.a) {
                        PositionQuality positionQuality = new PositionQuality();
                        aw3 = bn2;
                        bn2 = ((v)aw3).h;
                        aw3 = bn2;
                        positionQuality.setCalibrated(f.a(((ci)aw3).g.c()));
                        aw3 = bn2;
                        positionQuality.setDeadReckoning(f.a(((ci)aw3).c.c()));
                        aw3 = bn2;
                        positionQuality.setDifferentialGPSAvailable(f.a(((ci)aw3).b.c()));
                        aw3 = bn2;
                        positionQuality.setFullyDigitizedArea(f.a(((ci)aw3).e.c()));
                        aw3 = bn2;
                        positionQuality.setGps2DFix(f.a(((ci)aw3).i.c()));
                        aw3 = bn2;
                        positionQuality.setGps3DFix(f.a(((ci)aw3).j.c()));
                        aw3 = bn2;
                        positionQuality.setGpsPositionFixAvailable(f.a(((ci)aw3).a.c()));
                        aw3 = bn2;
                        positionQuality.setGpsTimeFix(f.a(((ci)aw3).h.c()));
                        aw3 = bn2;
                        positionQuality.setInsideDigitizedArea(f.a(((ci)aw3).d.c()));
                        aw3 = bn2;
                        positionQuality.setMatchedToDigitalMap(f.a(((ci)aw3).f.c()));
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

    private cp a() {
        try {
            ck ck2 = ((f)((Object)ck2)).a;
            return ck2.g.c();
        }
        catch (o o2) {
            throw new RuntimeException(o2.getMessage());
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
        Object object;
        Object object2;
        VehicleStatus vehicleStatus = null;
        Object object3 = this = ((f)this).a();
        Object object4 = ((cp)this).a;
        if (((ap)object4).a) {
            vehicleStatus = new VehicleStatus();
            object3 = this;
            object3 = object2 = ((cp)object3).g;
            object4 = ((cr)object2).m;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setFuelAmount(new Float((float)((cr)object3).K.c() / 10.0f));
            }
            object3 = object2;
            object4 = ((cr)object3).d;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setBatteryVoltage(new Float((float)((cr)object3).z.c() / 10.0f));
            }
            object3 = object2;
            object4 = ((cr)object3).n;
            if (((ap)object4).a) {
                object3 = object2;
                object4 = ((cr)object3).L;
                vehicleStatus.setOdometer(new Integer((int)((ag)object4).b.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).o;
            if (((ap)object4).a) {
                object3 = object2;
                object3 = ((cr)object3).M;
                object = new TyreStatus();
                object4 = object3;
                object4 = ((bb)object4).a;
                ((TyreStatus)object).setFrontLeftPressure((int)((az)object4).b.c());
                object4 = object3;
                object4 = ((bb)object4).a;
                ((TyreStatus)object).setFrontLeftStatus((int)((az)object4).a.c());
                object4 = object3;
                object4 = ((bb)object4).b;
                ((TyreStatus)object).setFrontRightPressure((int)((az)object4).b.c());
                object4 = object3;
                object4 = ((bb)object4).b;
                ((TyreStatus)object).setFrontRightStatus((int)((az)object4).a.c());
                object4 = object3;
                object4 = ((bb)object4).c;
                ((TyreStatus)object).setRearLeftPressure((int)((az)object4).b.c());
                object4 = object3;
                object4 = ((bb)object4).c;
                ((TyreStatus)object).setRearLeftStatus((int)((az)object4).a.c());
                object4 = object3;
                object4 = ((bb)object4).d;
                ((TyreStatus)object).setRearRightPressure((int)((az)object4).b.c());
                object4 = object3;
                object4 = ((bb)object4).d;
                ((TyreStatus)object).setRearRightStatus((int)((az)object4).a.c());
                vehicleStatus.setTyreStatus((TyreStatus)object);
            }
            object3 = object2;
            object4 = ((cr)object3).i;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setAvgFuelConsumption(new Float((float)((cr)object3).G.c() / 10.0f));
            }
            object3 = object2;
            object4 = ((cr)object3).j;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setAvgSpeedKmph(new Integer((int)((cr)object3).H.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).c;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setBatteryStatus(new Integer((int)((cr)object3).y.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).k;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setDistToEmptyFuel(new Integer((int)((cr)object3).I.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).h;
            if (((ap)object4).a) {
                object3 = object2;
                object3 = ((cr)object3).D;
                object = new DoorStatus();
                object4 = object3;
                ((DoorStatus)object).setAllDoorsLocked((int)((bq)object4).b.c());
                object4 = object3;
                ((DoorStatus)object).setTrunkLocked((int)((bq)object4).c.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).f;
                ((DoorStatus)object).setEngineHoodLockStatus((int)((cg)object4).b.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).f;
                ((DoorStatus)object).setEngineHoodPosition((int)((cg)object4).a.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).a;
                ((DoorStatus)object).setFrontLeftLockStatus((int)((cg)object4).b.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).a;
                ((DoorStatus)object).setFrontLeftPosition((int)((cg)object4).a.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).c;
                ((DoorStatus)object).setRearLeftLockStatus((int)((cg)object4).b.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).c;
                ((DoorStatus)object).setRearLeftPosition((int)((cg)object4).a.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).b;
                ((DoorStatus)object).setFrontRightLockStatus((int)((cg)object4).b.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).b;
                ((DoorStatus)object).setFrontRightPosition((int)((cg)object4).a.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).d;
                ((DoorStatus)object).setRearRightLockStatus((int)((cg)object4).b.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).d;
                ((DoorStatus)object).setRearRightPosition((int)((cg)object4).a.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).e;
                ((DoorStatus)object).setTailgateLockStatus((int)((cg)object4).b.c());
                object4 = object3;
                object4 = ((bq)object4).d;
                object4 = ((k)object4).e;
                ((DoorStatus)object).setTailgatePosition((int)((cg)object4).a.c());
                vehicleStatus.setDoorStatus((DoorStatus)object);
            }
            object3 = object2;
            object4 = ((cr)object3).p;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setEngineCoolantTemp(new Integer((int)((cr)object3).N.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).l;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setFuelLevel(new Integer((int)((cr)object3).J.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).a;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setSrs((int)((cr)object3).v.c());
            }
            object3 = object2;
            object4 = ((cr)object3).b;
            if (((ap)object4).a) {
                object3 = object2;
                vehicleStatus.setTheftAlarm((int)((cr)object3).w.c());
            }
            object3 = object2;
            object4 = ((cr)object3).e;
            if (((ap)object4).a) {
                object3 = object2;
                object4 = ((cr)object3).A;
                vehicleStatus.setTripMeter1(new Integer((int)((ag)object4).b.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).f;
            if (((ap)object4).a) {
                object3 = object2;
                object4 = ((cr)object3).B;
                vehicleStatus.setTripMeter2(new Integer((int)((ag)object4).b.c()));
            }
            object3 = object2;
            object4 = ((cr)object3).q;
            if (((ap)object4).a) {
                object = new Date();
                long l2 = ((Date)object).getTime() / 86400000L;
                object4 = object2;
                object3 = ((cr)object4).P;
                long l3 = l2 * 86400000L + 3600000L * ((bc)object3).a.c();
                object4 = object2;
                object3 = ((cr)object4).P;
                if (((Date)object).getTime() < (l3 += 60000L * ((bc)object3).b.c())) {
                    l3 -= 86400000L;
                }
                vehicleStatus.setVehicleDateTime(new Date(l3));
            }
            object3 = object2;
            object4 = ((cr)object3).g;
            if (((ap)object4).a) {
                object3 = object2;
                object3 = ((cr)object3).C;
                object = new WindowStatus();
                object4 = object3;
                ((WindowStatus)object).setFrontLeftPosition((int)((ai)object4).a.c());
                object4 = object3;
                ((WindowStatus)object).setRearLeftPosition((int)((ai)object4).c.c());
                object4 = object3;
                ((WindowStatus)object).setFrontRightPosition((int)((ai)object4).b.c());
                object4 = object3;
                ((WindowStatus)object).setRearRightPosition((int)((ai)object4).d.c());
                vehicleStatus.setWindowStatus((WindowStatus)object);
            }
            object3 = object2;
            vehicleStatus.setCabOpenStatus((int)((cr)object3).E.c());
            object3 = object2;
            vehicleStatus.setHeadLightOn((int)((cr)object3).O.c());
            object3 = object2;
            vehicleStatus.setIgnitionKeyInStatus((int)((cr)object3).t.c());
            object3 = object2;
            vehicleStatus.setIgnitionOnStatus((int)((cr)object3).s.c());
            object3 = object2;
            vehicleStatus.setMovingFlag((int)((cr)object3).r.c());
            object3 = object2;
            vehicleStatus.setPanicAlarmTriggered((int)((cr)object3).x.c());
            object3 = object2;
            vehicleStatus.setSunroofOpenStatus((int)((cr)object3).F.c());
        }
        object3 = this;
        object4 = ((cp)object3).b;
        if (((ap)object4).a) {
            if (vehicleStatus == null) {
                vehicleStatus = new VehicleStatus();
            }
            object2 = new ExtendedVehicleStatus();
            object3 = this;
            object3 = object = ((cp)object3).h;
            object4 = ((au)object).j;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setBrakeFluidWarn((int)((au)object3).z.c());
            }
            object3 = object;
            object4 = ((au)object3).i;
            if (((ap)object4).a) {
                object4 = object;
                object4 = ((au)object4).y;
                int n2 = (int)((com.wirelesscar.ngtp.svc.a.a.f)object4).c();
                int[] nArray = new int[n2];
                for (int i2 = 0; i2 < n2; ++i2) {
                    nArray[i2] = (int)((au)object).a(i2).c();
                }
                ((ExtendedVehicleStatus)object2).setBulbFailures(nArray);
            }
            object3 = object;
            object4 = ((au)object3).c;
            if (((ap)object4).a) {
                object4 = object;
                object3 = ((au)object4).s;
                ((ExtendedVehicleStatus)object2).setEchoGradeBraking(new Integer((int)((h)object3).b.c()));
                object4 = object;
                object3 = ((au)object4).s;
                ((ExtendedVehicleStatus)object2).setEchoGradePropulsion(new Integer((int)((h)object3).a.c()));
            }
            object3 = object;
            object4 = ((au)object3).k;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setEngCoolantLevelWarn((int)((au)object3).A.c());
            }
            object3 = object;
            object4 = ((au)object3).d;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setEngineHoursToService(new Integer((int)((au)object3).t.c()));
            }
            object3 = object;
            object4 = ((au)object3).a;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setExternalTemp(new Integer((int)((au)object3).q.c()));
            }
            object3 = object;
            object4 = ((au)object3).b;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setInternalTemp(new Integer((int)((au)object3).r.c()));
            }
            object3 = object;
            object4 = ((au)object3).e;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setKilometersToService(new Integer((int)((au)object3).u.c()));
            }
            object3 = object;
            object4 = ((au)object3).f;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setMonthsToService(new Integer((int)((au)object3).v.c()));
            }
            object3 = object;
            object4 = ((au)object3).l;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setOilLevelWarn((int)((au)object3).B.c());
            }
            object3 = object;
            object4 = ((au)object3).m;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setOilPressureWarn((int)((au)object3).C.c());
            }
            object3 = object;
            object4 = ((au)object3).g;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setServiceWarningStatus((int)((au)object3).w.c());
            }
            object3 = object;
            object4 = ((au)object3).h;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setServiceWarningTrigger((int)((au)object3).x.c());
            }
            object3 = object;
            object4 = ((au)object3).n;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setWasherFluidWarn((int)((au)object3).D.c());
            }
            object3 = object;
            object4 = ((au)object3).o;
            if (((ap)object4).a) {
                object3 = object;
                object4 = ((au)object3).E;
                ((ExtendedVehicleStatus)object2).setIgnitionOffMeter(new Integer((int)((ag)object4).b.c()));
            }
            object3 = object;
            object4 = ((au)object3).p;
            if (((ap)object4).a) {
                object3 = object;
                ((ExtendedVehicleStatus)object2).setIgnitionKeyState((int)((au)object3).F.c());
            }
            vehicleStatus.setExtendedVehicleStatus((ExtendedVehicleStatus)object2);
        }
        object3 = this;
        object4 = ((cp)object3).c;
        if (((ap)object4).a) {
            if (vehicleStatus == null) {
                vehicleStatus = new VehicleStatus();
            }
            object2 = new ElectricVehicleStatus();
            object3 = this;
            object3 = object = ((cp)object3).i;
            object4 = ((cb)object).e;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setChargeType((int)((cb)object3).q.c());
            }
            object3 = object;
            object4 = ((cb)object3).a;
            if (((ap)object4).a) {
                object4 = object;
                ((ElectricVehicleStatus)object2).setChargingProfile(((cb)object4).j.d());
            }
            object3 = object;
            object4 = ((cb)object3).b;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setDistanceToEmpty(new Integer((int)((cb)object3).n.c()));
            }
            object3 = object;
            object4 = ((cb)object3).c;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setStateOfCharge(new Integer((int)((cb)object3).o.c()));
            }
            object3 = object;
            object4 = ((cb)object3).d;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setTimeToFullyCharged(new Integer((int)((cb)object3).p.c()));
            }
            object3 = object;
            ((ElectricVehicleStatus)object2).setIsCharging((int)((cb)object3).l.c());
            object3 = object;
            ((ElectricVehicleStatus)object2).setIsPluggedIn((int)((cb)object3).m.c());
            object3 = object;
            ((ElectricVehicleStatus)object2).setIsPreconditioning((int)((cb)object3).k.c());
            object3 = object;
            object4 = ((cb)object3).g;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setTrip1AverageEnergyUsed(new Float((float)((cb)object3).s.c() / 10.0f));
            }
            object3 = object;
            object4 = ((cb)object3).h;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setTrip2AverageEnergyUsed(new Float((float)((cb)object3).t.c() / 10.0f));
            }
            object3 = object;
            object4 = ((cb)object3).i;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setTotalAverageEnergyUsed(new Float((float)((cb)object3).u.c() / 10.0f));
            }
            object3 = object;
            object4 = ((cb)object3).f;
            if (((ap)object4).a) {
                object3 = object;
                ((ElectricVehicleStatus)object2).setIgnitionOffAverageEnergyUsed(new Float((float)((cb)object3).r.c() / 10.0f));
            }
            vehicleStatus.setElectricVehicleStatus((ElectricVehicleStatus)object2);
        }
        return vehicleStatus;
    }

    /*
     * WARNING - void declaration
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public final void setVehicleStatus(VehicleStatus object) {
        void var22_58;
        Object object2;
        boolean bl2;
        Object object3;
        long l2;
        if (object == null) {
            this.a().a(false);
            this.a().b(false);
            this.a().c(false);
            return;
        }
        Object object4 = new cr();
        Object object5 = ((VehicleStatus)object).getFuelAmount();
        if (object5 != null) {
            l2 = (int)((double)(((Float)object5).floatValue() * 10.0f) + 0.5);
            object3 = object4;
            ((cr)object3).K.a(l2);
            bl2 = true;
            object2 = ((cr)object3).m;
            ((cr)object3).m.a = bl2;
            ((cr)object4).j(true);
        } else {
            ((cr)object4).j(false);
        }
        object5 = ((VehicleStatus)object).getBatteryVoltage();
        if (object5 != null) {
            l2 = (int)((double)(((Float)object5).floatValue() * 10.0f) + 0.5);
            object3 = object4;
            ((cr)object3).z.a(l2);
            bl2 = true;
            object2 = ((cr)object3).d;
            ((cr)object3).d.a = bl2;
            ((cr)object4).b(true);
        } else {
            ((cr)object4).b(false);
        }
        object5 = f.a(((VehicleStatus)object).getOdometer());
        if (object5 != null) {
            Object object6 = object5;
            object3 = object4;
            ((cr)object4).L = object6;
            ((cr)object4).k(true);
        } else {
            ((cr)object4).k(false);
        }
        Object object7 = ((VehicleStatus)object).getTyreStatus();
        object3 = this;
        Object var22_56 = null;
        if (object7 != null) {
            bb bb2 = new bb();
            az az2 = f.a(((TyreStatus)object7).getFrontLeftPressure(), ((TyreStatus)object7).getFrontLeftStatus());
            bb bb3 = bb2;
            bb2.a = az2;
            az2 = f.a(((TyreStatus)object7).getFrontRightPressure(), ((TyreStatus)object7).getFrontRightStatus());
            bb bb4 = bb2;
            bb2.b = az2;
            az2 = f.a(((TyreStatus)object7).getRearLeftPressure(), ((TyreStatus)object7).getRearLeftStatus());
            bb bb5 = bb2;
            bb2.c = az2;
            az2 = f.a(((TyreStatus)object7).getRearRightPressure(), ((TyreStatus)object7).getRearRightStatus());
            bb bb6 = bb2;
            bb2.d = az2;
        }
        if ((object5 = var22_58) != null) {
            object7 = object5;
            object3 = object4;
            ((cr)object4).M = object7;
            ((cr)object4).l(true);
        } else {
            ((cr)object4).l(false);
        }
        object5 = ((VehicleStatus)object).getAvgFuelConsumption();
        if (object5 != null) {
            long l3 = (int)((double)(((Float)object5).floatValue() * 10.0f) + 0.5);
            object3 = object4;
            ((cr)object3).G.a(l3);
            bl2 = true;
            object2 = ((cr)object3).i;
            ((cr)object3).i.a = bl2;
            ((cr)object4).g(true);
        } else {
            ((cr)object4).g(false);
        }
        object5 = ((VehicleStatus)object).getAvgSpeedKmph();
        if (object5 != null) {
            long l4 = ((Integer)object5).intValue();
            object3 = object4;
            ((cr)object3).H.a(l4);
            bl2 = true;
            object2 = ((cr)object3).j;
            ((cr)object3).j.a = bl2;
            ((cr)object4).h(true);
        } else {
            ((cr)object4).h(false);
        }
        object5 = ((VehicleStatus)object).getBatteryStatus();
        if (object5 != null) {
            long l5 = ((Integer)object5).intValue();
            object3 = object4;
            ((cr)object3).y.a(l5);
            ((cr)object4).a(true);
        } else {
            ((cr)object4).a(false);
        }
        object5 = ((VehicleStatus)object).getDistToEmptyFuel();
        if (object5 != null) {
            long l6 = ((Integer)object5).intValue();
            object3 = object4;
            ((cr)object3).I.a(l6);
            bl2 = true;
            object2 = ((cr)object3).k;
            ((cr)object3).k.a = bl2;
            ((cr)object4).i(true);
        } else {
            ((cr)object4).i(false);
        }
        object5 = ((VehicleStatus)object).getEngineCoolantTemp();
        if (object5 != null) {
            long l7 = ((Integer)object5).intValue();
            object3 = object4;
            ((cr)object3).N.a(l7);
            bl2 = true;
            object2 = ((cr)object3).p;
            ((cr)object3).p.a = bl2;
            ((cr)object4).m(true);
        } else {
            ((cr)object4).m(false);
        }
        object5 = ((VehicleStatus)object).getTripMeter1();
        if (object5 != null) {
            ag ag2 = f.a((Integer)object5);
            object3 = object4;
            ((cr)object4).A = ag2;
            ((cr)object4).c(true);
        } else {
            ((cr)object4).c(false);
        }
        object5 = ((VehicleStatus)object).getTripMeter2();
        if (object5 != null) {
            ag ag3 = f.a((Integer)object5);
            object3 = object4;
            ((cr)object4).B = ag3;
            ((cr)object4).d(true);
        } else {
            ((cr)object4).d(false);
        }
        object5 = ((VehicleStatus)object).getDoorStatus();
        if (object5 != null) {
            void var22_61;
            Object object8 = object5;
            object3 = this;
            Object var22_59 = null;
            if (object8 != null) {
                bq bq2 = new bq();
                long l8 = ((DoorStatus)object8).getAllDoorsLocked();
                bq bq3 = bq2;
                bq2.b.a(l8);
                l8 = ((DoorStatus)object8).getTrunkLocked();
                bq bq4 = bq2;
                bq4.c.a(l8);
                object2 = bq2;
                cg cg2 = f.b(((DoorStatus)object8).getFrontLeftPosition(), ((DoorStatus)object8).getFrontLeftLockStatus());
                k k2 = ((bq)object2).d;
                ((bq)object2).d.a = cg2;
                object2 = bq2;
                cg2 = f.b(((DoorStatus)object8).getRearLeftPosition(), ((DoorStatus)object8).getRearLeftLockStatus());
                k k3 = ((bq)object2).d;
                ((bq)object2).d.c = cg2;
                object2 = bq2;
                cg2 = f.b(((DoorStatus)object8).getFrontRightPosition(), ((DoorStatus)object8).getFrontRightLockStatus());
                k k4 = ((bq)object2).d;
                ((bq)object2).d.b = cg2;
                object2 = bq2;
                cg2 = f.b(((DoorStatus)object8).getRearRightPosition(), ((DoorStatus)object8).getRearRightLockStatus());
                k k5 = ((bq)object2).d;
                ((bq)object2).d.d = cg2;
                object2 = bq2;
                cg2 = f.b(((DoorStatus)object8).getEngineHoodPosition(), ((DoorStatus)object8).getEngineHoodLockStatus());
                k k6 = ((bq)object2).d;
                ((bq)object2).d.f = cg2;
                object2 = bq2;
                cg2 = f.b(((DoorStatus)object8).getTailgatePosition(), ((DoorStatus)object8).getTailgateLockStatus());
                k k7 = ((bq)object2).d;
                ((bq)object2).d.e = cg2;
                boolean bl3 = true;
                bq bq5 = bq2;
                bl2 = true;
                object2 = bq5.a;
                bq5.a.a = bl2;
            }
            object8 = var22_61;
            object3 = object4;
            ((cr)object4).D = object8;
            ((cr)object4).f(true);
        } else {
            ((cr)object4).f(false);
        }
        object5 = ((VehicleStatus)object).getVehicleDateTime();
        if (object5 != null) {
            object3 = object5;
            bc bc2 = null;
            if (object3 != null) {
                bc2 = new bc();
                long l9 = ((Date)object3).getTime() % 86400000L;
                long l10 = l9 / 3600000L;
                long l11 = l9 % 3600000L / 60000L;
                long l12 = l10;
                object5 = bc2;
                ((bc)object5).a.a(l12);
                l12 = l11;
                object5 = bc2;
                ((bc)object5).b.a(l12);
            }
            object3 = object4;
            ((cr)object4).P = bc2;
            ((cr)object4).n(true);
        } else {
            ((cr)object4).n(false);
        }
        object5 = ((VehicleStatus)object).getWindowStatus();
        if (object5 != null) {
            object3 = object5;
            ai ai2 = null;
            if (object3 != null) {
                ai2 = new ai();
                long l13 = ((WindowStatus)object3).getFrontLeftPosition();
                ai ai3 = ai2;
                ai2.a.a(l13);
                l13 = ((WindowStatus)object3).getFrontRightPosition();
                ai ai4 = ai2;
                ai4.b.a(l13);
                l13 = ((WindowStatus)object3).getRearLeftPosition();
                ai ai5 = ai2;
                ai5.c.a(l13);
                l13 = ((WindowStatus)object3).getRearRightPosition();
                ai ai6 = ai2;
                ai6.d.a(l13);
            }
            object3 = object4;
            ((cr)object4).C = ai2;
            ((cr)object4).e(true);
        } else {
            ((cr)object4).e(false);
        }
        long l14 = ((VehicleStatus)object).getCabOpenStatus();
        object3 = object4;
        ((cr)object3).E.a(l14);
        l14 = ((VehicleStatus)object).getEngineOnStatus();
        object3 = object4;
        ((cr)object3).u.a(l14);
        l14 = ((VehicleStatus)object).getHeadLightOn();
        object3 = object4;
        ((cr)object3).O.a(l14);
        l14 = ((VehicleStatus)object).getIgnitionKeyInStatus();
        object3 = object4;
        ((cr)object3).t.a(l14);
        l14 = ((VehicleStatus)object).getIgnitionOnStatus();
        object3 = object4;
        ((cr)object3).s.a(l14);
        l14 = ((VehicleStatus)object).getMovingFlag();
        object3 = object4;
        ((cr)object3).r.a(l14);
        l14 = ((VehicleStatus)object).getPanicAlarmTriggered();
        object3 = object4;
        ((cr)object3).x.a(l14);
        l14 = ((VehicleStatus)object).getSunroofOpenStatus();
        object3 = object4;
        ((cr)object3).F.a(l14);
        ((cr)object4).a(((VehicleStatus)object).getSrs());
        boolean bl4 = true;
        object3 = object4;
        bl2 = true;
        object2 = ((cr)object3).a;
        ((cr)object3).a.a = bl2;
        ((cr)object4).a(((VehicleStatus)object).getTheftAlarm());
        bl4 = true;
        object3 = object4;
        bl2 = true;
        object2 = ((cr)object3).b;
        ((cr)object3).b.a = bl2;
        Object object9 = object4;
        object3 = this.a();
        this.a().g = object9;
        this.a().a(true);
        object4 = ((VehicleStatus)object).getExtendedVehicleStatus();
        if (object4 != null) {
            object5 = new au();
            if (((ExtendedVehicleStatus)object4).getEchoGradeBraking() != null && ((ExtendedVehicleStatus)object4).getEchoGradePropulsion() != null) {
                object2 = object5;
                long l15 = ((ExtendedVehicleStatus)object4).getEchoGradeBraking().intValue();
                object3 = ((au)object2).s;
                ((h)object3).b.a(l15);
                object2 = object5;
                l15 = ((ExtendedVehicleStatus)object4).getEchoGradePropulsion().intValue();
                object3 = ((au)object2).s;
                ((h)object3).a.a(l15);
                ((au)object5).c(true);
            } else {
                ((au)object5).c(false);
            }
            long l16 = ((ExtendedVehicleStatus)object4).getBrakeFluidWarn();
            object3 = object5;
            ((au)object3).z.a(l16);
            boolean bl5 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).j;
            ((au)object3).j.a = bl2;
            int[] nArray = ((ExtendedVehicleStatus)object4).getBulbFailures();
            object3 = object5;
            try {
                int n2 = nArray == null ? 0 : nArray.length;
                boolean bl6 = n2 > 0;
                Object object10 = object3;
                bl2 = bl6;
                object2 = ((au)object10).i;
                ((au)object10).i.a = bl2;
                if (n2 > 0) {
                    void var23_92;
                    object2 = object3;
                    ((au)object2).y.b(n2);
                    boolean bl7 = false;
                    while (var23_92 < n2) {
                        ((au)object3).a((int)var23_92).a((long)nArray[var23_92]);
                        ++var23_92;
                    }
                }
            }
            catch (o o2) {
                throw new RuntimeException(o2.toString());
            }
            long l17 = ((ExtendedVehicleStatus)object4).getEngCoolantLevelWarn();
            object3 = object5;
            ((au)object3).A.a(l17);
            boolean bl8 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).k;
            ((au)object3).k.a = bl2;
            if (((ExtendedVehicleStatus)object4).getEngineHoursToService() != null) {
                long l18 = ((ExtendedVehicleStatus)object4).getEngineHoursToService().intValue();
                object3 = object5;
                ((au)object3).t.a(l18);
                bl2 = true;
                object2 = ((au)object3).d;
                ((au)object3).d.a = bl2;
                ((au)object5).d(true);
            } else {
                ((au)object5).d(false);
            }
            if (((ExtendedVehicleStatus)object4).getExternalTemp() != null) {
                long l19 = ((ExtendedVehicleStatus)object4).getExternalTemp().intValue();
                object3 = object5;
                ((au)object3).q.a(l19);
                bl2 = true;
                object2 = ((au)object3).a;
                ((au)object3).a.a = bl2;
                ((au)object5).a(true);
            } else {
                ((au)object5).a(false);
            }
            if (((ExtendedVehicleStatus)object4).getInternalTemp() != null) {
                long l20 = ((ExtendedVehicleStatus)object4).getInternalTemp().intValue();
                object3 = object5;
                ((au)object3).r.a(l20);
                bl2 = true;
                object2 = ((au)object3).b;
                ((au)object3).b.a = bl2;
                ((au)object5).b(true);
            } else {
                ((au)object5).b(false);
            }
            if (((ExtendedVehicleStatus)object4).getKilometersToService() != null) {
                long l21 = ((ExtendedVehicleStatus)object4).getKilometersToService().intValue();
                object3 = object5;
                ((au)object3).u.a(l21);
                bl2 = true;
                object2 = ((au)object3).e;
                ((au)object3).e.a = bl2;
                ((au)object5).e(true);
            } else {
                ((au)object5).e(false);
            }
            if (((ExtendedVehicleStatus)object4).getMonthsToService() != null) {
                long l22 = ((ExtendedVehicleStatus)object4).getMonthsToService().intValue();
                object3 = object5;
                ((au)object3).v.a(l22);
                bl2 = true;
                object2 = ((au)object3).f;
                ((au)object3).f.a = bl2;
                ((au)object5).f(true);
            } else {
                ((au)object5).f(false);
            }
            if (((ExtendedVehicleStatus)object4).getIgnitionOffMeter() != null) {
                ag ag4 = f.a(((ExtendedVehicleStatus)object4).getIgnitionOffMeter());
                object3 = object5;
                ((au)object5).E = ag4;
                ((au)object5).g(true);
            } else {
                ((au)object5).g(false);
            }
            long l23 = ((ExtendedVehicleStatus)object4).getWasherFluidWarn();
            object3 = object5;
            ((au)object3).D.a(l23);
            boolean bl9 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).n;
            ((au)object3).n.a = bl2;
            long l24 = ((ExtendedVehicleStatus)object4).getOilLevelWarn();
            object3 = object5;
            ((au)object3).B.a(l24);
            boolean bl10 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).l;
            ((au)object3).l.a = bl2;
            long l25 = ((ExtendedVehicleStatus)object4).getOilPressureWarn();
            object3 = object5;
            ((au)object3).C.a(l25);
            boolean bl11 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).m;
            ((au)object3).m.a = bl2;
            long l26 = ((ExtendedVehicleStatus)object4).getServiceWarningStatus();
            object3 = object5;
            ((au)object3).w.a(l26);
            boolean bl12 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).g;
            ((au)object3).g.a = bl2;
            long l27 = ((ExtendedVehicleStatus)object4).getServiceWarningTrigger();
            object3 = object5;
            ((au)object3).x.a(l27);
            boolean bl13 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).h;
            ((au)object3).h.a = bl2;
            long l28 = ((ExtendedVehicleStatus)object4).getIgnitionKeyState();
            object3 = object5;
            ((au)object3).F.a(l28);
            boolean bl14 = true;
            object3 = object5;
            bl2 = true;
            object2 = ((au)object3).p;
            ((au)object3).p.a = bl2;
            object9 = object5;
            object3 = this.a();
            this.a().h = object9;
            this.a().b(true);
        } else {
            this.a().b(false);
        }
        object5 = ((VehicleStatus)object).getElectricVehicleStatus();
        if (object5 == null) {
            this.a().c(false);
            return;
        }
        object = new cb();
        if (((ElectricVehicleStatus)object5).getChargingProfile() != null) {
            object2 = object;
            ((cb)object2).j.a(((ElectricVehicleStatus)object5).getChargingProfile());
            ((cb)object).a(true);
        } else {
            ((cb)object).a(false);
        }
        if (((ElectricVehicleStatus)object5).getTrip1AverageEnergyUsed() != null) {
            long l29 = (int)((double)(((ElectricVehicleStatus)object5).getTrip1AverageEnergyUsed().floatValue() * 10.0f) + 0.5);
            object3 = object;
            ((cb)object3).s.a(l29);
            bl2 = true;
            object2 = ((cb)object3).g;
            ((cb)object3).g.a = bl2;
            ((cb)object).f(true);
        } else {
            ((cb)object).f(false);
        }
        if (((ElectricVehicleStatus)object5).getTrip2AverageEnergyUsed() != null) {
            long l30 = (int)((double)(((ElectricVehicleStatus)object5).getTrip2AverageEnergyUsed().floatValue() * 10.0f) + 0.5);
            object3 = object;
            ((cb)object3).t.a(l30);
            bl2 = true;
            object2 = ((cb)object3).h;
            ((cb)object3).h.a = bl2;
            ((cb)object).g(true);
        } else {
            ((cb)object).g(false);
        }
        if (((ElectricVehicleStatus)object5).getTotalAverageEnergyUsed() != null) {
            long l31 = (int)((double)(((ElectricVehicleStatus)object5).getTotalAverageEnergyUsed().floatValue() * 10.0f) + 0.5);
            object3 = object;
            ((cb)object3).u.a(l31);
            bl2 = true;
            object2 = ((cb)object3).i;
            ((cb)object3).i.a = bl2;
            ((cb)object).h(true);
        } else {
            ((cb)object).h(false);
        }
        if (((ElectricVehicleStatus)object5).getIgnitionOffAverageEnergyUsed() != null) {
            long l32 = (int)((double)(((ElectricVehicleStatus)object5).getIgnitionOffAverageEnergyUsed().floatValue() * 10.0f) + 0.5);
            object3 = object;
            ((cb)object3).r.a(l32);
            bl2 = true;
            object2 = ((cb)object3).f;
            ((cb)object3).f.a = bl2;
            ((cb)object).e(true);
        } else {
            ((cb)object).e(false);
        }
        long l33 = ((ElectricVehicleStatus)object5).getChargeType();
        object3 = object;
        ((cb)object3).q.a(l33);
        boolean bl15 = true;
        object3 = object;
        bl2 = true;
        object2 = ((cb)object3).e;
        ((cb)object3).e.a = bl2;
        if (((ElectricVehicleStatus)object5).getDistanceToEmpty() != null) {
            long l34 = ((ElectricVehicleStatus)object5).getDistanceToEmpty().intValue();
            object3 = object;
            ((cb)object3).n.a(l34);
            bl2 = true;
            object2 = ((cb)object3).b;
            ((cb)object3).b.a = bl2;
            ((cb)object).b(true);
        } else {
            ((cb)object).b(false);
        }
        long l35 = ((ElectricVehicleStatus)object5).getIsCharging();
        object3 = object;
        ((cb)object3).l.a(l35);
        l35 = ((ElectricVehicleStatus)object5).getIsPluggedIn();
        object3 = object;
        ((cb)object3).m.a(l35);
        l35 = ((ElectricVehicleStatus)object5).getIsPreconditioning();
        object3 = object;
        ((cb)object3).k.a(l35);
        if (((ElectricVehicleStatus)object5).getStateOfCharge() != null) {
            l35 = ((ElectricVehicleStatus)object5).getStateOfCharge().intValue();
            object3 = object;
            ((cb)object3).o.a(l35);
            bl2 = true;
            object2 = ((cb)object3).c;
            ((cb)object3).c.a = bl2;
            ((cb)object).c(true);
        } else {
            ((cb)object).c(false);
        }
        if (((ElectricVehicleStatus)object5).getTimeToFullyCharged() != null) {
            l35 = ((ElectricVehicleStatus)object5).getTimeToFullyCharged().intValue();
            object3 = object;
            ((cb)object3).p.a(l35);
            bl2 = true;
            object2 = ((cb)object3).d;
            ((cb)object3).d.a = bl2;
            ((cb)object).d(true);
        } else {
            ((cb)object).d(false);
        }
        Object object11 = object;
        object3 = this.a();
        this.a().i = object11;
        this.a().c(true);
    }

    private static az a(int n2, int n3) {
        az az2 = new az();
        long l2 = n2;
        az az3 = az2;
        az2.b.a(l2);
        l2 = n3;
        az3 = az2;
        az3.a.a(l2);
        return az2;
    }

    private static cg b(int n2, int n3) {
        cg cg2 = new cg();
        long l2 = n2;
        cg cg3 = cg2;
        cg2.a.a(l2);
        l2 = n3;
        cg3 = cg2;
        cg3.b.a(l2);
        return cg2;
    }

    private static ag a(Integer n2) {
        ag ag2 = null;
        if (n2 != null) {
            ag2 = new ag();
            boolean bl2 = true;
            aw aw2 = ag2;
            bl2 = true;
            aw2 = ag2.a;
            ag2.a.a = bl2;
            long l2 = n2.longValue();
            aw2 = ag2;
            aw2.b.a(l2);
        }
        return ag2;
    }
}

