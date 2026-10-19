/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.concurrency;

import com.sprint.gskills.concurrency.GSkillsCallable;
import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsScheduledThreadPoolExecutor;
import com.sprint.gskills.concurrency.GSkillsThreadPoolExecutor;
import com.sprint.gskills.concurrency.GSkillsThreadStatusMonitor;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import edu.emory.mathcs.backport.java.util.concurrent.ScheduledFuture;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsThreadManager {
    private Logger _logger = Log.createLogger((String)this.getClass().getName());
    public static final int THREAD_POOL_SIZE = 5;
    public static final int PERIODIC_THREAD_POOL_SIZE = 1;
    public static final int MAX_THREAD_POOL_SIZE = 25;
    private static final GSkillsThreadManager INSTANCE = new GSkillsThreadManager();
    private Future _threadMonitorFuture = null;

    private GSkillsThreadManager() {
        this._logger.debug((Object)"Creating GSkillsThreadManager");
    }

    public void startThreadMonitor() {
        this._logger.debug((Object)"Starting GSkillsThreadStatusMonitor task......");
        this._threadMonitorFuture = this.submit(GSkillsThreadStatusMonitor.getInstance());
    }

    public static GSkillsThreadManager getInstance() {
        return INSTANCE;
    }

    public void execute(GSkillsRunnable runObject) {
        GSkillsThreadPoolExecutor.getInstance().execute(runObject);
    }

    public Future submit(GSkillsRunnable runObject) {
        return GSkillsThreadPoolExecutor.getInstance().submit(runObject);
    }

    public Future submit(GSkillsCallable callObject) {
        return GSkillsThreadPoolExecutor.getInstance().submit(callObject);
    }

    public ScheduledFuture scheduleAtFixedRate(GSkillsRunnable runObject, long period) {
        return GSkillsScheduledThreadPoolExecutor.getInstance().scheduleAtFixedRate(runObject, 0L, period, TimeUnit.MILLISECONDS);
    }

    public int getActiveThreadCount() {
        return GSkillsThreadPoolExecutor.getInstance().getActiveCount();
    }

    public int getHighestThreadCount() {
        return GSkillsThreadPoolExecutor.getInstance().getLargestPoolSize();
    }

    public int getCurrentPoolSize() {
        return GSkillsThreadPoolExecutor.getInstance().getPoolSize();
    }

    public long getTotalThreadCount() {
        return GSkillsThreadPoolExecutor.getInstance().getTaskCount();
    }

    public long getCompletedThreadCount() {
        return GSkillsThreadPoolExecutor.getInstance().getCompletedTaskCount();
    }

    public int getCalculatedThreadCount() {
        return GSkillsThreadPoolExecutor.getInstance().getCalculatedTaskCount();
    }

    public int getActivePeriodicThreadCount() {
        return GSkillsScheduledThreadPoolExecutor.getInstance().getActiveCount();
    }

    public int getHighestPeriodicThreadCount() {
        return GSkillsScheduledThreadPoolExecutor.getInstance().getLargestPoolSize();
    }

    public int getCurrentPeriodicPoolSize() {
        return GSkillsScheduledThreadPoolExecutor.getInstance().getPoolSize();
    }

    public long getTotalPeriodicThreadCount() {
        return GSkillsScheduledThreadPoolExecutor.getInstance().getTaskCount();
    }

    public long getCompletedPeriodicThreadCount() {
        return GSkillsScheduledThreadPoolExecutor.getInstance().getCompletedTaskCount();
    }

    public int getCalculatedPeriodicThreadCount() {
        return GSkillsScheduledThreadPoolExecutor.getInstance().getCalculatedTaskCount();
    }

    public void destroy() {
        this._threadMonitorFuture.cancel(true);
        GSkillsThreadPoolExecutor.getInstance().shutdownNow();
        GSkillsScheduledThreadPoolExecutor.getInstance().shutdownNow();
    }
}

