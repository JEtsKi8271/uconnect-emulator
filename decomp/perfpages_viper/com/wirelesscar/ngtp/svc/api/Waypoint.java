/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.PositionQuality;
import java.util.Date;

public class Waypoint {
    private final int a;
    private final int b;
    private Integer c;
    private Integer d;
    private Integer e;
    private PositionQuality f;
    private Date g;
    public static final Waypoint UNKNOWN_POSITION = new Waypoint();

    public Waypoint() {
        this.a = 324000001;
        this.b = 648000001;
    }

    public Waypoint(int n2, int n3) {
        this.a = n2;
        this.b = n3;
    }

    public Waypoint(double d2, double d3) {
        this.a = (int)(d2 * 3600000.0);
        this.b = (int)(d3 * 3600000.0);
    }

    public boolean isValidPosition() {
        return this.a != 324000001 && this.b != 648000001;
    }

    public int getNgtpLatitude() {
        return this.a;
    }

    public double getLatitude() {
        return (double)this.a / 3600000.0;
    }

    public int getNgtpLongitude() {
        return this.b;
    }

    public double getLongitude() {
        return (double)this.b / 3600000.0;
    }

    public Integer getAltitude() {
        return this.c;
    }

    public void setAltitude(Integer n2) {
        this.c = n2;
    }

    public Integer getHeading() {
        return this.d;
    }

    public void setHeading(Integer n2) {
        this.d = n2;
    }

    public PositionQuality getQuality() {
        return this.f;
    }

    public void setQuality(PositionQuality positionQuality) {
        this.f = positionQuality;
    }

    public Integer getSpeed() {
        return this.e;
    }

    public void setSpeed(Integer n2) {
        this.e = n2;
    }

    public Date getTimestamp() {
        return this.g;
    }

    public void setTimestamp(Date date) {
        this.g = date;
    }

    public int hashCode() {
        int n2 = 31 + (this.c == null ? 0 : this.c.hashCode());
        n2 = n2 * 31 + (this.d == null ? 0 : this.d.hashCode());
        n2 = n2 * 31 + this.a;
        n2 = n2 * 31 + this.b;
        n2 = n2 * 31 + (this.f == null ? 0 : this.f.hashCode());
        n2 = n2 * 31 + (this.e == null ? 0 : this.e.hashCode());
        n2 = n2 * 31 + (this.g == null ? 0 : this.g.hashCode());
        return n2;
    }

    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }
        if (object == null) {
            return false;
        }
        if (this.getClass() != object.getClass()) {
            return false;
        }
        object = (Waypoint)object;
        if (this.c == null ? ((Waypoint)object).c != null : !this.c.equals(((Waypoint)object).c)) {
            return false;
        }
        if (this.d == null ? ((Waypoint)object).d != null : !this.d.equals(((Waypoint)object).d)) {
            return false;
        }
        if (this.a != ((Waypoint)object).a) {
            return false;
        }
        if (this.b != ((Waypoint)object).b) {
            return false;
        }
        if (this.f == null ? ((Waypoint)object).f != null : !this.f.equals(((Waypoint)object).f)) {
            return false;
        }
        if (this.e == null ? ((Waypoint)object).e != null : !this.e.equals(((Waypoint)object).e)) {
            return false;
        }
        return !(this.g == null ? ((Waypoint)object).g != null : !this.g.equals(((Waypoint)object).g));
    }

    public String toString() {
        return "Waypoint [ngtpLatitude=" + this.a + ", ngtpLongitude=" + this.b + ", altitude=" + this.c + ", heading=" + this.d + ", speed=" + this.e + ", quality=" + this.f + ", timestamp=" + this.g + ", getLatitude()=" + this.getLatitude() + ", getLongitude()=" + this.getLongitude() + "]";
    }
}

