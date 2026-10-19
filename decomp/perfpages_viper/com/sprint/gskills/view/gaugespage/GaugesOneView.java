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

public class GaugesOneView
extends Container
implements GSkillsViewDataListener {
    private Logger logger = LoggerFactory.getLogger(GaugesOneView.class);
    private DashboardViewContainer oilTempView = null;
    private DashboardViewContainer batteryVoltageView = null;
    private DashboardViewContainer oilPressureView = null;
    private CommonViewResourceManager resourceManager = CommonViewResourceManager.getInstance();
    private CommonSensorModel dataModel = GSkillsDataModelFactory.getSensorDataModel();
    private double MAX_OILTEMP = 0.0;
    private double MIN_OILTEMP = 0.0;
    private double MAX_BATTERY = 0.0;
    private double MIN_BATTERY = 0.0;
    private double MAX_OILPRESSURE = 0.0;
    private double MIN_OILPRESSURE = 0.0;
    private String oilTempValue;
    private int oilTempImageNumber = 1;
    private boolean hasConatainerChanged;
    private String batteryVoltageValue;
    private int batteryVoltageImageNumber = 1;
    private String oilPressureValue;
    private int oilPressureImageNumber = 1;
    private final int containerH = 271;
    private final int containerW = 530;
    private final int margin = 10;
    private final int containerXoffset = 96;
    private final int containerYoffset = 102;
    private String tempUnit = null;

    public GaugesOneView() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(530, 271)));
        this.setPreferredSize(new Dimension(530, 271));
        this.getStyle().setMargin(0, 2);
        this.oilTempView = new DashboardViewContainer(1, false);
        this.oilTempView.setX(10);
        this.oilTempView.setY(10);
        this.batteryVoltageView = new DashboardViewContainer(1, true);
        int componentW = this.batteryVoltageView.getPreferredW();
        this.batteryVoltageView.setX(530 - componentW - 10);
        this.batteryVoltageView.setY(10);
        this.oilPressureView = new DashboardViewContainer(1, true);
        int componentH = this.oilPressureView.getPreferredH();
        this.oilPressureView.setX(265 - componentW / 2);
        this.oilPressureView.setY(271 - componentH - 10);
        this.initView();
    }

    public void initView() {
        this.addComponent((Component)this.oilTempView);
        this.addComponent((Component)this.batteryVoltageView);
        this.addComponent((Component)this.oilPressureView);
        this.updateViewOnUnitChanged();
    }

    public void updateViewOnLanguageChanged() {
        String current_unit = GSkillsStateManager.getInstance().getCurrentUnit() == 0 ? "US" : "M";
        this.tempUnit = this.resourceManager.getLanguageResByKey("unit_" + current_unit + "_Temp");
        this.oilTempView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_oilTemp") + " " + this.tempUnit);
        this.batteryVoltageView.setSymbol(this.resourceManager.getLanguageResByKey("unit_" + current_unit + "_batteryVoltage"));
        this.oilPressureView.setSymbol(this.resourceManager.getLanguageResByKey("unit_" + current_unit + "_OilPressure"));
        this.batteryVoltageView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_batteryVolt"));
        this.oilPressureView.setTitle(this.resourceManager.getLanguageResByKey("gauges_title_oilPreessure"));
    }

    public void updateViewOnUnitChanged() {
        this.updateViewOnLanguageChanged();
        this.MAX_OILTEMP = GSkillsIndicatorValueRangeFactory.getMaxOilTemp();
        this.MIN_OILTEMP = GSkillsIndicatorValueRangeFactory.getMinOilTemp();
        this.oilTempView.setRangeValue(this.MIN_OILTEMP, this.MAX_OILTEMP);
        this.MAX_BATTERY = GSkillsIndicatorValueRangeFactory.getMaxBattery();
        this.MIN_BATTERY = GSkillsIndicatorValueRangeFactory.getMinBattery();
        this.batteryVoltageView.setRangeValue(this.MIN_BATTERY, this.MAX_BATTERY);
        this.MAX_OILPRESSURE = GSkillsIndicatorValueRangeFactory.getMaxOilPressure();
        this.MIN_OILPRESSURE = GSkillsIndicatorValueRangeFactory.getMinOilPressure();
        this.oilPressureView.setRangeValue(this.MIN_OILPRESSURE, this.MAX_OILPRESSURE);
        this.updateViewOnDataChanged();
    }

    public void updateViewOnDataChanged() {
        if (this.dataModel.hasOilTempChanged()) {
            this.oilTempValue = this.dataModel.getOilTemp();
            this.oilTempImageNumber = this.dataModel.getOilTempImageNumber();
            this.hasConatainerChanged = true;
        }
        if (this.dataModel.pollAndCheckBatteryChange()) {
            this.batteryVoltageValue = this.dataModel.getBatteryPolled();
            this.batteryVoltageImageNumber = this.dataModel.getBatteryVoltPolledImageNumber();
            this.hasConatainerChanged = true;
        }
        if (this.dataModel.pollAndCheckOilPressureChange()) {
            this.oilPressureValue = this.dataModel.getOilPressurePolled();
            this.oilPressureImageNumber = this.dataModel.getOilPressurePolledImageNumber(true);
            this.hasConatainerChanged = true;
        }
        if (this.hasConatainerChanged) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    try {
                        GaugesOneView.this.oilTempView.setGaugesValue(GaugesOneView.this.oilTempValue, GaugesOneView.this.oilTempImageNumber);
                        GaugesOneView.this.batteryVoltageView.setGaugesValue(GaugesOneView.this.batteryVoltageValue, GaugesOneView.this.batteryVoltageImageNumber);
                        GaugesOneView.this.oilPressureView.setGaugesValue(GaugesOneView.this.oilPressureValue, GaugesOneView.this.oilPressureImageNumber);
                    }
                    catch (Throwable ex) {
                        GaugesOneView.this.logger.error((Object)"", ex);
                    }
                }
            });
            this.hasConatainerChanged = false;
        }
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        this.logger.error((Object)"Not yet implement");
    }

    public void notifyStatus(int remoteError) {
        this.logger.error((Object)"Not yet implement");
    }
}

