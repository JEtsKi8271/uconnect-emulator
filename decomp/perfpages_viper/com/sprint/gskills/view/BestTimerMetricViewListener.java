/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Display
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view;

import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.model.CommonTimerModel;
import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.view.CommonTimerViewContainer;
import com.sprint.gskills.view.timerview.TimerButtonsContainer;
import com.sprint.gskills.view.timerview.TimerOkButtonContainer;
import com.sprint.gskills.view.timerview.TimerTypeButtonsContainer;
import com.sun.lwuit.Display;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

class BestTimerMetricViewListener
extends CommonTimerViewContainer {
    private Logger logger = Log.createLogger((String)this.getClass().getName());

    public BestTimerMetricViewListener(final TimerTypeButtonsContainer timebuttonscontainer, final TimerButtonsContainer savebuttonscontainer, final TimerButtonsContainer timerOkButtonContainer, final TimerOkButtonContainer timerCancelButtonContainer) {
        if (Display.getInstance().isEdt()) {
            this.initializeTimerContainer(TimersDisplayStatusEnum.BEST, 1, timebuttonscontainer, savebuttonscontainer, timerOkButtonContainer, timerCancelButtonContainer, false);
            this.updateViewOnLanguageChanged();
        } else {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    BestTimerMetricViewListener.this.initializeTimerContainer(TimersDisplayStatusEnum.BEST, 1, timebuttonscontainer, savebuttonscontainer, timerOkButtonContainer, timerCancelButtonContainer, false);
                    BestTimerMetricViewListener.this.updateViewOnLanguageChanged();
                }
            });
        }
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        int quaterMphValue;
        Double quaterEtValue;
        int eighthMphValue;
        Double eighthEValue;
        Double zeroToSixtyValue;
        String zeroToSixtyValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getZeroToSixtyValue();
        String eighthEValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getEighthEValue();
        String eighthMphValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getEighthMphValue();
        String quaterEtValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getQuarterEtValue();
        String quaterMphValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getQuarterMphValue();
        if (zeroToSixtyValueString != "--" && (zeroToSixtyValue = new Double(zeroToSixtyValueString)) != 25.4 && zeroToSixtyValue != 25.3) {
            if (zeroToSixtyValue == 25.5) {
                this.setZeroToSixtyValue("--");
            } else {
                this.setZeroToSixtyValue(zeroToSixtyValueString);
            }
        }
        if (eighthEValueString != "--" && (eighthEValue = new Double(eighthEValueString)) != 25.4 && eighthEValue != 25.3) {
            if (eighthEValue == 25.5) {
                this.setEighthEValue("--");
            } else {
                this.setEighthEValue(eighthEValueString);
            }
        }
        if (eighthMphValueString != "--" && (eighthMphValue = new Integer(eighthMphValueString).intValue()) != 254 && eighthMphValue != 253) {
            if (eighthMphValue == 255) {
                this.setEighthMphValue("--");
            } else {
                this.setEighthMphValue(eighthMphValueString);
            }
        }
        if (quaterEtValueString != "--" && (quaterEtValue = new Double(quaterEtValueString)) != 25.4 && quaterEtValue != 25.3) {
            if (quaterEtValue == 25.5) {
                this.setQuaterEtValue("--");
            } else {
                this.setQuaterEtValue(quaterEtValueString);
            }
        }
        if (quaterMphValueString != "--" && (quaterMphValue = new Integer(quaterMphValueString).intValue()) != 254 && quaterMphValue != 253) {
            if (quaterMphValue == 255) {
                this.setQuaterMphValue("--");
            } else {
                this.setQuaterMphValue(quaterMphValueString);
            }
        }
        Display.getInstance().callSerially((Runnable)new CommonTimerViewContainer.RefreshCenterDownTimerContainer(this));
    }

    public void updateViewOnLanguageChanged() {
        this.updateViewOnLanguageChanged(TimersDisplayStatusEnum.BEST, 1, false);
    }
}

