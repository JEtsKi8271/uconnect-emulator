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
package com.sprint.gskills.model;

import com.sprint.gskills.factory.GSkillsPerformanceSRTData;
import com.sprint.gskills.model.CommonTimerModel;
import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.model.PerformanceSRTAttributesEnum;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
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

public abstract class CommonTimerModelImpl
implements GSkillsDataModel,
PerformanceSRTListener,
CommonTimerModel {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private GSkillsViewDataListener timerView;
    protected DecimalFormat decimalFormat = new DecimalFormat("#0.0");
    protected String modelName;
    protected Map<Integer, PerformanceSRTData> performanceSRTAttributesToValue = new HashMap<Integer, PerformanceSRTData>();
    protected ArrayList<Integer> unregisteredSRTAttributes = new ArrayList();

    protected abstract void initializeAttributeToListenTo();

    public abstract String getZeroToSixtyValue();

    public abstract String getEighthEValue();

    public abstract String getEighthMphValue();

    public abstract String getQuarterEtValue();

    public abstract String getQuarterMphValue();

    public abstract String getBrakeDistValue();

    public abstract String getBrakeSpeedValue();

    public String getModelName() {
        return this.modelName;
    }

    public CommonTimerModelImpl(String modelName) {
        this.initializeAttributeToListenTo();
        this.unregisteredSRTAttributes.addAll(this.performanceSRTAttributesToValue.keySet());
        this.modelName = modelName;
    }

    public boolean registerListenerForAttributes() {
        boolean allTimerAttributesRegistered = true;
        Iterator<Integer> unregisteredSRTAttributesIter = this.unregisteredSRTAttributes.iterator();
        PerformanceSRTManager performanceSRTManager = PerformanceSRTManager.getInstance();
        while (unregisteredSRTAttributesIter.hasNext()) {
            int performanceSRTAttribute = unregisteredSRTAttributesIter.next();
            String performanceSRTAttributeName = PerformanceSRTAttributesEnum.getName(performanceSRTAttribute);
            try {
                this.setInitialTimerValue(performanceSRTAttribute);
                performanceSRTManager.registerPerformanceSRTListener(performanceSRTAttribute, (PerformanceSRTListener)this);
                this.logger.debug((Object)("Successfully registered the timer attribute " + performanceSRTAttributeName + ". Removing it from the list"));
                unregisteredSRTAttributesIter.remove();
            }
            catch (PerformanceException e2) {
                this.logger.error((Object)("Failed to register listener - " + performanceSRTAttributeName + " with PerformanceException: " + (Object)((Object)e2)));
                allTimerAttributesRegistered = false;
            }
        }
        this.notifyListeners(this, false);
        return allTimerAttributesRegistered;
    }

    public void unregisterListenerForAttributes() {
        try {
            PerformanceSRTManager performanceSRTManager = PerformanceSRTManager.getInstance();
            for (int performanceSRTAttribute : this.performanceSRTAttributesToValue.keySet()) {
                performanceSRTManager.removePerformanceSRTListener(performanceSRTAttribute);
            }
            this.logger.debug((Object)"unregistered listener");
        }
        catch (Exception e2) {
            this.logger.error((Object)("failed to unregister " + e2));
        }
    }

    public void setListener(GSkillsViewDataListener viewListener) {
        this.timerView = viewListener;
        this.notifyListeners(this, false);
    }

    public void removeViewListener() {
        this.timerView = null;
    }

    public void onPerformanceDataUpdate(PerformanceSRTData performanceSRTData) {
        if (performanceSRTData.getDataType() == 0) {
            this.logger.debug((Object)("received " + PerformanceSRTAttributesEnum.getName(performanceSRTData.getAttribute()) + " " + performanceSRTData.getIntValue()));
        } else {
            this.logger.debug((Object)("received " + PerformanceSRTAttributesEnum.getName(performanceSRTData.getAttribute()) + " " + performanceSRTData.getDoubleValue()));
        }
        int performanceSRTAttribute = performanceSRTData.getAttribute();
        if (this.performanceSRTAttributesToValue.containsKey(performanceSRTAttribute)) {
            if (performanceSRTData.getDataType() == 0) {
                int timerValue = performanceSRTData.getIntValue();
                this.performanceSRTAttributesToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
            } else {
                double timerValue = performanceSRTData.getDoubleValue();
                this.performanceSRTAttributesToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
            }
            this.notifyListeners(this, true);
        } else {
            this.logger.error((Object)("Not a valid PerformanceSRTAttributes " + performanceSRTData.getAttribute()));
        }
    }

    private void setInitialTimerValue(int performanceSRTAttribute) throws PerformanceException {
        PerformanceSRTData performanceSRTData = PerformanceSRTManager.getInstance().getPerformanceData(performanceSRTAttribute);
        if (performanceSRTData.getDataType() == 0) {
            int timerValue = performanceSRTData.getIntValue();
            this.performanceSRTAttributesToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
            this.logger.debug((Object)("*****<" + PerformanceSRTAttributesEnum.getName(performanceSRTAttribute) + " , " + timerValue + ">*****"));
        } else {
            double timerValue = performanceSRTData.getDoubleValue();
            this.performanceSRTAttributesToValue.put(performanceSRTAttribute, GSkillsPerformanceSRTData.createGSkillsPerformanceSRTData(performanceSRTAttribute, timerValue));
            this.logger.debug((Object)("*****<" + PerformanceSRTAttributesEnum.getName(performanceSRTAttribute) + " , " + timerValue + ">*****"));
        }
    }

    protected String convertYardtoFeet(String brakeDist) {
        int yardValue = Integer.parseInt(brakeDist);
        return String.valueOf(yardValue *= 3);
    }

    private void notifyListeners(GSkillsDataModel gskillsDataModel, boolean saveToRMS) {
        new Thread(new NotifyViewListenersAndSaveToRMS(gskillsDataModel)).start();
    }

    private class NotifyViewListenersAndSaveToRMS
    implements Runnable {
        GSkillsDataModel timerModelListenerImpl;

        public NotifyViewListenersAndSaveToRMS(GSkillsDataModel timerModelListenerImpl) {
            this.timerModelListenerImpl = timerModelListenerImpl;
        }

        public void run() {
            if (CommonTimerModelImpl.this.timerView != null) {
                CommonTimerModelImpl.this.timerView.onNotifyDataChange(this.timerModelListenerImpl);
            }
        }
    }
}

