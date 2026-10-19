/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Label
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.Label;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

class EngineMessageContainer
extends Container {
    private Logger logger = Log.createLogger((String)((Object)((Object)this)).getClass().getName());
    private CommonLabel speedMeterLabel = null;
    private CommonLabel speedUnitLabel = null;
    private CommonLabel horsePowercenterUnitLabel = null;
    private CommonLabel torqueCenterUnitLabel = null;
    private CommonLabel oilPressureCenterUnitLabel = null;
    private CommonLabel horsePowerLabel;
    private CommonLabel horsePowerValue;
    private CommonLabel horsePowerUnit;
    private CommonLabel torqueLabel;
    private CommonLabel torqueValueLabel;
    private CommonLabel torqueUnitLabel;
    private CommonLabel oilPressureLabel;
    private CommonLabel oilPressureValue;
    private CommonLabel oilPressureUnit;
    private final int engineViewContainerW = 516;
    private final int engineViewContainerH = 273;
    private CommonViewResourceManager resourceManager = null;

    public EngineMessageContainer() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(516, 273)));
        this.setPreferredSize(new Dimension(516, 273));
        GSkillsFontsStyleFactory fontFactory = GSkillsFontsStyleFactory.getInstance();
        Font f14 = fontFactory.getFontSize14();
        int font14Height = f14.getHeight();
        Font f46 = fontFactory.getFontSize46();
        int font46Height = f46.getHeight();
        Font f35 = fontFactory.getFontSize35();
        int font35Height = f35.getHeight();
        Font f28 = fontFactory.getFontSize28();
        int font28Height = f28.getHeight();
        this.speedMeterLabel = new CommonLabel();
        int font46Width = f46.stringWidth("000") + 2;
        this.speedMeterLabel.setLabelStyle(0xFFFFFF, new Dimension(font46Width + 10, font46Height), 3);
        this.speedMeterLabel.getStyle().setFont(f46);
        this.setSpeedoMeterValue("0");
        this.speedMeterLabel.getStyle().setPadding(0, 8);
        this.speedMeterLabel.getStyle().setMargin(3, 5);
        this.speedUnitLabel = new CommonLabel();
        this.speedUnitLabel.setLabelStyle(0xFFFFFF, new Dimension(90, font14Height + 2), 1);
        this.speedUnitLabel.getStyle().setFont(f14);
        this.speedUnitLabel.getStyle().setPadding(0, 23);
        Container speedDisplayContainer = new Container((Layout)new BoxLayout(1));
        speedDisplayContainer.addComponent((Component)this.speedMeterLabel);
        speedDisplayContainer.addComponent((Component)this.speedUnitLabel);
        speedDisplayContainer.setX(10);
        speedDisplayContainer.setY(6);
        this.addComponent((Component)speedDisplayContainer);
        this.horsePowercenterUnitLabel = new CommonLabel();
        this.horsePowercenterUnitLabel.setLabelStyle(0xFF0000, new Dimension(30, 14), 4);
        this.horsePowercenterUnitLabel.setX(100);
        this.horsePowercenterUnitLabel.setY(212);
        this.torqueCenterUnitLabel = new CommonLabel();
        this.torqueCenterUnitLabel.setLabelStyle(14792537, new Dimension(40, 14), 4);
        this.torqueCenterUnitLabel.setX(130);
        this.torqueCenterUnitLabel.setY(212);
        this.oilPressureCenterUnitLabel = new CommonLabel();
        this.oilPressureCenterUnitLabel.setLabelStyle(0xFFFFFF, new Dimension(40, 14), 4);
        this.oilPressureCenterUnitLabel.setX(185);
        this.oilPressureCenterUnitLabel.setY(212);
        int labelTitleW = 130;
        int labelValueW = 125;
        this.horsePowerLabel = new CommonLabel(0xFF0000, 1, f14);
        this.horsePowerLabel.setPreferredSize(new Dimension(labelTitleW, font14Height + 10));
        this.horsePowerLabel.getStyle().setPadding(0, 10);
        this.horsePowerLabel.getStyle().setPadding(2, 0);
        this.horsePowerValue = new CommonLabel(0xFF0000, 3, f46);
        this.horsePowerValue.setPreferredSize(new Dimension(labelValueW, font46Height + 10));
        this.setHorsePowerValue("--");
        this.horsePowerUnit = new CommonLabel(0xFF0000, 1, f14);
        this.horsePowerUnit.setPreferredSize(new Dimension(40, font14Height + 10));
        this.horsePowerUnit.getStyle().setPadding(1, 4);
        this.horsePowerUnit.getStyle().setPadding(0, 15);
        this.torqueLabel = new CommonLabel(14792537, 1, f14);
        this.torqueLabel.setPreferredSize(new Dimension(labelTitleW, font14Height + 10));
        this.torqueLabel.getStyle().setPadding(1, 25);
        this.torqueValueLabel = new CommonLabel(14792537, 3, f35);
        this.torqueValueLabel.setPreferredSize(new Dimension(labelValueW, font35Height + 10 + 11));
        this.settOrqueValue("--");
        this.torqueUnitLabel = new CommonLabel(14792537, 1, f14);
        this.torqueUnitLabel.setPreferredSize(new Dimension(40, font14Height + 10));
        this.torqueUnitLabel.getStyle().setPadding(1, 4);
        this.torqueUnitLabel.getStyle().setPadding(0, 10);
        this.oilPressureLabel = new CommonLabel(0xFFFFFF, 1, f14);
        this.oilPressureLabel.setPreferredSize(new Dimension(labelTitleW + 10, font14Height + 10));
        this.oilPressureLabel.getStyle().setPadding(1, 40);
        this.oilPressureLabel.getStyle().setPadding(0, 5);
        this.oilPressureValue = new CommonLabel(0xFFFFFF, 3, f28);
        this.oilPressureValue.setPreferredSize(new Dimension(labelValueW, font28Height + 20));
        this.oilPressureValue.getStyle().setPadding(2, 10);
        this.setOilPressureValue("--");
        this.oilPressureUnit = new CommonLabel(0xFFFFFF, 1, f14);
        this.oilPressureUnit.setPreferredSize(new Dimension(40, font14Height + 20));
        this.oilPressureUnit.getStyle().setPadding(1, 4);
        this.oilPressureUnit.getStyle().setPadding(2, 3);
        this.oilPressureValue.getStyle().setPadding(2, 10);
        this.torqueCenterUnitLabel.getStyle().setFont(f14);
        this.horsePowercenterUnitLabel.getStyle().setFont(f14);
        this.oilPressureCenterUnitLabel.getStyle().setFont(f14);
        Container base = new Container((Layout)new BoxLayout(2));
        Container HPLabel = new Container();
        HPLabel.addComponent((Component)this.horsePowerLabel);
        this.horsePowerLabel.getStyle().setBgColor(65535);
        Container hp = new Container((Layout)new BoxLayout(1));
        hp.addComponent((Component)this.horsePowerValue);
        hp.addComponent((Component)this.horsePowerUnit);
        hp.setPreferredH(font46Height - 20 + 5);
        base.addComponent((Component)HPLabel);
        base.addComponent((Component)hp);
        Container TorqueLabelContainer = new Container();
        TorqueLabelContainer.addComponent((Component)this.torqueLabel);
        Container torque = new Container((Layout)new BoxLayout(1));
        torque.addComponent((Component)this.torqueValueLabel);
        torque.addComponent((Component)this.torqueUnitLabel);
        torque.setPreferredH(font46Height - 20 - 5);
        base.addComponent((Component)TorqueLabelContainer);
        base.addComponent((Component)torque);
        Container oilPressureContainer = new Container();
        oilPressureContainer.addComponent((Component)this.oilPressureLabel);
        oilPressureContainer.setPreferredW(100);
        Container oil = new Container((Layout)new BoxLayout(1));
        oil.addComponent((Component)this.oilPressureValue);
        oil.addComponent((Component)this.oilPressureUnit);
        oil.setPreferredH(font46Height - 20);
        base.addComponent((Component)oilPressureContainer);
        base.addComponent((Component)oil);
        base.setX(516 - base.getPreferredW());
        this.addComponent((Component)base);
    }

    protected void initView() {
        this.addComponent((Component)this.horsePowercenterUnitLabel);
        this.addComponent((Component)this.torqueCenterUnitLabel);
        this.addComponent((Component)this.oilPressureCenterUnitLabel);
    }

    protected void setSpeedoMeterValue(String speed) {
        this.setValueToTheLabel(this.speedMeterLabel, speed);
    }

    private void setValueToTheLabel(Label label, String gaugeValue) {
        if (gaugeValue == null) {
            label.setText("0");
        } else {
            label.setText(gaugeValue);
        }
    }

    protected void setHorsePowerValue(String horsePower) {
        this.horsePowerValue.setText(horsePower);
    }

    protected void setOilPressureValue(String oilPres) {
        this.oilPressureValue.setText(oilPres);
    }

    protected void settOrqueValue(String torqueValue) {
        this.torqueValueLabel.setText(torqueValue);
    }

    protected void updateViewOnLanguageChanged() {
        if (this.resourceManager == null) {
            this.resourceManager = CommonViewResourceManager.getInstance();
        }
        this.horsePowerLabel.setText(this.resourceManager.getLanguageResByKey("engine_title_horsepower"));
        this.torqueLabel.setText(this.resourceManager.getLanguageResByKey("engine_title_Torque"));
        this.oilPressureLabel.setText(this.resourceManager.getLanguageResByKey("gauges_title_oilPreessure"));
        this.speedUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_US_Speed"));
    }

    protected void updateViewOnUnitChanged(String currentUnit) {
        if (this.resourceManager == null) {
            this.resourceManager = CommonViewResourceManager.getInstance();
        }
        String horsepowerUnit = "unit_" + currentUnit + "_Horsepower";
        this.horsePowerUnit.setText(this.resourceManager.getLanguageResByKey(horsepowerUnit));
        this.horsePowercenterUnitLabel.setText(this.resourceManager.getLanguageResByKey(horsepowerUnit));
        String oilpressureUnit = "unit_" + currentUnit + "_OilPressure";
        this.oilPressureUnit.setText(this.resourceManager.getLanguageResByKey(oilpressureUnit));
        this.oilPressureCenterUnitLabel.setText(this.resourceManager.getLanguageResByKey(oilpressureUnit));
        String torqueUnit = "unit_" + currentUnit + "_Torque";
        this.torqueUnitLabel.setText(this.resourceManager.getLanguageResByKey(torqueUnit));
        this.torqueCenterUnitLabel.setText(this.resourceManager.getLanguageResByKey(torqueUnit));
    }

    public void setSpeedUnit(String speedUnit) {
        this.speedUnitLabel.setText(speedUnit);
    }
}

