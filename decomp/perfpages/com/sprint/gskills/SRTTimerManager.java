/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  kona.performancesrt.PerformanceSRTManager
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsRunnableWithErrorHandler;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.model.timers.BestTimerModel;
import com.sprint.gskills.model.timers.CurrentTimerModel;
import com.sprint.gskills.model.timers.LastTimerModel;
import com.sprint.gskills.util.GSkillsLogger;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import kona.logger.Log;
import kona.performancesrt.PerformanceSRTManager;
import net.sf.microlog.core.Logger;

public class SRTTimerManager {
    private Logger _logger = Log.createLogger((String)this.getClass().getName());
    private Future _reRegisterTimersFuture = null;
    private CurrentTimerModel _currentTimerModel = CurrentTimerModel.getInstance();
    private LastTimerModel _lastTimerModel = LastTimerModel.getInstance();
    private BestTimerModel _bestTimerModel = BestTimerModel.getInstance();
    private static final SRTTimerManager INSTANCE = new SRTTimerManager();

    private SRTTimerManager() {
    }

    public static SRTTimerManager getInstance() {
        return INSTANCE;
    }

    public void updateTimersOnUnitChange() {
        this._logger.debug((Object)"updateTimersOnUnitChange() called");
        this._currentTimerModel.updateSRTAttributesOnUnitChange();
        this._lastTimerModel.updateSRTAttributesOnUnitChange();
        this._bestTimerModel.updateSRTAttributesOnUnitChange();
        this.registerTimerAttributes();
    }

    public void registerTimerAttributes() {
        try {
            if (null != this._reRegisterTimersFuture && !this._reRegisterTimersFuture.isDone()) {
                GSkillsLogger.debug("Cancelling the timers re-registration thread");
                this._reRegisterTimersFuture.cancel(true);
                this._reRegisterTimersFuture = null;
            }
            this._reRegisterTimersFuture = GSkillsThreadManager.getInstance().submit(new GSkillsRunnableWithErrorHandler(new ReRegisterTimerAttributesRunnable("ReRegisterTimersThread")));
        }
        catch (Throwable e2) {
            e2.printStackTrace();
        }
    }

    public void destroy() {
        PerformanceSRTManager.getInstance().removeALLPerformanceSRTListeners();
    }

    class ReRegisterTimerAttributesRunnable
    extends GSkillsRunnable {
        public ReRegisterTimerAttributesRunnable(String name) {
            super(name);
        }

        public void run() {
            SRTTimerManager.this._logger.debug((Object)"Starting the timers re-registration thread");
            boolean keepThreadAlive = true;
            while (keepThreadAlive && (SRTTimerManager.this._currentTimerModel.timersNotRegistered() || SRTTimerManager.this._lastTimerModel.timersNotRegistered() || SRTTimerManager.this._bestTimerModel.timersNotRegistered())) {
                try {
                    if (SRTTimerManager.this._currentTimerModel.timersNotRegistered()) {
                        SRTTimerManager.this._logger.debug((Object)"******************* Trying to re-register CURRENT timer attributes ******************** ");
                        SRTTimerManager.this._currentTimerModel.registerTimerAttributes();
                    }
                    if (SRTTimerManager.this._lastTimerModel.timersNotRegistered()) {
                        SRTTimerManager.this._logger.debug((Object)"******************* Trying to re-register LAST timer attributes ******************** ");
                        SRTTimerManager.this._lastTimerModel.registerTimerAttributes();
                    }
                    if (SRTTimerManager.this._bestTimerModel.timersNotRegistered()) {
                        SRTTimerManager.this._logger.debug((Object)"******************* Trying to re-register BEST timer attributes ********************* ");
                        SRTTimerManager.this._bestTimerModel.registerTimerAttributes();
                    }
                    Thread.sleep(ResKeyPropertiesFactory.getDelayedTimerRegisterRetryTime() * 1000);
                }
                catch (InterruptedException e2) {
                    SRTTimerManager.this._logger.debug((Object)"Timers re-registration thread interrupted. Stopping the thread");
                    keepThreadAlive = false;
                }
            }
            SRTTimerManager.this._logger.debug((Object)"Timers re-registration thread stopped");
        }
    }
}

