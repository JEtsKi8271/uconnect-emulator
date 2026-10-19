/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.util;

public class IntegerRange {
    private int low;
    private int high;

    public IntegerRange(int low, int high) {
        this.low = low;
        this.high = high;
    }

    public int size() {
        return this.high - this.low;
    }

    public boolean found(int val) {
        boolean found = false;
        if (val >= this.low && val < this.high) {
            found = true;
        }
        return found;
    }

    public int getLow() {
        return this.low;
    }

    public int getHigh() {
        return this.high;
    }
}

