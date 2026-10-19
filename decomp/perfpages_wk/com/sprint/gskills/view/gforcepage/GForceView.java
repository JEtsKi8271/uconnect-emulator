/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsView;
import com.sprint.gskills.view.gforcepage.GForceContainer;
import com.sprint.gskills.view.gforcepage.GForceSpeedValueContainer;
import com.sprint.gskills.view.gforcepage.GForceSteeringAngleValueContainer;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public class GForceView
extends GSkillsView {
    private GForceSpeedValueContainer _speedValuesContainer = null;
    private GForceSteeringAngleValueContainer _steeringValuesContainer = null;
    private GForceContainer _gForceContainer = null;
    private final int CONTAINER_W = 528;
    private final int CONTAINER_H = 285;
    private static final GForceView INSTANCE = new GForceView();

    public static GForceView getInstance() {
        return INSTANCE;
    }

    private GForceView() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(528, 285)));
        this.setPreferredSize(new Dimension(528, 285));
        this.getStyle().setBackgroundAlignment((byte)-95);
        this.getStyle().setBgTransparency(0);
        Image bgImage = GSkillsResourceManager.getInstance().getCommonImage("gforce-background-black.png");
        this.getStyle().setBgImage(bgImage);
        this._speedValuesContainer = new GForceSpeedValueContainer();
        this._speedValuesContainer.setLayout((Layout)new BoxLayout(1));
        this._speedValuesContainer.setPreferredSize(new Dimension(180, 34));
        this._speedValuesContainer.setX(380);
        this._speedValuesContainer.setY(30);
        this._steeringValuesContainer = new GForceSteeringAngleValueContainer();
        this._steeringValuesContainer.setLayout((Layout)new BoxLayout(1));
        this._steeringValuesContainer.setPreferredSize(new Dimension(185, 43));
        this._steeringValuesContainer.setX(386);
        this._steeringValuesContainer.setY(69);
        this._gForceContainer = new GForceContainer(new Dimension(528, 285));
        this.initContainer(this._gForceContainer);
        this.initContainer(this._speedValuesContainer);
        this.initContainer(this._steeringValuesContainer);
        GSkillsViewBuildFactory.getInstance().addToUnitList(ViewEnum.GFORCE_VIEW);
        GSkillsViewBuildFactory.getInstance().addToLanguageList(ViewEnum.GFORCE_VIEW);
        this.initView();
    }
}

