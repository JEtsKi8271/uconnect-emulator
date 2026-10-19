/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.BestTimerMetricViewListener;
import com.sprint.gskills.view.BestTimerUSViewListener;
import com.sprint.gskills.view.CommonTimerViewContainer;
import com.sprint.gskills.view.CurrentTimerMetricViewListener;
import com.sprint.gskills.view.CurrentTimerUSViewListener;
import com.sprint.gskills.view.LastTimerMetricViewListener;
import com.sprint.gskills.view.LastTimerUSViewListener;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.view.enginepage.EngineView;
import com.sprint.gskills.view.gaugespage.GaugesOneView;
import com.sprint.gskills.view.gaugespage.GaugesTwoViewForJeep;
import com.sprint.gskills.view.gaugespage.GaugesTwoViewForViper;
import com.sprint.gskills.view.gforcehandlingpage.GForceView;
import com.sprint.gskills.view.homepage.HomeView;
import com.sprint.gskills.view.mainview.MainMenuView;
import com.sprint.gskills.view.mainview.MainTitleView;
import com.sprint.gskills.view.mainview.MainView;
import com.sprint.gskills.view.optionspage.OptionsView;
import com.sprint.gskills.view.timerview.TimerOkButtonContainer;
import com.sprint.gskills.view.timerview.TimerSaveButtonContainer;
import com.sprint.gskills.view.timerview.TimerTypeButtonsContainer;
import com.sun.lwuit.Container;
import java.util.ArrayList;
import java.util.List;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

/*
 * This class specifies class file version 49.0 but uses Java 6 signatures.  Assumed Java 6.
 */
public class GSkillsViewBuildFactory {
    private Logger logger = Log.createLogger((String)"GSkillsViewBuildFactory");
    private static GSkillsViewBuildFactory INSTANCE = new GSkillsViewBuildFactory();
    private static MainView mainView = new MainView(INSTANCE);
    private CommonUtils readWriteToRMS = CommonUtils.getInstance();
    private GSkillsViewController viewController = null;
    private MainMenuView mainMenuView = null;
    private HomeView homeView = null;
    private GForceView gForceView = null;
    private GaugesOneView gaugesOneView = null;
    private GaugesTwoViewForJeep gaugesTwoViewForJeep = null;
    private GaugesTwoViewForViper gaugesTwoViewForViper = null;
    private EngineView engineView = null;
    private OptionsView optionsView = null;
    private List<Integer> languageChangeableViewList = null;
    private List<Integer> unitChangeableViewList = null;
    private Boolean hasGforceProcessed = false;
    private Boolean hasGaugeOneProcessed = false;
    private Boolean hasGaugeTwoProcessed = false;
    private Boolean hasEngineProcessed = false;
    private TimerSaveButtonContainer timerSaveButtonContainer;
    private TimerOkButtonContainer timerOkButtonContainer;
    private TimerOkButtonContainer timerCancelButtonContainer;
    private GSkillsViewDataListener currentTimerUSView;
    private GSkillsViewDataListener lastTimerUSView;
    private GSkillsViewDataListener bestTimerUSView;
    private GSkillsViewDataListener currentTimerMetricView;
    private GSkillsViewDataListener lastTimerMetricView;
    private GSkillsViewDataListener bestTimerMetricView;
    private final Object monitorObject = new Object();

    private GSkillsViewBuildFactory() {
        this.languageChangeableViewList = new ArrayList<Integer>();
        this.unitChangeableViewList = new ArrayList<Integer>();
    }

    public static GSkillsViewBuildFactory getInstance() {
        return INSTANCE;
    }

    public MainView getMainView() {
        return mainView;
    }

    public MainMenuView getMainMenuView() {
        if (this.mainMenuView == null) {
            this.mainMenuView = new MainMenuView();
        }
        return this.mainMenuView;
    }

    public MainTitleView getMainTitleView() {
        return new MainTitleView();
    }

