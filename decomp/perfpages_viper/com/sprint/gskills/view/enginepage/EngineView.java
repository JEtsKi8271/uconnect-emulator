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
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.view.enginepage.EngineGearContainer;
import com.sprint.gskills.view.enginepage.EngineHorsepowerContainer;
import com.sprint.gskills.view.enginepage.EngineMessageContainer;
import com.sprint.gskills.view.enginepage.EngineOilPressureContainer;
import com.sprint.gskills.view.enginepage.EngineTorqueContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Display;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class EngineView
extends Container
implements GSkillsViewDataListener {
    private Logger logger = LoggerFactory.getLogger(EngineView.class);
    private EngineGearContainer gearContainer = null;
    private EngineOilPressureContainer oilPressureContainer = null;
    private EngineTorqueContainer torqueContainer = null;
    private EngineHorsepowerContainer horsepowerContainer = null;
    private EngineMessageContainer messageContainer = null;
    private CommonSensorModel dataModel = GSkillsDataModelFactory.getSensorDataModel();
    private boolean isvehicleAutomatic = false;
    private boolean hasValueChanged = false;
    private String oilPressureValue = null;
    private int oilpressureImageNumber = 1;
    private String PATH_ENGINE_BACKGROUND = "image_enginelanding_bg.png";
    private int torqueImageNumber = 1;
    private int hpImageNumber = 1;
    private String torqueValue = null;
    private String horsePowerValue = null;
    private String gearValue = null;
    private final int engineImageW = 516;
    private final int engineImageH = 273;

    public EngineView() {
        this.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile(this.PATH_ENGINE_BACKGROUND));
        this.setLayout((Layout)new CoordinateLayout(new Dimension(516, 273)));
        this.setPreferredSize(new Dimension(516, 273));
        this.getStyle().setMargin(1, 14);
        this.oilPressureContainer = new EngineOilPressureContainer();
        this.oilPressureContainer.setPreferredSize(new Dimension(516, 273));
        this.oilPressureContainer.getStyle().setBackgroundType((byte)5);
        this.oilPressureContainer.getStyle().setBackgroundAlignment((byte)-94);
        this.torqueContainer = new EngineTorqueContainer();
        this.torqueContainer.setPreferredSize(new Dimension(516, 273));
        this.torqueContainer.getStyle().setBackgroundType((byte)5);
        this.torqueContainer.getStyle().setBackgroundAlignment((byte)-94);
        this.horsepowerContainer = new EngineHorsepowerContainer();
        this.horsepowerContainer.setPreferredSize(new Dimension(516, 273));
        this.horsepowerContainer.getStyle().setBackgroundType((byte)5);
        this.horsepowerContainer.getStyle().setBackgroundAlignment((byte)-94);
        this.messageContainer = new EngineMessageContainer();
        if (1 == GSkillsStateManager.getInstance().getTransType()) {
            this.isvehicleAutomatic = true;
        }
        if (this.isvehicleAutomatic) {
            this.gearContainer = new EngineGearContainer();
            this.gearContainer.setPreferredSize(new Dimension(516, 273));
        }
    }

    public void initView() {
        try {
            this.messageContainer.initView();
            this.torqueContainer.initView();
            this.horsepowerContainer.initView();
            this.oilPressureContainer.initView();
        }
        catch (Exception ex) {
            this.logger.error((Object)"Engine View init error :", (Throwable)ex);
        }
        if (this.isvehicleAutomatic) {
            this.gearContainer.initView();
            this.addComponent((Component)this.gearContainer);
        }
        this.addComponent((Component)this.oilPressureContainer);
        this.addComponent((Component)this.torqueContainer);
        this.addComponent((Component)this.horsepowerContainer);
        this.addComponent((Component)this.messageContainer);
        this.updateViewOnLanguageChanged();
    }

    public void updateViewOnLanguageChanged() {
        this.messageContainer.updateViewOnLanguageChanged();
        if (this.isvehicleAutomatic) {
            this.gearContainer.updateViewOnLanguageChanged();
        }
        this.updateViewOnUnitChanged();
    }

    public void updateViewOnUnitChanged() {
        String current_unit = GSkillsStateManager.getInstance().getCurrentUnit() == 0 ? "US" : "M";
        this.messageContainer.updateViewOnUnitChanged(current_unit);
        this.messageContainer.setSpeedUnit(this.dataModel.getSpeedUnit());
    }

    public void updateViewOnDataChanged() {
        if (this.dataModel.hasSpeedUnitChanged()) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    EngineView.this.messageContainer.setSpeedUnit(EngineView.this.dataModel.getSpeedUnit());
                }
            });
        }
        if (this.dataModel.hasSpeedChangedPolling()) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    EngineView.this.messageContainer.setSpeedoMeterValue(EngineView.this.dataModel.getCurrentSpeedPolled());
                }
            });
        }
        if (this.dataModel.PollandCheckTorqueDataChange()) {
            this.torqueValue = this.dataModel.getTorquePolled();
            this.hasValueChanged = true;
            this.torqueImageNumber = this.dataModel.getTorqueImageNumber(this.torqueValue);
        }
        if (this.dataModel.pollAndCheckHpChange(this.torqueValue)) {
            this.horsePowerValue = this.dataModel.getHorsePowerPolled();
            this.hasValueChanged = true;
            this.hpImageNumber = this.dataModel.getHorsePowerImageNumber(this.horsePowerValue);
        }
        if (this.isvehicleAutomatic && this.dataModel.hasGearChanged()) {
            this.gearValue = this.dataModel.getGear();
            this.hasValueChanged = true;
        }
        if (this.dataModel.pollAndCheckOilPressureChange()) {
            this.oilPressureValue = this.dataModel.getOilPressurePolled();
            this.hasValueChanged = true;
            this.oilpressureImageNumber = this.dataModel.getOilPressurePolledImageNumber(true);
        }
        if (this.hasValueChanged) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    boolean hasHPImageChanged = false;
                    boolean hasOilPressureImageChanged = false;
                    boolean hasTorqueImageChanged = false;
                    try {
                        EngineView.this.messageContainer.setOilPressureValue(EngineView.this.oilPressureValue);
                        EngineView.this.messageContainer.settOrqueValue(EngineView.this.torqueValue);
                        EngineView.this.messageContainer.setHorsePowerValue(EngineView.this.horsePowerValue);
                        hasOilPressureImageChanged = EngineView.this.oilPressureContainer.updateViewOnDataChanged(EngineView.this.oilpressureImageNumber);
                        hasTorqueImageChanged = EngineView.this.torqueContainer.updateViewOnDataChanged(EngineView.this.torqueImageNumber);
                        hasHPImageChanged = EngineView.this.horsepowerContainer.updateViewOnDataChanged(EngineView.this.hpImageNumber);
                        if (EngineView.this.isvehicleAutomatic) {
                            EngineView.this.gearContainer.updateViewOnDataChanged(EngineView.this.gearValue);
                        }
                    }
                    catch (Throwable ex) {
                        EngineView.this.logger.error((Object)"", ex);
                    }
                    if (hasOilPressureImageChanged || hasTorqueImageChanged || hasHPImageChanged) {
                        EngineView.this.refreshEngineView();
                    }
                }
            });
            this.hasValueChanged = false;
        }
    }

    private void refreshEngineView() {
        this.repaint();
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        this.logger.error((Object)"Not yet implement");
    }

    public void notifyStatus(int remoteError) {
        this.logger.error((Object)"Not yet implement");
    }
}

