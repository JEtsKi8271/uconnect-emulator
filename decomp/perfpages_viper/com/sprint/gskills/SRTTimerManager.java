/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  kona.performancesrt.PerformanceSRTManager
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills;

import com.sprint.gskills.common.GSkillsException;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.model.CommonTimerModelImpl;
import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import kona.logger.Log;
import kona.performancesrt.PerformanceSRTManager;
import net.sf.microlog.core.Logger;

public class SRTTimerManager {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private static final SRTTimerManager INSTANCE = new SRTTimerManager();
    private GSkillsDataModelFactory gskillsDataModelFactory = GSkillsDataModelFactory.getInstance();
    private Set<GSkillsDataModel> unregisteredUSTimersSet = new HashSet<GSkillsDataModel>();
    private Set<GSkillsDataModel> unregisteredMetricTimersSet = new HashSet<GSkillsDataModel>();

    private SRTTimerManager() {
    }

    public static SRTTimerManager getInstance() {
        return INSTANCE;
    }

    public void init() throws GSkillsException {
        try {
            this.unregisteredUSTimersSet.add(this.gskillsDataModelFactory.initializeCurrentTimerUSModel());
            this.unregisteredUSTimersSet.add(this.gskillsDataModelFactory.initializeLastTimerUSModel());
            this.unregisteredUSTimersSet.add(this.gskillsDataModelFactory.initializeBestTimerUSModel());
            this.unregisteredMetricTimersSet.add(this.gskillsDataModelFactory.initializeCurrentTimerMetricModel());
            this.unregisteredMetricTimersSet.add(this.gskillsDataModelFactory.initializeBestTimerMetricModel());
            this.unregisteredMetricTimersSet.add(this.gskillsDataModelFactory.initializeLastTimerMetricModel());
            this.registerAllTimerListener();
        }
        catch (Throwable e2) {
            throw new GSkillsException(e2);
        }
    }

    public void pause() {
        this.gskillsDataModelFactory.getTimerModelListener(0, TimersDisplayStatusEnum.CURRENT).removeViewListener();
        this.gskillsDataModelFactory.getTimerModelListener(0, TimersDisplayStatusEnum.LAST).removeViewListener();
        this.gskillsDataModelFactory.getTimerModelListener(0, TimersDisplayStatusEnum.BEST).removeViewListener();
        this.gskillsDataModelFactory.getTimerModelListener(1, TimersDisplayStatusEnum.CURRENT).removeViewListener();
        this.gskillsDataModelFactory.getTimerModelListener(1, TimersDisplayStatusEnum.LAST).removeViewListener();
        this.gskillsDataModelFactory.getTimerModelListener(1, TimersDisplayStatusEnum.BEST).removeViewListener();
    }

    private void registerAllTimerListener() {
        new Thread(new Runnable(){

            public void run() {
                while (!SRTTimerManager.this.unregisteredUSTimersSet.isEmpty() || !SRTTimerManager.this.unregisteredMetricTimersSet.isEmpty()) {
                    CommonTimerModelImpl timerModel;
                    Iterator iter;
                    if (0 == GSkillsStateManager.getInstance().getCurrentUnit()) {
                        if (!SRTTimerManager.this.unregisteredUSTimersSet.isEmpty()) {
                            iter = SRTTimerManager.this.unregisteredUSTimersSet.iterator();
                            while (iter.hasNext()) {
                                timerModel = (CommonTimerModelImpl)iter.next();
                                SRTTimerManager.this.logger.debug((Object)("********** Attempting to register " + timerModel.getModelName() + " ************"));
                                if (!timerModel.registerListenerForAttributes()) continue;
                                SRTTimerManager.this.logger.debug((Object)("********** Successfully registered " + timerModel.getModelName() + " ************"));
                                iter.remove();
                            }
                        }
                    } else if (!SRTTimerManager.this.unregisteredMetricTimersSet.isEmpty()) {
                        iter = SRTTimerManager.this.unregisteredMetricTimersSet.iterator();
                        while (iter.hasNext()) {
                            timerModel = (CommonTimerModelImpl)iter.next();
                            SRTTimerManager.this.logger.debug((Object)("********** Attempting to register " + timerModel.getModelName() + " ************"));
                            if (!timerModel.registerListenerForAttributes()) continue;
                            SRTTimerManager.this.logger.debug((Object)("********** Successfully registered " + timerModel.getModelName() + " ************"));
                            iter.remove();
                        }
                    }
                    try {
                        Thread.sleep(ResKeyPropertiesFactory.getTimersRegisterRetryTime() * 1000);
                    }
                    catch (InterruptedException e2) {
                        e2.printStackTrace();
                    }
                }
                SRTTimerManager.this.logger.debug((Object)"***** Exiting the timers registration thread *****");
            }
        }).start();
    }

    public void destroy() {
        PerformanceSRTManager.getInstance().removeALLPerformanceSRTListeners();
    }
}

