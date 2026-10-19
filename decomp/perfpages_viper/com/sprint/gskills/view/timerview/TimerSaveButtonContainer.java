/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.beep.BeepException
 *  kona.beep.BeepManager
 *  kona.logger.Log
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.timerview;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.util.NetworkUtils;
import com.sprint.gskills.view.mainview.MainView;
import com.sprint.gskills.view.timerview.ButtonContainer;
import com.sprint.gskills.view.timerview.TimerButtonsContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import kona.beep.BeepException;
import kona.beep.BeepManager;
import kona.logger.Log;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;

public class TimerSaveButtonContainer
extends Container
implements TimerButtonsContainer {
    Logger logger = Log.createLogger((String)this.getClass().getName());
    private MainView mainView = null;
    private ButtonContainer USBButtonContainer;
    private ButtonContainer SDButtonContainer;
    private ButtonContainer websiteButtonContainer;
    private ButtonContainer cancelButtonContainer;
    private static final boolean _isInternetAvailable = NetworkUtils.isInternetAvailable();
    private ActionListener usbActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerSaveButtonContainer.this.getBeepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.USB);
        }
    };
    private ActionListener sdCardActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerSaveButtonContainer.this.getBeepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.SDCard);
        }
    };
    private ActionListener uconnectActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerSaveButtonContainer.this.getBeepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.uConnect);
        }
    };
    private ActionListener cancelActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerSaveButtonContainer.this.getBeepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.CANCEL);
        }
    };

    public TimerSaveButtonContainer(MainView mainview) {
        this.mainView = mainview;
        this.initContainer();
    }

    private void initContainer() {
        this.setLayout((Layout)new BoxLayout(2));
        this.USBButtonContainer = new ButtonContainer();
        this.USBButtonContainer.addActionListener(this.usbActionListener);
        this.USBButtonContainer.getStyle().setMargin(0, 28);
        this.addComponent((Component)this.USBButtonContainer);
        this.SDButtonContainer = new ButtonContainer();
        this.SDButtonContainer.addActionListener(this.sdCardActionListener);
        this.SDButtonContainer.getStyle().setMargin(0, 15);
        this.addComponent((Component)this.SDButtonContainer);
        this.websiteButtonContainer = new ButtonContainer();
        this.websiteButtonContainer.addActionListener(this.uconnectActionListener);
        this.websiteButtonContainer.getStyle().setMargin(0, 15);
        if (_isInternetAvailable) {
            this.addComponent((Component)this.websiteButtonContainer);
        }
        this.cancelButtonContainer = new ButtonContainer();
        this.cancelButtonContainer.addActionListener(this.cancelActionListener);
        this.cancelButtonContainer.getStyle().setMargin(0, 15);
        this.addComponent((Component)this.cancelButtonContainer);
    }

    public void initView(TimersDisplayStatusEnum timerType) {
        this.logger.error((Object)"initView : unimplemented method");
    }

    public void updateOnLanguageChanged() {
        this.USBButtonContainer.setText(TimerSaveOptionsEnum.USB.getTitleName());
        this.SDButtonContainer.setText(TimerSaveOptionsEnum.SDCard.getTitleName());
        if (_isInternetAvailable) {
            this.websiteButtonContainer.setText(TimerSaveOptionsEnum.uConnect.getTitleName());
        }
        this.cancelButtonContainer.setText(TimerSaveOptionsEnum.CANCEL.getTitleName());
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

