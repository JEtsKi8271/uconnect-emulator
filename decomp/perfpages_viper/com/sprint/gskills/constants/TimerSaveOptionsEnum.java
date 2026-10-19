/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;

public class TimerSaveOptionsEnum {
    private int type_int;
    private String displayName;
    private String devicePath;
    public static final TimerSaveOptionsEnum USB = new TimerSaveOptionsEnum(4, "timer_save_usb", ResKeyPropertiesFactory.getUSBSavePath());
    public static final TimerSaveOptionsEnum SDCard = new TimerSaveOptionsEnum(5, "timer_save_sd", ResKeyPropertiesFactory.getSDSavePath());
    public static final TimerSaveOptionsEnum uConnect = new TimerSaveOptionsEnum(6, "timer_save_uconnect", null);
    public static final TimerSaveOptionsEnum SAVE = new TimerSaveOptionsEnum(3, "timer_btn_save", null);
    public static final TimerSaveOptionsEnum CANCEL = new TimerSaveOptionsEnum(7, "timer_btn_cancel", null);
    public static final TimerSaveOptionsEnum OK = new TimerSaveOptionsEnum(6, "common_btn_ok", null);

    public TimerSaveOptionsEnum(int type_int, String displayName, String devicePath) {
        this.type_int = type_int;
        this.displayName = displayName;
        this.devicePath = devicePath;
    }

    public int getIntegerValue() {
        return this.type_int;
    }

    public String getTitleName() {
        return this.displayName;
    }

    public String getDevicePath() {
        return this.devicePath;
    }

    public int hashCode() {
        return this.getIntegerValue();
    }
}

