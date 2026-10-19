/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.model.GForceSensorModel;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sprint.gskills.view.gforcepage.GForceBackYContainer;
import com.sprint.gskills.view.gforcepage.GForceCarMoveContainer;
import com.sprint.gskills.view.gforcepage.GForceValuesContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public class GForceContainer
extends UpdatableContainer {
    private GForceBackYContainer _backGroundXImageContainer = null;
    private GForceBackYContainer _backGroundYImageContainer = null;
    private GForceValuesContainer _gForceValuesContainer = null;
    private GForceCarMoveContainer _carViewContainer = null;

    public GForceContainer(Dimension dim) {
        this.setLayout((Layout)new CoordinateLayout(dim));
        this._backGroundXImageContainer = new GForceBackYContainer();
        this._backGroundXImageContainer.setX(45);
        this._backGroundXImageContainer.setY(21);
        this._backGroundYImageContainer = new GForceBackYContainer();
        this._backGroundYImageContainer.setX(45);
        this._backGroundYImageContainer.setY(21);
        this._carViewContainer = new GForceCarMoveContainer();
        this._carViewContainer.setPreferredSize(new Dimension(293, 238));
        this._carViewContainer.getStyle().setBgTransparency(0);
        this._gForceValuesContainer = new GForceValuesContainer(dim);
        this.initView();
    }

    private void initView() {
        this._carViewContainer.setX(120);
        this._carViewContainer.setY(30);
        this._backGroundXImageContainer.initView();
        this._backGroundYImageContainer.initView();
        this.addComponent((Component)this._backGroundXImageContainer);
        this.addComponent((Component)this._backGroundYImageContainer);
        this.addComponent((Component)this._carViewContainer);
        this.addComponent((Component)this._gForceValuesContainer);
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean hasViewChanged = false;
        GForceSensorModel gForceSensorModel = GForceSensorModel.getInstance();
        if (gForceSensorModel.hasSensorValueChanged()) {
            hasViewChanged = this._gForceValuesContainer.updateViewOnDataChange() || hasViewChanged;
            hasViewChanged = this._backGroundYImageContainer.updateViewOnDataChanged(gForceSensorModel.getGForceFrontRearImageName()) || hasViewChanged;
            hasViewChanged = this._backGroundXImageContainer.updateViewOnDataChanged(gForceSensorModel.getGForceLeftRightImageNumber()) || hasViewChanged;
            hasViewChanged = this._carViewContainer.updateViewOnDataChanged(gForceSensorModel.getGForceLeftRightImageNumber()) || hasViewChanged;
        }
        return this._gForceValuesContainer.updatePeakGForceValues() || hasViewChanged;
    }

    public void updateViewOnLanguageChange() {
        this._gForceValuesContainer.updateViewOnLanguageChanged();
    }

    public void updateViewOnUnitChange() {
        String gForceUnit = this._resourceManager.getLanguageResByKey("unit_US_Gforce");
        this._gForceValuesContainer.updateViewOnUnitChange(gForceUnit);
    }
}

