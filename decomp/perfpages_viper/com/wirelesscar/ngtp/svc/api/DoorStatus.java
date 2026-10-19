/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class DoorStatus {
    public static final int POSITION_OPEN = 0;
    public static final int POSITION_CLOSED = 1;
    public static final int POSITION_UNKNOWN = 7;
    public static final int LOCKSTATUS_UNKNOWN = 0;
    public static final int LOCKSTATUS_UNLOCKED = 1;
    public static final int LOCKSTATUS_LOCKED = 3;
    public static final int LOCKSTATUS_SECURED = 4;
    private int a;
    private int b;
    private int c = 7;
    private int d = 7;
    private int e = 7;
    private int f = 7;
    private int g = 7;
    private int h = 7;
    private int i;
    private int j;
    private int k;
    private int l;
    private int m;
    private int n;

    public int getAllDoorsLocked() {
        return this.a;
    }

    public void setAllDoorsLocked(int n2) {
        this.a = n2;
    }

    public int getTrunkLocked() {
        return this.b;
    }

    public void setTrunkLocked(int n2) {
        this.b = n2;
    }

    public int getFrontLeftPosition() {
        return this.c;
    }

    public void setFrontLeftPosition(int n2) {
        this.c = n2;
    }

    public int getFrontRightPosition() {
        return this.d;
    }

    public void setFrontRightPosition(int n2) {
        this.d = n2;
    }

    public int getRearLeftPosition() {
        return this.e;
    }

    public void setRearLeftPosition(int n2) {
        this.e = n2;
    }

    public int getRearRightPosition() {
        return this.f;
    }

    public void setRearRightPosition(int n2) {
        this.f = n2;
    }

    public int getTailgatePosition() {
        return this.g;
    }

    public void setTailgatePosition(int n2) {
        this.g = n2;
    }

    public int getEngineHoodPosition() {
        return this.h;
    }

    public void setEngineHoodPosition(int n2) {
        this.h = n2;
    }

    public int getFrontLeftLockStatus() {
        return this.i;
    }

    public void setFrontLeftLockStatus(int n2) {
        this.i = n2;
    }

    public int getFrontRightLockStatus() {
        return this.j;
    }

    public void setFrontRightLockStatus(int n2) {
        this.j = n2;
    }

    public int getRearLeftLockStatus() {
        return this.k;
    }

    public void setRearLeftLockStatus(int n2) {
        this.k = n2;
    }

    public int getRearRightLockStatus() {
        return this.l;
    }

    public void setRearRightLockStatus(int n2) {
        this.l = n2;
    }

    public int getTailgateLockStatus() {
        return this.m;
    }

    public void setTailgateLockStatus(int n2) {
        this.m = n2;
    }

    public int getEngineHoodLockStatus() {
        return this.n;
    }

    public void setEngineHoodLockStatus(int n2) {
        this.n = n2;
    }

    public int hashCode() {
        int n2 = 31 + this.a;
        n2 = n2 * 31 + this.n;
        n2 = n2 * 31 + this.h;
        n2 = n2 * 31 + this.i;
        n2 = n2 * 31 + this.c;
        n2 = n2 * 31 + this.j;
        n2 = n2 * 31 + this.d;
        n2 = n2 * 31 + this.k;
        n2 = n2 * 31 + this.e;
        n2 = n2 * 31 + this.l;
        n2 = n2 * 31 + this.f;
        n2 = n2 * 31 + this.m;
        n2 = n2 * 31 + this.g;
        n2 = n2 * 31 + this.b;
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
        object = (DoorStatus)object;
        if (this.a != ((DoorStatus)object).a) {
            return false;
        }
        if (this.n != ((DoorStatus)object).n) {
            return false;
        }
        if (this.h != ((DoorStatus)object).h) {
            return false;
        }
        if (this.i != ((DoorStatus)object).i) {
            return false;
        }
        if (this.c != ((DoorStatus)object).c) {
            return false;
        }
        if (this.j != ((DoorStatus)object).j) {
            return false;
        }
        if (this.d != ((DoorStatus)object).d) {
            return false;
        }
        if (this.k != ((DoorStatus)object).k) {
            return false;
        }
        if (this.e != ((DoorStatus)object).e) {
            return false;
        }
        if (this.l != ((DoorStatus)object).l) {
            return false;
        }
        if (this.f != ((DoorStatus)object).f) {
            return false;
        }
        if (this.m != ((DoorStatus)object).m) {
            return false;
        }
        if (this.g != ((DoorStatus)object).g) {
            return false;
        }
        return this.b == ((DoorStatus)object).b;
    }
}

