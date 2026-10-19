/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.concurrency;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import edu.emory.mathcs.backport.java.util.concurrent.atomic.AtomicBoolean;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsThreadStatusMonitor
extends GSkillsRunnable {
    Logger logger = Log.createLogger((String)this.getClass().getName());
    private static final GSkillsThreadStatusMonitor INSTANCE = new GSkillsThreadStatusMonitor("GSkillsThreadStatusMonitor");
    private volatile AtomicBoolean continueRun = new AtomicBoolean(true);

    private GSkillsThreadStatusMonitor(String threadName) {
        super(threadName);
    }

    public static GSkillsThreadStatusMonitor getInstance() {
        return INSTANCE;
    }

    private void stopThread() {
        this.continueRun.set(false);
    }

    public void run() {
        this.logger.debug((Object)"GSkillsThreadStatusMonitor task started");
        GSkillsThreadManager ex = GSkillsThreadManager.getInstance();
        while (this.continueRun.get()) {
            try {
                this.logger.debug((Object)("Thread status - Active:" + ex.getActiveThreadCount() + ", InPool:" + ex.getCurrentPoolSize() + ", Calculated:" + ex.getCalculatedThreadCount() + ", Highest:" + ex.getHighestThreadCount()));
                this.logger.debug((Object)("Periodic threads status - Active:" + ex.getActivePeriodicThreadCount() + ", InPool:" + ex.getCurrentPeriodicPoolSize() + ", Calculated:" + ex.getCalculatedPeriodicThreadCount() + ", Highest:" + ex.getHighestPeriodicThreadCount()));
                Thread.sleep(60000L);
            }
            catch (InterruptedException e2) {
                this.logger.debug((Object)"Thread monitor task interrupted");
                this.stopThread();
            }
        }
        this.logger.debug((Object)"Exiting the thread monitor task");
    }
}

