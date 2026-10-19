/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  kona.performancesrt.PerformanceException
 *  kona.performancesrt.PerformanceSRTData
 *  kona.performancesrt.PerformanceSRTListener
 *  kona.performancesrt.PerformanceSRTManager
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.model.timers;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsRunnableWithErrorHandler;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.factory.GSkillsPerformanceSRTData;
import com.sprint.gskills.model.timers.PerformanceSRTAttributesEnum;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.util.GSkillsLogger;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import kona.logger.Log;
import kona.performancesrt.PerformanceException;
import kona.performancesrt.PerformanceSRTData;
import kona.performancesrt.PerformanceSRTListener;
import kona.performancesrt.PerformanceSRTManager;
import net.sf.microlog.core.Logger;

/*
 * This class specifies class file version 49.0 but uses Java 6 signatures.  Assumed Java 6.
 */
public abstract class CommonTimerModel
implements PerformanceSRTListener {
    private Logger _logger = Log.createLogger((String)this.getClass().getName());
    protected DecimalFormat _decimalFormat = new DecimalFormat("#0.0");
    protected DecimalFormat _hundredthsPlaceFormat = new DecimalFormat("#0.00");
    protected Map<Integer, PerformanceSRTData> _performanceSRTAttribToValue = new HashMap<Integer, PerformanceSRTData>();
    protected Map<Integer, Integer> _performanceSRTAttribEnumMap = new HashMap<Integer, Integer>();
    protected ArrayList<Integer> _unregisteredUSTimers = null;
    protected ArrayList<Integer> _unregisteredMetricTimers = null;
    protected boolean _initialTimersSet = false;
    private final String _timerModelName;
    private boolean _usTimersRegistered = false;
    private boolean _metricTimersRegistered = false;
    protected boolean _hasValueChanged = false;
    protected boolean _is60ftTimerAvailable = false;
    public static final int SRT_REACTTM = 0;
    public static final int SRT_60MPHTM = 1;
    public static final int SRT_100MPHTM = 2;
    public static final int SRT_EIGHTHTM = 3;
    public static final int SRT_ETHSPD = 4;
    public static final int SRT_QUARTERTM = 5;
    public static final int SRT_QRTSPD = 6;
    public static final int SRT_60FTTM = 7;
    public static final int SRT_BRKDIST = 8;
    public static final int SRT_BRKSPD = 9;

    protected abstract void initializeAttributeToListenTo();

    protected abstract void updateSRTAttributesOnUnitChange();

    public CommonTimerModel(String timerModelName) {
        this._timerModelName = timerModelName;
        if (!GSkillsStateManager.getInstance().isLSeriesVehicle()) {
            this._is60ftTimerAvailable = true;
        }
        this.initializeAttributeToListenTo();
    }

    public String toString() {
        return this._timerModelName;
    }

    private boolean usTimerAttributesRegistered() {
        return SpeedUnitEnum.MPH == GSkillsStateManager.getInstance().getSpeedUnit() && this._usTimersRegistered;
    }

    private boolean metricTimerAttributesRegistered() {
        return SpeedUnitEnum.KMPH == GSkillsStateManager.getInstance().getSpeedUnit() && this._metricTimersRegistered;
    }

    public boolean timersNotRegistered() {
        return false == this.metricTimerAttributesRegistered() && false == this.usTimerAttributesRegistered();
    }

    public boolean registerTimerAttributes() {
        SpeedUnitEnum speedUnit = GSkillsStateManager.getInstance().getSpeedUnit();
        if (SpeedUnitEnum.MPH == speedUnit) {
            return this.registerTimerAttributes(this._unregisteredUSTimers);
        }
        return this.registerTimerAttributes(this._unregisteredMetricTimers);
    }

    private boolean registerTimerAttributes(ArrayList<Integer> unregisteredTimerAttributes) {
        boolean allTimerAttributesRegistered = true;
        boolean timerAttributeRegistered = false;
        int performanceSRTAttribute = 0;
        PerformanceSRTManager performanceSRTManager = PerformanceSRTManager.getInstance();
        Iterator<Integer> unregisteredSRTAttributesIter = unregisteredTimerAttributes.iterator();
        while (unregisteredSRTAttributesIter.hasNext()) {
            performanceSRTAttribute = unregisteredSRTAttributesIter.next();
            String performanceSRTAttributeName = PerformanceSRTAttributesEnum.getName(performanceSRTAttribute);
            try {
                this.setInitialTimerValue(performanceSRTAttribute);
                timerAttributeRegistered = true;
                performanceSRTManager.registerPerformanceSRTListener(performanceSRTAttribute, (PerformanceSRTListener)this);
                GSkillsLogger.debug("Successfully registered the timer attribute " + performanceSRTAttributeName + ". Removing it from the list");
                unregisteredSRTAttributesIter.remove();
            }
            catch (PerformanceException e2) {
                GSkillsLogger.debug("Failed to register listener - " + performanceSRTAttributeName + " with PerformanceException: " + (Object)((Object)e2));
                allTimerAttributesRegistered = false;
            }
            catch (Exception e3) {
                GSkillsLogger.debug("Failed to register listener - " + performanceSRTAttributeName + " with exception: " + e3);
                this._logger.debug((Object)("The listener - " + performanceSRTAttributeName + " is not supported by the firmware. Removing it from the list"));
                unregisteredSRTAttributesIter.remove();
            }
        }
        if (allTimerAttributesRegistered) {
            this.setTimerAttributesRegComplete();
        }
        if (timerAttributeRegistered) {
            this._hasValueChanged = true;
        }
        return allTimerAttributesRegistered;
    }

    private void setTimerAttributesRegComplete() {
        this._logger.debug((Object)"=====================================================================================");
        if (SpeedUnitEnum.KMPH == GSkillsStateManager.getInstance().getSpeedUnit()) {
            this._logger.debug((Object)("********** " + this._timerModelName + ": Metric timers attributes registration complete ***********"));
            this._metricTimersRegistered = true;
        } else {
            this._logger.debug((Object)("*********** " + this._timerModelName + ":US timers attributes registration complete ***********"));
            this._usTimersRegistered = true;
        }
        this._logger.debug((Object)"=====================================================================================");
    }

    public void onPerformanceDataUpdate(PerformanceSRTData performanceSRTData) {
        GSkillsThreadManager.getInstance().execute(new GSkillsRunnableWithErrorHandler(new NotifyOnPerformanceDataChange(performanceSRTData)));
    }

    public boolean hasTimerValueChanged() {
        return this._hasValueChanged;
    }

    private void setInitialTimerValue(int performanceSRTAttribute) throws PerformanceException {
        PerformanceSRTData performanceSRTData = PerformanceSRTManager.getInstance().getPerformanceData(performanceSRTAttribute);
        if (performanceSRTData.getDataType() == 0) {
            int timerValue = performanceSRTData.getIntValue();
            this._performanceSRTAttribToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
            GSkillsLogger.debug("*****<" + PerformanceSRTAttributesEnum.getName(performanceSRTAttribute) + " , " + timerValue + ">*****");
        } else {
            double timerValue = performanceSRTData.getDoubleValue();
            this._performanceSRTAttribToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
            GSkillsLogger.debug("*****<" + PerformanceSRTAttributesEnum.getName(performanceSRTAttribute) + " , " + timerValue + ">*****");
        }
    }

    public void resetChangeFlag() {
        this._hasValueChanged = false;
    }

    public String getReactionTimeValue() {
        return this._hundredthsPlaceFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(0)).getDoubleValue());
    }

    public String getZeroToSixtyValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(1)).getDoubleValue());
    }

    public String getZeroToHundredValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(2)).getDoubleValue());
    }

    public String getEighthEValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(3)).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(4)).getIntValue());
    }

    public String getQuarterEtValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(5)).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(6)).getIntValue());
    }

    public String getSixtyFeetValue() {
        return this._hundredthsPlaceFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(7)).getDoubleValue());
    }

    public String getBrakeDistValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(8)).getIntValue());
    }

    public String getBrakeSpeedValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(9)).getIntValue());
    }

    protected void addAttributeToMap(int attribute) {
        this._performanceSRTAttribToValue.put(attribute, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(attribute));
    }

    class NotifyOnPerformanceDataChange
    extends GSkillsRunnable {
        private PerformanceSRTData _performanceSRTData;

        public NotifyOnPerformanceDataChange(PerformanceSRTData performanceSRTData) {
            super("NotifyOnPerformanceDataChange");
            this._performanceSRTData = performanceSRTData;
        }

        public void run() {
            int performanceSRTAttribute = this._performanceSRTData.getAttribute();
            if (this._performanceSRTData.getDataType() == 0) {
                CommonTimerModel.this._logger.debug((Object)("received " + PerformanceSRTAttributesEnum.getName(performanceSRTAttribute) + ":" + performanceSRTAttribute + " " + this._performanceSRTData.getIntValue()));
            } else {
                CommonTimerModel.this._logger.debug((Object)("received " + PerformanceSRTAttributesEnum.getName(performanceSRTAttribute) + ":" + performanceSRTAttribute + " " + this._performanceSRTData.getDoubleValue()));
            }
            if (CommonTimerModel.this._performanceSRTAttribToValue.containsKey(performanceSRTAttribute)) {
                if (this._performanceSRTData.getDataType() == 0) {
                    int timerValue = this._performanceSRTData.getIntValue();
                    CommonTimerModel.this._performanceSRTAttribToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
                } else {
                    double timerValue = this._performanceSRTData.getDoubleValue();
                    CommonTimerModel.this._performanceSRTAttribToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
                }
                CommonTimerModel.this._hasValueChanged = true;
            } else {
                CommonTimerModel.this._logger.error((Object)("Not a valid PerformanceSRTAttributes " + this._performanceSRTData.getAttribute()));
            }
        }
    }
}

