/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

import java.util.Date;

public class Timestamp {
    private final int a;
    private final int b;

    public Timestamp(int n2, int n3) {
        this.a = n2;
        this.b = n3;
    }

    public static Timestamp fromDate(Date date) {
        return Timestamp.a(date.getTime());
    }

    public static Timestamp fromJavaMillis(long l2) {
        return Timestamp.a(l2);
    }

    public static Timestamp now() {
        long l2 = System.currentTimeMillis();
        if (Timestamp.isValidNgtpTime(l2)) {
            return Timestamp.a(l2);
        }
        return Timestamp.a(946684800000L);
    }

    public static boolean isValidNgtpTime(long l2) {
        return l2 >= 946684800000L;
    }

    public int getNgtpTime() {
        return this.a;
    }

    public int getNgtpMillis() {
        return this.b;
    }

    public Date getDate() {
        return new Date(Timestamp.a(this.a, this.b));
    }

    public long getJavaMillis() {
        return Timestamp.a(this.a, this.b);
    }

    private static final Timestamp a(long l2) {
        if (l2 < 946684800000L) {
            throw new IllegalArgumentException("Supplied timestamp is not a valid NGTP time: " + l2);
        }
        int n2 = (int)((l2 - 946684800000L) / 1000L);
        return new Timestamp(n2, (int)(l2 % 1000L));
    }

    private static final long a(int n2, int n3) {
        return (long)n2 * 1000L + 946684800000L + (long)n3;
    }

    public int hashCode() {
        int n2 = 31 + this.b;
        n2 = n2 * 31 + this.a;
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
        object = (Timestamp)object;
        if (this.b != ((Timestamp)object).b) {
            return false;
        }
        return this.a == ((Timestamp)object).a;
    }

    public String toString() {
        return "Timestamp [ngtpTime=" + this.a + " (" + this.getDate() + ")" + "]";
    }
}

