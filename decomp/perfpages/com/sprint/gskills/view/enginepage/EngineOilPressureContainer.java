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

import car.jamaica.widgets.gskills.RotatingLSeriesEngOilPressureNeedle;
import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.model.BoostPressureSensorModel;
import com.sprint.gskills.model.OilPressureSensorModel;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.unit.PressureUnitEnum;
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

public class EngineOilPressureContainer
extends UpdatableContainer {
    private final VehicleTrimEnum _vehicleTrim;
    private final VehicleLineEnum _vehicleLine;
    private RotatingLSeriesEngOilPressureNeedle _needle;
    private Container _engineGaugeImgContainer;
    private Container _engineNeedleImgContainer;
    private final CommonSensorModel _sensorModel;
    private final int TOTAL_IMG_COUNT;
    private final int PRESSURE_TITLE_W = 165;
    private int _oilPresImgNumber;
    private double _currentUnifiedValue;
    private FastNumberLabel _pressureTitleLabel;
    private FastNumberLabel _pressureValueLabel;
    private FastNumberLabel _pressureUnitLabel;
    private FastNumberLabel _pressureGaugeUnitLabel;
    private CommonLabel _oilGaugePointerLabel;
    private final String _oilPressureTitleResKey;
    private String _oilPressureValueString;
    private Container _pressureValueUnitContainer;
    private Container _pressureTitlePointerContainer;

    public EngineOilPressureContainer() {
        this._vehicleTrim = this._stateManager.getVehicleTrim();
        this._vehicleLine = this._stateManager.getVehicleLine();
        this.TOTAL_IMG_COUNT = this._stateManager.isLSeriesVehicle() ? 30 : 25;
        this.PRESSURE_TITLE_W = 165;
        this._oilPresImgNumber = 1;
        this._currentUnifiedValue = -360.0;
        this.getStyle().setBgTransparency(0);
        if (VehicleTrimEnum.HELLCAT == this._vehicleTrim) {
            this._oilPressureTitleResKey = "gauges_title_BoostPressure";
            this._sensorModel = BoostPressureSensorModel.getInstance();
        } else {
            this._oilPressureTitleResKey = "gauges_title_oilPreessure";
            this._sensorModel = OilPressureSensorModel.getInstance();
        }
        this.initView();
    }

    protected void initView() {
        this.setLayout((Layout)new CoordinateLayout(520, 280));
        this.setPreferredSize(new Dimension(520, 280));
        this.getStyle().setBgTransparency(0);
        this.getStyle().setBackgroundType((byte)5);
        this.getStyle().setBackgroundAlignment((byte)-94);
        this._engineGaugeImgContainer = new Container();
        this._engineGaugeImgContainer.setPreferredSize(new Dimension(520, 280));
        this._engineGaugeImgContainer.getStyle().setBgTransparency(0);
        if (this._stateManager.isLSeriesVehicle()) {
            if (VehicleLineEnum.LX == this._vehicleLine) {
                this._engineNeedleImgContainer = new Container();
                this._engineNeedleImgContainer.setPreferredSize(new Dimension(132, 100));
                this._engineNeedleImgContainer.getStyle().setBackgroundAlignment((byte)-95);
                this._engineNeedleImgContainer.getStyle().setBgTransparency(0);
                this._engineNeedleImgContainer.setX(175);
                this._engineNeedleImgContainer.setY(101);
                this._engineNeedleImgContainer.getStyle().setBgImage(this._resourceManager.getLineSpecificImage("needle-large-lx-1.png"));
                this.addComponent((Component)this._engineNeedleImgContainer);
            } else {
                this._needle = new RotatingLSeriesEngOilPressureNeedle(this._resourceManager.getLineSpecificImage("needle-large-" + this._stateManager.getVehicleLine().toString() + ".png"));
                this._needle.setX(175);
                this._needle.setY(101);
                this.addComponent((Component)this._needle);
            }
            this.addComponent((Component)this._engineGaugeImgContainer);
        } else {
            this._engineNeedleImgContainer = new Container();
            this._engineNeedleImgContainer.setPreferredSize(new Dimension(342, 288));
            this._engineNeedleImgContainer.getStyle().setBackgroundType((byte)5);
            this._engineNeedleImgContainer.getStyle().setBackgroundAlignment((byte)-94);
            this._engineNeedleImgContainer.getStyle().setBgTransparency(0);
            this._engineNeedleImgContainer.setX(68);
            this._engineNeedleImgContainer.setY(-3);
            this._engineNeedleImgContainer.getStyle().setBgImage(this._resourceManager.getLineSpecificImage("needle-large-" + this._vehicleLine + "-1.png"));
            this.addComponent((Component)this._engineGaugeImgContainer);
            this.addComponent((Component)this._engineNeedleImgContainer);
        }
        if (this._stateManager.isLSeriesVehicle()) {
            this.initLSeriesOilPresLabelContainer();
        } else {
            this.initJeepViperOilPresLabelContainer();
        }
    }

    private void initLSeriesOilPresLabelContainer() {
        Font f18 = this._fontFactory.getFontSize18();
        int font18Height = f18.getHeight();
        Font f46 = this._fontFactory.getFontSize46();
        int font46Height = f46.getHeight();
        int pressureTitleXPos = 35;
        this._pressureTitleLabel = new FastNumberLabel(0xFFFFFF, 3, f18);
        this._pressureTitleLabel.setPreferredSize(new Dimension(165, font18Height));
        this._pressureTitleLabel.setX(35);
        this._pressureTitleLabel.setY(this._alignmentFactory.getAlignment(29));
        Image oilGaugePointerImage = this._resourceManager.getCommonImage("oil-gauge-pointer.png");
        this._oilGaugePointerLabel = new FastNumberLabel();
        this._oilGaugePointerLabel.getStyle().setBgImage(oilGaugePointerImage);
        this._oilGaugePointerLabel.setPreferredSize(new Dimension(oilGaugePointerImage.getWidth(), oilGaugePointerImage.getHeight()));
        this._oilGaugePointerLabel.setX(25);
        this._oilGaugePointerLabel.setY(13);
        this._pressureTitlePointerContainer = new Container();
        this._pressureTitlePointerContainer.setLayout((Layout)new CoordinateLayout(new Dimension(200, 42)));
        this._pressureTitlePointerContainer.setPreferredSize(new Dimension(200, 42));
        this._pressureTitlePointerContainer.addComponent((Component)this._oilGaugePointerLabel);
        this._pressureTitlePointerContainer.addComponent((Component)this._pressureTitleLabel);
        this._pressureTitlePointerContainer.setX(520 - this._pressureTitlePointerContainer.getPreferredW() - 10);
        this._pressureTitlePointerContainer.setY(280 - this._pressureTitlePointerContainer.getPreferredH());
        this._pressureValueLabel = new FastNumberLabel(0xFFFFFF, 4, this._fontFactory.getFont(8));
        this._pressureValueLabel.setPreferredSize(new Dimension(125, font46Height));
        this._pressureValueLabel.getStyle().setPadding(0, 4);
        this._pressureValueLabel.setX(this._alignmentFactory.getAlignment(8));
        this._pressureValueLabel.setY(this._alignmentFactory.getAlignment(9));
        this._pressureUnitLabel = new FastNumberLabel(0xFFFFFF, 4, f18);
        this._pressureUnitLabel.setPreferredSize(new Dimension(67, font18Height + 6));
        this._pressureUnitLabel.getStyle().setPadding(0, 2);
        this._pressureUnitLabel.setX(this._alignmentFactory.getAlignment(10));
        this._pressureUnitLabel.setY(this._pressureValueLabel.getPreferredH() + this._alignmentFactory.getAlignment(11));
        this.addComponent((Component)this._pressureTitlePointerContainer);
        this.addComponent((Component)this._pressureValueLabel);
        this.addComponent((Component)this._pressureUnitLabel);
    }

    private void initJeepViperOilPresLabelContainer() {
        Font f14 = this._fontFactory.getFontSize14();
        int font14Height = f14.getHeight();
        Font f18 = this._fontFactory.getFontSize18();
        int font18Height = f18.getHeight();
        Font f28 = this._fontFactory.getFontSize28();
        int font28Height = f28.getHeight();
        int pressureValueW = 100;
        int pressureUnitW = 65;
        this._pressureTitleLabel = new FastNumberLabel(0xFFFFFF, 3, f18);
        this._pressureTitleLabel.setPreferredSize(new Dimension(165, font18Height + 5));
        this._pressureValueLabel = new FastNumberLabel(0xFFFFFF, 3, f28);
        this._pressureValueLabel.setPreferredSize(new Dimension(100, font28Height));
        this._pressureValueLabel.getStyle().setPadding(0, 4);
        this._pressureUnitLabel = new FastNumberLabel(0xFFFFFF, 3, f18);
        this._pressureUnitLabel.setPreferredSize(new Dimension(pressureUnitW, font18Height + 6));
        this._pressureUnitLabel.getStyle().setPadding(0, 10);
        this._pressureValueUnitContainer = new Container((Layout)new BoxLayout(1));
        this._pressureValueUnitContainer.addComponent(0, (Component)this._pressureValueLabel);
        this._pressureValueUnitContainer.addComponent(1, (Component)this._pressureUnitLabel);
        Container pressureTitleValueUnitContainer = new Container((Layout)new BoxLayout(2));
        pressureTitleValueUnitContainer.addComponent((Component)this._pressureTitleLabel);
        pressureTitleValueUnitContainer.addComponent((Component)this._pressureValueUnitContainer);
        pressureTitleValueUnitContainer.setX(347);
        pressureTitleValueUnitContainer.setY(220);
        this._pressureGaugeUnitLabel = new FastNumberLabel(0xFFFFFF, 1, f14);
        this._pressureGaugeUnitLabel.setPreferredSize(new Dimension(65, font14Height));
        this._pressureGaugeUnitLabel.setX(160);
        this._pressureGaugeUnitLabel.setY(222);
        this.addComponent((Component)pressureTitleValueUnitContainer);
        this.addComponent((Component)this._pressureGaugeUnitLabel);
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean valueChanged = false;
        valueChanged = this.updatePressureValueLabel(forceUpdate);
        valueChanged = valueChanged || this.updatePressureGaugeImage(forceUpdate);
        return valueChanged;
    }

    private boolean updatePressureValueLabel(boolean forceUpdate) {
        boolean valueChanged = false;
        valueChanged = VehicleTrimEnum.HELLCAT == this._vehicleTrim ? this.setBoostPressureValue(forceUpdate) : this.setOilPressureValue(forceUpdate);
        return valueChanged;
    }

    private boolean updatePressureGaugeImage(boolean forceUpdate) {
        boolean valueChanged = false;
        if (VehicleLineEnum.LX == this._vehicleLine || VehicleLineEnum.WK == this._vehicleLine) {
            int imgNumber = this._sensorModel.getImageNumber(this.TOTAL_IMG_COUNT);
            if (imgNumber != this._oilPresImgNumber || forceUpdate) {
                valueChanged = true;
                this._oilPresImgNumber = imgNumber;
                this._engineNeedleImgContainer.getStyle().setBgImage(this._resourceManager.getLineSpecificImage("needle-large-" + this._vehicleLine + "-" + this._oilPresImgNumber + ".png"));
            }
        } else {
            double unifiedValue = this._sensorModel.getUnifiedValue();
            if (unifiedValue != this._currentUnifiedValue || forceUpdate) {
                valueChanged = true;
                this._currentUnifiedValue = unifiedValue;
                this._needle.set(this._currentUnifiedValue);
            }
        }
        return valueChanged;
    }

    private boolean setBoostPressureValue(boolean forceUpdate) {
        boolean valueChanged = false;
        BoostPressureSensorModel boostModel = BoostPressureSensorModel.getInstance();
        String boostValue = boostModel.getValueForDigitalDisplay();
        if (!boostValue.equals(this._oilPressureValueString) || forceUpdate) {
            this._oilPressureValueString = boostValue;
            this._pressureValueLabel.setText(this._oilPressureValueString);
            valueChanged = true;
            if (PressureUnitEnum.PSI == this._stateManager.getPressureUnit()) {
                double sensorDblValue = boostModel.getValueForAnalogDisplay();
                if (sensorDblValue >= 0.0 && sensorDblValue < 100.0) {
                    this._pressureUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_US_BoostPressure"));
                } else {
                    this._pressureUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_US_OilPressure"));
                }
            }
        }
        return valueChanged;
    }

    private boolean setOilPressureValue(boolean forceUpdate) {
        boolean valueChanged = false;
        String oilPressure = OilPressureSensorModel.getInstance().getValueForDigitalDisplay();
        if (!oilPressure.equals(this._oilPressureValueString) || forceUpdate) {
            this._pressureValueLabel.setText(oilPressure);
            this._oilPressureValueString = oilPressure;
            valueChanged = true;
        }
        return valueChanged;
    }

    public void updateViewOnLanguageChange() {
        this._pressureTitleLabel.setText(this._resourceManager.getLanguageResByKey(this._oilPressureTitleResKey));
    }

    public void updateViewOnPressureUnitChange() {
        PressureUnitEnum pressureUnit = this._stateManager.getPressureUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on oil pressure unit change to " + pressureUnit.toString()));
        String imageSuffix = "";
        if (VehicleTrimEnum.RT != this._vehicleTrim && VehicleLineEnum.WK != this._vehicleLine) {
            imageSuffix = "_" + pressureUnit.toString();
        }
        String engineImagePath = this._vehicleLine.toString() + "_" + this._vehicleTrim.toString() + imageSuffix + ".png";
        this._engineGaugeImgContainer.getStyle().setBgImage(this._resourceManager.getTrimSpecificImage(engineImagePath));
        this.updatePressureUnitLabel();
    }

    private void updatePressureUnitLabel() {
        double boostPressureValue;
        PressureUnitEnum pressureUnit = this._stateManager.getPressureUnit();
        String pressureUnitResKey = pressureUnit.getResKey();
        if (VehicleTrimEnum.HELLCAT == this._vehicleTrim && PressureUnitEnum.PSI == pressureUnit && (boostPressureValue = BoostPressureSensorModel.getInstance().getValueForAnalogDisplay()) >= 0.0 && boostPressureValue < 100.0) {
            pressureUnitResKey = "unit_US_BoostPressure";
        }
        String pressureUnitText = this._resourceManager.getLanguageResByKey(pressureUnitResKey);
        this._pressureUnitLabel.setText(pressureUnitText);
        if (!this._stateManager.isLSeriesVehicle()) {
            int pressureUnitW = this._pressureUnitLabel.getStyle().getFont().stringWidth(pressureUnitText) + 5;
            this._pressureUnitLabel.setPreferredW(pressureUnitW);
            this._pressureValueLabel.setPreferredW(165 - pressureUnitW);
            this._pressureValueUnitContainer.replace(this._pressureValueUnitContainer.getComponentAt(0), (Component)this._pressureValueLabel, null);
            this._pressureValueUnitContainer.replace(this._pressureValueUnitContainer.getComponentAt(1), (Component)this._pressureUnitLabel, null);
            this._pressureGaugeUnitLabel.setText(pressureUnitText);
        }
    }
}

