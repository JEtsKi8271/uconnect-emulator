/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.enginepage;

import car.jamaica.widgets.gskills.Rotatable;
import com.sprint.gskills.model.HorsePowerSensorModel;
import com.sprint.gskills.unit.PowerUnitEnum;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public class EngineHorsepowerContainer
extends UpdatableContainer {
    private FastNumberLabel _horsePowerTitleLabel;
    private FastNumberLabel _horsePowerValueLabel;
    private FastNumberLabel _horsePowerUnitLabel;
    private Rotatable _horsepowerInputContainer_1 = null;
    private Rotatable _horsepowerInputContainer_2 = null;
    private CommonLabel _hpTipLabel = null;
    private Image _rotateImage = null;

    public EngineHorsepowerContainer() {
        this.getStyle().setBgTransparency(0);
        this.initView();
    }

    protected void initView() {
        this.setPreferredSize(new Dimension(520, 280));
        this.setLayout((Layout)new CoordinateLayout(520, 280));
        this.getStyle().setBackgroundType((byte)5);
        this.getStyle().setBackgroundAlignment((byte)-94);
        this._rotateImage = this._resourceManager.getCommonImage("hp.png");
        this._horsepowerInputContainer_1 = this.getHPContainer();
        this._horsepowerInputContainer_2 = this.getHPContainer();
        Font f18 = this._fontFactory.getFontSize18();
        int font18Height = f18.getHeight();
        Font f46 = this._fontFactory.getFontSize46();
        int font46Height = f46.getHeight();
        this._horsePowerTitleLabel = new FastNumberLabel(0xFF0000, 1, f18);
        this._horsePowerTitleLabel.setPreferredSize(new Dimension(130, font18Height + 3));
        this._horsePowerTitleLabel.getStyle().setPadding(0, this._alignmentFactory.getAlignment(14));
        this._horsePowerTitleLabel.getStyle().setPadding(1, 10);
        this._horsePowerTitleLabel.getStyle().setBgColor(65535);
        this._horsePowerValueLabel = new FastNumberLabel(0xFF0000, 3, f46);
        this._horsePowerValueLabel.setPreferredW(this._alignmentFactory.getAlignment(15));
        this._horsePowerValueLabel.setPreferredH(font46Height + this._alignmentFactory.getAlignment(16));
        this._horsePowerValueLabel.getStyle().setPadding(2, this._alignmentFactory.getAlignment(17));
        this._horsePowerUnitLabel = new FastNumberLabel(0xFF0000, 3, f18);
        this._horsePowerUnitLabel.setPreferredSize(new Dimension(43, font18Height + 3));
        this._horsePowerUnitLabel.getStyle().setPadding(3, 8);
        this._horsePowerUnitLabel.getStyle().setPadding(0, this._alignmentFactory.getAlignment(18));
        Container hpValueUnitContainer = new Container((Layout)new BoxLayout(1));
        hpValueUnitContainer.addComponent((Component)this._horsePowerValueLabel);
        hpValueUnitContainer.addComponent((Component)this._horsePowerUnitLabel);
        hpValueUnitContainer.getStyle().setPadding(0, this._alignmentFactory.getAlignment(22));
        hpValueUnitContainer.getStyle().setPadding(1, this._alignmentFactory.getAlignment(21));
        hpValueUnitContainer.setPreferredH(font46Height - this._alignmentFactory.getAlignment(23));
        Container hpTitleValueUnitContainer = new Container((Layout)new BoxLayout(2));
        hpTitleValueUnitContainer.addComponent((Component)this._horsePowerTitleLabel);
        hpTitleValueUnitContainer.addComponent((Component)hpValueUnitContainer);
        hpTitleValueUnitContainer.setX(520 - hpTitleValueUnitContainer.getPreferredW());
        this._hpTipLabel = new CommonLabel();
        Image hpTip = this._resourceManager.getCommonImage("hp_tip.png");
        this._hpTipLabel.setPreferredSize(new Dimension(hpTip.getWidth(), hpTip.getHeight()));
        this._hpTipLabel.getStyle().setBgImage(hpTip);
        this._hpTipLabel.setVisible(false);
        this._hpTipLabel.setX(390);
        this._hpTipLabel.setY(160);
        this.addComponent((Component)this._horsepowerInputContainer_1);
        this.addComponent((Component)this._horsepowerInputContainer_2);
        this.addComponent((Component)this._hpTipLabel);
        this.addComponent((Component)hpTitleValueUnitContainer);
    }

    private Rotatable getHPContainer() {
        Rotatable hpContainer = new Rotatable(this._rotateImage, 173, 170);
        hpContainer.setPreferredSize(new Dimension(342, 288));
        hpContainer.setX(67);
        hpContainer.setY(-3);
        hpContainer.getStyle().setBgTransparency(1);
        return hpContainer;
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean needRepaint;
        HorsePowerSensorModel horsepowerViewModel = HorsePowerSensorModel.getInstance();
        boolean bl2 = needRepaint = horsepowerViewModel.hasSensorValueChanged() || forceUpdate;
        if (needRepaint) {
            double unifiedVal = horsepowerViewModel.getUnifiedValue();
            double angle = 189.626 * unifiedVal - 99.634;
            double angle32 = (double)Math.round(angle / 3.214) * 3.214;
            this._horsepowerInputContainer_1.setAngleDegrees(Math.min(0.0, angle32));
            this._horsepowerInputContainer_2.setAngleDegrees(angle32);
            this._horsePowerValueLabel.setText(HorsePowerSensorModel.getInstance().getValueForDigitalDisplay(true));
            if (unifiedVal < 1.0) {
                this._hpTipLabel.setVisible(false);
            } else {
                this._hpTipLabel.setVisible(true);
            }
        }
        return needRepaint;
    }

    public void updateViewOnPowerUnitChange() {
        PowerUnitEnum powerUnit = this._stateManager.getPowerUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on power unit change to " + powerUnit.toString()));
        String horsepowerUnit = PowerUnitEnum.KW == powerUnit ? "M" : "US";
        this._horsePowerUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_" + horsepowerUnit + "_Horsepower"));
    }

    public void updateViewOnLanguageChange() {
        this._horsePowerTitleLabel.setText(this._resourceManager.getLanguageResByKey("engine_title_horsepower"));
    }
}

