/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Display
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.controller;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.controller.RegisterUnregisterListeners;
import com.sprint.gskills.controller.SensorsManager;
import com.sprint.gskills.controller.ViewRefreshTimer;
import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.CommonTimerViewContainer;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.view.mainview.MainView;
import com.sun.lwuit.Display;
import edu.emory.mathcs.backport.java.util.concurrent.ExecutionException;
import edu.emory.mathcs.backport.java.util.concurrent.Future;
import edu.emory.mathcs.backport.java.util.concurrent.RejectedExecutionException;
import java.util.List;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsViewController {
    private static Logger logger = LoggerFactory.getLogger(GSkillsViewController.class);
    private static final GSkillsViewController INSTANCE = new GSkillsViewController();
    private GSkillsViewBuildFactory viewFactory = GSkillsViewBuildFactory.getInstance();
    private GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
    private MainView mainView = this.viewFactory.getMainView();
    private ViewRefreshTimer viewRefreshTimer = new ViewRefreshTimer();
    private RegisterUnregisterListeners registerUnregisterListenersCallable;
    private CommonUtils readWriteFromRMS;
    private Future regUnregFuture = null;

    private GSkillsViewController() {
    }

    public static GSkillsViewController getInstance() {
        return INSTANCE;
    }

    public void displayHomePage(Future initMainScreenFuture) {
        if (initMainScreenFuture != null) {
            try {
                this.readWriteFromRMS = (CommonUtils)initMainScreenFuture.get();
            }
            catch (InterruptedException e2) {
                logger.error((Object)"", (Throwable)e2);
            }
            catch (ExecutionException e3) {
                logger.error((Object)"", (Throwable)e3);
            }
        }
        if (Display.getInstance().isEdt()) {
            this.mainView.initializeHomePage(this.readWriteFromRMS);
        } else {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    GSkillsViewController.this.mainView.initializeHomePage(GSkillsViewController.this.readWriteFromRMS);
                }
            });
        }
        this.startThreadToRefreshView();
    }

    public void startThreadToRefreshView() {
        try {
            this.viewRefreshTimer.startTimer();
        }
        catch (RejectedExecutionException e2) {
            logger.error((Object)"RejectedExecutionException", (Throwable)e2);
        }
        catch (Throwable e3) {
            logger.error((Object)"submit new thread error", e3);
        }
    }

    public void stopViewRefreshThread() {
        try {
            this.viewRefreshTimer.stopTimer();
        }
        catch (Throwable e2) {
            logger.error((Object)"error stopping viewRefreshTimer thread", e2);
        }
    }

    public void destroyGskills() {
        logger.trace((Object)"In destroyGskillsViewController");
        try {
            this.getRegisterUnregisterListenersCallable().destroy();
            GSkillsProjectFactory.destroyDataListenersExecutor();
            GSkillsProjectFactory.destroyViewChangeExecutor();
            CommonTimerViewContainer usTimerContainer = (CommonTimerViewContainer)GSkillsViewBuildFactory.getInstance().getTimerContainer(0, TimersDisplayStatusEnum.CURRENT);
            usTimerContainer.stopTimerBlinkThread();
            CommonTimerViewContainer metricTimerContainer = (CommonTimerViewContainer)GSkillsViewBuildFactory.getInstance().getTimerContainer(1, TimersDisplayStatusEnum.CURRENT);
            metricTimerContainer.stopTimerBlinkThread();
        }
        catch (Exception e2) {
            logger.error((Object)"In destroyGskills() Error", (Throwable)e2);
        }
    }

    public void notifyDisplayViewChanged(int viewType) {
        if (null != this.getRegUnregFuture() && !this.getRegUnregFuture().isDone()) {
            logger.trace((Object)"***VPS*** - Register/Unregister of sensors is still in progress. Ignore this request.");
            return;
        }
        logger.trace((Object)"In notifyDisplayViewChanged() fucntion..");
        this.viewRefreshTimer.setRefreshView(false, null);
        this.stateManager.setCurrentView(viewType);
        if (viewType == 2) {
            this.viewFactory.getGForceView().updateViewOnThemeChanged(this.readWriteFromRMS.getCarThemeInRMS());
        }
        this.mainView.updateViewOnSelectedMenuChanged(viewType);
        this.getRegisterUnregisterListenersCallable().currentView(viewType);
        try {
            if (!GSkillsProjectFactory.getViewChangeExecutor().isTerminated()) {
                this.setRegUnregFuture(GSkillsProjectFactory.getViewChangeExecutor().submit(this.getRegisterUnregisterListenersCallable()));
            } else {
                logger.trace((Object)"View Change Executor is terminated");
            }
        }
        catch (Exception e2) {
            logger.error((Object)"NOT ENOUGH THREADS. Exception:in notifyDisplayViewChanged() ", (Throwable)e2);
            e2.printStackTrace();
        }
    }

    public void notifyDisplayViewChanged(TimersDisplayStatusEnum timerType) {
        this.mainView.updateRightScreen(timerType);
    }

    public void notifyLanguageChanged(String languageName) {
        CommonViewResourceManager.getInstance().setCurrentLanguage(languageName);
        this.localizeGSkillPages();
    }

    private void localizeGSkillPages() {
        Display.getInstance().callSerially(new Runnable(){

            public void run() {
                try {
                    GSkillsViewController.this.viewFactory.getMainMenuView().updateOnLanguageChanged();
                    List<Integer> lanChangeableViewList = GSkillsViewController.this.viewFactory.getLanguageChangeableViewList();
                    if (lanChangeableViewList.contains(GSkillsViewController.this.stateManager.getCurrentView())) {
                        ((GSkillsViewDataListener)GSkillsViewController.this.viewFactory.getViewByCode(GSkillsViewController.this.stateManager.getCurrentView())).updateViewOnLanguageChanged();
                    }
                    for (int viewIndex = 0; viewIndex < lanChangeableViewList.size(); ++viewIndex) {
                        if (lanChangeableViewList.get(viewIndex).intValue() == GSkillsViewController.this.stateManager.getCurrentView()) continue;
                        ((GSkillsViewDataListener)GSkillsViewController.this.viewFactory.getViewByCode(lanChangeableViewList.get(viewIndex))).updateViewOnLanguageChanged();
                    }
                }
                catch (Exception ex) {
                    logger.error((Object)"Update view on language changed error: ", (Throwable)ex);
                }
            }
        });
    }

    public void notifyUnitChanged(final int currentView) {
        Display.getInstance().callSerially(new Runnable(){

            public void run() {
                List<Integer> unitChangeableViewList = GSkillsViewController.this.viewFactory.getUnitChangeableViewList();
                if (currentView == 1) {
                    GSkillsViewController.this.notifyDisplayViewChanged(1);
                } else if (unitChangeableViewList.contains(GSkillsViewController.this.stateManager.getCurrentView())) {
                    ((GSkillsViewDataListener)GSkillsViewController.this.viewFactory.getViewByCode(GSkillsViewController.this.stateManager.getCurrentView())).updateViewOnUnitChanged();
                    GSkillsDataModelFactory.getSensorDataModel().setViewOrUnitHasChanged(true);
                    ((GSkillsViewDataListener)GSkillsViewController.this.viewFactory.getViewByCode(GSkillsViewController.this.stateManager.getCurrentView())).updateViewOnDataChanged();
                    GSkillsDataModelFactory.getSensorDataModel().setViewOrUnitHasChanged(false);
                }
                for (int viewIndex = 0; viewIndex < GSkillsViewController.this.viewFactory.getUnitChangeableViewList().size(); ++viewIndex) {
                    if (unitChangeableViewList.get(viewIndex).intValue() == GSkillsViewController.this.stateManager.getCurrentView()) continue;
                    ((GSkillsViewDataListener)GSkillsViewController.this.viewFactory.getViewByCode(unitChangeableViewList.get(viewIndex))).updateViewOnUnitChanged();
                }
            }
        });
    }

    public void pause() {
        this.stopViewRefreshThread();
        this.getRegisterUnregisterListenersCallable().pause();
    }

    public void resumeApplication() {
        if (SensorsManager.getInstance().hasHULanguageChanged()) {
            this.localizeGSkillPages();
        }
        CommonTimerViewContainer usTimerContainer = (CommonTimerViewContainer)GSkillsViewBuildFactory.getInstance().getTimerContainer(0, TimersDisplayStatusEnum.CURRENT);
        usTimerContainer.startTimersBlinkThread();
        CommonTimerViewContainer metricTimerContainer = (CommonTimerViewContainer)GSkillsViewBuildFactory.getInstance().getTimerContainer(1, TimersDisplayStatusEnum.CURRENT);
        metricTimerContainer.startTimersBlinkThread();
        this.getRegisterUnregisterListenersCallable().resumeApplication(this.stateManager);
    }

    public void init() {
        this.setRegisterUnregisterListenersCallable(new RegisterUnregisterListeners(this));
    }

    public void resetRefreshView() {
        logger.trace((Object)"reset refresh view");
        int currentView = this.stateManager.getCurrentView();
        switch (currentView) {
            case 2: {
                this.viewRefreshTimer.setRefreshView(true, this.viewFactory.getViewByCode(currentView));
                break;
            }
            case 3: 
            case 4: {
                this.viewRefreshTimer.setRefreshView(true, this.viewFactory.getViewByCode(currentView));
                break;
            }
            case 5: {
                this.viewRefreshTimer.setRefreshView(true, this.viewFactory.getViewByCode(currentView));
                break;
            }
            default: {
                this.viewRefreshTimer.setRefreshView(false, null);
            }
        }
    }

    public void notifyDisplayViewChanged(TimerSaveOptionsEnum timerSaveType) {
        this.mainView.updateRightScreen(timerSaveType);
    }

    public RegisterUnregisterListeners getRegisterUnregisterListenersCallable() {
        return this.registerUnregisterListenersCallable;
    }

    public void setRegisterUnregisterListenersCallable(RegisterUnregisterListeners registerUnregisterListenersCallable) {
        this.registerUnregisterListenersCallable = registerUnregisterListenersCallable;
    }

    public Future getRegUnregFuture() {
        return this.regUnregFuture;
    }

    public void setRegUnregFuture(Future regUnregFuture) {
        this.regUnregFuture = regUnregFuture;
    }
}

