/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Display
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.controller.RegisterUnregisterListeners;
import com.sprint.gskills.model.sensordata.SensorPollManager;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.mainview.MainMenuView;
import com.sprint.gskills.view.mainview.MainView;
import com.sun.lwuit.Display;
import java.util.List;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsViewController {
    private final Logger _logger = Log.createLogger((String)this.getClass().getName());
    private static final GSkillsViewController INSTANCE = new GSkillsViewController();
    private GSkillsViewBuildFactory _viewFactory = GSkillsViewBuildFactory.getInstance();
    private GSkillsStateManager _stateManager = GSkillsStateManager.getInstance();
    private MainView _mainView = MainView.getInstance();

    private GSkillsViewController() {
    }

    public static GSkillsViewController getInstance() {
        return INSTANCE;
    }

    public void destroyGSkills() {
        this._logger.trace((Object)"In destroyGskillsViewController");
        try {
            RegisterUnregisterListeners.getInstance().destroy();
        }
        catch (Exception e2) {
            this._logger.error((Object)"In destroyGskills() Error", (Throwable)e2);
        }
    }

    public void notifyDisplayViewChanged(ViewEnum viewType) {
        this._stateManager.setCurrentView(viewType);
        this._mainView.updateViewOnSelectedMenuChanged(viewType);
        RegisterUnregisterListeners.getInstance().currentView(viewType);
        SensorPollManager.getInstance().currentView(viewType);
        RegisterUnregisterListeners.getInstance().regUnregSensorListeners();
    }

    public void notifyDisplayViewChanged() {
        this._mainView.updateRightScreen();
    }

    public void localizeGSkillPages() {
        Display.getInstance().callSerially((Runnable)new UpdateViewsOnLanguageChangeRunnable());
        this._stateManager.forceUpdateAllUnits();
        Display.getInstance().callSerially((Runnable)new UpdateViewsOnUnitChangeRunnable());
    }

    public void notifyUnitChanged() {
        Display.getInstance().callSerially((Runnable)new UpdateViewsOnUnitChangeRunnable());
        Display.getInstance().callSerially((Runnable)new UpdateViewsOnLanguageChangeRunnable());
    }

    public void pause() {
        RegisterUnregisterListeners.getInstance().pause();
    }

    public void resumeApplication() {
        RegisterUnregisterListeners.getInstance().resumeApplication();
    }

    public void notifyDisplayViewChanged(TimerSaveOptionsEnum timerSaveType) {
        this._mainView.updateRightScreen(timerSaveType);
    }

    private class UpdateViewsOnLanguageChangeRunnable
    extends GSkillsRunnable {
        private UpdateViewsOnLanguageChangeRunnable() {
        }

        public void run() {
            MainMenuView.getInstance().updateOnLanguageChanged();
            List<ViewEnum> lanChangeableViewList = GSkillsViewController.this._viewFactory.getLanguageChangeableViewList();
            for (int viewIndex = 0; viewIndex < lanChangeableViewList.size(); ++viewIndex) {
                GSkillsViewController.this._viewFactory.getViewByCode(lanChangeableViewList.get(viewIndex)).notifyLanguageChanged();
            }
        }
    }

    private class UpdateViewsOnUnitChangeRunnable
    extends GSkillsRunnable {
        private UpdateViewsOnUnitChangeRunnable() {
        }

        public void run() {
            List<ViewEnum> unitChangeableViewList = GSkillsViewController.this._viewFactory.getUnitChangeableViewList();
            for (int viewIndex = 0; viewIndex < unitChangeableViewList.size(); ++viewIndex) {
                GSkillsViewController.this._viewFactory.getViewByCode(unitChangeableViewList.get(viewIndex)).notifyUnitChanged();
            }
        }
    }
}

