/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.factory.GSkillsAlignmentFactory;
import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.unit.UnitsOfMeasurementEnum;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Container;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public abstract class UpdatableContainer
extends Container {
    protected Logger _logger = LoggerFactory.getLogger((String)((Object)((Object)this)).getClass().getName());
    public static final int LX_NEEDLE_IMAGE_COUNT = 30;
    public static final int WK_NEEDLE_IMAGE_COUNT = 25;
    public static final String SNA_STRING = "--";
    public static final double SNA_DBL_VAL = -200.0;
    protected final int ENGINE_CONTAINER_W = 520;
    protected final int ENGINE_CONTAINER_H = 280;
    protected final int LEFT_COMPONENT_INDEX = 0;
    protected final int RIGHT_COMPONENT_INDEX = 1;
    protected final GSkillsResourceManager _resourceManager = GSkillsResourceManager.getInstance();
    protected final GSkillsFontsStyleFactory _fontFactory = GSkillsFontsStyleFactory.getInstance();
    protected final GSkillsAlignmentFactory _alignmentFactory = GSkillsAlignmentFactory.getInstance();
    protected final GSkillsStateManager _stateManager = GSkillsStateManager.getInstance();

    public abstract boolean updateViewOnDataChange(boolean var1);

    public abstract void updateViewOnLanguageChange();

    public void updateViewOnUnitChange() {
        UnitsOfMeasurementEnum unit = GSkillsStateManager.getInstance().getChangedUnit();
        if (UnitsOfMeasurementEnum.ALL == unit) {
            this.updateViewOnPowerUnitChange();
            this.updateViewOnTempUnitChange();
            this.updateViewOnTorqueUnitChange();
            this.updateViewOnPressureUnitChange();
            this.updateViewOnSpeedUnitChange();
            this.updateViewOnDistanceUnitChange();
        } else {
            switch (unit.getID()) {
                case 3: {
                    this.updateViewOnPowerUnitChange();
                    break;
                }
                case 1: {
                    this.updateViewOnTempUnitChange();
                    break;
                }
                case 5: {
                    this.updateViewOnTorqueUnitChange();
                    break;
                }
                case 2: {
                    this.updateViewOnPressureUnitChange();
                    break;
                }
                case 4: {
                    this.updateViewOnSpeedUnitChange();
                    break;
                }
                case 6: {
                    this.updateViewOnDistanceUnitChange();
                    break;
                }
            }
        }
    }

    public void updateViewOnPowerUnitChange() {
    }

    public void updateViewOnTempUnitChange() {
    }

    public void updateViewOnTorqueUnitChange() {
    }

    public void updateViewOnPressureUnitChange() {
    }

    public void updateViewOnSpeedUnitChange() {
    }

    public void updateViewOnDistanceUnitChange() {
    }

    public String toString() {
        String str = ((Object)((Object)this)).getClass().getName();
        return str.substring(str.lastIndexOf(46) + 1, str.length());
    }
}

