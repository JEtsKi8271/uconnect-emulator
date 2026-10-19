/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Display
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.factory.GSkillsIndicatorValueRangeFactory;
import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.view.gaugespage.DashboardViewContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Display;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GaugesTwoViewForJeep
extends Container
implements GSkillsViewDataListener {
    private Logger logger = LoggerFactory.getLogger(GaugesTwoViewForJeep.class);
    private DashboardViewContainer coolantTempView = null;
    private DashboardViewContainer intakeAirTempView = null;
    private DashboardViewContainer transTempView = null;
    private double MAX_COOLANTTEMP = 0.0;
    private double MIN_COOLANTTEMP = 0.0;
    private double MAX_INTAKEAIR = 0.0;
    private double MIN_INTAKEAIR = 0.0;
    private double MAX_TRANSTEMP = 0.0;
    private double MIN_TRANSTEMP = 0.0;
    private String engineCoolantTempValue;
    private int engineCoolantTempImageNumber = 1;
    private String intakeAirTempValue;
    private int intakeAirTempImageNumber = 1;
    private String transTempValue;
    private int transTempImageNumber = 1;
    private boolean hasContainerChanged;
    private String tempUnit = null;
    private CommonViewResourceManager resourceManager = CommonViewResourceManager.getInstance();
    private CommonSensorModel dataModel = GSkillsDataModelFactory.getSensorDataModel();
    private final int containerH = 271;
    private final int containerW = 530;
    private final int margin = 10;

    public GaugesTwoViewForJeep() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(530, 271)));
        this.setPreferredSize(new Dimension(530, 271));
        this.getStyle().setMargin(0, 2);
        this.coolantTempView = new DashboardViewContainer(1, false);
        this.coolantTempView.setX(10);
        this.coolantTempView.setY(10);
        this.intakeAirTempView = new DashboardViewContainer(1, false);
        int componentW = this.intakeAirTempView.getPreferredW();
        this.intakeAirTempView.setX(530 - componentW - 10);
        this.intakeAirTempView.setY(10);
        this.transTempView = new DashboardViewContainer(1, false);
        int componentH = this.transTempView.getPreferredH();
        this.transTempView.setX(265 - componentW / 2);
        this.transTempView.setY(271 - componentH - 10);
        this.initView();
    }

    public void initView() {
        this.addComponent((Component)this.coolantTempView);
        this.addComponent((Component)this.intakeAirTempView);
        this.addComponent((Component)this.transTempView);
        this.updateViewOnUnitChanged();
    }

    public void updateViewOnLanguageChanged() {
        String current_unit = GSkillsStateManager.getInstance().getCurrentUnit() == 0 ? "US" : "M";
        this.tempUnit = this.resourceManager.getLanguageResByKey("unit_" + current_unit + "_Temp");
        this.coolantTempView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_coolantTemp") + " " + this.tempUnit);
        this.intakeAirTempView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_intakeAirTemp") + " " + this.tempUnit);
        this.transTempView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_transTemp") + " " + this.tempUnit);
    }

    public void updateViewOnUnitChanged() {
        this.MAX_COOLANTTEMP = GSkillsIndicatorValueRangeFactory.getMaxCoolantTemp();
        this.MIN_COOLANTTEMP = GSkillsIndicatorValueRangeFactory.getMinCoolantTemp();
        this.MAX_INTAKEAIR = GSkillsIndicatorValueRangeFactory.getMaxIntakeAirTemp();
        this.MIN_INTAKEAIR = GSkillsIndicatorValueRangeFactory.getMinIntakeAirTemp();
        this.MAX_TRANSTEMP = GSkillsIndicatorValueRangeFactory.getMaxTransTemp();
        this.MIN_TRANSTEMP = GSkillsIndicatorValueRangeFactory.getMinTransTemp();
        this.intakeAirTempView.setRangeValue(this.MIN_INTAKEAIR, this.MAX_INTAKEAIR);
        this.coolantTempView.setRangeValue(this.MIN_COOLANTTEMP, this.MAX_COOLANTTEMP);
        this.transTempView.setRangeValue(this.MIN_TRANSTEMP, this.MAX_TRANSTEMP);
        this.updateViewOnLanguageChanged();
    }

    public void updateViewOnDataChanged() {
        if (this.dataModel.hasEngineCoolantTempChanged()) {
            this.engineCoolantTempValue = this.dataModel.getEngineCoolantTemp();
            this.engineCoolantTempImageNumber = this.dataModel.getEngineCoolantTempImageNumber();
            this.hasContainerChanged = true;
        }
        if (this.dataModel.hasIntakeAirTempChanged()) {
            this.intakeAirTempValue = this.dataModel.getIntakeAirTemp();
            this.intakeAirTempImageNumber = this.dataModel.getIntakeAirTempImageNumber();
            this.hasContainerChanged = true;
        }
        if (this.dataModel.hasTransTempChanged()) {
            this.transTempValue = this.dataModel.getTransTemp();
            this.transTempImageNumber = this.dataModel.getTransTempImageNumber();
            this.hasContainerChanged = true;
        }
        if (this.hasContainerChanged) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    try {
                        GaugesTwoViewForJeep.this.coolantTempView.setGaugesValue(GaugesTwoViewForJeep.this.engineCoolantTempValue, GaugesTwoViewForJeep.this.engineCoolantTempImageNumber);
                        GaugesTwoViewForJeep.this.intakeAirTempView.setGaugesValue(GaugesTwoViewForJeep.this.intakeAirTempValue, GaugesTwoViewForJeep.this.intakeAirTempImageNumber);
                        GaugesTwoViewForJeep.this.transTempView.setGaugesValue(GaugesTwoViewForJeep.this.transTempValue, GaugesTwoViewForJeep.this.transTempImageNumber);
                    }
                    catch (Throwable ex) {
                        GaugesTwoViewForJeep.this.logger.error((Object)"", ex);
                    }
                }
            });
            this.hasContainerChanged = false;
        }
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        this.logger.error((Object)"Not implement");
    }

    public void notifyStatus(int remoteError) {
        this.logger.error((Object)"Not implement");
    }
}

