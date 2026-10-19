/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.model.PeakGForceSensorModel;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;

class CommonGForceValueContainer
extends Container {
    private FastNumberLabel _valueLabel = null;
    private CommonLabel _unitLabel = null;
    private FastNumberLabel _peakGValueLabel = null;
    private Font _fontSize14;
    private Font _peakLabelFont;
    private Font _labelFont;
    private boolean _isPeakDisplayedOnSameLine;
    private boolean _isTopGforceContainer;
    private String _unitString = null;
    private String _peakGForceValue = "--";
    private CommonLabel _peakTitleLabel = null;
    private String _peakTitle;
    private GSkillsResourceManager _resourceManager = GSkillsResourceManager.getInstance();
    private PeakGForceSensorModel _peakGModel = null;

    public CommonGForceValueContainer(PeakGForceSensorModel peakGModel, boolean isPeakDisplayedOnSameLine, boolean isTopGforceContainer) {
        this._isPeakDisplayedOnSameLine = isPeakDisplayedOnSameLine;
        this._isTopGforceContainer = isTopGforceContainer;
        this._peakGModel = peakGModel;
        this._labelFont = this._isTopGforceContainer ? GSkillsFontsStyleFactory.getInstance().getFontSize28() : GSkillsFontsStyleFactory.getInstance().getFontSize35();
        this.setContainerLayout();
    }

    public CommonGForceValueContainer(PeakGForceSensorModel peakGModel) {
        this(peakGModel, false, false);
    }

    private void setContainerLayout() {
        this.getStyle().setMargin(2, 5);
        Container gforceValueContainer = new Container();
        gforceValueContainer.setLayout((Layout)new BoxLayout(1));
        int labelWidth = this._labelFont.stringWidth("0.00");
        int labelHeight = this._labelFont.getHeight();
        this._valueLabel = new FastNumberLabel(0x4A4A4A, 3, this._labelFont);
        this._valueLabel.setPreferredSize(new Dimension(labelWidth + 5, labelHeight));
        this.setGForceValueLabel("--");
        this._fontSize14 = GSkillsFontsStyleFactory.getInstance().getFontSize14();
        this._peakLabelFont = GSkillsFontsStyleFactory.getInstance().getFont(7);
        this._unitLabel = new CommonLabel(0x4A4A4A, 1, this._fontSize14);
        this._unitLabel.setPreferredSize(new Dimension(this._fontSize14.stringWidth("g"), this._fontSize14.getHeight()));
        this._unitLabel.getStyle().setMargin(1, 2);
        this._unitLabel.getStyle().setMargin(0, 8);
        gforceValueContainer.addComponent((Component)this._valueLabel);
        gforceValueContainer.addComponent((Component)this._unitLabel);
        this._peakTitleLabel = new CommonLabel(0xE10000, 3, this._peakLabelFont);
        this._peakTitleLabel.getStyle().setMargin(1, 2);
        this._peakTitleLabel.setPreferredSize(new Dimension(labelWidth, this._peakLabelFont.getHeight()));
        this._peakGValueLabel = new FastNumberLabel(0xE10000, 3, this._peakLabelFont);
        this._peakGValueLabel.getStyle().setMargin(1, 2);
        this.setPeakGValueLabel("--");
        VehicleTrimEnum vehicleTrim = GSkillsStateManager.getInstance().getVehicleTrim();
        if (this._isPeakDisplayedOnSameLine) {
            this.setLayout((Layout)new BoxLayout(1));
            Container peakGforceContainer = new Container();
            if (this._isTopGforceContainer) {
                this._peakGValueLabel.setPreferredSize(new Dimension(190, this._fontSize14.getHeight()));
                this._peakGValueLabel.getStyle().setPadding(3, 10);
                this.setPeakGTitleText(this._resourceManager.getLanguageResByKey("gforce_title_peak"));
                peakGforceContainer.setPreferredSize(new Dimension(190, this._fontSize14.getHeight()));
                peakGforceContainer.getStyle().setPadding(0, 10);
                if (VehicleTrimEnum.RT == vehicleTrim) {
                    this._valueLabel.setPreferredSize(new Dimension(labelWidth + 15, labelHeight - 25));
                    this._peakTitleLabel.setPreferredSize(new Dimension(labelWidth, this._peakLabelFont.getHeight()));
                    peakGforceContainer.getStyle().setPadding(0, 7);
                }
            } else {
                this._peakGValueLabel.setAlignment(4);
                this._peakGValueLabel.setPreferredSize(new Dimension(200, this._fontSize14.getHeight()));
                this.setPeakGTitleText(this._resourceManager.getLanguageResByKey("gforce_title_peak"));
                peakGforceContainer.setPreferredSize(new Dimension(200, this._fontSize14.getHeight()));
                if (VehicleTrimEnum.RT == vehicleTrim) {
                    this._valueLabel.setPreferredSize(new Dimension(labelWidth + 15, labelHeight - 20));
                    this._peakTitleLabel.setPreferredSize(new Dimension(labelWidth, this._peakLabelFont.getHeight()));
                    peakGforceContainer.getStyle().setPadding(0, gforceValueContainer.getPreferredH() - this._peakGValueLabel.getPreferredH() + 12);
                    gforceValueContainer.getStyle().setPadding(0, 13);
                } else {
                    peakGforceContainer.getStyle().setPadding(0, gforceValueContainer.getPreferredH() - this._peakGValueLabel.getPreferredH() + 10);
                    gforceValueContainer.getStyle().setPadding(0, 16);
                }
            }
            peakGforceContainer.addComponent((Component)this._peakGValueLabel);
            this.addComponent((Component)peakGforceContainer);
            this.addComponent((Component)gforceValueContainer);
        } else {
            if (VehicleTrimEnum.RT == vehicleTrim) {
                this._valueLabel.setPreferredSize(new Dimension(labelWidth + 5, labelHeight - 20));
                this._peakTitleLabel.setPreferredSize(new Dimension(labelWidth, this._peakLabelFont.getHeight() - 5));
            }
            this.setLayout((Layout)new BoxLayout(2));
            this.addComponent((Component)gforceValueContainer);
            this._peakTitleLabel.getStyle().setMargin(3, 10);
            this.addComponent((Component)this._peakTitleLabel);
            this._peakGValueLabel.getStyle().setMargin(3, 10);
            this._peakGValueLabel.setPreferredSize(new Dimension(labelWidth - 10, this._fontSize14.getHeight()));
            this.setPeakGTitleText(this._resourceManager.getLanguageResByKey("gforce_title_peak"));
            this.addComponent((Component)this._peakGValueLabel);
        }
    }

    protected void setUnitText(String str) {
        this._unitLabel.setText(str);
        if (this._peakGValueLabel != null) {
            this._unitString = str;
            this.setPeakGValueLabel(this._peakGForceValue);
        }
    }

    protected void setGForceValueLabel(String value) {
        if (value.equals("0.00") || value.equals("--")) {
            if (0x4A4A4A != this._valueLabel.getStyle().getFgColor()) {
                this._valueLabel.getStyle().setFgColor(0x4A4A4A);
            }
        } else if (0xE1E1E1 != this._valueLabel.getStyle().getFgColor()) {
            this._valueLabel.getStyle().setFgColor(0xE1E1E1);
        }
        this._valueLabel.setText(value);
    }

    protected boolean setPeakGValueLabel() {
        boolean hasValueChanged = this._peakGModel.hasSensorValueChanged();
        if (hasValueChanged) {
            this._peakGForceValue = this._peakGModel.getValueForDigitalDisplay();
            this.setPeakGValueLabel(this._peakGForceValue);
        }
        return hasValueChanged;
    }

    protected void setPeakGValueLabel(String peakGValue) {
        if (this._isPeakDisplayedOnSameLine) {
            this._peakGValueLabel.setText(" " + this._peakTitle + " " + peakGValue + this._unitString);
        } else {
            this._peakGValueLabel.setText(peakGValue + this._unitString);
        }
    }

    public void setPeakGTitleText(String peakTitle) {
        this._peakTitle = peakTitle;
        if (this._isPeakDisplayedOnSameLine) {
            this._peakGValueLabel.setText(" " + this._peakTitle + " " + this._peakGForceValue + this._unitString);
        } else {
            this._peakTitleLabel.setText(peakTitle);
        }
    }
}

