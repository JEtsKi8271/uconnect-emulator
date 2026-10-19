/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

public class Phone {
    private String a;
    private int b;

    public Phone(String string, int n2) {
        this.a = string;
        this.b = n2;
    }

    public int getType() {
        return this.b;
    }

    public void setType(int n2) {
        this.b = n2;
    }

    public void setPhoneNumber(String string) {
        this.a = string;
    }

    public String getPhoneNumber() {
        return this.a;
    }
}

