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
import com.sprint.gskills.model.TorqueSensorModel;
import com.sprint.gskills.unit.TorqueUnitEnum;
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

public class EngineTorqueContainer
extends UpdatableContainer {
    private FastNumberLabel _torqueTitleLabel;
    private FastNumberLabel _torqueValueLabel;
    private FastNumberLabel _torqueUnitLabel;
    private Rotatable _torqueStepInputContainer_1 = null;
    private Rotatable _torqueStepInputContainer_2 = null;
    private CommonLabel _torqueTipLabel = null;
    private Image _rotateImage;

    public EngineTorqueContainer() {
        this.initView();
    }

    protected void initView() {
        this.setPreferredSize(new Dimension(520, 280));
        this.setLayout((Layout)new CoordinateLayout(520, 280));
        this.getStyle().setBackgroundType((byte)5);
        this.getStyle().setBackgroundAlignment((byte)-94);
        this._rotateImage = this._resourceManager.getCommonImage("torque.png");
        this._torqueStepInputContainer_1 = this.getTorqueContainer();
        this._torqueStepInputContainer_2 = this.getTorqueContainer();
        Font f14 = this._fontFactory.getFontSize14();
        int font14Height = f14.getHeight();
        Font f18 = this._fontFactory.getFontSize18();
        int font18Height = f18.getHeight();
        Font f28 = this._fontFactory.getFontSize28();
        int font28Height = f28.getHeight();
        this._torqueTitleLabel = new FastNumberLabel(14792537, 1, f18);
        this._torqueTitleLabel.setPreferredSize(new Dimension(170, font14Height));
        this._torqueTitleLabel.getStyle().setPadding(1, this._alignmentFactory.getAlignment(20));
        this._torqueValueLabel = new FastNumberLabel(14792537, 3, f28);
        this._torqueValueLabel.setPreferredSize(new Dimension(130, font28Height));
        this._torqueUnitLabel = new FastNumberLabel(14792537, 4, f18);
        this._torqueUnitLabel.setPreferredSize(new Dimension(50, font18Height));
        this._torqueUnitLabel.getStyle().setPadding(0, 6);
        Container torqueValueUnitContainer = new Container((Layout)new BoxLayout(1));
        torqueValueUnitContainer.addComponent((Component)this._torqueValueLabel);
        torqueValueUnitContainer.addComponent((Component)this._torqueUnitLabel);
        torqueValueUnitContainer.getStyle().setMargin(0, this._alignmentFactory.getAlignment(25));
        torqueValueUnitContainer.getStyle().setPadding(1, this._alignmentFactory.getAlignment(24));
        torqueValueUnitContainer.setPreferredH(font28Height);
        Container torqueTitleValueUnitContainer = new Container((Layout)new BoxLayout(2));
        torqueTitleValueUnitContainer.addComponent((Component)this._torqueTitleLabel);
        torqueTitleValueUnitContainer.addComponent((Component)torqueValueUnitContainer);
        torqueTitleValueUnitContainer.setX(520 - torqueTitleValueUnitContainer.getPreferredW());
        torqueTitleValueUnitContainer.setY(73);
        this._torqueTipLabel = new CommonLabel();
        Image torqueTip = this._resourceManager.getCommonImage("torque_tip.png");
        this._torqueTipLabel.setPreferredSize(new Dimension(torqueTip.getWidth(), torqueTip.getHeight()));
        this._torqueTipLabel.getStyle().setBgImage(torqueTip);
        this._torqueTipLabel.setVisible(false);
        this._torqueTipLabel.setX(372);
        this._torqueTipLabel.setY(160);
        this.addComponent((Component)this._torqueStepInputContainer_1);
        this.addComponent((Component)this._torqueStepInputContainer_2);
        this.addComponent((Component)this._torqueTipLabel);
        this.addComponent((Component)torqueTitleValueUnitContainer);
    }

    private Rotatable getTorqueContainer() {
        Rotatable torqueContainer = new Rotatable(this._rotateImage, 173, 170);
        torqueContainer.setPreferredSize(new Dimension(342, 288));
        torqueContainer.setX(67);
        torqueContainer.setY(-3);
        torqueContainer.getStyle().setBgTransparency(1);
        return torqueContainer;
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean needRepaint;
        TorqueSensorModel torqueSensorModel = TorqueSensorModel.getInstance();
        boolean bl2 = needRepaint = torqueSensorModel.hasSensorValueChanged() || forceUpdate;
        if (needRepaint) {
            double unifiedVal = torqueSensorModel.getUnifiedValue();
            double angle = 196.07 * unifiedVal - 99.634;
            double angle32 = (double)Math.round(angle / 3.214) * 3.214;
            this._torqueStepInputContainer_1.setAngleDegrees(Math.min(0.0, angle32));
            this._torqueStepInputContainer_2.setAngleDegrees(angle32);
            this._torqueValueLabel.setText(TorqueSensorModel.getInstance().getValueForDigitalDisplay(true));
            if (unifiedVal < 1.0) {
                this._torqueTipLabel.setVisible(false);
            } else {
                this._torqueTipLabel.setVisible(true);
            }
        }
        return needRepaint;
    }

    public void updateViewOnTorqueUnitChange() {
        TorqueUnitEnum torqueUnitEnum = this._stateManager.getTorqueUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on torque unit change to " + torqueUnitEnum.toString()));
        String torqueUnit = TorqueUnitEnum.FT_LB == torqueUnitEnum ? "US" : "M";
        this._torqueUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_" + torqueUnit + "_Torque"));
    }

    public void updateViewOnLanguageChange() {
        this._torqueTitleLabel.setText(this._resourceManager.getLanguageResByKey("engine_title_Torque"));
    }
}

