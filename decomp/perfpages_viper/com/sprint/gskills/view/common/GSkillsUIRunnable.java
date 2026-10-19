/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.SRTTimerManager;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.InitializeHomePageCallable;
import com.sprint.gskills.view.common.StartGSkillsCallable;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsUIRunnable
implements Runnable {
    Logger logger = Log.createLogger((String)"GSkillsUIRunnable");
    private GSkillsViewController viewController = GSkillsViewController.getInstance();

    public GSkillsUIRunnable() {
        this.viewController.init();
    }

    public void run() {
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        int pauseState = stateManager.getCurrentRunningState();
        if (pauseState < 1) {
            Future initMainScreenFuture = GSkillsProjectFactory.getInitializeApplicationExecutor().submit(new InitializeHomePageCallable());
            GSkillsProjectFactory.getInitializeApplicationExecutor().submit(new StartGSkillsCallable());
            this.viewController.displayHomePage(initMainScreenFuture);
            stateManager.setCurrentRunningState(1);
        } else {
            this.viewController.startThreadToRefreshView();
            this.viewController.notifyDisplayViewChanged(stateManager.getCurrentView());
        }
        this.viewController.resumeApplication();
    }

    public void destroyUIRunnable() {
        this.onPauseXlet();
        SRTTimerManager.getInstance().destroy();
        this.viewController.destroyGskills();
    }

    public void onPauseXlet() {
        SRTTimerManager.getInstance().pause();
        this.viewController.pause();
    }
}

