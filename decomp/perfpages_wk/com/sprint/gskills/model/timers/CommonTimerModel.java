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
import com.sprint.gskills.model.timers.TimerAttribute;
import com.sprint.gskills.unit.DistanceUnitEnum;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.util.GSkillsLogger;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.text.DecimalFormat;
import java.util.Collection;
import java.util.HashMap;
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
    protected Map<Integer, TimerAttribute> _performanceSRTAttribEnumMap = new HashMap<Integer, TimerAttribute>();
    private final String _timerModelName;
    private boolean _speedMPHDistMileRegistered = false;
    private boolean _speedKMPHDistKMRegistered = false;
    private boolean _speedMPHDistKMRegistered = false;
    private boolean _speedKMPHDistMileRegistered = false;
    protected boolean _hasValueChanged = false;
    protected boolean _isMY16Vehicle = false;
    public static final int SRT_REACT_TIME = 0;
    public static final int SRT_60MPH_TIME = 1;
    public static final int SRT_100MPH_TIME = 2;
    public static final int SRT_ETH_TIME = 3;
    public static final int SRT_ETH_SPD = 4;
    public static final int SRT_QRT_TIME = 5;
    public static final int SRT_QRT_SPD = 6;
    public static final int SRT_60FT_TIME = 7;
    public static final int SRT_BRK_DIST = 8;
    public static final int SRT_BRK_SPD = 9;
    protected Map<Integer, TimerAttribute> _timersSpeedKMPHDistMile = new HashMap<Integer, TimerAttribute>();
    protected Map<Integer, TimerAttribute> _timersSpeedMPHDistMile = new HashMap<Integer, TimerAttribute>();
    protected Map<Integer, TimerAttribute> _timersSpeedKMPHDistKM = new HashMap<Integer, TimerAttribute>();
    protected Map<Integer, TimerAttribute> _timersSpeedMPHDistKM = new HashMap<Integer, TimerAttribute>();

    protected abstract void initializeAttributeToListenTo();

    public CommonTimerModel(String timerModelName) {
        this._timerModelName = timerModelName;
        if (!GSkillsStateManager.getInstance().isLSeriesVehicle()) {
            this._isMY16Vehicle = true;
        }
        this.initializeAttributeToListenTo();
    }

    public String toString() {
        return this._timerModelName;
    }

    public void onPerformanceDataUpdate(PerformanceSRTData performanceSRTData) {
        GSkillsThreadManager.getInstance().execute(new GSkillsRunnableWithErrorHandler(new NotifyOnPerformanceDataChange(performanceSRTData)));
    }

    public boolean hasTimerValueChanged() {
        return this._hasValueChanged;
    }

    public void resetChangeFlag() {
        this._hasValueChanged = false;
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

    public void updateSRTAttributesOnUnitChange() {
        SpeedUnitEnum speedUnit = GSkillsStateManager.getInstance().getSpeedUnit();
        DistanceUnitEnum distanceUnit = GSkillsStateManager.getInstance().getDistanceUnit();
        if (SpeedUnitEnum.KMPH == speedUnit) {
            if (this._isMY16Vehicle && DistanceUnitEnum.MILES == distanceUnit) {
                this._performanceSRTAttribEnumMap.putAll(this._timersSpeedKMPHDistMile);
            } else {
                this._performanceSRTAttribEnumMap.putAll(this._timersSpeedKMPHDistKM);
            }
        } else if (this._isMY16Vehicle && DistanceUnitEnum.KM == distanceUnit) {
            this._performanceSRTAttribEnumMap.putAll(this._timersSpeedMPHDistKM);
        } else {
            this._performanceSRTAttribEnumMap.putAll(this._timersSpeedMPHDistMile);
        }
        this._hasValueChanged = true;
    }

    public String getReactionTimeValue() {
        return this._hundredthsPlaceFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(0).getTimerAttribute()).getDoubleValue());
    }

    public String getZeroToSixtyValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(1).getTimerAttribute()).getDoubleValue());
    }

    public String getZeroToHundredValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(2).getTimerAttribute()).getDoubleValue());
    }

    public String getEighthEValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(3).getTimerAttribute()).getDoubleValue());
    }

    public String getEighthMphValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(4).getTimerAttribute()).getIntValue());
    }

    public String getQuarterEtValue() {
        return this._decimalFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(5).getTimerAttribute()).getDoubleValue());
    }

    public String getQuarterMphValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(6).getTimerAttribute()).getIntValue());
    }

    public String getSixtyFeetValue() {
        return this._hundredthsPlaceFormat.format(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(7).getTimerAttribute()).getDoubleValue());
    }

    public String getBrakeDistValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(8).getTimerAttribute()).getIntValue());
    }

    public String getBrakeSpeedValue() {
        return Integer.toString(this._performanceSRTAttribToValue.get(this._performanceSRTAttribEnumMap.get(9).getTimerAttribute()).getIntValue());
    }

    protected void addAttributeToMap(int attribute) {
        this._performanceSRTAttribToValue.put(attribute, GSkillsPerformanceSRTData.getDefaultPerformanceSRTData(attribute));
    }

    public void registerTimerAttributes() {
        SpeedUnitEnum speedUnit = GSkillsStateManager.getInstance().getSpeedUnit();
        DistanceUnitEnum distanceUnit = GSkillsStateManager.getInstance().getDistanceUnit();
        if (SpeedUnitEnum.MPH == speedUnit) {
            if (this._isMY16Vehicle && DistanceUnitEnum.KM == distanceUnit) {
                if (this.registerTimerAttributes(this._timersSpeedMPHDistKM.values())) {
                    this._speedMPHDistKMRegistered = true;
                    this._logger.debug((Object)"Speed MPH, Distance KM timers registered");
                }
            } else if (this.registerTimerAttributes(this._timersSpeedMPHDistMile.values())) {
                this._speedMPHDistMileRegistered = true;
                this._logger.debug((Object)"Speed MPH, Distance Mile timers registered");
            }
        } else if (this._isMY16Vehicle && DistanceUnitEnum.MILES == distanceUnit) {
            if (this.registerTimerAttributes(this._timersSpeedKMPHDistMile.values())) {
                this._speedKMPHDistMileRegistered = true;
                this._logger.debug((Object)"Speed KMPH, Distance Mile timers registered");
            }
        } else if (this.registerTimerAttributes(this._timersSpeedKMPHDistKM.values())) {
            this._speedKMPHDistKMRegistered = true;
            this._logger.debug((Object)"Speed KMPH, Distance KM timers registered");
        }
    }

    private boolean registerTimerAttributes(Collection<TimerAttribute> timerAttributes) {
        boolean allTimerAttributesRegistered = true;
        boolean timerAttributesRegistered = false;
        PerformanceSRTManager performanceSRTManager = PerformanceSRTManager.getInstance();
        for (TimerAttribute timerAttribute : timerAttributes) {
            if (timerAttribute.isTimerAttributeRegistered()) continue;
            int performanceSRTAttribute = timerAttribute.getTimerAttribute();
            String performanceSRTAttributeName = PerformanceSRTAttributesEnum.getName(performanceSRTAttribute);
            try {
                this.setInitialTimerValue(performanceSRTAttribute);
                timerAttribute.setTimerAttributeRegistered();
                timerAttributesRegistered = true;
                performanceSRTManager.registerPerformanceSRTListener(performanceSRTAttribute, (PerformanceSRTListener)this);
                GSkillsLogger.debug("Successfully registered the timer attribute " + performanceSRTAttributeName);
            }
            catch (PerformanceException e2) {
                this._logger.debug((Object)("Failed to register attribute - " + performanceSRTAttributeName + " with PerformanceException: " + (Object)((Object)e2)));
                allTimerAttributesRegistered = false;
            }
            catch (Exception e3) {
                this._logger.debug((Object)("Failed to register attribute - " + performanceSRTAttributeName + " with exception: " + e3));
                allTimerAttributesRegistered = false;
            }
        }
        if (timerAttributesRegistered) {
            this._hasValueChanged = true;
        }
        return allTimerAttributesRegistered;
    }

    public boolean areAllTimersRegistered() {
        boolean timersRegistered = false;
        SpeedUnitEnum speedUnit = GSkillsStateManager.getInstance().getSpeedUnit();
        DistanceUnitEnum distanceUnit = GSkillsStateManager.getInstance().getDistanceUnit();
        if (SpeedUnitEnum.MPH == speedUnit) {
            if (this._isMY16Vehicle) {
                if (DistanceUnitEnum.KM == distanceUnit && this._speedMPHDistKMRegistered || DistanceUnitEnum.MILES == distanceUnit && this._speedMPHDistMileRegistered) {
                    timersRegistered = true;
                }
            } else if (this._speedMPHDistMileRegistered) {
                timersRegistered = true;
            }
        } else if (this._isMY16Vehicle) {
            if (DistanceUnitEnum.KM == distanceUnit && this._speedKMPHDistKMRegistered || DistanceUnitEnum.MILES == distanceUnit && this._speedKMPHDistMileRegistered) {
                timersRegistered = true;
            }
        } else if (this._speedKMPHDistKMRegistered) {
            timersRegistered = true;
        }
        return timersRegistered;
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

