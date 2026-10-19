/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.timers.components;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.timers.components.CommonTimerButtonsContainer;
import com.sprint.gskills.view.timers.components.TimersButtonContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Image;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class TimerTypeButtonsContainer
extends Container
implements CommonTimerButtonsContainer {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private TimersButtonContainer _currentButtonContainer;
    private TimersButtonContainer _lastButtonContainer;
    private TimersButtonContainer _bestButtonContainer;
    private TimersButtonContainer _saveButtonContainer;
    private GSkillsViewController _viewController = GSkillsViewController.getInstance();
    private GSkillsStateManager _stateManager = GSkillsStateManager.getInstance();
    private final String PATH_BUTTON_GREEN = "btn_srt_green.png";
    private final String PATH_BUTTON_YELLOW = "btn_srt_yellow.png";
    private final String PATH_BUTTON_RED = "btn_srt_red.png";
    private ActionListener _saveActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonUtils.getInstance().beepOnClick();
            TimerTypeButtonsContainer.this._viewController.notifyDisplayViewChanged(TimerSaveOptionsEnum.SAVE);
        }
    };

    public TimerTypeButtonsContainer() {
        this.initContainer();
    }

    private void initContainer() {
        this.setLayout((Layout)new BoxLayout(2));
        this.setPreferredSize(new Dimension(165, 229));
        this.getStyle().setMargin(0, 39);
        this._currentButtonContainer = new TimersButtonContainer();
        this._currentButtonContainer.addActionListener(new TimerButtonActionLister(TimersDisplayStatusEnum.CURRENT));
        this._lastButtonContainer = new TimersButtonContainer();
        this._lastButtonContainer.addActionListener(new TimerButtonActionLister(TimersDisplayStatusEnum.LAST));
        this._lastButtonContainer.getStyle().setMargin(0, 15);
        this._bestButtonContainer = new TimersButtonContainer();
        this._bestButtonContainer.addActionListener(new TimerButtonActionLister(TimersDisplayStatusEnum.BEST));
        this._bestButtonContainer.getStyle().setMargin(0, 15);
        this._saveButtonContainer = new TimersButtonContainer();
        this._saveButtonContainer.addActionListener(this._saveActionListener);
        this._saveButtonContainer.getStyle().setMargin(0, 15);
        this.addComponent((Component)this._currentButtonContainer);
        this.addComponent((Component)this._lastButtonContainer);
        this.addComponent((Component)this._bestButtonContainer);
        this.addComponent((Component)this._saveButtonContainer);
    }

    public void initView(TimersDisplayStatusEnum timersDisplayStatusEnum) {
        this.updateButtonImage(timersDisplayStatusEnum);
    }

    private void updateButtonImage(TimersDisplayStatusEnum timersDisplayStatusEnum) {
        try {
            Image buttonImage = null;
            TimersButtonContainer buttonContainer = null;
            if (TimersDisplayStatusEnum.CURRENT == timersDisplayStatusEnum) {
                buttonImage = GSkillsResourceManager.getInstance().getCommonImage("btn_srt_green.png");
                buttonContainer = this._currentButtonContainer;
            } else if (TimersDisplayStatusEnum.LAST == timersDisplayStatusEnum) {
                buttonImage = GSkillsResourceManager.getInstance().getCommonImage("btn_srt_yellow.png");
                buttonContainer = this._lastButtonContainer;
            } else {
                buttonImage = GSkillsResourceManager.getInstance().getCommonImage("btn_srt_red.png");
                buttonContainer = this._bestButtonContainer;
            }
            buttonContainer.getStyle().setBgImage(buttonImage);
            buttonContainer.getPressedStyle().setBgImage(buttonImage);
            buttonContainer.getSelectedStyle().setBgImage(buttonImage);
        }
        catch (Exception e2) {
            this._logger.error((Object)" ", (Throwable)e2);
        }
    }

    public void updateOnLanguageChanged() {
        GSkillsResourceManager resourceManager = GSkillsResourceManager.getInstance();
        String currentTimerTextKey = GSkillsStateManager.getInstance().isLSeriesVehicle() ? "timer_state_Current" : "timer_state_Recent";
        this._currentButtonContainer.setText(resourceManager.getLanguageResByKey(currentTimerTextKey));
        this._lastButtonContainer.setText(resourceManager.getLanguageResByKey("timer_state_Last"));
        this._bestButtonContainer.setText(resourceManager.getLanguageResByKey("timer_state_Best"));
        this._saveButtonContainer.setText(resourceManager.getLanguageResByKey("timer_btn_save"));
    }

    private class TimerButtonActionLister
    implements ActionListener {
        private TimersDisplayStatusEnum _timersEnum;

        public TimerButtonActionLister(TimersDisplayStatusEnum timersEnum) {
            this._timersEnum = timersEnum;
        }

        public void actionPerformed(ActionEvent event) {
            CommonUtils.getInstance().beepOnClick();
            if (TimerTypeButtonsContainer.this._stateManager.getTimersType() != this._timersEnum) {
                TimerTypeButtonsContainer.this._stateManager.setTimersType(this._timersEnum);
                TimerTypeButtonsContainer.this._viewController.notifyDisplayViewChanged();
            }
        }
    }
}

