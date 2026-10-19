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
 *  kona.logger.Log
 *  kona.platform.PlatformException
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.timers.components;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.mainview.MainView;
import com.sprint.gskills.view.timers.components.CommonTimerButtonsContainer;
import com.sprint.gskills.view.timers.components.TimersButtonContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import kona.logger.Log;
import kona.platform.PlatformException;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;

public class TimerSaveButtonContainer
extends Container
implements CommonTimerButtonsContainer {
    Logger logger = Log.createLogger((String)this.getClass().getName());
    private MainView mainView = null;
    private TimersButtonContainer USBButtonContainer;
    private TimersButtonContainer SDButtonContainer;
    private TimersButtonContainer websiteButtonContainer;
    private TimersButtonContainer cancelButtonContainer;
    private ActionListener usbActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonUtils.getInstance().beepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.USB);
        }
    };
    private ActionListener sdCardActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonUtils.getInstance().beepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.SDCARD);
        }
    };
    private ActionListener uconnectActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonUtils.getInstance().beepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.UCONNECT);
        }
    };
    private ActionListener cancelActionListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonUtils.getInstance().beepOnClick();
            TimerSaveButtonContainer.this.mainView.updateRightScreen(TimerSaveOptionsEnum.CANCEL);
        }
    };

    public TimerSaveButtonContainer() {
        this.mainView = MainView.getInstance();
        this.initContainer();
    }

    private void initContainer() {
        this.setLayout((Layout)new BoxLayout(2));
        this.USBButtonContainer = new TimersButtonContainer();
        this.USBButtonContainer.addActionListener(this.usbActionListener);
        this.USBButtonContainer.getStyle().setMargin(0, 38);
        this.SDButtonContainer = new TimersButtonContainer();
        this.SDButtonContainer.addActionListener(this.sdCardActionListener);
        this.SDButtonContainer.getStyle().setMargin(0, 15);
        this.cancelButtonContainer = new TimersButtonContainer();
        this.cancelButtonContainer.addActionListener(this.cancelActionListener);
        this.addComponent((Component)this.USBButtonContainer);
        this.addComponent((Component)this.SDButtonContainer);
        this.websiteButtonContainer = new TimersButtonContainer();
        this.websiteButtonContainer.addActionListener(this.uconnectActionListener);
        this.websiteButtonContainer.getStyle().setMargin(0, 15);
        try {
            if (PlatformInfo.getPlatformInfo().isEmbeddedPhonePresent()) {
                this.addComponent((Component)this.websiteButtonContainer);
                this.cancelButtonContainer.getStyle().setMargin(0, 15);
            } else {
                this.cancelButtonContainer.getStyle().setMargin(0, 76);
            }
        }
        catch (PlatformException e2) {
            this.cancelButtonContainer.getStyle().setMargin(0, 76);
            e2.printStackTrace();
        }
        this.addComponent((Component)this.cancelButtonContainer);
    }

    public void initView(TimersDisplayStatusEnum timerType) {
        this.logger.error((Object)"initView : unimplemented method");
    }

    public void updateOnLanguageChanged() {
        this.USBButtonContainer.setText(TimerSaveOptionsEnum.USB.getTitleName());
        this.SDButtonContainer.setText(TimerSaveOptionsEnum.SDCARD.getTitleName());
        this.websiteButtonContainer.setText(TimerSaveOptionsEnum.UCONNECT.getTitleName());
        this.cancelButtonContainer.setText(TimerSaveOptionsEnum.CANCEL.getTitleName());
    }
}

