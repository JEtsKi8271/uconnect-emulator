/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

import com.sprint.gskills.view.common.GSkillsStateManager;

public final class TimersDisplayStatusEnum {
    public static final TimersDisplayStatusEnum BEST = new TimersDisplayStatusEnum("Best", 0xE10000);
    public static final TimersDisplayStatusEnum LAST = new TimersDisplayStatusEnum("Last", 0xEE9009);
    private static final String CURRENT_TIMER_TEXT = GSkillsStateManager.getInstance().isLSeriesVehicle() ? "Current" : "Recent";
    public static final TimersDisplayStatusEnum CURRENT = new TimersDisplayStatusEnum(CURRENT_TIMER_TEXT, 1144581);
    private final String _displayName;
    private final int _color;

    public TimersDisplayStatusEnum(String displayName, int color) {
        this._color = color;
        this._displayName = displayName;
    }

    public String toString() {
        return this._displayName;
    }

    public int getFontColor() {
        return this._color;
    }
}