    private HomeView getHomeView() {
        if (this.homeView == null) {
            this.homeView = new HomeView();
        }
        return this.homeView;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public GForceView getGForceView() {
        Boolean bl2 = this.hasGforceProcessed;
        synchronized (bl2) {
            if (!this.hasGforceProcessed.booleanValue() && this.gForceView == null) {
                this.hasGforceProcessed = true;
                if (null == this.readWriteToRMS) {
                    this.waitForInitToComplete();
                }
                this.gForceView = new GForceView(this.readWriteToRMS.getCarThemeInRMS());
                this.languageChangeableViewList.add(2);
                this.unitChangeableViewList.add(2);
            }
        }
        return this.gForceView;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private GaugesOneView getGaugesOneView() {
        Boolean bl2 = this.hasGaugeOneProcessed;
        synchronized (bl2) {
            if (!this.hasGaugeOneProcessed.booleanValue() && this.gaugesOneView == null) {
                this.hasGaugeOneProcessed = true;
                this.gaugesOneView = new GaugesOneView();
                this.languageChangeableViewList.add(3);
                this.unitChangeableViewList.add(3);
            }
        }
        return this.gaugesOneView;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private GaugesTwoViewForJeep getGaugesTwoViewForJeep() {
        Boolean bl2 = this.hasGaugeTwoProcessed;
        synchronized (bl2) {
            if (!this.hasGaugeTwoProcessed.booleanValue() && this.gaugesTwoViewForJeep == null) {
                this.hasGaugeTwoProcessed = true;
                this.gaugesTwoViewForJeep = new GaugesTwoViewForJeep();
                this.languageChangeableViewList.add(4);
                this.unitChangeableViewList.add(4);
            }
        }
        return this.gaugesTwoViewForJeep;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private GaugesTwoViewForViper getGaugesTwoViewForViper() {
        Boolean bl2 = this.hasGaugeTwoProcessed;
        synchronized (bl2) {
            if (!this.hasGaugeTwoProcessed.booleanValue() && this.gaugesTwoViewForViper == null) {
                this.hasGaugeTwoProcessed = true;
                this.gaugesTwoViewForViper = new GaugesTwoViewForViper();
                this.languageChangeableViewList.add(4);
                this.unitChangeableViewList.add(4);
            }
        }
        return this.gaugesTwoViewForViper;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private EngineView getEngineView() {
        Boolean bl2 = this.hasEngineProcessed;
        synchronized (bl2) {
            if (!this.hasEngineProcessed.booleanValue() && this.engineView == null) {
                this.hasEngineProcessed = true;
                this.engineView = new EngineView();
                this.engineView.initView();
                this.languageChangeableViewList.add(5);
                this.unitChangeableViewList.add(5);
            }
        }
        return this.engineView;
    }

    private OptionsView getOptionsView() {
        if (this.optionsView == null) {
            if (null == this.readWriteToRMS) {
                this.waitForInitToComplete();
            }
            this.optionsView = new OptionsView(this.readWriteToRMS);
            this.languageChangeableViewList.add(7);
        }
        return this.optionsView;
    }

    public Container getViewByCode(int IntViewType) {
        Container currentView = null;
        switch (IntViewType) {
            case 0: {
                currentView = this.getHomeView();
                break;
            }
            case 1: {
                currentView = this.getTimerContainer(GSkillsStateManager.getInstance().getCurrentUnit(), GSkillsStateManager.getInstance().getTimersType());
                break;
            }
            case 2: {
                currentView = this.getGForceView();
                break;
            }
            case 3: {
                currentView = this.getGaugesOneView();
                break;
            }
            case 4: {
                if (1 == GSkillsStateManager.getInstance().getVehicleLine()) {
                    currentView = this.getGaugesTwoViewForJeep();
                    break;
                }
                currentView = this.getGaugesTwoViewForViper();
                break;
            }
            case 5: {
                currentView = this.getEngineView();
                break;
            }
            case 7: {
                currentView = this.getOptionsView();
                break;
            }
            case 8: {
                return (Container)this.getBestTimerUSView();
            }
            case 9: {
                return (Container)this.getLastTimerUSView();
            }
            case 10: {
                return (Container)this.getCurrentTimerUSView();
            }
            case 11: {
                return (Container)this.getBestTimerMetricView();
            }
            case 12: {
                return (Container)this.getLastTimerMetricView();
            }
            case 13: {
                return (Container)this.getCurrentTimerMetricView();
            }
            default: {
                this.logger.trace((Object)"not a valid selection");
                currentView = this.getHomeView();
            }
        }
        return currentView;
    }

    public Container getTimerContainer(int unit, TimersDisplayStatusEnum timerType) {
        Container timerContainer = null;
        if (unit == 0) {
            if (timerType == TimersDisplayStatusEnum.CURRENT) {
                timerContainer = (Container)this.getCurrentTimerUSView();
            } else if (timerType == TimersDisplayStatusEnum.LAST) {
                timerContainer = (Container)this.getLastTimerUSView();
            } else if (timerType == TimersDisplayStatusEnum.BEST) {
                timerContainer = (Container)this.getBestTimerUSView();
            }
        } else if (unit == 1) {
            if (timerType == TimersDisplayStatusEnum.CURRENT) {
                timerContainer = (Container)this.getCurrentTimerMetricView();
            } else if (timerType == TimersDisplayStatusEnum.LAST) {
                timerContainer = (Container)this.getLastTimerMetricView();
            } else if (timerType == TimersDisplayStatusEnum.BEST) {
                timerContainer = (Container)this.getBestTimerMetricView();
            }
        }
        GSkillsDataModelFactory.getInstance().getTimerModelListener(unit, timerType).setListener((GSkillsViewDataListener)timerContainer);
        return timerContainer;
    }

    public Container getTimerContainer(TimerSaveOptionsEnum timerSaveOption) {
        Container timerContainer = null;
        timerContainer = this.getViewByCode(1);
        ((CommonTimerViewContainer)timerContainer).updateDialogAndButtons(timerSaveOption);
        return timerContainer;
    }

    private void initTimerButtonConatiners() {
        if (this.timerOkButtonContainer == null) {
            this.timerOkButtonContainer = new TimerOkButtonContainer(mainView, TimerSaveOptionsEnum.OK);
        }
        if (this.timerCancelButtonContainer == null) {
            this.timerCancelButtonContainer = new TimerOkButtonContainer(mainView, TimerSaveOptionsEnum.CANCEL);
        }
        if (this.timerSaveButtonContainer == null) {
            this.timerSaveButtonContainer = new TimerSaveButtonContainer(mainView);
        }
        if (this.viewController == null) {
            this.viewController = GSkillsViewController.getInstance();
        }
    }

    private GSkillsViewDataListener getBestTimerUSView() {
        if (this.bestTimerUSView == null) {
            this.initTimerButtonConatiners();
            this.bestTimerUSView = new BestTimerUSViewListener(new TimerTypeButtonsContainer(this.viewController), this.timerSaveButtonContainer, this.timerOkButtonContainer, this.timerCancelButtonContainer);
            this.languageChangeableViewList.add(8);
        }
        return this.bestTimerUSView;
    }

    private GSkillsViewDataListener getLastTimerUSView() {
        if (this.lastTimerUSView == null) {
            this.initTimerButtonConatiners();
            this.lastTimerUSView = new LastTimerUSViewListener(new TimerTypeButtonsContainer(this.viewController), this.timerSaveButtonContainer, this.timerOkButtonContainer, this.timerCancelButtonContainer);
            this.languageChangeableViewList.add(9);
        }
        return this.lastTimerUSView;
    }

    public List<Integer> getLanguageChangeableViewList() {
        return this.languageChangeableViewList;
    }

    public List<Integer> getUnitChangeableViewList() {
        return this.unitChangeableViewList;
    }

    private GSkillsViewDataListener getCurrentTimerUSView() {
        if (this.currentTimerUSView == null) {
            this.initTimerButtonConatiners();
            this.currentTimerUSView = new CurrentTimerUSViewListener(new TimerTypeButtonsContainer(this.viewController), this.timerSaveButtonContainer, this.timerOkButtonContainer, this.timerCancelButtonContainer);
            this.languageChangeableViewList.add(10);
        }
        return this.currentTimerUSView;
    }

    private GSkillsViewDataListener getBestTimerMetricView() {
        if (this.bestTimerMetricView == null) {
            this.initTimerButtonConatiners();
            this.bestTimerMetricView = new BestTimerMetricViewListener(new TimerTypeButtonsContainer(this.viewController), this.timerSaveButtonContainer, this.timerOkButtonContainer, this.timerCancelButtonContainer);
            this.languageChangeableViewList.add(11);
        }
        return this.bestTimerMetricView;
    }

    private GSkillsViewDataListener getLastTimerMetricView() {
        if (this.lastTimerMetricView == null) {
            this.initTimerButtonConatiners();
            this.lastTimerMetricView = new LastTimerMetricViewListener(new TimerTypeButtonsContainer(this.viewController), this.timerSaveButtonContainer, this.timerOkButtonContainer, this.timerCancelButtonContainer);
            this.languageChangeableViewList.add(12);
        }
        return this.lastTimerMetricView;
    }

    private GSkillsViewDataListener getCurrentTimerMetricView() {
        if (this.currentTimerMetricView == null) {
            this.initTimerButtonConatiners();
            this.currentTimerMetricView = new CurrentTimerMetricViewListener(new TimerTypeButtonsContainer(this.viewController), this.timerSaveButtonContainer, this.timerOkButtonContainer, this.timerCancelButtonContainer);
            this.languageChangeableViewList.add(13);
        }
        return this.currentTimerMetricView;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void init() {
        this.logger.trace((Object)"***VPS***: init() - Inside init().");
        Object object = this.monitorObject;
        synchronized (object) {
            this.monitorObject.notifyAll();
        }
        this.logger.trace((Object)"***VPS***: init() - readWriteToRMS set complete. Signalling the completion");
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    private void waitForInitToComplete() {
        Object object = this.monitorObject;
        synchronized (object) {
            try {
                while (null == this.readWriteToRMS) {
                    this.logger.trace((Object)"***VPS***: waitForInitToComplete() - readWriteToRMS is null. Waiting for readWriteToRMS to be set in init().");
                    this.monitorObject.wait();
                }
                this.logger.trace((Object)"***VPS***: waitForInitToComplete() - monitorObject is now ready.");
            }
            catch (InterruptedException e2) {
                e2.printStackTrace();
            }
        }
    }
}

