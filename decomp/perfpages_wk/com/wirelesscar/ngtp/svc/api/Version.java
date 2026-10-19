/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class Version {
    private final int a;
    private final int b;

    public Version(int n2, int n3) {
        this.a = n2;
        this.b = n3;
    }

    public int getMajor() {
        return this.a;
    }

    public int getMinor() {
        return this.b;
    }

    public int hashCode() {
        int n2 = 31 + this.a;
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
        object = (Version)object;
        if (this.a != ((Version)object).a) {
            return false;
        }
        return this.b == ((Version)object).b;
    }

    public String toString() {
        return "Version [major=" + this.a + ", minor=" + this.b + "]";
    }
}

