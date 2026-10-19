/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class PostalAddress {
    private String a;
    private String b;
    private String c;
    private String d;
    private String e;
    private String f;

    public PostalAddress(String string, String string2, String string3, String string4, String string5, String string6) {
        this.a = string;
        this.b = string2;
        this.c = string3;
        this.d = string4;
        this.e = string5;
        this.f = string6;
    }

    public String getStreet() {
        return this.a;
    }

    public String getHouseNumber() {
        return this.b;
    }

    public String getCity() {
        return this.c;
    }

    public String getRegion() {
        return this.d;
    }

    public String getPostalCode() {
        return this.e;
    }

    public String getCountry() {
        return this.f;
    }

    public String toString() {
        return "PostalAddressImpl [street=" + this.a + ", houseNumber=" + this.b + ", city=" + this.c + ", region=" + this.d + ", postalCode=" + this.e + ", country=" + this.f + "]";
    }
}

