/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BorderLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.factory.GSkillsAlignmentFactory;
import com.sprint.gskills.model.GForceSensorModel;
import com.sprint.gskills.model.PeakGForceXNegSensorModel;
import com.sprint.gskills.model.PeakGForceXPosSensorModel;
import com.sprint.gskills.model.PeakGForceYNegSensorModel;
import com.sprint.gskills.model.PeakGForceYPosSensorModel;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.gforcepage.CommonGForceValueContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BorderLayout;
import com.sun.lwuit.layouts.Layout;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GForceValuesContainer
extends Container {
    private Logger _logger = Log.createLogger((String)((Object)((Object)this)).getClass().getName());
    private CommonGForceValueContainer _leftGForceValueContainer = null;
    private CommonGForceValueContainer _rightGForceValueContainer = null;
    private CommonGForceValueContainer _topGForceValueContainer = null;
    private CommonGForceValueContainer _bottomGForceValueContainer = null;
    private String _leftGForceValue = "";
    private String _rightGForceValue = "";
    private String _topGForceValue = "";
    private String _bottomGForceValue = "";

    public GForceValuesContainer(Dimension dimension) {
        GSkillsAlignmentFactory alignmentFactory = GSkillsAlignmentFactory.getInstance();
        this.setPreferredSize(dimension);
        this.setLayout((Layout)new BorderLayout());
        this._leftGForceValueContainer = new CommonGForceValueContainer(PeakGForceYNegSensorModel.getInstance());
        this._leftGForceValueContainer.getStyle().setMargin(0, alignmentFactory.getAlignment(26));
        this._rightGForceValueContainer = new CommonGForceValueContainer(PeakGForceYPosSensorModel.getInstance());
        this._rightGForceValueContainer.getStyle().setMargin(3, 5);
        this._rightGForceValueContainer.getStyle().setMargin(0, alignmentFactory.getAlignment(27));
        this._topGForceValueContainer = new CommonGForceValueContainer(PeakGForceXNegSensorModel.getInstance(), true, true);
        this._topGForceValueContainer.getStyle().setMargin(0, alignmentFactory.getAlignment(28));
        this._topGForceValueContainer.getStyle().setMargin(1, 15);
        this._bottomGForceValueContainer = new CommonGForceValueContainer(PeakGForceXPosSensorModel.getInstance(), true, false);
        this._bottomGForceValueContainer.getStyle().setMargin(2, 0);
        this.initView();
    }

    private void initView() {
        this.addComponent("West", (Component)this._leftGForceValueContainer);
        this.addComponent("East", (Component)this._rightGForceValueContainer);
        this.addComponent("North", (Component)this._topGForceValueContainer);
        this.addComponent("South", (Component)this._bottomGForceValueContainer);
    }

    public boolean updateViewOnDataChange() {
        String rightGForce;
        String leftGForce;
        String bottomGForce;
        boolean hasValueChanged = false;
        GForceSensorModel gForceViewModel = GForceSensorModel.getInstance();
        String topGForce = gForceViewModel.getTopGForceValue();
        if (!topGForce.equals(this._topGForceValue)) {
            this._topGForceValue = topGForce;
            this._topGForceValueContainer.setGForceValueLabel(this._topGForceValue);
            this._logger.debug((Object)("Top GForce set to " + this._topGForceValue));
            hasValueChanged = true;
        }
        if (!(bottomGForce = gForceViewModel.getBottomGForceValue()).equals(this._bottomGForceValue)) {
            this._bottomGForceValue = bottomGForce;
            this._bottomGForceValueContainer.setGForceValueLabel(this._bottomGForceValue);
            this._logger.debug((Object)("Bottom GForce set to " + this._bottomGForceValue));
            hasValueChanged = true;
        }
        if (!(leftGForce = gForceViewModel.getLeftGForceValue()).equals(this._leftGForceValue)) {
            this._leftGForceValue = leftGForce;
            this._leftGForceValueContainer.setGForceValueLabel(this._leftGForceValue);
            this._logger.debug((Object)("Left GForce set to " + this._leftGForceValue));
            hasValueChanged = true;
        }
        if (!(rightGForce = gForceViewModel.getRightGForceValue()).equals(this._rightGForceValue)) {
            this._rightGForceValue = rightGForce;
            this._rightGForceValueContainer.setGForceValueLabel(this._rightGForceValue);
            this._logger.debug((Object)("Right GForce set to " + this._rightGForceValue));
            hasValueChanged = true;
        }
        return hasValueChanged;
    }

    public boolean updatePeakGForceValues() {
        boolean hasValueChanged = this._topGForceValueContainer.setPeakGValueLabel();
        hasValueChanged = this._bottomGForceValueContainer.setPeakGValueLabel() || hasValueChanged;
        hasValueChanged = this._leftGForceValueContainer.setPeakGValueLabel() || hasValueChanged;
        hasValueChanged = this._rightGForceValueContainer.setPeakGValueLabel() || hasValueChanged;
        return hasValueChanged;
    }

    public void updateViewOnUnitChange(String gForceUnit) {
        this._leftGForceValueContainer.setUnitText(gForceUnit);
        this._rightGForceValueContainer.setUnitText(gForceUnit);
        this._topGForceValueContainer.setUnitText(gForceUnit);
        this._bottomGForceValueContainer.setUnitText(gForceUnit);
    }

    public void updateViewOnLanguageChanged() {
        String peakTitle = GSkillsResourceManager.getInstance().getLanguageResByKey("gforce_title_peak");
        this._leftGForceValueContainer.setPeakGTitleText(peakTitle);
        this._rightGForceValueContainer.setPeakGTitleText(peakTitle);
        this._topGForceValueContainer.setPeakGTitleText(peakTitle);
        this._bottomGForceValueContainer.setPeakGTitleText(peakTitle);
    }
}

