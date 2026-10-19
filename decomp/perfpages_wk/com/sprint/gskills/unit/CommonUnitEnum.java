/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.unit;

public abstract class CommonUnitEnum {
    protected final int _unitID;
    protected final String _unitName;

    protected CommonUnitEnum(int unitID, String unitName) {
        this._unitID = unitID;
        this._unitName = unitName;
    }

    public String toString() {
        return this._unitName;
    }

    public int getID() {
        return this._unitID;
    }
}

