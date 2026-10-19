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
 *  kona.beep.BeepException
 *  kona.beep.BeepManager
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.timerview;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.timerview.ButtonContainer;
import com.sprint.gskills.view.timerview.TimerButtonsContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Image;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import kona.beep.BeepException;
import kona.beep.BeepManager;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class TimerTypeButtonsContainer
extends Container
implements TimerButtonsContainer {
    private Logger logger = LoggerFactory.getLogger(TimerTypeButtonsContainer.class);
    private ButtonContainer currentButtonContainer;
    private ButtonContainer lastButtonContainer;
    private ButtonContainer bestButtonContainer;
    private ButtonContainer saveButtonContainer;
    private GSkillsViewController viewController;
    private GSkillsStateManager stateManager;
    private static boolean buttonClicked;
    private ActionListener currentActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerTypeButtonsContainer.this.getBeepOnClick();
            if (TimerTypeButtonsContainer.this.stateManager.getTimersType() != TimersDisplayStatusEnum.CURRENT && !buttonClicked) {
                buttonClicked = true;
                TimerTypeButtonsContainer.this.stateManager.setTimersType(TimersDisplayStatusEnum.CURRENT);
                TimerTypeButtonsContainer.this.viewController.notifyDisplayViewChanged(TimersDisplayStatusEnum.CURRENT);
                buttonClicked = false;
            }
        }
    };
    private ActionListener lastActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerTypeButtonsContainer.this.getBeepOnClick();
            if (TimerTypeButtonsContainer.this.stateManager.getTimersType() != TimersDisplayStatusEnum.LAST && !buttonClicked) {
                buttonClicked = true;
                TimerTypeButtonsContainer.this.stateManager.setTimersType(TimersDisplayStatusEnum.LAST);
                TimerTypeButtonsContainer.this.viewController.notifyDisplayViewChanged(TimersDisplayStatusEnum.LAST);
                buttonClicked = false;
            }
        }
    };
    private ActionListener bestActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerTypeButtonsContainer.this.getBeepOnClick();
            if (TimerTypeButtonsContainer.this.stateManager.getTimersType() != TimersDisplayStatusEnum.BEST && !buttonClicked) {
                buttonClicked = true;
                TimerTypeButtonsContainer.this.stateManager.setTimersType(TimersDisplayStatusEnum.BEST);
                TimerTypeButtonsContainer.this.viewController.notifyDisplayViewChanged(TimersDisplayStatusEnum.BEST);
                buttonClicked = false;
            }
        }
    };
    private ActionListener downloadActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerTypeButtonsContainer.this.getBeepOnClick();
            TimerTypeButtonsContainer.this.viewController.notifyDisplayViewChanged(TimerSaveOptionsEnum.SAVE);
        }
    };

    public TimerTypeButtonsContainer(GSkillsViewController viewController) {
        this.viewController = viewController;
        this.stateManager = GSkillsStateManager.getInstance();
        this.initContainer();
    }

    private void initContainer() {
        this.setLayout((Layout)new BoxLayout(2));
        this.setPreferredSize(new Dimension(126, 229));
        this.getStyle().setMargin(0, 29);
        this.currentButtonContainer = new ButtonContainer();
        this.currentButtonContainer.addActionListener(this.currentActionListener);
        this.lastButtonContainer = new ButtonContainer();
        this.lastButtonContainer.addActionListener(this.lastActionListener);
        this.lastButtonContainer.getStyle().setMargin(0, 15);
        this.bestButtonContainer = new ButtonContainer();
        this.bestButtonContainer.addActionListener(this.bestActionListener);
        this.bestButtonContainer.getStyle().setMargin(0, 15);
        this.saveButtonContainer = new ButtonContainer();
        this.saveButtonContainer.addActionListener(this.downloadActionListener);
        this.saveButtonContainer.getStyle().setMargin(0, 15);
        this.addComponent((Component)this.currentButtonContainer);
        this.addComponent((Component)this.lastButtonContainer);
        this.addComponent((Component)this.bestButtonContainer);
        this.addComponent((Component)this.saveButtonContainer);
    }

    public void initView(TimersDisplayStatusEnum timersDisplayStatusEnum) {
        this.updateButtonImage(timersDisplayStatusEnum);
    }

    private void updateButtonImage(TimersDisplayStatusEnum timersDisplayStatusEnum) {
        try {
            Image buttonImage;
            if (timersDisplayStatusEnum.getIntegerValue() == TimersDisplayStatusEnum.CURRENT.getIntegerValue()) {
                buttonImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("btn_srt_green.png");
                this.currentButtonContainer.getStyle().setBgImage(buttonImage);
                this.currentButtonContainer.getPressedStyle().setBgImage(buttonImage);
                this.currentButtonContainer.getSelectedStyle().setBgImage(buttonImage);
            }
            if (timersDisplayStatusEnum.getIntegerValue() == TimersDisplayStatusEnum.LAST.getIntegerValue()) {
                buttonImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("btn_srt_yellow.png");
                this.lastButtonContainer.getStyle().setBgImage(buttonImage);
                this.lastButtonContainer.getPressedStyle().setBgImage(buttonImage);
                this.lastButtonContainer.getSelectedStyle().setBgImage(buttonImage);
            }
            if (timersDisplayStatusEnum.getIntegerValue() == TimersDisplayStatusEnum.BEST.getIntegerValue()) {
                buttonImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("btn_srt_red.png");
                this.bestButtonContainer.getStyle().setBgImage(buttonImage);
                this.bestButtonContainer.getPressedStyle().setBgImage(buttonImage);
                this.bestButtonContainer.getSelectedStyle().setBgImage(buttonImage);
            }
        }
        catch (Exception e2) {
            this.logger.error((Object)" ", (Throwable)e2);
        }
    }

    public void updateOnLanguageChanged() {
        this.currentButtonContainer.setText("timer_state_Current");
        this.lastButtonContainer.setText("timer_state_Last");
        this.bestButtonContainer.setText("timer_state_Best");
        this.saveButtonContainer.setText("timer_btn_save");
    }

    public void getBeepOnClick() {
        if (PlatformInfo.isRunningInEmulator()) {
            return;
        }
        try {
            BeepManager.getBeep().requestBeep("CONF_1");
        }
        catch (BeepException e2) {
            e2.printStackTrace();
        }
    }
}

