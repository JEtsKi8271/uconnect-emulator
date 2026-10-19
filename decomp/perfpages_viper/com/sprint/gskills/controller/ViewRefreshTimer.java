/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sun.lwuit.Container;
import edu.emory.mathcs.backport.java.util.concurrent.atomic.AtomicBoolean;
import java.util.Timer;
import java.util.TimerTask;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

class ViewRefreshTimer {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private AtomicBoolean refreshView;
    private Container currentView = null;
    private long currentTime;
    private Timer refreshViewTimer;
    private int viewRefreshRate = ResKeyPropertiesFactory.getViewRefreshFrequency();
    private long timeTORepaintPreviousView = 0L;

    ViewRefreshTimer() {
        this.refreshView = new AtomicBoolean(false);
    }

    public void startTimer() {
        this.refreshViewTimer = new Timer();
        this.currentTime = System.currentTimeMillis();
        RefreshViewTimerTask refreshViewTimerTask = new RefreshViewTimerTask();
        this.refreshViewTimer.scheduleAtFixedRate((TimerTask)refreshViewTimerTask, 0L, (long)this.viewRefreshRate);
    }

    protected void setRefreshView(boolean refreshRequired, Container currentView2) {
        if (refreshRequired) {
            GSkillsDataModelFactory.getSensorDataModel().setViewOrUnitHasChanged(true);
            this.currentView = currentView2;
            ((GSkillsViewDataListener)this.currentView).updateViewOnDataChanged();
            GSkillsDataModelFactory.getSensorDataModel().setViewOrUnitHasChanged(false);
            this.currentTime = System.currentTimeMillis();
        }
        this.refreshView.set(refreshRequired);
    }

    protected void stopTimer() {
        try {
            if (this.refreshViewTimer != null) {
                this.refreshViewTimer.cancel();
                if (this.logger.isDebugEnabled()) {
                    this.logger.debug((Object)"stopTimer successful");
                }
            }
        }
        catch (Exception e2) {
            this.logger.error((Object)"", (Throwable)e2);
        }
    }

    private class RefreshViewTimerTask
    extends TimerTask {
        private RefreshViewTimerTask() {
        }

        public void run() {
            try {
                if (ViewRefreshTimer.this.refreshView.get() && ViewRefreshTimer.this.currentView != null) {
                    ViewRefreshTimer.this.currentTime = System.currentTimeMillis();
                    if (ViewRefreshTimer.this.timeTORepaintPreviousView < 500L) {
                        ((GSkillsViewDataListener)ViewRefreshTimer.this.currentView).updateViewOnDataChanged();
                    } else if (ViewRefreshTimer.this.logger.isDebugEnabled()) {
                        // empty if block
                    }
                    ViewRefreshTimer.this.timeTORepaintPreviousView = System.currentTimeMillis() - ViewRefreshTimer.this.currentTime;
                }
            }
            catch (Throwable e2) {
                ViewRefreshTimer.this.logger.error((Object)"", e2);
            }
        }
    }
}

