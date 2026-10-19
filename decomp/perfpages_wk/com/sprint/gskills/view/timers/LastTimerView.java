/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.timers;

import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.model.timers.LastTimerModel;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.timers.CommonTimerView;

public class LastTimerView
extends CommonTimerView {
    private static final LastTimerView INSTANCE = new LastTimerView();

    private LastTimerView() {
        super(TimersDisplayStatusEnum.LAST);
        this.initializeTimerContainer();
        GSkillsViewBuildFactory.getInstance().addToLanguageList(ViewEnum.TIMERS_LAST_VIEW);
        GSkillsViewBuildFactory.getInstance().addToUnitList(ViewEnum.TIMERS_LAST_VIEW);
        this.notifyUnitChanged();
        this.notifyLanguageChanged();
    }

    public static LastTimerView getInstance() {
        return INSTANCE;
    }

    protected void setTimerModel() {
        this._timerModel = LastTimerModel.getInstance();
    }
}

