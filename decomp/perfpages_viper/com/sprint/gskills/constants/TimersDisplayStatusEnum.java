/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

public final class TimersDisplayStatusEnum {
    public static final TimersDisplayStatusEnum BEST = new TimersDisplayStatusEnum(0, "Best", 0xE10000);
    public static final TimersDisplayStatusEnum LAST = new TimersDisplayStatusEnum(1, "Last", 0xEE9009);
    public static final TimersDisplayStatusEnum CURRENT = new TimersDisplayStatusEnum(2, "Current", 1144581);
    private int type_int;
    private String displayName;
    private int color;

    public TimersDisplayStatusEnum(int type_int, String displayName, int color) {
        this.type_int = type_int;
        this.color = color;
        this.displayName = displayName;
    }

    public int getIntegerValue() {
        return this.type_int;
    }

    public String getTitleName() {
        return this.displayName;
    }

    public int getFontColor() {
        return this.color;
    }

    public int hashCode() {
        return this.getIntegerValue();
    }
}

