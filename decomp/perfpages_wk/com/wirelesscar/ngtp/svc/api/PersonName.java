/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class PersonName {
    private String a;
    private String b;
    private String c;
    private String d;
    private String e;

    public String getFamilyName() {
        return this.a;
    }

    public String getFirstName() {
        return this.b;
    }

    public String getMiddleName() {
        return this.c;
    }

    public String getPrefix() {
        return this.d;
    }

    public String getSuffix() {
        return this.e;
    }

    public PersonName(String string, String string2, String string3, String string4, String string5) {
        this.a = string;
        this.b = string2;
        this.c = string3;
        this.d = string4;
        this.e = string5;
    }

    public String toString() {
        return "PersonNameImpl [familyName=" + this.a + ", firstName=" + this.b + ", middleName=" + this.c + ", prefix=" + this.d + ", suffix=" + this.e + "]";
    }
}

