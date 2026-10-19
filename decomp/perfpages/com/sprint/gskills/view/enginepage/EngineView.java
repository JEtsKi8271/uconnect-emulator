/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.constants.TransmissionTypeEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsView;
import com.sprint.gskills.view.enginepage.EngineGearContainer;
import com.sprint.gskills.view.enginepage.EngineHPTorqueUnitContainer;
import com.sprint.gskills.view.enginepage.EngineHorsepowerContainer;
import com.sprint.gskills.view.enginepage.EngineOilPressureContainer;
import com.sprint.gskills.view.enginepage.EngineSpeedContainer;
import com.sprint.gskills.view.enginepage.EngineTorqueContainer;
import com.sun.lwuit.Container;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public abstract class EngineView
extends GSkillsView {
    protected EngineGearContainer _gearContainer = null;
    protected EngineOilPressureContainer _oilPressureContainer = null;
    protected EngineTorqueContainer _torqueContainer = null;
    protected EngineHorsepowerContainer _horsepowerContainer = null;
    protected EngineSpeedContainer _speedContainer = null;
    protected Container _maskContainer = null;
    protected EngineHPTorqueUnitContainer _hpTorqueUnitContainer = null;
    private final int ENGINE_IMAGE_W = 520;
    private final int ENGINE_IMAGE_H = 285;

    public EngineView() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(520, 285)));
        this.setPreferredSize(new Dimension(520, 285));
        this._oilPressureContainer = new EngineOilPressureContainer();
        this._oilPressureContainer.setY(5);
        this._torqueContainer = new EngineTorqueContainer();
        this._torqueContainer.setY(5);
        this._horsepowerContainer = new EngineHorsepowerContainer();
        this._horsepowerContainer.setY(5);
        this._speedContainer = new EngineSpeedContainer();
        this._speedContainer.setY(5);
        this._maskContainer = new Container();
        this._maskContainer.setPreferredSize(new Dimension(407, 280));
        this._maskContainer.getStyle().setBackgroundType((byte)5);
        this._maskContainer.getStyle().setBackgroundAlignment((byte)-94);
        this._maskContainer.getStyle().setBgTransparency(0);
        this._maskContainer.getStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage("mask_new.png"));
        this._maskContainer.setY(5);
        this._hpTorqueUnitContainer = new EngineHPTorqueUnitContainer();
        if (TransmissionTypeEnum.AUTO == GSkillsStateManager.getInstance().getTransType()) {
            this._gearContainer = new EngineGearContainer();
            this.layoutGearContainer();
        }
        this.initLayout();
        GSkillsViewBuildFactory.getInstance().addToUnitList(ViewEnum.ENGINE_VIEW);
        GSkillsViewBuildFactory.getInstance().addToLanguageList(ViewEnum.ENGINE_VIEW);
        this.initView();
    }

    protected abstract void layoutGearContainer();

    protected abstract void initLayout();
}

