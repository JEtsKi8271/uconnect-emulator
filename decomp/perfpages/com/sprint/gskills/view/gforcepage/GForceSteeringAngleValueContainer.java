/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.TextArea
 *  com.sun.lwuit.geom.Dimension
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.model.SteeringAngleSensorModel;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.TextArea;
import com.sun.lwuit.geom.Dimension;

public class GForceSteeringAngleValueContainer
extends UpdatableContainer {
    private FastNumberLabel _steeringValueLabel = new FastNumberLabel("--");
    private TextArea _steeringUnitLabel = null;
    private TextArea _steeringAngleTextArea = null;

    public GForceSteeringAngleValueContainer() {
        this._steeringValueLabel.setLabelStyle(0xE1E1E1, new Dimension(70, 40), 3);
        this._steeringUnitLabel = new TextArea();
        this._steeringUnitLabel.getStyle().setFgColor(0xFFFFFF);
        this._steeringUnitLabel.setAlignment(1);
        this._steeringUnitLabel.setEditable(false);
        this._steeringUnitLabel.setFocusable(false);
        this._steeringUnitLabel.getStyle().setBorder(null);
        this._steeringUnitLabel.getStyle().setBgTransparency(0);
        this._steeringUnitLabel.getStyle().setPadding(0, 0, 0, 0);
        this._steeringUnitLabel.setPreferredSize(new Dimension(10, 40));
        this._steeringAngleTextArea = new TextArea();
        this._steeringAngleTextArea.getStyle().setFgColor(0xFFFFFF);
        this._steeringAngleTextArea.setAlignment(1);
        this._steeringAngleTextArea.setEditable(false);
        this._steeringAngleTextArea.setFocusable(false);
        this._steeringAngleTextArea.getStyle().setBorder(null);
        this._steeringAngleTextArea.getStyle().setBgTransparency(0);
        this._steeringAngleTextArea.getStyle().setPadding(0, 0, 0, 0);
        this._steeringAngleTextArea.setPreferredSize(new Dimension(105, 40));
        this.initView();
    }

    private void initView() {
        GSkillsFontsStyleFactory fontFactory = GSkillsFontsStyleFactory.getInstance();
        this._steeringValueLabel.getStyle().setFont(fontFactory.getFontSize22());
        this._steeringValueLabel.getStyle().setMargin(2, 5);
        this._steeringUnitLabel.getStyle().setFont(fontFactory.getFontSize11());
        this._steeringUnitLabel.getStyle().setMargin(0, 7);
        this._steeringAngleTextArea.getStyle().setFont(fontFactory.getFontSize11());
        this._steeringAngleTextArea.getStyle().setMargin(0, 7);
        this.addComponent((Component)this._steeringValueLabel);
        this.addComponent((Component)this._steeringUnitLabel);
        this.addComponent((Component)this._steeringAngleTextArea);
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        SteeringAngleSensorModel steeringSensorModel = SteeringAngleSensorModel.getInstance();
        boolean steeringAngleChanged = steeringSensorModel.hasSensorValueChanged();
        if (steeringAngleChanged) {
            this._steeringValueLabel.setText(steeringSensorModel.getValueForDigitalDisplay());
        }
        return steeringAngleChanged;
    }

    public void updateViewOnLanguageChange() {
        this._steeringAngleTextArea.setText(this.replaceRegaExp(GSkillsResourceManager.getInstance().getLanguageResByKey("Gforce_SteeringAngel"), "\n"));
        this._steeringUnitLabel.setText(GSkillsResourceManager.getInstance().getLanguageResByKey("Gforce_SteeringUnit"));
    }

    private String replaceRegaExp(String languageResByKey, String replacementSubString) {
        if (languageResByKey.indexOf("[]") == -1) {
            return languageResByKey;
        }
        String temString = languageResByKey.substring(0, languageResByKey.lastIndexOf("[]")) + replacementSubString + languageResByKey.substring(languageResByKey.lastIndexOf("[]") + 2, languageResByKey.length());
        return this.replaceRegaExp(temString, replacementSubString);
    }
}

