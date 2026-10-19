/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Display
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

class LastTimerUSViewListener
extends CommonTimerViewContainer {
    public LastTimerUSViewListener(final TimerTypeButtonsContainer timerTypebuttonscontainer, final TimerButtonsContainer savebuttonscontainer, final TimerButtonsContainer timerOkButtonContainer, final TimerOkButtonContainer timerCancelButtonContainer) {
        if (Display.getInstance().isEdt()) {
            this.initializeTimerContainer(TimersDisplayStatusEnum.LAST, 0, timerTypebuttonscontainer, savebuttonscontainer, timerOkButtonContainer, timerCancelButtonContainer, true);
            this.updateViewOnLanguageChanged();
        } else {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    LastTimerUSViewListener.this.initializeTimerContainer(TimersDisplayStatusEnum.LAST, 0, timerTypebuttonscontainer, savebuttonscontainer, timerOkButtonContainer, timerCancelButtonContainer, true);
                    LastTimerUSViewListener.this.updateViewOnLanguageChanged();
                }
            });
        }
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        Integer brakeDistValue;
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
        String brakeDistValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getBrakeDistValue();
        String brakeSpeedValueString = ((CommonTimerModel)((Object)gskillsDataModel)).getBrakeSpeedValue();
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
        if (brakeDistValueString != "--" && (brakeDistValue = Integer.valueOf(Integer.parseInt(brakeDistValueString))) != 762 && brakeDistValue != 759) {
            if (brakeDistValue == 765) {
                this.setBrakeDistValue("--");
            } else {
                this.setBrakeDistValue(brakeDistValueString);
            }
        }
        try {
            Integer brakeSpeedValue;
            if (brakeSpeedValueString != "--" && (brakeSpeedValue = Integer.valueOf(Integer.parseInt(brakeSpeedValueString))) != 254 && brakeSpeedValue != 253) {
                if (brakeSpeedValue == 255) {
                    this.setBrakeSpeedValue("--");
                } else {
                    this.setBrakeSpeedValue(brakeSpeedValueString);
                }
            }
        }
        catch (Throwable e2) {
            this.logger.error((Object)("" + e2));
        }
        Display.getInstance().callSerially((Runnable)new CommonTimerViewContainer.RefreshCenterDownTimerContainer());
    }

    public void updateViewOnLanguageChanged() {
        this.updateViewOnLanguageChanged(TimersDisplayStatusEnum.LAST, 0, true);
    }
}

