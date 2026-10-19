/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.model.GearSensorModel;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;

public class EngineGearContainer
extends UpdatableContainer {
    private FastNumberLabel _valueLabel;
    private FastNumberLabel _titleLabel;

    public EngineGearContainer() {
        if (this._stateManager.isLSeriesVehicle()) {
            this.initLSeriesGearContainer();
        } else {
            this.initJeepViperGearContainer();
        }
    }

    private void initLSeriesGearContainer() {
        Image gearBgImage = this._resourceManager.getCommonImage("automatic-gear-label-bg.png");
        this.setPreferredSize(new Dimension(gearBgImage.getWidth(), gearBgImage.getHeight()));
        this.setLayout((Layout)new BoxLayout(2));
        this.getStyle().setBgTransparency(0);
        this.getStyle().setBgImage(gearBgImage);
        this._titleLabel = new FastNumberLabel();
        this._titleLabel.setLabelStyle(0xFFFFFF, new Dimension(200, 25), 3);
        this._titleLabel.getStyle().setFont(this._fontFactory.getFontSize18());
        this._titleLabel.getStyle().setPadding(3, 10);
        this._valueLabel = new FastNumberLabel();
        this._valueLabel.getStyle().setFont(this._fontFactory.getFontSize46());
        this._valueLabel.getStyle().setPadding(3, 10);
        this._valueLabel.setLabelStyle(0xFFFFFF, new Dimension(200, 40), 3);
        this.addComponent((Component)this._titleLabel);
        this.addComponent((Component)this._valueLabel);
    }

    private void initJeepViperGearContainer() {
        this.setPreferredSize(new Dimension(80, 70));
        this.setLayout((Layout)new BoxLayout(2));
        this.getStyle().setBgTransparency(0);
        this._titleLabel = new FastNumberLabel();
        this._titleLabel.setLabelStyle(0xFFFFFF, new Dimension(0, 20), 4);
        this._titleLabel.getStyle().setFont(this._fontFactory.getFontSize14());
        this._valueLabel = new FastNumberLabel();
        this._valueLabel.setLabelStyle(0xFFFFFF, new Dimension(80, 50), 4);
        this._valueLabel.getStyle().setFont(this._fontFactory.getFontSize42());
        this.addComponent((Component)this._valueLabel);
        this.addComponent((Component)this._titleLabel);
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean valueChanged;
        GearSensorModel engineGearModel = GearSensorModel.getInstance();
        boolean bl2 = valueChanged = engineGearModel.hasSensorValueChanged() || forceUpdate;
        if (valueChanged) {
            this._valueLabel.setText(((CommonSensorModel)engineGearModel).getValueForDigitalDisplay());
        }
        return valueChanged;
    }

    public void updateViewOnLanguageChange() {
        this._titleLabel.setText(this._resourceManager.getLanguageResByKey("engine_title_gear"));
    }
}

