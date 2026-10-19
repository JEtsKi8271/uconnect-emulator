/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsView;
import com.sprint.gskills.view.enginepage.EngineJeepViperView;
import com.sprint.gskills.view.enginepage.EngineLSeriesView;
import com.sprint.gskills.view.gaugespage.GaugesOneView;
import com.sprint.gskills.view.gaugespage.GaugesTwoView;
import com.sprint.gskills.view.gforcepage.GForceView;
import com.sprint.gskills.view.homepage.HomeView;
import com.sprint.gskills.view.timers.BestTimerView;
import com.sprint.gskills.view.timers.CommonTimerView;
import com.sprint.gskills.view.timers.CurrentTimerView;
import com.sprint.gskills.view.timers.LastTimerView;
import com.sprint.gskills.view.timers.components.CommonTimerButtonsContainer;
import com.sprint.gskills.view.timers.components.TimerOkButtonContainer;
import com.sprint.gskills.view.timers.components.TimerSaveButtonContainer;
import java.util.ArrayList;
import java.util.List;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

/*
 * This class specifies class file version 49.0 but uses Java 6 signatures.  Assumed Java 6.
 */
public class GSkillsViewBuildFactory {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private static final GSkillsViewBuildFactory INSTANCE = new GSkillsViewBuildFactory();
    private List<ViewEnum> _languageChangeableViewList = new ArrayList<ViewEnum>();
    private List<ViewEnum> _unitChangeableViewList = new ArrayList<ViewEnum>();
    private TimerSaveButtonContainer _timerSaveButtonContainer;
    private TimerOkButtonContainer _timerOkButtonContainer;
    private TimerOkButtonContainer _timerCancelButtonContainer;

    private GSkillsViewBuildFactory() {
    }

    public static GSkillsViewBuildFactory getInstance() {
        return INSTANCE;
    }

    public void addToLanguageList(ViewEnum viewConstant) {
        if (!this._languageChangeableViewList.contains(viewConstant)) {
            this._languageChangeableViewList.add(viewConstant);
        }
    }

    public void addToUnitList(ViewEnum viewConstant) {
        if (!this._unitChangeableViewList.contains(viewConstant)) {
            this._unitChangeableViewList.add(viewConstant);
        }
    }

    public GSkillsView getViewByCode(ViewEnum viewEnum) {
        GSkillsView currentView = null;
        switch (viewEnum.getViewID()) {
            case 0: {
                currentView = HomeView.getInstance();
                break;
            }
            case 1: {
                currentView = this.getTimerContainer();
                break;
            }
            case 4: {
                currentView = GForceView.getInstance();
                break;
            }
            case 2: {
                currentView = GaugesOneView.getInstance();
                break;
            }
            case 3: {
                currentView = GaugesTwoView.getInstance();
                break;
            }
            case 5: {
                if (GSkillsStateManager.getInstance().isLSeriesVehicle()) {
                    currentView = EngineLSeriesView.getInstance();
                    break;
                }
                currentView = EngineJeepViperView.getInstance();
                break;
            }
            case 8: {
                currentView = CurrentTimerView.getInstance();
                break;
            }
            case 7: {
                currentView = LastTimerView.getInstance();
                break;
            }
            case 6: {
                currentView = BestTimerView.getInstance();
                break;
            }
            default: {
                this.logger.trace((Object)"not a valid selection");
                currentView = HomeView.getInstance();
            }
        }
        return currentView;
    }

    public List<ViewEnum> getLanguageChangeableViewList() {
        return this._languageChangeableViewList;
    }

    public List<ViewEnum> getUnitChangeableViewList() {
        return this._unitChangeableViewList;
    }

    public GSkillsView getTimerContainer() {
        CommonTimerView timerContainer = CurrentTimerView.getInstance();
        TimersDisplayStatusEnum timerType = GSkillsStateManager.getInstance().getTimersType();
        if (TimersDisplayStatusEnum.LAST == timerType) {
            timerContainer = LastTimerView.getInstance();
        } else if (TimersDisplayStatusEnum.BEST == timerType) {
            timerContainer = BestTimerView.getInstance();
        }
        return timerContainer;
    }

    public GSkillsView getTimerContainer(TimerSaveOptionsEnum timerSaveOption) {
        GSkillsView timerContainer = this.getViewByCode(ViewEnum.TIMERS_VIEW);
        ((CommonTimerView)timerContainer).updateDialogAndButtons(timerSaveOption);
        return timerContainer;
    }

    public CommonTimerButtonsContainer getTimerSaveButtonContainer() {
        if (this._timerSaveButtonContainer == null) {
            this._timerSaveButtonContainer = new TimerSaveButtonContainer();
        }
        return this._timerSaveButtonContainer;
    }

    public CommonTimerButtonsContainer getTimerOkButtonContainer() {
        if (this._timerOkButtonContainer == null) {
            this._timerOkButtonContainer = new TimerOkButtonContainer(TimerSaveOptionsEnum.OK);
        }
        return this._timerOkButtonContainer;
    }

    public CommonTimerButtonsContainer getTimerCancelButtonContainer() {
        if (this._timerCancelButtonContainer == null) {
            this._timerCancelButtonContainer = new TimerOkButtonContainer(TimerSaveOptionsEnum.CANCEL);
        }
        return this._timerCancelButtonContainer;
    }
}

