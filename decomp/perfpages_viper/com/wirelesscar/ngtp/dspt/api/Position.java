/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

public class Position {
    private final int a;
    private final int b;
    public static final Position UNKNOWN_POSITION = new Position();

    private Position() {
        this.a = 324000001;
        this.b = 648000001;
    }

    public Position(int n2, int n3) {
        this.a = n2;
        this.b = n3;
    }

    public Position(double d2, double d3) {
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

    public int hashCode() {
        int n2 = 23 + this.a;
        n2 = n2 * 23 + this.b;
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
        object = (Position)object;
        if (this.b != ((Position)object).b) {
            return false;
        }
        return this.a == ((Position)object).a;
    }

    public String toString() {
        return "Position [latitude=" + this.a + ", longitude=" + this.b + "]";
    }
}

