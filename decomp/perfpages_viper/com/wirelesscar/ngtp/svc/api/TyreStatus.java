/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class TyreStatus {
    private int a;
    private int b;
    private int c;
    private int d;
    private int e;
    private int f;
    private int g;
    private int h;

    public int getFrontLeftPressure() {
        return this.a;
    }

    public void setFrontLeftPressure(int n2) {
        this.a = n2;
    }

    public int getFrontRightPressure() {
        return this.b;
    }

    public void setFrontRightPressure(int n2) {
        this.b = n2;
    }

    public int getRearLeftPressure() {
        return this.c;
    }

    public void setRearLeftPressure(int n2) {
        this.c = n2;
    }

    public int getRearRightPressure() {
        return this.d;
    }

    public void setRearRightPressure(int n2) {
        this.d = n2;
    }

    public int getFrontLeftStatus() {
        return this.e;
    }

    public void setFrontLeftStatus(int n2) {
        this.e = n2;
    }

    public int getFrontRightStatus() {
        return this.f;
    }

    public void setFrontRightStatus(int n2) {
        this.f = n2;
    }

    public int getRearLeftStatus() {
        return this.g;
    }

    public void setRearLeftStatus(int n2) {
        this.g = n2;
    }

    public int getRearRightStatus() {
        return this.h;
    }

    public void setRearRightStatus(int n2) {
        this.h = n2;
    }

    public int hashCode() {
        int n2 = 31 + this.a;
        n2 = n2 * 31 + this.e;
        n2 = n2 * 31 + this.b;
        n2 = n2 * 31 + this.f;
        n2 = n2 * 31 + this.c;
        n2 = n2 * 31 + this.g;
        n2 = n2 * 31 + this.d;
        n2 = n2 * 31 + this.h;
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
        object = (TyreStatus)object;
        if (this.a != ((TyreStatus)object).a) {
            return false;
        }
        if (this.e != ((TyreStatus)object).e) {
            return false;
        }
        if (this.b != ((TyreStatus)object).b) {
            return false;
        }
        if (this.f != ((TyreStatus)object).f) {
            return false;
        }
        if (this.c != ((TyreStatus)object).c) {
            return false;
        }
        if (this.g != ((TyreStatus)object).g) {
            return false;
        }
        if (this.d != ((TyreStatus)object).d) {
            return false;
        }
        return this.h == ((TyreStatus)object).h;
    }
}

