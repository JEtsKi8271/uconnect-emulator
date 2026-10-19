/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.view.enginepage.EngineView;
import com.sun.lwuit.Component;

public class EngineJeepViperView
extends EngineView {
    private static final EngineJeepViperView INSTANCE = new EngineJeepViperView();

    public static EngineJeepViperView getInstance() {
        return INSTANCE;
    }

    private EngineJeepViperView() {
    }

    public void initLayout() {
        this.initContainer(this._oilPressureContainer);
        this.initContainer(this._torqueContainer);
        this.initContainer(this._horsepowerContainer);
        this.initContainer(this._speedContainer);
        this.addComponent((Component)this._maskContainer);
        this.initContainer(this._hpTorqueUnitContainer);
        this.initContainer(this._gearContainer);
    }

    protected void layoutGearContainer() {
        this._gearContainer.setX(200);
        this._gearContainer.setY(140);
    }
}

