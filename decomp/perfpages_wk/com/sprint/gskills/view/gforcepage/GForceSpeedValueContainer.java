/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.geom.Dimension
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.model.SpeedSensorModel;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.geom.Dimension;

public class GForceSpeedValueContainer
extends UpdatableContainer {
    private FastNumberLabel _speedValueLabel = new FastNumberLabel("0");
    private CommonLabel _speedUnitLabel = null;
    private String _speedValue;

    public GForceSpeedValueContainer() {
        this._speedValueLabel.setLabelStyle(0xE1E1E1, new Dimension(96, 30), 3);
        this._speedUnitLabel = new CommonLabel();
        this._speedUnitLabel.setLabelStyle(0xFFFFFF, new Dimension(60, 15), 1);
        this._speedUnitLabel.getStyle().setMargin(1, 2);
        this.initView();
    }

    private void initView() {
        this._speedUnitLabel.getStyle().setFont(this._fontFactory.getFontSize14());
        this._speedValueLabel.getStyle().setFont(this._fontFactory.getFontSize35());
        this._speedUnitLabel.getStyle().setMargin(2, 15);
        this.addComponent((Component)this._speedValueLabel);
        this.addComponent((Component)this._speedUnitLabel);
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean valueChanged = false;
        String speedValue = SpeedSensorModel.getInstance().getValueForDigitalDisplay();
        if (!speedValue.equals(this._speedValue)) {
            valueChanged = true;
            this._speedValue = speedValue;
            this._speedValueLabel.setText(this._speedValue);
        }
        return valueChanged;
    }

    public void updateViewOnLanguageChange() {
        this._speedUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_" + this._stateManager.getSpeedUnit().getResKey()));
    }

    public void updateViewOnSpeedUnitChange(boolean forceUpdate) {
        SpeedUnitEnum speedUnit = this._stateManager.getSpeedUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on speed unit change to " + speedUnit.toString()));
        this._speedUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_" + speedUnit.getResKey()));
    }
}

