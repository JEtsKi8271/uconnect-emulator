/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.HashMap;

public class GSkillsAlignmentFactory {
    private HashMap<Integer, Integer> _alignmentMap = null;
    private static final GSkillsAlignmentFactory INSTANCE = new GSkillsAlignmentFactory();

    private GSkillsAlignmentFactory() {
        this.setGSkillsAlignmentProperties();
    }

    public static GSkillsAlignmentFactory getInstance() {
        return INSTANCE;
    }

    public int getAlignment(int alignmentConstant) {
        return this._alignmentMap.get(alignmentConstant);
    }

    public void setGSkillsAlignmentProperties() {
        this._alignmentMap = new HashMap();
        VehicleLineEnum vehLine = GSkillsStateManager.getInstance().getVehicleLine();
        VehicleTrimEnum vehTrim = GSkillsStateManager.getInstance().getVehicleTrim();
        if (VehicleTrimEnum.RT == vehTrim) {
            if (VehicleLineEnum.LA == vehLine) {
                this.setLACommonAlignments();
                this._alignmentMap.put(0, 29);
                this._alignmentMap.put(1, 86);
                this._alignmentMap.put(2, 51);
                this._alignmentMap.put(3, 98);
                this._alignmentMap.put(8, 173);
                this._alignmentMap.put(9, 200);
                this._alignmentMap.put(10, 253);
                this._alignmentMap.put(11, 155);
            } else if (VehicleLineEnum.LD == vehLine) {
                this.setLDCommonAlignments();
                this._alignmentMap.put(0, 28);
                this._alignmentMap.put(1, 85);
                this._alignmentMap.put(2, 24);
                this._alignmentMap.put(3, 112);
                this._alignmentMap.put(8, 178);
                this._alignmentMap.put(9, 192);
                this._alignmentMap.put(10, 207);
                this._alignmentMap.put(11, 174);
            } else if (VehicleLineEnum.LX == vehLine) {
                this.setLXCommonAlignments();
                this._alignmentMap.put(0, 28);
                this._alignmentMap.put(1, 85);
                this._alignmentMap.put(2, 24);
                this._alignmentMap.put(3, 112);
                this._alignmentMap.put(8, 178);
                this._alignmentMap.put(9, 192);
                this._alignmentMap.put(10, 207);
                this._alignmentMap.put(11, 174);
            }
            this._alignmentMap.put(14, 1);
            this._alignmentMap.put(18, 7);
            this._alignmentMap.put(17, 8);
            this._alignmentMap.put(15, 135);
            this._alignmentMap.put(16, 15);
            this._alignmentMap.put(22, 0);
            this._alignmentMap.put(21, 20);
            this._alignmentMap.put(23, 15);
            this._alignmentMap.put(20, 80);
            this._alignmentMap.put(25, 5);
            this._alignmentMap.put(24, 24);
            this._alignmentMap.put(26, 80);
            this._alignmentMap.put(27, 80);
            this._alignmentMap.put(28, 5);
            this._alignmentMap.put(29, 7);
        } else if (VehicleTrimEnum.HELLCAT == vehTrim) {
            if (VehicleLineEnum.LA == vehLine) {
                this.setLACommonAlignments();
                this._alignmentMap.put(0, 29);
                this._alignmentMap.put(1, 87);
                this._alignmentMap.put(2, 25);
                this._alignmentMap.put(3, 112);
            } else if (VehicleLineEnum.LD == vehLine) {
                this.setLDCommonAlignments();
                this._alignmentMap.put(0, 29);
                this._alignmentMap.put(1, 85);
                this._alignmentMap.put(2, 25);
                this._alignmentMap.put(3, 112);
            }
            this._alignmentMap.put(8, 178);
            this._alignmentMap.put(9, 204);
            this._alignmentMap.put(10, 207);
            this._alignmentMap.put(11, 194);
            this._alignmentMap.put(14, 5);
            this._alignmentMap.put(18, 15);
            this._alignmentMap.put(17, 0);
            this._alignmentMap.put(15, 135);
            this._alignmentMap.put(16, 20);
            this._alignmentMap.put(22, 5);
            this._alignmentMap.put(21, 20);
            this._alignmentMap.put(23, 5);
            this._alignmentMap.put(20, 73);
            this._alignmentMap.put(25, 10);
            this._alignmentMap.put(24, 24);
            this._alignmentMap.put(26, 80);
            this._alignmentMap.put(27, 80);
            this._alignmentMap.put(28, 3);
            this._alignmentMap.put(29, 10);
        } else {
            if (VehicleLineEnum.LA == vehLine) {
                this.setLACommonAlignments();
                this._alignmentMap.put(0, 29);
                this._alignmentMap.put(1, 87);
                this._alignmentMap.put(2, 25);
                this._alignmentMap.put(3, 112);
            } else if (VehicleLineEnum.LD == vehLine) {
                this.setLDCommonAlignments();
                this._alignmentMap.put(0, 29);
                this._alignmentMap.put(1, 85);
                this._alignmentMap.put(2, 25);
                this._alignmentMap.put(3, 112);
            } else if (VehicleLineEnum.LX == vehLine) {
                this.setLXCommonAlignments();
                this._alignmentMap.put(0, 28);
                this._alignmentMap.put(1, 85);
                this._alignmentMap.put(2, 24);
                this._alignmentMap.put(3, 112);
            }
            this._alignmentMap.put(8, 178);
            this._alignmentMap.put(9, 204);
            this._alignmentMap.put(10, 207);
            this._alignmentMap.put(11, 194);
            this._alignmentMap.put(14, 5);
            this._alignmentMap.put(18, 15);
            this._alignmentMap.put(17, 0);
            this._alignmentMap.put(15, 135);
            this._alignmentMap.put(16, 20);
            this._alignmentMap.put(22, 5);
            this._alignmentMap.put(21, 20);
            this._alignmentMap.put(23, 5);
            this._alignmentMap.put(20, 73);
            this._alignmentMap.put(25, 10);
            this._alignmentMap.put(24, 24);
            this._alignmentMap.put(26, 80);
            this._alignmentMap.put(27, 80);
            this._alignmentMap.put(28, 3);
            this._alignmentMap.put(29, 10);
        }
    }

    private void setLACommonAlignments() {
        this._alignmentMap.put(4, 66);
        this._alignmentMap.put(5, 48);
        this._alignmentMap.put(6, 58);
        this._alignmentMap.put(7, 40);
    }

    private void setLDCommonAlignments() {
        this._alignmentMap.put(4, 63);
        this._alignmentMap.put(5, 48);
        this._alignmentMap.put(6, 57);
        this._alignmentMap.put(7, 41);
    }

    private void setLXCommonAlignments() {
        this._alignmentMap.put(4, 72);
        this._alignmentMap.put(5, 50);
        this._alignmentMap.put(6, 57);
        this._alignmentMap.put(7, 41);
    }
}

