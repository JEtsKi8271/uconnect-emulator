/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 */
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsSensorDisplayRangeFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import java.text.DecimalFormat;
import konax.sensors.Data;

public class GForceSensorModel
extends CommonSensorModel {
    private final double MAX_GFORCE_VALUE = GSkillsSensorDisplayRangeFactory.getMaxGForceValue();
    private final String ZERO_VALUE = "0.00";
    private double _gForceXDataPolled = -54321.123;
    private double _gForceYDataPolled = -54321.123;
    private String _gForceTopString = "--";
    private String _gForceBottomString = "--";
    private String _gForceLeftString = "--";
    private String _gForceRightString = "--";
    private int _gForceLeftRightImageNumber = 0;
    public static final String VEH_ACC_X_CH_NAME = "VehPerfAccel_X";
    public static final String VEH_ACC_Y_CH_NAME = "VehPerfAccel_Y";
    private static final GForceSensorModel INSTANCE = new GForceSensorModel();

    public static GForceSensorModel getInstance() {
        return INSTANCE;
    }

    private GForceSensorModel() {
    }

    protected void setSensorURL() {
        this._sensorURL = "VehicleAcceleration";
    }

    public void setSensorAnalogRange() {
        this._maxAnalogValue = GSkillsSensorDisplayRangeFactory.getMaxGForceImages();
        this._minAnalogValue = GSkillsSensorDisplayRangeFactory.getMinGForceImages();
    }

    public void pollAndSetRawData() {
        Data[] data = this.getRawData();
        if (data != null) {
            try {
                for (int i2 = 0; i2 < data.length; ++i2) {
                    double gForceYfromSensor;
                    if (data[i2].getChannelInfo().getName().equals(VEH_ACC_X_CH_NAME)) {
                        double gForceXfromSensor = data[i2].getDoubleValues()[0];
                        if (this._gForceXDataPolled == gForceXfromSensor) continue;
                        this._gForceXDataPolled = gForceXfromSensor;
                        this._logger.debug((Object)("VehPerfAccel_X:" + this._gForceXDataPolled));
                        this.setTopBottomGForceValue();
                        this._valueChanged = true;
                        continue;
                    }
                    if (!data[i2].getChannelInfo().getName().equals(VEH_ACC_Y_CH_NAME) || this._gForceYDataPolled == (gForceYfromSensor = data[i2].getDoubleValues()[0])) continue;
                    this._gForceYDataPolled = gForceYfromSensor;
                    this._logger.debug((Object)("VehPerfAccel_Y:" + this._gForceYDataPolled));
                    this.setLeftRightGForceValue();
                    this._valueChanged = true;
                }
            }
            catch (Exception e2) {
                this._valueChanged = false;
                this._logger.debug((Object)"VehAccel :: Exception thrown on value.getIntValues. VehAccel will not update");
            }
        }
    }

    protected boolean isGForceValueSNA(double gForceValue) {
        return gForceValue < this._minMeasurementRange || gForceValue > this._maxMeasurementRange;
    }

    protected String formatGForceValue(double doubleValue) {
        DecimalFormat formatter = new DecimalFormat("0.00");
        if (doubleValue == this.MAX_GFORCE_VALUE) {
            return Double.toString(this.MAX_GFORCE_VALUE - 0.01);
        }
        return formatter.format(doubleValue);
    }

    protected double getGForceValue(double gForceData) {
        double douXValue = Math.round(Math.abs(gForceData) * 10.0);
        return this.getRangeControlledValue(douXValue /= 100.0, this.MAX_GFORCE_VALUE, this._minAnalogValue);
    }

    public String getValueForDigitalDisplay() {
        return null;
    }

    private void setLeftRightGForceValue() {
        if (this.isGForceValueSNA(this._gForceYDataPolled)) {
            this._gForceLeftString = "--";
            this._gForceRightString = "--";
        } else if (this._gForceYDataPolled < 0.0) {
            double douXValue = this.getGForceValue(this._gForceYDataPolled);
            this._gForceLeftString = this.formatGForceValue(douXValue);
            this._gForceRightString = "0.00";
        } else if (this._gForceYDataPolled > 0.0) {
            double douXValue = this.getGForceValue(this._gForceYDataPolled);
            this._gForceRightString = this.formatGForceValue(douXValue);
            this._gForceLeftString = "0.00";
        } else {
            this._gForceRightString = "0.00";
            this._gForceLeftString = "0.00";
        }
        this._gForceLeftRightImageNumber = this.getGForceLeftRightNumber(this._gForceLeftString, this._gForceRightString);
    }

    private void setTopBottomGForceValue() {
        if (this.isGForceValueSNA(this._gForceXDataPolled)) {
            this._gForceTopString = "--";
            this._gForceBottomString = "--";
        } else if (this._gForceXDataPolled > 0.0) {
            double douXValue = this.getGForceValue(this._gForceXDataPolled);
            this._gForceBottomString = this.formatGForceValue(douXValue);
            this._gForceTopString = "0.00";
        } else if (this._gForceXDataPolled < 0.0) {
            double douXValue = this.getGForceValue(this._gForceXDataPolled);
            this._gForceTopString = this.formatGForceValue(douXValue);
            this._gForceBottomString = "0.00";
        } else {
            this._gForceTopString = "0.00";
            this._gForceBottomString = "0.00";
        }
    }

    public String getLeftGForceValue() {
        return this._gForceLeftString;
    }

    public String getRightGForceValue() {
        return this._gForceRightString;
    }

    public String getBottomGForceValue() {
        return this._gForceBottomString;
    }

    public String getTopGForceValue() {
        return this._gForceTopString;
    }

    private int getGForceLeftRightNumber(String negativeGForceStr, String positiveGForceStr) {
        int interval = 0;
        if (negativeGForceStr != "--" && positiveGForceStr != "--") {
            String str = positiveGForceStr;
            int inter = -7;
            if (Double.valueOf(positiveGForceStr) == 0.0) {
                str = negativeGForceStr;
                inter = 1;
            }
            if (str != null) {
                double gforceDoub = Double.parseDouble(str);
                interval = gforceDoub > 0.1 && gforceDoub <= 0.15 ? inter + 6 : (gforceDoub > 0.15 && gforceDoub <= 0.3 ? inter + 5 : (gforceDoub > 0.3 && gforceDoub <= 0.45 ? inter + 4 : (gforceDoub > 0.45 && gforceDoub <= 0.6 ? inter + 3 : (gforceDoub > 0.6 && gforceDoub <= 0.75 ? inter + 2 : (gforceDoub > 0.75 && gforceDoub <= 0.9 ? inter + 1 : (gforceDoub > 0.9 ? inter + 0 : 0))))));
            }
        }
        return interval;
    }

    public int getGForceLeftRightImageNumber() {
        return this._gForceLeftRightImageNumber;
    }

    public String getGForceFrontRearImageName() {
        String gForceImageName = "image_gindicator_active";
        String imageName = "";
        String imageExtension = ".png";
        double gForceXValue = this.getGForceValue(this._gForceXDataPolled);
        if (this._gForceXDataPolled >= 0.0) {
            if (gForceXValue < 0.1 || this.isGForceValueSNA(this._gForceXDataPolled)) {
                return gForceImageName + imageExtension;
            }
            imageName = "_rear";
        } else if (this._gForceXDataPolled < 0.0) {
            if (gForceXValue < 0.1 || this.isGForceValueSNA(this._gForceXDataPolled)) {
                return gForceImageName + imageExtension;
            }
            imageName = "_front";
        }
        return gForceImageName + imageName + this.getImageNumber(gForceXValue, this._maxAnalogValue, 0.1, 4) + imageExtension;
    }

    private int getImageNumber(double receivedValue, double maxValue, double minValue, int imgsCount) {
        int imageIndexInt = 1;
        double slotSize = new Double((maxValue - minValue) / (double)imgsCount);
        if (receivedValue >= maxValue) {
            return imgsCount;
        }
        double imageIndex = (receivedValue - minValue) / slotSize;
        imageIndexInt = (int)(imageIndex + 1.0);
        return imageIndexInt;
    }
}

