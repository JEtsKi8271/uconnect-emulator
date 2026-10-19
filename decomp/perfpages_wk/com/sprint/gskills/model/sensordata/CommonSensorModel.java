/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  konax.io.Connector
 *  konax.sensors.Data
 *  konax.sensors.DataListener
 *  konax.sensors.MeasurementRange
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.model.sensordata;

import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.Iterator;
import java.util.TreeMap;
import kona.logger.Log;
import konax.io.Connector;
import konax.sensors.Data;
import konax.sensors.DataListener;
import konax.sensors.MeasurementRange;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;

public abstract class CommonSensorModel
implements DataListener {
    protected final String SNA_STRING = "--";
    protected final double SNA_DBL_VAL = -54321.123;
    protected final int GFORCE_SNA = 1023;
    protected final Logger _logger = Log.createLogger((String)this.getClass().getName());
    protected String _sensorURL = null;
    protected SensorConnection _sensorConnection = null;
    protected double _sensorRawValue = -54321.123;
    protected double _minAnalogValue;
    protected double _maxAnalogValue;
    protected double _minMeasurementRange;
    protected double _maxMeasurementRange;
    protected boolean _valueChanged = false;
    protected boolean _stepIncrementRequired = false;
    protected TreeMap<Double, Double> _baseSegmentMap = null;
    protected final String SENSOR_PREFIX = "sensor:";
    protected final int SENSOR_BUFFER_SIZE = 1;
    protected static final GSkillsStateManager _stateManager_ = GSkillsStateManager.getInstance();

    public CommonSensorModel() {
        this.setSensorURL();
        this.openConnection();
        this.setInitialValue();
        this.setSensorAnalogRange();
    }

    protected abstract void setSensorURL();

    public abstract void setSensorAnalogRange();

    public synchronized double getRawValue() {
        return this._sensorRawValue;
    }

    public void pollAndSetRawData() {
        this.setRawValue(this.getRawData());
    }

    public double getUnifiedValue() {
        double unifiedValue = 0.0;
        double sensorValue = this.getValueForAnalogDisplay();
        if (-54321.123 != sensorValue) {
            if (this._stepIncrementRequired) {
                unifiedValue = this.getStepValue(this._sensorRawValue);
            } else if (sensorValue >= this._maxAnalogValue) {
                unifiedValue = 1.0;
            } else if (sensorValue >= this._minAnalogValue) {
                unifiedValue = (sensorValue - this._minAnalogValue) / (this._maxAnalogValue - this._minAnalogValue);
            }
        }
        return unifiedValue;
    }

    public final Data[] getRawData() {
        Data[] data = null;
        try {
            if (null == this._sensorConnection) {
                this.openConnection();
            }
            if (null != this._sensorConnection && 1 == this._sensorConnection.getState()) {
                data = this._sensorConnection.getData(1);
            }
        }
        catch (Exception e2) {
            e2.printStackTrace();
        }
        return data;
    }

    public void dataReceived(SensorConnection sensorConnection, Data[] data, boolean arg2) {
        this._logger.debug((Object)("Received data listener callback for sensor " + this.toString()));
        this.setRawValue(data);
    }

    protected synchronized void setRawValue(Data[] data) {
        int dataType;
        double sensorValue;
        if (null != data && CommonUtils.compareDbl(this._sensorRawValue, sensorValue = 2 == (dataType = data[0].getChannelInfo().getDataType()) ? (double)data[0].getIntValues()[0] : data[0].getDoubleValues()[0])) {
            this._valueChanged = true;
            this._sensorRawValue = sensorValue;
            this._logger.debug((Object)("Sensor " + this.toString() + " value set to " + this._sensorRawValue));
        }
    }

    public synchronized double getValueForAnalogDisplay() {
        this._valueChanged = false;
        double sensorValueForAnalogDisplay = -54321.123;
        if (this._sensorRawValue >= this._minMeasurementRange && this._sensorRawValue <= this._maxMeasurementRange) {
            sensorValueForAnalogDisplay = this.getRangeControlledValue();
        }
        return sensorValueForAnalogDisplay;
    }

    public synchronized String getValueForDigitalDisplay(boolean rangeControlRequired) {
        this._valueChanged = false;
        String sensorValue = "--";
        if (this._sensorRawValue >= this._minMeasurementRange && this._sensorRawValue <= this._maxMeasurementRange) {
            sensorValue = this.formatSensorValue(this.getUnitConvertedValue(rangeControlRequired ? this.getRangeControlledValue() : this._sensorRawValue));
        } else {
            this._logger.debug((Object)("Sensor " + this.toString() + " has invalid value. SENSOR_VAL:" + this._sensorRawValue + " MIN:" + this._minMeasurementRange + " MAX:" + this._maxMeasurementRange));
        }
        return sensorValue;
    }

    public synchronized String getValueForDigitalDisplay() {
        return this.getValueForDigitalDisplay(false);
    }

    protected double getRangeControlledValue() {
        double rangeControlledValue = this._sensorRawValue;
        if (this._sensorRawValue < this._minAnalogValue) {
            rangeControlledValue = this._minAnalogValue;
        } else if (this._sensorRawValue > this._maxAnalogValue) {
            rangeControlledValue = this._maxAnalogValue;
        }
        return rangeControlledValue;
    }

    protected double getRangeControlledValue(double sensorValue, double maxValue, double minValue) {
        double rangeControlledValue = sensorValue;
        if (sensorValue < minValue) {
            rangeControlledValue = minValue;
        } else if (sensorValue > maxValue) {
            rangeControlledValue = maxValue;
        }
        return rangeControlledValue;
    }

    protected double getUnitConvertedValue(double sensorValue) {
        return sensorValue;
    }

    protected String formatSensorValue(double sensorValue) {
        return Integer.toString((int)sensorValue);
    }

    public boolean hasSensorValueChanged() {
        return this._valueChanged;
    }

    public int getImageNumber(int maxImgCount) {
        double sensorValue = this.getValueForAnalogDisplay();
        int imageIndex = 1;
        if (-54321.123 != sensorValue) {
            if (sensorValue >= this._maxAnalogValue) {
                imageIndex = maxImgCount;
            } else if (sensorValue >= this._minAnalogValue) {
                double slotSize = (this._maxAnalogValue - this._minAnalogValue) / (double)maxImgCount;
                double imageIndexDbl = (sensorValue - this._minAnalogValue) / slotSize;
                imageIndex = (int)(imageIndexDbl + 1.0);
            }
        }
        return imageIndex;
    }

    private double getStepValue(double sensorValue) {
        double stepValueInPercent = 0.0;
        double x1 = 0.0;
        double x2 = 0.0;
        double y1 = 0.0;
        double y2 = 0.0;
        if (null != this._baseSegmentMap) {
            double denominator;
            Iterator<Double> iter = this._baseSegmentMap.keySet().iterator();
            while (iter.hasNext()) {
                x1 = x2;
                y1 = y2;
                x2 = iter.next();
                y2 = this._baseSegmentMap.get(new Double(x2));
                if (!(sensorValue <= x2)) continue;
            }
            if (CommonUtils.compareDbl(denominator = x2 - x1, 0.0)) {
                stepValueInPercent = y1 + (sensorValue - x1) * (y2 - y1) / denominator;
                if (stepValueInPercent > 1.0) {
                    stepValueInPercent = 1.0;
                }
                this._logger.debug((Object)("sensorVal:" + sensorValue + " x1:" + x1 + ", x2:" + x2 + ", y1:" + y1 * 100.0 + ", y2:" + y2 * 100.0 + " deflection:" + stepValueInPercent * 100.0 + "%"));
            }
        }
        return stepValueInPercent;
    }

    private final void openConnection() {
        if (this._sensorConnection == null && this._sensorURL != null) {
            try {
                this._sensorConnection = (SensorConnection)Connector.open((String)("sensor:" + this._sensorURL));
                this._logger.debug((Object)("Connection for sensor " + this._sensorURL + " opened"));
            }
            catch (Exception e2) {
                this._logger.error((Object)(this._sensorURL + e2));
                e2.printStackTrace();
            }
        }
    }

    private final void setInitialValue() {
        Data[] data = this.getRawData();
        if (null != data) {
            MeasurementRange range = data[0].getChannelInfo().getMeasurementRanges()[0];
            this._maxMeasurementRange = range.getLargestValue();
            this._minMeasurementRange = range.getSmallestValue();
            this._logger.debug((Object)("Sensor: " + this.toString() + " MIN:" + this._minMeasurementRange + " MAX:" + this._maxMeasurementRange));
            this.setRawValue(data);
        }
    }

    public final void registerListener() {
        if (null == this._sensorConnection) {
            this.openConnection();
        }
        if (null != this._sensorConnection && 1 == this._sensorConnection.getState()) {
            this._logger.debug((Object)("Setting data listener for sensor " + this.toString()));
            this._sensorConnection.setDataListener((DataListener)this, 1);
        }
    }

    public final void unregisterListener() {
        if (null != this._sensorConnection && 2 == this._sensorConnection.getState()) {
            this._logger.debug((Object)("Removing data listener for sensor " + this.toString()));
            this._sensorConnection.removeDataListener();
        }
    }

    public void closeSensorConnection() {
        if (this._sensorConnection != null) {
            try {
                if (this._sensorConnection.getState() != 4) {
                    this._logger.debug((Object)("Closing sensor " + this.toString()));
                    this._sensorConnection.close();
                }
                this._sensorConnection = null;
            }
            catch (Exception e2) {
                this._logger.debug((Object)(this.toString() + e2));
                e2.printStackTrace();
            }
        }
    }

    public String toString() {
        return this._sensorURL;
    }
}

