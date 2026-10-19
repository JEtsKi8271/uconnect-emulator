/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.constants.TransmissionTypeEnum;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.enginepage.EngineView;
import com.sun.lwuit.Component;

public class EngineLSeriesView
extends EngineView {
    private static final EngineLSeriesView INSTANCE = new EngineLSeriesView();

    public static EngineLSeriesView getInstance() {
        return INSTANCE;
    }

    private EngineLSeriesView() {
    }

    public void initLayout() {
        if (TransmissionTypeEnum.AUTO == GSkillsStateManager.getInstance().getTransType()) {
            this.initContainer(this._gearContainer);
        }
        this.initContainer(this._oilPressureContainer);
        this.initContainer(this._torqueContainer);
        this.initContainer(this._horsepowerContainer);
        this.initContainer(this._speedContainer);
        this.addComponent((Component)this._maskContainer);
        this.initContainer(this._hpTorqueUnitContainer);
    }

    protected void layoutGearContainer() {
        this._gearContainer.setX(299);
        this._gearContainer.setY(166);
    }
}

