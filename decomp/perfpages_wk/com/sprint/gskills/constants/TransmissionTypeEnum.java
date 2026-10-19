/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.constants;

import com.sprint.gskills.constants.GSkillsBrandConstants;

public class TransmissionTypeEnum {
    private final int _transType;
    private final String _transTypeName;
    public static final TransmissionTypeEnum MANUAL = TransmissionTypeEnum.buildTransTypeEnum(0, "Manual");
    public static final TransmissionTypeEnum AUTO = TransmissionTypeEnum.buildTransTypeEnum(1, "Automatic");

    private TransmissionTypeEnum(int transType, String transTypeName) {
        this._transType = transType;
        this._transTypeName = transTypeName;
    }

    private static TransmissionTypeEnum buildTransTypeEnum(int transType, String transTypeName) {
        TransmissionTypeEnum transTypeEnum = new TransmissionTypeEnum(transType, transTypeName);
        GSkillsBrandConstants.addToTransTypeEnumMap(transTypeEnum);
        return transTypeEnum;
    }

    public String toString() {
        return this._transTypeName;
    }

    public int getTransType() {
        return this._transType;
    }
}

