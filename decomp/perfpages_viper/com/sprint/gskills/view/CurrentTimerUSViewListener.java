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
import com.sun.lwuit.Display;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

class CurrentTimerUSViewListener
extends CommonTimerViewContainer {
    Logger logger = Log.createLogger((String)this.getClass().getName());

    public CurrentTimerUSViewListener(final TimerButtonsContainer timebuttonscontainer, final TimerButtonsContainer savebuttonscontainer, final TimerButtonsContainer timerOkButtonContainer, final TimerOkButtonContainer timerCancelButtonContainer) {
        if (Display.getInstance().isEdt()) {
            this.initializeTimerContainer(TimersDisplayStatusEnum.CURRENT, 0, timebuttonscontainer, savebuttonscontainer, timerOkButtonContainer, timerCancelButtonContainer, true);
            this.updateViewOnLanguageChanged();
            this.timerLabelBlinkHandler.initLabelMap();
        } else {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    CurrentTimerUSViewListener.this.initializeTimerContainer(TimersDisplayStatusEnum.CURRENT, 0, timebuttonscontainer, savebuttonscontainer, timerOkButtonContainer, timerCancelButtonContainer, true);
                    CurrentTimerUSViewListener.this.updateViewOnLanguageChanged();
                    CurrentTimerUSViewListener.this.timerLabelBlinkHandler.initLabelMap();
                }
            });
        }
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        String zeroToSixtyValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getZeroToSixtyValue();
        String eighthEValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getEighthEValue();
        String eighthMphValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getEighthMphValue();
        String quaterEtValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getQuarterEtValue();
        String quaterMphValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getQuarterMphValue();
        String brakeDistValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getBrakeDistValue();
        String brakeSpeedValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getBrakeSpeedValue();
        if (zeroToSixtyValueString != "--") {
            Double zeroToSixtyValue = new Double(zeroToSixtyValueString);
            if (zeroToSixtyValue == 25.4) {
                this.setZeroToSixtyValue("--");
                this.timerLabelBlinkHandler.registerForBlinking(1);
            } else {
                this.timerLabelBlinkHandler.unregisterForBlinking(1);
                if (zeroToSixtyValue == 25.3 || zeroToSixtyValue == 25.5) {
                    this.setZeroToSixtyValue("--");
                } else {
                    this.setZeroToSixtyValue(zeroToSixtyValueString);
                }
            }
        }
        if (eighthEValueString != "--") {
            Double eighthEValue = new Double(eighthEValueString);
            if (eighthEValue == 25.4) {
                this.setEighthEValue("--");
                this.setEighthMphValue("--");
                this.timerLabelBlinkHandler.registerForBlinking(2);
                this.timerLabelBlinkHandler.registerForBlinking(3);
            } else {
                int eighthMphValue;
                this.timerLabelBlinkHandler.unregisterForBlinking(2);
                this.timerLabelBlinkHandler.unregisterForBlinking(3);
                if (eighthEValue == 25.3 || eighthEValue == 25.5) {
                    this.setEighthEValue("--");
                } else {
                    this.setEighthEValue(eighthEValueString);
                }
                if (eighthMphValueString != "--" && (eighthMphValue = Integer.parseInt(eighthMphValueString)) != 254 && eighthMphValue != 253) {
                    if (eighthMphValue == 255) {
                        this.setEighthMphValue("--");
                    } else {
                        this.setEighthMphValue(eighthMphValueString);
                    }
                }
            }
        }
        if (quaterEtValueString != "--") {
            Double quaterEtValue = new Double(quaterEtValueString);
            if (quaterEtValue == 25.4) {
                this.setQuaterEtValue("--");
                this.setQuaterMphValue("--");
                this.timerLabelBlinkHandler.registerForBlinking(4);
                this.timerLabelBlinkHandler.registerForBlinking(5);
            } else {
                Integer quaterMphValue;
                this.timerLabelBlinkHandler.unregisterForBlinking(4);
                this.timerLabelBlinkHandler.unregisterForBlinking(5);
                if (quaterEtValue == 25.3 || quaterEtValue == 25.5) {
                    this.setQuaterEtValue("--");
                } else {
                    this.setQuaterEtValue(quaterEtValueString);
                }
                if (quaterMphValueString != "--" && (quaterMphValue = Integer.valueOf(Integer.parseInt(quaterMphValueString))) != 254 && quaterMphValue != 253) {
                    if (quaterMphValue == 255) {
                        this.setQuaterMphValue("--");
                    } else {
                        this.setQuaterMphValue(quaterMphValueString);
                    }
                }
            }
        }
        if (brakeDistValueString != "--") {
            Integer brakeDistValue = Integer.parseInt(brakeDistValueString);
            if (brakeDistValue == 762) {
                this.setBrakeDistValue("--");
                this.setBrakeSpeedValue("--");
                this.timerLabelBlinkHandler.registerForBlinking(6);
                this.timerLabelBlinkHandler.registerForBlinking(7);
            } else {
                Integer brakeSpeedValue;
                this.timerLabelBlinkHandler.unregisterForBlinking(6);
                this.timerLabelBlinkHandler.unregisterForBlinking(7);
                if (brakeDistValue == 759 || brakeDistValue == 765) {
                    this.setBrakeDistValue("--");
                } else {
                    this.setBrakeDistValue(brakeDistValueString);
                }
                if (brakeSpeedValueString != "--" && (brakeSpeedValue = Integer.valueOf(Integer.parseInt(brakeSpeedValueString))) != 254 && brakeSpeedValue != 253) {
                    if (brakeSpeedValue == 255) {
                        this.setBrakeSpeedValue("--");
                    } else {
                        this.setBrakeSpeedValue(brakeSpeedValueString);
                    }
                }
            }
        }
        Display.getInstance().callSerially((Runnable)new CommonTimerViewContainer.RefreshCenterDownTimerContainer());
    }

    public void updateViewOnLanguageChanged() {
        this.updateViewOnLanguageChanged(TimersDisplayStatusEnum.CURRENT, 0, true);
    }
}

