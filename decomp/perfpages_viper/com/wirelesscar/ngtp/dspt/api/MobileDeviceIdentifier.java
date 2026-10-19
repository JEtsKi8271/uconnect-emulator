/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

public class MobileDeviceIdentifier {
    private String a;
    private String b;
    private String c;
    private String d;

    public String getPublicAddress() {
        return this.a;
    }

    public void setPublicAddress(String string) {
        this.a = string;
    }

    public String getEquipmentIdentifier() {
        return this.b;
    }

    public void setEquipmentIdentifier(String string) {
        this.b = string;
    }

    public String getSubscriberIdentity() {
        return this.c;
    }

    public void setSubscriberIdentity(String string) {
        this.c = string;
    }

    public String getIccId() {
        return this.d;
    }

    public void setIccId(String string) {
        this.d = string;
    }
}

