/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.timers;

import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.model.timers.BestTimerModel;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.timers.CommonTimerView;

public class BestTimerView
extends CommonTimerView {
    private static final BestTimerView INSTANCE = new BestTimerView();

    private BestTimerView() {
        super(TimersDisplayStatusEnum.BEST);
        this.initializeTimerContainer();
        GSkillsViewBuildFactory.getInstance().addToLanguageList(ViewEnum.TIMERS_BEST_VIEW);
        GSkillsViewBuildFactory.getInstance().addToUnitList(ViewEnum.TIMERS_BEST_VIEW);
        this.notifyUnitChanged();
        this.notifyLanguageChanged();
    }

    public static BestTimerView getInstance() {
        return INSTANCE;
    }

    protected void setTimerModel() {
        this._timerModel = BestTimerModel.getInstance();
    }
}

