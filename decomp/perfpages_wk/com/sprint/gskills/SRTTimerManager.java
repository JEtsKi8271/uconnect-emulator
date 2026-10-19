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
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import kona.logger.Log;
import kona.performancesrt.PerformanceSRTManager;
import net.sf.microlog.core.Logger;

public class SRTTimerManager {
    private Logger _logger = Log.createLogger((String)this.getClass().getName());
    private Future _registerTimersFuture = null;
    private CurrentTimerModel _currentTimerModel = CurrentTimerModel.getInstance();
    private LastTimerModel _lastTimerModel = LastTimerModel.getInstance();
    private BestTimerModel _bestTimerModel = BestTimerModel.getInstance();
    private static final SRTTimerManager INSTANCE = new SRTTimerManager();

    private SRTTimerManager() {
    }

    public static SRTTimerManager getInstance() {
        return INSTANCE;
    }

    public synchronized void updateTimersOnUnitChange() {
        this._logger.debug((Object)"updateTimersOnUnitChange() called");
        this._currentTimerModel.updateSRTAttributesOnUnitChange();
        this._lastTimerModel.updateSRTAttributesOnUnitChange();
        this._bestTimerModel.updateSRTAttributesOnUnitChange();
        this.registerTimerAttributes();
    }

    private void registerTimerAttributes() {
        try {
            if (null != this._registerTimersFuture) {
                this._logger.debug((Object)"Cancelling the timers registration thread");
                this._registerTimersFuture.cancel(true);
                this._registerTimersFuture = null;
            }
            if (!(this._currentTimerModel.areAllTimersRegistered() && this._lastTimerModel.areAllTimersRegistered() && this._bestTimerModel.areAllTimersRegistered())) {
                this._registerTimersFuture = GSkillsThreadManager.getInstance().submit(new GSkillsRunnableWithErrorHandler(new RegisterTimersRunnable()));
            }
        }
        catch (Throwable e2) {
            e2.printStackTrace();
        }
    }

    public void destroy() {
        PerformanceSRTManager.getInstance().removeALLPerformanceSRTListeners();
    }

    class RegisterTimersRunnable
    extends GSkillsRunnable {
        private volatile boolean _keepTaskAlive = true;

        RegisterTimersRunnable() {
        }

        public void run() {
            SRTTimerManager.this._logger.debug((Object)"Starting the timers registration thread");
            while (!(!this._keepTaskAlive || SRTTimerManager.this._currentTimerModel.areAllTimersRegistered() && SRTTimerManager.this._lastTimerModel.areAllTimersRegistered() && SRTTimerManager.this._bestTimerModel.areAllTimersRegistered())) {
                try {
                    SRTTimerManager.this._logger.debug((Object)"****************************************");
                    SRTTimerManager.this._logger.debug((Object)"ATTEMPTING TO REGISTER TIMER ATTRIBUTES");
                    SRTTimerManager.this._logger.debug((Object)"****************************************");
                    if (!SRTTimerManager.this._currentTimerModel.areAllTimersRegistered() && this._keepTaskAlive) {
                        SRTTimerManager.this._logger.debug((Object)"\n******* CURRENT ********* ");
                        SRTTimerManager.this._currentTimerModel.registerTimerAttributes();
                    }
                    if (!SRTTimerManager.this._lastTimerModel.areAllTimersRegistered() && this._keepTaskAlive) {
                        SRTTimerManager.this._logger.debug((Object)"\n******* LAST ********* ");
                        SRTTimerManager.this._lastTimerModel.registerTimerAttributes();
                    }
                    if (!SRTTimerManager.this._bestTimerModel.areAllTimersRegistered() && this._keepTaskAlive) {
                        SRTTimerManager.this._logger.debug((Object)"\n******* BEST ********* ");
                        SRTTimerManager.this._bestTimerModel.registerTimerAttributes();
                    }
                    Thread.sleep(ResKeyPropertiesFactory.getDelayedTimerRegisterRetryTime() * 1000);
                }
                catch (InterruptedException e2) {
                    SRTTimerManager.this._logger.debug((Object)"Thread interrupted. Stopping the timers registration thread");
                    this._keepTaskAlive = false;
                }
                catch (Exception e3) {
                    SRTTimerManager.this._logger.debug((Object)"Something went wrong. Stopping the timers registration thread");
                    e3.printStackTrace();
                    this._keepTaskAlive = false;
                }
            }
            SRTTimerManager.this._logger.debug((Object)"Timers registration thread stopped");
        }
    }
}

