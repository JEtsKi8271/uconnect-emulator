/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  kona.logger.Log
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
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class TimerOkButtonContainer
extends Container
implements CommonTimerButtonsContainer {
    Logger _logger = Log.createLogger((String)this.getClass().getName());
    private MainView _mainView = null;
    private TimersButtonContainer _okButtonContainer;
    private TimerSaveOptionsEnum _buttonType;
    private ActionListener okButtonListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonUtils.getInstance().beepOnClick();
            TimerOkButtonContainer.this._mainView.updateRightScreen(TimerOkButtonContainer.this._buttonType);
        }
    };

    public TimerOkButtonContainer(TimerSaveOptionsEnum buttonType) {
        this._mainView = MainView.getInstance();
        this._buttonType = buttonType;
        this.initContainer();
    }

    private void initContainer() {
        this._okButtonContainer = new TimersButtonContainer();
        this._okButtonContainer.addActionListener(this.okButtonListener);
        this._okButtonContainer.getStyle().setMargin(0, 221);
        this.addComponent((Component)this._okButtonContainer);
    }

    public void initView(TimersDisplayStatusEnum timersDisplayStatusEnum) {
        this._logger.error((Object)"initView : unimplemented method");
    }

    public void updateOnLanguageChanged() {
        this._okButtonContainer.setText(this._buttonType.getTitleName());
    }
}

