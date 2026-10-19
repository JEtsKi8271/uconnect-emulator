/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  kona.beep.BeepException
 *  kona.beep.BeepManager
 *  kona.logger.Log
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.timerview;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.view.mainview.MainView;
import com.sprint.gskills.view.timerview.ButtonContainer;
import com.sprint.gskills.view.timerview.TimerButtonsContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import kona.beep.BeepException;
import kona.beep.BeepManager;
import kona.logger.Log;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;

public class TimerOkButtonContainer
extends Container
implements TimerButtonsContainer {
    Logger logger = Log.createLogger((String)this.getClass().getName());
    private MainView mainView = null;
    private ButtonContainer okButtonContainer;
    private TimerSaveOptionsEnum buttonType;
    private ActionListener okButtonListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            TimerOkButtonContainer.this.getBeepOnClick();
            TimerOkButtonContainer.this.mainView.updateRightScreen(TimerOkButtonContainer.this.buttonType);
        }
    };

    public TimerOkButtonContainer(MainView mainview, TimerSaveOptionsEnum buttonType) {
        this.mainView = mainview;
        this.buttonType = buttonType;
        this.initContainer();
    }

    private void initContainer() {
        this.okButtonContainer = new ButtonContainer();
        this.okButtonContainer.addActionListener(this.okButtonListener);
        this.okButtonContainer.getStyle().setMargin(0, 211);
        this.addComponent((Component)this.okButtonContainer);
    }

    public void initView(TimersDisplayStatusEnum timersDisplayStatusEnum) {
        this.logger.error((Object)"initView : unimplemented method");
    }

    public void updateOnLanguageChanged() {
        this.okButtonContainer.setText(this.buttonType.getTitleName());
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

