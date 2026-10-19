/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.airbiquity.sdp.common.impl;

import java.io.Serializable;
import java.util.Hashtable;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class PowerModeStateEnum
implements Serializable {
    private static final long serialVersionUID = 1L;
    static Logger logger = LoggerFactory.getLogger(PowerModeStateEnum.class);
    private static Hashtable OBJ_TO_VALUE = new Hashtable();
    public static PowerModeStateEnum IGN_LK = new PowerModeStateEnum(0, "Ignition lock");
    public static PowerModeStateEnum IGN_OFF = new PowerModeStateEnum(1, "Ignition off");
    public static PowerModeStateEnum IGN_ACC = new PowerModeStateEnum(2, "Ignition accessory");
    public static PowerModeStateEnum IGN_OFF_ACC = new PowerModeStateEnum(3, "Ignition off & accessory");
    public static PowerModeStateEnum IGN_RUN = new PowerModeStateEnum(4, "Ignition run");
    public static PowerModeStateEnum IGN_START = new PowerModeStateEnum(5, "Ignition start");
    public static PowerModeStateEnum SNA = new PowerModeStateEnum(0, "Signal not available");
    private int state;
    private String name;

    public static PowerModeStateEnum getFromInt(int value) {
        PowerModeStateEnum stateFromMap = (PowerModeStateEnum)OBJ_TO_VALUE.get(value);
        if (stateFromMap == null && stateFromMap == null) {
            logger.warn((Object)("Unsupported state returned from PowerMode sensor " + value));
        }
        return stateFromMap;
    }

    private PowerModeStateEnum(int value, String name) {
        this.state = value;
        this.name = name;
        OBJ_TO_VALUE.put(value, this);
    }

    public String getName() {
        return this.name;
    }

    public int getState() {
        return this.state;
    }

    public String toString() {
        return this.name + " " + this.state;
    }

    public boolean equals(Object object) {
        if (!(object instanceof PowerModeStateEnum)) {
            return false;
        }
        PowerModeStateEnum obj = (PowerModeStateEnum)object;
        return this.name.equals(obj.getName()) && this.state == obj.getState();
    }

    public int hashCode() {
        return this.name.hashCode() + this.state;
    }
}

