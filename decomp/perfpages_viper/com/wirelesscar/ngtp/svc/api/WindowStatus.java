/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class WindowStatus {
    public static final int POSITION_OPEN = 1;
    public static final int POSITION_CLOSED = 2;
    public static final int POSITION_UNKNOWN = 7;
    private int a = 7;
    private int b = 7;
    private int c = 7;
    private int d = 7;

    public int getFrontLeftPosition() {
        return this.a;
    }

    public void setFrontLeftPosition(int n2) {
        this.a = n2;
    }

    public int getFrontRightPosition() {
        return this.b;
    }

    public void setFrontRightPosition(int n2) {
        this.b = n2;
    }

    public int getRearLeftPosition() {
        return this.c;
    }

    public void setRearLeftPosition(int n2) {
        this.c = n2;
    }

    public int getRearRightPosition() {
        return this.d;
    }

    public void setRearRightPosition(int n2) {
        this.d = n2;
    }

    public int hashCode() {
        int n2 = 31 + this.a;
        n2 = n2 * 31 + this.b;
        n2 = n2 * 31 + this.c;
        n2 = n2 * 31 + this.d;
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
        object = (WindowStatus)object;
        if (this.a != ((WindowStatus)object).a) {
            return false;
        }
        if (this.b != ((WindowStatus)object).b) {
            return false;
        }
        if (this.c != ((WindowStatus)object).c) {
            return false;
        }
        return this.d == ((WindowStatus)object).d;
    }
}

