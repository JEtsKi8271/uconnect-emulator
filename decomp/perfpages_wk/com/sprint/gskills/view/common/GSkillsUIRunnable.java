/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.SRTTimerManager;
import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsRunnableWithErrorHandler;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.constants.GSkillsRunningStateEnum;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.LoadGSkillsResFilesRunnable;
import com.sprint.gskills.view.mainview.MainView;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsUIRunnable
extends GSkillsRunnable {
    private static final GSkillsUIRunnable INSTANCE = new GSkillsUIRunnable();
    private Logger _logger = Log.createLogger((String)this.getClass().getName());

    private GSkillsUIRunnable() {
    }

    public static GSkillsUIRunnable getInstance() {
        return INSTANCE;
    }

    public void run() {
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        GSkillsViewController viewController = GSkillsViewController.getInstance();
        if (stateManager.getCurrentRunningState() != GSkillsRunningStateEnum.POST_INIT) {
            this._logger.debug((Object)"INIT:Displaying the splash screen now");
            MainView.getInstance().showSplashScreen();
            GSkillsThreadManager.getInstance().submit(new GSkillsRunnableWithErrorHandler(LoadGSkillsResFilesRunnable.getInstance()));
            LoadGSkillsResFilesRunnable.getInstance().waitForResourcesToLoad();
            this._logger.debug((Object)"INIT:Displaying the home screen now");
            MainView.getInstance().displayHomePage();
            stateManager.setCurrentRunningState(GSkillsRunningStateEnum.POST_INIT);
        } else {
            viewController.notifyDisplayViewChanged(stateManager.getCurrentView());
        }
        viewController.resumeApplication();
    }

    public void destroyUIRunnable() {
        this.onPauseXlet();
        SRTTimerManager.getInstance().destroy();
        GSkillsViewController.getInstance().destroyGSkills();
    }

    public void onPauseXlet() {
        GSkillsViewController.getInstance().pause();
    }
}

