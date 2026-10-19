/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;

public class TimerSaveOptionsEnum {
    private int _typeID;
    private String _displayName;
    private String _devicePath;
    public static final TimerSaveOptionsEnum USB = new TimerSaveOptionsEnum(4, "timer_save_usb", ResKeyPropertiesFactory.getUSBSavePath());
    public static final TimerSaveOptionsEnum SDCARD = new TimerSaveOptionsEnum(5, "timer_save_sd", ResKeyPropertiesFactory.getSDSavePath());
    public static final TimerSaveOptionsEnum UCONNECT = new TimerSaveOptionsEnum(6, "timer_save_uconnect", null);
    public static final TimerSaveOptionsEnum SAVE = new TimerSaveOptionsEnum(3, "timer_btn_save", null);
    public static final TimerSaveOptionsEnum CANCEL = new TimerSaveOptionsEnum(7, "timer_btn_cancel", null);
    public static final TimerSaveOptionsEnum OK = new TimerSaveOptionsEnum(6, "common_btn_ok", null);

    public TimerSaveOptionsEnum(int type_int, String displayName, String devicePath) {
        this._typeID = type_int;
        this._displayName = displayName;
        this._devicePath = devicePath;
    }

    public int getIntegerValue() {
        return this._typeID;
    }

    public String getTitleName() {
        return this._displayName;
    }

    public String getDevicePath() {
        return this._devicePath;
    }

    public int hashCode() {
        return this.getIntegerValue();
    }
}

