/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class StringAttribute {
    private String a;
    private String b;

    public StringAttribute(String string, String string2) {
        this.a = string;
        this.b = string2;
    }

    public String getKey() {
        return this.a;
    }

    public void setKey(String string) {
        this.a = string;
    }

    public String getValue() {
        return this.b;
    }

    public void setValue(String string) {
        this.b = string;
    }

    public String toString() {
        return "POIAttribute [key=" + this.a + ", value=" + this.b + "]";
    }
}

