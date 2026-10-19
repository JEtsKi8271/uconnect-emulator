/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.gaugespage;

import car.jamaica.widgets.gskills.RotatingJeepViperGaugeNeedle;
import car.jamaica.widgets.gskills.RotatingLSeriesGaugeNeedle;
import car.jamaica.widgets.gskills.RotatingNeedle;
import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public abstract class DashboardViewContainer
extends UpdatableContainer {
    protected CommonLabel _titleLabel = null;
    protected FastNumberLabel _valueLabel = null;
    protected CommonLabel _unitLabel = null;
    protected Container _guageImageContainer = null;
    protected Container _needleImageContainer = null;
    protected Image _gaugeImage = null;
    protected CommonSensorModel _sensorModel = null;
    protected String _gaugeBgImageName = null;
    protected String _sensorValue;
    private String _vehicleLine = this._stateManager.getVehicleLine().toString();
    private String _vehicleTrim = this._stateManager.getVehicleTrim().toString();
    protected RotatingNeedle _gaugeNeedle = null;
    protected int _currentImageIndex = -1;

    public DashboardViewContainer() {
        this.setSensorModel();
        this.initView();
    }

    protected abstract void setSensorModel();

    private void initView() {
        if (this._stateManager.isLSeriesVehicle()) {
            if (VehicleLineEnum.LX == this._stateManager.getVehicleLine()) {
                this.initLXLayout();
            } else {
                this.initLSeriesViewLayout();
            }
        } else {
            this.initJeepViperViewLayout();
        }
        this.addComponent((Component)this._guageImageContainer);
        this.addComponent((Component)this._valueLabel);
        this.addComponent((Component)this._unitLabel);
        this.addComponent((Component)this._titleLabel);
    }

    private void initLSeriesViewLayout() {
        int componentW = 180;
        int componentH = 159;
        this.setLayout((Layout)new CoordinateLayout(new Dimension(componentW, componentH)));
        this.setPreferredSize(new Dimension(componentW, componentH));
        this._titleLabel = new CommonLabel(this._fontFactory.getFont(3));
        this._titleLabel.setPreferredSize(new Dimension(componentW, 18));
        this._titleLabel.setX(0);
        this._titleLabel.setY(134);
        this._unitLabel = new CommonLabel(this._fontFactory.getFont(5));
        this._unitLabel.setPreferredSize(new Dimension(132, 15));
        this._unitLabel.setX(this._alignmentFactory.getAlignment(2));
        this._unitLabel.setY(this._alignmentFactory.getAlignment(3));
        this._valueLabel = new FastNumberLabel("");
        this._valueLabel.getStyle().setFont(this._fontFactory.getFont(4));
        this._valueLabel.setPreferredSize(new Dimension(122, 38));
        this._valueLabel.setX(this._alignmentFactory.getAlignment(0));
        this._valueLabel.setY(this._alignmentFactory.getAlignment(1));
        this._gaugeNeedle = new RotatingLSeriesGaugeNeedle(this._resourceManager.getLineSpecificImage("needle-small-" + this._vehicleLine + ".png"));
        this._gaugeNeedle.setX(59);
        this._gaugeNeedle.setY(40);
        this.addComponent((Component)this._gaugeNeedle);
        this._guageImageContainer = new Container();
        this._guageImageContainer.setPreferredSize(new Dimension(145, 132));
        this._guageImageContainer.getStyle().setBackgroundType((byte)5);
        this._guageImageContainer.getStyle().setBackgroundAlignment((byte)-95);
        this._guageImageContainer.getStyle().setBgTransparency(1);
        this._guageImageContainer.setX(18);
        this._guageImageContainer.setY(0);
    }

    private void initLXLayout() {
        int componentW = 180;
        int componentH = 159;
        this.setLayout((Layout)new CoordinateLayout(new Dimension(componentW, componentH)));
        this.setPreferredSize(new Dimension(componentW, componentH));
        this._titleLabel = new CommonLabel(this._fontFactory.getFont(3));
        this._titleLabel.setPreferredSize(new Dimension(componentW, 18));
        this._titleLabel.setX(0);
        this._titleLabel.setY(134);
        this._unitLabel = new CommonLabel(this._fontFactory.getFont(5));
        this._unitLabel.setPreferredSize(new Dimension(132, 15));
        this._unitLabel.setX(this._alignmentFactory.getAlignment(2));
        this._unitLabel.setY(this._alignmentFactory.getAlignment(3));
        this._valueLabel = new FastNumberLabel("");
        this._valueLabel.getStyle().setFont(this._fontFactory.getFont(4));
        this._valueLabel.setPreferredSize(new Dimension(122, 38));
        this._valueLabel.setX(this._alignmentFactory.getAlignment(0));
        this._valueLabel.setY(this._alignmentFactory.getAlignment(1));
        this._guageImageContainer = new Container();
        this._guageImageContainer.setPreferredSize(new Dimension(145, 132));
        this._guageImageContainer.getStyle().setBackgroundType((byte)5);
        this._guageImageContainer.getStyle().setBackgroundAlignment((byte)-95);
        this._guageImageContainer.getStyle().setBgTransparency(1);
        this._guageImageContainer.setX(18);
        this._guageImageContainer.setY(0);
        this._needleImageContainer = new Container();
        this._needleImageContainer.setPreferredW(this._alignmentFactory.getAlignment(4));
        this._needleImageContainer.setPreferredH(this._alignmentFactory.getAlignment(5));
        this._needleImageContainer.setPreferredSize(new Dimension(66, 48));
        this._needleImageContainer.getStyle().setBackgroundType((byte)5);
        this._needleImageContainer.getStyle().setBackgroundAlignment((byte)-95);
        this._needleImageContainer.getStyle().setBgTransparency(0);
        this._needleImageContainer.setX(this._alignmentFactory.getAlignment(6));
        this._needleImageContainer.setY(this._alignmentFactory.getAlignment(7));
        this.addComponent((Component)this._needleImageContainer);
    }

    private void initJeepViperViewLayout() {
        int gaugeImageWidth = 200;
        int gaugeImageHeight = 90;
        int componentHeight = gaugeImageHeight + 45;
        this.setLayout((Layout)new CoordinateLayout(new Dimension(gaugeImageWidth, componentHeight)));
        this.setPreferredSize(new Dimension(gaugeImageWidth, componentHeight));
        Image gaugeNeedleImage = this._resourceManager.getTrimSpecificImage("needle_small_wk_mask.png");
        this._gaugeNeedle = new RotatingJeepViperGaugeNeedle(gaugeNeedleImage);
        this._gaugeNeedle.setX(0);
        this._gaugeNeedle.setY(0);
        this.addComponent((Component)this._gaugeNeedle);
        Container gaugeMaskOverlay = new Container();
        Image maskOverlay = this._resourceManager.getTrimSpecificImage("needle_small_wk_overlay.png");
        gaugeMaskOverlay.setPreferredSize(new Dimension(maskOverlay.getWidth(), maskOverlay.getHeight()));
        gaugeMaskOverlay.getStyle().setBgImage(maskOverlay);
        gaugeMaskOverlay.getStyle().setBgTransparency(1);
        this.addComponent((Component)gaugeMaskOverlay);
        this._guageImageContainer = new Container();
        this._guageImageContainer.setPreferredSize(new Dimension(gaugeImageWidth, gaugeImageHeight));
        this._guageImageContainer.getStyle().setBackgroundType((byte)5);
        this._guageImageContainer.getStyle().setBackgroundAlignment((byte)-95);
        this._guageImageContainer.getStyle().setBgTransparency(1);
        this._guageImageContainer.setX(0);
        this._guageImageContainer.setY(0);
        this._titleLabel = new CommonLabel(this._fontFactory.getFont(3));
        this._titleLabel.setPreferredSize(new Dimension(gaugeImageWidth, 25));
        this._titleLabel.setX(0);
        this._titleLabel.setY(100);
        this._valueLabel = new FastNumberLabel("--");
        this._valueLabel.setAlignment(3);
        this._valueLabel.getStyle().setFont(this._fontFactory.getFont(4));
        this._valueLabel.setPreferredSize(new Dimension(50, 30));
        this._valueLabel.setX(58);
        this._valueLabel.setY(73);
        this._unitLabel = new CommonLabel(this._fontFactory.getFont(5));
        this._unitLabel.setAlignment(1);
        this._unitLabel.setPreferredSize(new Dimension(40, 20));
        this._unitLabel.setX(113);
        this._unitLabel.setY(78);
        this._unitLabel.setAlignment(1);
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        boolean valueChanged = false;
        String sensorValue = this._sensorModel.getValueForDigitalDisplay();
        if (!sensorValue.equals(this._sensorValue) || forceUpdate) {
            valueChanged = true;
            this._sensorValue = sensorValue;
            this.setGaugeLabelValue(this._sensorValue);
            if (VehicleLineEnum.LX == this._stateManager.getVehicleLine()) {
                this.setImage(this._sensorModel.getImageNumber(30));
            } else {
                this._gaugeNeedle.set(this._sensorModel.getUnifiedValue());
            }
        }
        return valueChanged;
    }

    protected void setTitle(String titleKey) {
        this._titleLabel.setText(this._resourceManager.getLanguageResByKey(titleKey));
    }

    protected void setUnit(String unitKey) {
        this._unitLabel.setText(this._resourceManager.getLanguageResByKey(unitKey));
    }

    protected void setGaugeLabelValue(String strValue) {
        if (strValue == null) {
            this._valueLabel.setText("--");
        } else {
            this._valueLabel.setText(strValue);
        }
    }

    protected void setGuageBgImageContainer(String guageSuffix) {
        this._gaugeImage = this._resourceManager.getTrimSpecificImage(this._vehicleLine + "-" + this._vehicleTrim + guageSuffix + ".png");
        this._guageImageContainer.getStyle().setBgImage(this._gaugeImage);
    }

    private void setImage(int imgIndex) {
        if (this._currentImageIndex != imgIndex) {
            this._currentImageIndex = imgIndex;
            Image image = this._resourceManager.getLineSpecificImage("needle-small-" + this._vehicleLine + "-" + this._currentImageIndex + ".png");
            this._needleImageContainer.getStyle().setBgImage(image);
        }
    }
}

