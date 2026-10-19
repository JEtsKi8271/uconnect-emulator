/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class PositionQuality {
    public static final int FLAG_YES = 0;
    public static final int FLAG_NO = 1;
    public static final int FLAG_NOT_APPLICABLE = 2;
    public static final int FLAG_UNKNOWN = 3;
    private int a = 3;
    private int b = 3;
    private int c = 3;
    private int d = 3;
    private int e = 3;
    private int f = 3;
    private int g = 3;
    private int h = 3;
    private int i = 3;
    private int j = 3;

    public int getGpsPositionFixAvailable() {
        return this.a;
    }

    public void setGpsPositionFixAvailable(int n2) {
        this.a = n2;
    }

    public int getDifferentialGPSAvailable() {
        return this.b;
    }

    public void setDifferentialGPSAvailable(int n2) {
        this.b = n2;
    }

    public int getDeadReckoning() {
        return this.c;
    }

    public void setDeadReckoning(int n2) {
        this.c = n2;
    }

    public int getInsideDigitizedArea() {
        return this.d;
    }

    public void setInsideDigitizedArea(int n2) {
        this.d = n2;
    }

    public int getFullyDigitizedArea() {
        return this.e;
    }

    public void setFullyDigitizedArea(int n2) {
        this.e = n2;
    }

    public int getMatchedToDigitalMap() {
        return this.f;
    }

    public void setMatchedToDigitalMap(int n2) {
        this.f = n2;
    }

    public int getCalibrated() {
        return this.g;
    }

    public void setCalibrated(int n2) {
        this.g = n2;
    }

    public int getGpsTimeFix() {
        return this.h;
    }

    public void setGpsTimeFix(int n2) {
        this.h = n2;
    }

    public int getGps2DFix() {
        return this.i;
    }

    public void setGps2DFix(int n2) {
        this.i = n2;
    }

    public int getGps3DFix() {
        return this.j;
    }

    public void setGps3DFix(int n2) {
        this.j = n2;
    }

    public int hashCode() {
        int n2 = 31 + this.g;
        n2 = n2 * 31 + this.c;
        n2 = n2 * 31 + this.b;
        n2 = n2 * 31 + this.e;
        n2 = n2 * 31 + this.i;
        n2 = n2 * 31 + this.j;
        n2 = n2 * 31 + this.a;
        n2 = n2 * 31 + this.h;
        n2 = n2 * 31 + this.d;
        n2 = n2 * 31 + this.f;
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
        object = (PositionQuality)object;
        if (this.g != ((PositionQuality)object).g) {
            return false;
        }
        if (this.c != ((PositionQuality)object).c) {
            return false;
        }
        if (this.b != ((PositionQuality)object).b) {
            return false;
        }
        if (this.e != ((PositionQuality)object).e) {
            return false;
        }
        if (this.i != ((PositionQuality)object).i) {
            return false;
        }
        if (this.j != ((PositionQuality)object).j) {
            return false;
        }
        if (this.a != ((PositionQuality)object).a) {
            return false;
        }
        if (this.h != ((PositionQuality)object).h) {
            return false;
        }
        if (this.d != ((PositionQuality)object).d) {
            return false;
        }
        return this.f == ((PositionQuality)object).f;
    }

    public String toString() {
        return "PositionQuality [gpsPositionFixAvailable=" + this.a + ", differentialGPSAvailable=" + this.b + ", deadReckoning=" + this.c + ", insideDigitizedArea=" + this.d + ", fullyDigitizedArea=" + this.e + ", matchedToDigitalMap=" + this.f + ", calibrated=" + this.g + ", gpsTimeFix=" + this.h + ", gps2DFix=" + this.i + ", gps3DFix=" + this.j + "]";
    }
}

