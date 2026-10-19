/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model.timers;

public class TimerAttribute {
    private int _performanceSRTAttribute;
    private boolean _isRegistered = false;
    public static final TimerAttribute SRT_REACTTMC = new TimerAttribute(44);
    public static final TimerAttribute SRT_60MPHTMC = new TimerAttribute(0);
    public static final TimerAttribute SRT_100MPHTMC = new TimerAttribute(43);
    public static final TimerAttribute SRT_EIGHTHTMC = new TimerAttribute(6);
    public static final TimerAttribute SRT_ETHSPDC_M = new TimerAttribute(12);
    public static final TimerAttribute SRT_QUARTERTMC = new TimerAttribute(18);
    public static final TimerAttribute SRT_QRTSPDC_M = new TimerAttribute(24);
    public static final TimerAttribute SRT_BRKDISTC_M = new TimerAttribute(30);
    public static final TimerAttribute SRT_BRKSPDC_M = new TimerAttribute(36);
    public static final TimerAttribute SRT_60ftTmC = new TimerAttribute(60);
    public static final TimerAttribute SRT_REACTTM_C = new TimerAttribute(50);
    public static final TimerAttribute SRT_60MPHTM_C = new TimerAttribute(1);
    public static final TimerAttribute SRT_100MPHTM_C = new TimerAttribute(49);
    public static final TimerAttribute SRT_EIGHTHTM_C = new TimerAttribute(7);
    public static final TimerAttribute SRT_ETHSPDC_US = new TimerAttribute(13);
    public static final TimerAttribute SRT_QUARTERTM_C = new TimerAttribute(19);
    public static final TimerAttribute SRT_QRTSPDC_US = new TimerAttribute(25);
    public static final TimerAttribute SRT_BRKDISTC_US = new TimerAttribute(35);
    public static final TimerAttribute SRT_BRKSPDC_US = new TimerAttribute(39);
    public static final TimerAttribute SRT_60ftTm_C = new TimerAttribute(63);
    public static final TimerAttribute SRT_REACTTML = new TimerAttribute(48);
    public static final TimerAttribute SRT_60MPHTML = new TimerAttribute(2);
    public static final TimerAttribute SRT_100MPHTML = new TimerAttribute(47);
    public static final TimerAttribute SRT_EIGHTHTML = new TimerAttribute(10);
    public static final TimerAttribute SRT_ETHSPDL_M = new TimerAttribute(14);
    public static final TimerAttribute SRT_QUARTERTML = new TimerAttribute(20);
    public static final TimerAttribute SRT_QRTSPDL_M = new TimerAttribute(26);
    public static final TimerAttribute SRT_BRKDISTL_M = new TimerAttribute(31);
    public static final TimerAttribute SRT_BRKSPDL_M = new TimerAttribute(37);
    public static final TimerAttribute SRT_60ftTmL = new TimerAttribute(62);
    public static final TimerAttribute SRT_REACTTM_L = new TimerAttribute(54);
    public static final TimerAttribute SRT_60MPHTM_L = new TimerAttribute(3);
    public static final TimerAttribute SRT_100MPHTM_L = new TimerAttribute(53);
    public static final TimerAttribute SRT_EIGHTHTM_L = new TimerAttribute(11);
    public static final TimerAttribute SRT_ETHSPDL_US = new TimerAttribute(15);
    public static final TimerAttribute SRT_QUARTERTM_L = new TimerAttribute(21);
    public static final TimerAttribute SRT_QRTSPDL_US = new TimerAttribute(27);
    public static final TimerAttribute SRT_BRKDISTL_US = new TimerAttribute(33);
    public static final TimerAttribute SRT_BRKSPDL_US = new TimerAttribute(40);
    public static final TimerAttribute SRT_60ftTm_L = new TimerAttribute(65);
    public static final TimerAttribute SRT_ReactTmB = new TimerAttribute(46);
    public static final TimerAttribute SRT_60MPHTMB = new TimerAttribute(4);
    public static final TimerAttribute SRT_100MPHTMB = new TimerAttribute(45);
    public static final TimerAttribute SRT_EIGHTHTMB = new TimerAttribute(8);
    public static final TimerAttribute SRT_ETHSPDB_M = new TimerAttribute(16);
    public static final TimerAttribute SRT_QUARTERTMB = new TimerAttribute(22);
    public static final TimerAttribute SRT_QRTSPDB_M = new TimerAttribute(28);
    public static final TimerAttribute SRT_BRKDISTB_M = new TimerAttribute(32);
    public static final TimerAttribute SRT_BRKSPDB_M = new TimerAttribute(38);
    public static final TimerAttribute SRT_60ftTmB = new TimerAttribute(61);
    public static final TimerAttribute SRT_REACTTM_B = new TimerAttribute(52);
    public static final TimerAttribute SRT_60MPHTM_B = new TimerAttribute(5);
    public static final TimerAttribute SRT_100MPHTM_B = new TimerAttribute(51);
    public static final TimerAttribute SRT_EIGHTHTM_B = new TimerAttribute(9);
    public static final TimerAttribute SRT_ETHSPDB_US = new TimerAttribute(17);
    public static final TimerAttribute SRT_QUARTERTM_B = new TimerAttribute(23);
    public static final TimerAttribute SRT_QRTSPDB_US = new TimerAttribute(29);
    public static final TimerAttribute SRT_BRKDISTB_US = new TimerAttribute(34);
    public static final TimerAttribute SRT_BRKSPDB_US = new TimerAttribute(41);
    public static final TimerAttribute SRT_60ftTm_B = new TimerAttribute(64);

    public TimerAttribute(int performanceSRTAttribute) {
        this._performanceSRTAttribute = performanceSRTAttribute;
    }

    public void setTimerAttributeRegistered() {
        this._isRegistered = true;
    }

    public boolean isTimerAttributeRegistered() {
        return this._isRegistered;
    }

    public int getTimerAttribute() {
        return this._performanceSRTAttribute;
    }
}

