/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.model.SpeedSensorModel;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

class EngineSpeedContainer
extends UpdatableContainer {
    private Logger _logger = Log.createLogger((String)((Object)((Object)this)).getClass().getName());
    private FastNumberLabel _speedValueLabel = null;
    private FastNumberLabel _speedUnitLabel = null;
    private String _speedValueString;

    public EngineSpeedContainer() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(520, 280)));
        this.setPreferredSize(new Dimension(520, 280));
        Font f14 = this._fontFactory.getFontSize14();
        int font14Height = f14.getHeight();
        Font f18 = this._fontFactory.getFontSize18();
        Font f46 = this._fontFactory.getFontSize46();
        int font46Height = f46.getHeight();
        int speedLabelWidth = f46.stringWidth("000") + 2;
        this._speedValueLabel = new FastNumberLabel();
        this._speedValueLabel.setLabelStyle(0xFFFFFF, new Dimension(speedLabelWidth + 10, font46Height + 7), 3);
        this._speedValueLabel.getStyle().setFont(f46);
        this._speedUnitLabel = new FastNumberLabel();
        this._speedUnitLabel.setLabelStyle(0xFFFFFF, new Dimension(speedLabelWidth - 12, font14Height - 9), 1);
        this._speedUnitLabel.getStyle().setFont(f18);
        this._speedUnitLabel.getStyle().setPadding(2, 30);
        Container speedValueUnitContainer = new Container((Layout)new BoxLayout(1));
        speedValueUnitContainer.addComponent((Component)this._speedValueLabel);
        speedValueUnitContainer.addComponent((Component)this._speedUnitLabel);
        this.addComponent((Component)speedValueUnitContainer);
    }

    public void updateViewOnLanguageChange() {
        this._speedUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_" + this._stateManager.getSpeedUnit().getResKey()));
    }

    public void updateViewOnSpeedUnitChange() {
        SpeedUnitEnum speedUnit = this._stateManager.getSpeedUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on speed unit change to " + speedUnit.toString()));
        this._speedUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_" + speedUnit.getResKey()));
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean valueChanged = false;
        String speed = SpeedSensorModel.getInstance().getValueForDigitalDisplay();
        if (!speed.equals(this._speedValueString)) {
            this._speedValueLabel.setText(speed);
            this._speedValueString = speed;
            valueChanged = true;
        }
        return valueChanged;
    }
}

