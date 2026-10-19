/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.dspt.api;

public class MessageCount {
    private int a;
    private int b;

    public MessageCount(int n2, int n3) {
        this.a = n2;
        this.b = n3;
    }

    public int getUplinkCount() {
        return this.a;
    }

    public int getDownlinkCount() {
        return this.b;
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
        object = (MessageCount)object;
        if (this.b != ((MessageCount)object).b) {
            return false;
        }
        return this.a == ((MessageCount)object).a;
    }

    public String toString() {
        return "MessageCount [uplinkCount=" + this.a + ", downlinkCount=" + this.b + "]";
    }
}

