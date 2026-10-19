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

public class GaugesTwoViewForViper
extends Container
implements GSkillsViewDataListener {
    private Logger logger = LoggerFactory.getLogger(GaugesTwoViewForViper.class);
    private DashboardViewContainer oilTempView = null;
    private DashboardViewContainer batteryVoltageView = null;
    private DashboardViewContainer oilPressureView = null;
    private DashboardViewContainer coolantTempView = null;
    private DashboardViewContainer intakeAirTempView = null;
    private double MAX_OILTEMP = 0.0;
    private double MIN_OILTEMP = 0.0;
    private double MAX_BATTERY = 0.0;
    private double MIN_BATTERY = 0.0;
    private double MAX_OILPRESSURE = 0.0;
    private double MIN_OILPRESSURE = 0.0;
    private double MAX_COOLANTTEMP = 0.0;
    private double MIN_COOLANTTEMP = 0.0;
    private double MAX_INTAKEAIR = 0.0;
    private double MIN_INTAKEAIR = 0.0;
    private String oilTempValue;
    private int oilTempImageNumber = 1;
    private String engineCoolantTempValue;
    private int engineCoolantTempImageNumber = 1;
    private String oilPressureValue;
    private int oilPressureImageNumber = 1;
    private String batteryVoltageValue;
    private int batteryVoltageImageNumber = 1;
    private String intakeAirTempValue;
    private int intakeAirTempImageNumber = 1;
    private boolean hasContainerChanged;
    private String tempUnit = null;
    private CommonViewResourceManager resourceManager = CommonViewResourceManager.getInstance();
    private CommonSensorModel dataModel = GSkillsDataModelFactory.getSensorDataModel();
    private final int containerH = 271;
    private final int containerW = 530;
    private final int margin = 4;
    private final int componentW = 188;

    public GaugesTwoViewForViper() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(530, 271)));
        this.setPreferredSize(new Dimension(530, 271));
        this.getStyle().setMargin(0, 2);
        this.oilTempView = new DashboardViewContainer(2, false);
        this.oilTempView.setX(4);
        this.oilTempView.setY(4);
        this.coolantTempView = new DashboardViewContainer(2, false);
        int coolantTempViewH = this.coolantTempView.getPreferredH();
        this.coolantTempView.setX(4);
        this.coolantTempView.setY(271 - coolantTempViewH - 4);
        this.oilPressureView = new DashboardViewContainer(2, true);
        int oilPressureViewH = this.oilPressureView.getPreferredH();
        this.oilPressureView.setX(171);
        this.oilPressureView.setY(135 - oilPressureViewH / 2 - 18);
        this.batteryVoltageView = new DashboardViewContainer(2, true);
        this.batteryVoltageView.setX(338);
        this.batteryVoltageView.setY(4);
        this.intakeAirTempView = new DashboardViewContainer(2, false);
        int intakeAirTempViewH = this.intakeAirTempView.getPreferredH();
        this.intakeAirTempView.setX(338);
        this.intakeAirTempView.setY(271 - intakeAirTempViewH - 4);
        this.initView();
    }

    public void initView() {
        this.addComponent((Component)this.oilTempView);
        this.addComponent((Component)this.coolantTempView);
        this.addComponent((Component)this.oilPressureView);
        this.addComponent((Component)this.batteryVoltageView);
        this.addComponent((Component)this.intakeAirTempView);
        this.updateViewOnUnitChanged();
    }

    public void updateViewOnLanguageChanged() {
        String current_unit = GSkillsStateManager.getInstance().getCurrentUnit() == 0 ? "US" : "M";
        this.tempUnit = this.resourceManager.getLanguageResByKey("unit_" + current_unit + "_Temp");
        this.oilTempView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_oilTemp") + " " + this.tempUnit);
        this.coolantTempView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_coolantTemp") + " " + this.tempUnit);
        this.intakeAirTempView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_intakeAirTemp") + " " + this.tempUnit);
        this.oilPressureView.setSymbol(this.resourceManager.getLanguageResByKey("unit_" + current_unit + "_OilPressure"));
        this.batteryVoltageView.setSymbol(this.resourceManager.getLanguageResByKey("unit_" + current_unit + "_batteryVoltage"));
        this.oilPressureView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_oilPreessure"));
        this.batteryVoltageView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_batteryVolt"));
    }

    public void updateViewOnUnitChanged() {
        this.MAX_OILTEMP = GSkillsIndicatorValueRangeFactory.getMaxOilTemp();
        this.MIN_OILTEMP = GSkillsIndicatorValueRangeFactory.getMinOilTemp();
        this.MAX_BATTERY = GSkillsIndicatorValueRangeFactory.getMaxBattery();
        this.MIN_BATTERY = GSkillsIndicatorValueRangeFactory.getMinBattery();
        this.MAX_OILPRESSURE = GSkillsIndicatorValueRangeFactory.getMaxOilPressure();
        this.MIN_OILPRESSURE = GSkillsIndicatorValueRangeFactory.getMinOilPressure();
        this.MAX_COOLANTTEMP = GSkillsIndicatorValueRangeFactory.getMaxCoolantTemp();
        this.MIN_COOLANTTEMP = GSkillsIndicatorValueRangeFactory.getMinCoolantTemp();
        this.MAX_INTAKEAIR = GSkillsIndicatorValueRangeFactory.getMaxIntakeAirTemp();
        this.MIN_INTAKEAIR = GSkillsIndicatorValueRangeFactory.getMinIntakeAirTemp();
        this.intakeAirTempView.setRangeValue(this.MIN_INTAKEAIR, this.MAX_INTAKEAIR);
        this.coolantTempView.setRangeValue(this.MIN_COOLANTTEMP, this.MAX_COOLANTTEMP);
        this.oilPressureView.setRangeValue(this.MIN_OILPRESSURE, this.MAX_OILPRESSURE);
        this.batteryVoltageView.setRangeValue(this.MIN_BATTERY, this.MAX_BATTERY);
        this.oilTempView.setRangeValue(this.MIN_OILTEMP, this.MAX_OILTEMP);
        this.updateViewOnLanguageChanged();
    }

    public void updateViewOnDataChanged() {
        if (this.dataModel.hasOilTempChanged()) {
            this.oilTempValue = this.dataModel.getOilTemp();
            this.oilTempImageNumber = this.dataModel.getOilTempImageNumber();
            this.hasContainerChanged = true;
        }
        if (this.dataModel.hasEngineCoolantTempChanged()) {
            this.engineCoolantTempValue = this.dataModel.getEngineCoolantTemp();
            this.engineCoolantTempImageNumber = this.dataModel.getEngineCoolantTempImageNumber();
            this.hasContainerChanged = true;
        }
        if (this.dataModel.pollAndCheckBatteryChange()) {
            this.batteryVoltageValue = this.dataModel.getBatteryPolled();
            this.batteryVoltageImageNumber = this.dataModel.getBatteryVoltPolledImageNumber();
            this.hasContainerChanged = true;
        }
        if (this.dataModel.hasIntakeAirTempChanged()) {
            this.intakeAirTempValue = this.dataModel.getIntakeAirTemp();
            this.intakeAirTempImageNumber = this.dataModel.getIntakeAirTempImageNumber();
            this.hasContainerChanged = true;
        }
        if (this.dataModel.pollAndCheckOilPressureChange()) {
            this.oilPressureValue = this.dataModel.getOilPressurePolled();
            this.oilPressureImageNumber = this.dataModel.getOilPressurePolledImageNumber(true);
            this.hasContainerChanged = true;
        }
        if (this.hasContainerChanged) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    try {
                        GaugesTwoViewForViper.this.batteryVoltageView.setGaugesValue(GaugesTwoViewForViper.this.batteryVoltageValue, GaugesTwoViewForViper.this.batteryVoltageImageNumber);
                        GaugesTwoViewForViper.this.intakeAirTempView.setGaugesValue(GaugesTwoViewForViper.this.intakeAirTempValue, GaugesTwoViewForViper.this.intakeAirTempImageNumber);
                        GaugesTwoViewForViper.this.oilPressureView.setGaugesValue(GaugesTwoViewForViper.this.oilPressureValue, GaugesTwoViewForViper.this.oilPressureImageNumber);
                        GaugesTwoViewForViper.this.oilTempView.setGaugesValue(GaugesTwoViewForViper.this.oilTempValue, GaugesTwoViewForViper.this.oilTempImageNumber);
                        GaugesTwoViewForViper.this.coolantTempView.setGaugesValue(GaugesTwoViewForViper.this.engineCoolantTempValue, GaugesTwoViewForViper.this.engineCoolantTempImageNumber);
                        GaugesTwoViewForViper.this.refreshGaugesTwoContainer();
                    }
                    catch (Throwable ex) {
                        GaugesTwoViewForViper.this.logger.error((Object)"", ex);
                    }
                }
            });
            this.hasContainerChanged = false;
        }
    }

    private void refreshGaugesTwoContainer() {
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        this.logger.error((Object)"Not implement");
    }

    public void notifyStatus(int remoteError) {
        this.logger.error((Object)"Not implement");
    }
}

