/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.timers;

import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.model.timers.CurrentTimerModel;
import com.sprint.gskills.unit.DistanceUnitEnum;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.timers.CommonTimerView;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;

public class CurrentTimerView
extends CommonTimerView {
    private Object _syncObject = new Object();
    private boolean _drawDash = true;
    private long _time = System.currentTimeMillis();
    private String _labelText = "";
    private boolean _isMY16Vehicle = true;
    private static final String TIMER_READY = "--";
    private static final String TIMER_ACTIVE = "REC";
    private static final CurrentTimerView INSTANCE = new CurrentTimerView();
    private ArrayList<Integer> _blinkingLabelsList = new ArrayList();
    private HashMap<Integer, CommonLabel> _blinkingLabelsMap = new HashMap();
    private static final int REACTION_TIME_LABEL = 0;
    private static final int ZERO_TO_SIXTY_LABEL = 1;
    private static final int ZERO_TO_HUNDRED_LABEL = 2;
    private static final int QRTR_MILE_TM_LABEL = 3;
    private static final int QRTR_MILE_SPD_LABEL = 4;
    private static final int EIGHTH_MILE_TM_LABEL = 5;
    private static final int EIGHTH_MILE_SPD_LABEL = 6;
    private static final int SIXTY_FEET_LABEL = 7;
    private static final int BRAKING_DIST_LABEL = 8;
    private static final int BRAKING_SPD_LABEL = 9;

    private CurrentTimerView() {
        super(TimersDisplayStatusEnum.CURRENT);
        this.initializeTimerContainer();
        this.initLabelMap();
        if (GSkillsStateManager.getInstance().isLSeriesVehicle()) {
            this._isMY16Vehicle = false;
        }
        GSkillsViewBuildFactory.getInstance().addToLanguageList(ViewEnum.TIMERS_CURRENT_VIEW);
        GSkillsViewBuildFactory.getInstance().addToUnitList(ViewEnum.TIMERS_CURRENT_VIEW);
        this.notifyUnitChanged();
        this.notifyLanguageChanged();
    }

    protected void setTimerModel() {
        this._timerModel = CurrentTimerModel.getInstance();
    }

    public void initLabelMap() {
        this._blinkingLabelsMap.put(0, this._reactionTimeValueLabel);
        this._blinkingLabelsMap.put(1, this._zeroToSixtyValueLabel);
        this._blinkingLabelsMap.put(2, this._zeroToHundredValueLabel);
        this._blinkingLabelsMap.put(3, this._quarterEtValueLabel);
        this._blinkingLabelsMap.put(4, this._quarterMphValueLabel);
        this._blinkingLabelsMap.put(5, this._eighthEValueLabel);
        this._blinkingLabelsMap.put(6, this._eighthMphValueLabel);
        this._blinkingLabelsMap.put(7, this._sixtyFeetValueLabel);
        this._blinkingLabelsMap.put(8, this._brakeDistValueLabel);
        this._blinkingLabelsMap.put(9, this._brakeSpeedValueLabel);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void registerForBlinking(int labelIndex) {
        if (!this._blinkingLabelsList.contains(labelIndex)) {
            Object object = this._syncObject;
            synchronized (object) {
                this._blinkingLabelsList.add(labelIndex);
            }
        }
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void unregisterForBlinking(int labelIndex) {
        if (this._blinkingLabelsList.contains(labelIndex)) {
            Object object = this._syncObject;
            synchronized (object) {
                this._blinkingLabelsList.remove(this._blinkingLabelsList.indexOf(labelIndex));
            }
        }
    }

    public static CurrentTimerView getInstance() {
        return INSTANCE;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public boolean animate() {
        boolean needRepaint = super.animate();
        if (!this._blinkingLabelsList.isEmpty()) {
            boolean animateBlinking = false;
            long currentTime = System.currentTimeMillis();
            if (this._drawDash) {
                if (currentTime - this._time > 1000L) {
                    this._time = currentTime;
                    animateBlinking = true;
                    this._labelText = "";
                    this._drawDash = false;
                }
            } else if (currentTime - this._time > 500L) {
                animateBlinking = true;
                this._labelText = TIMER_READY;
                this._drawDash = true;
            }
            if (animateBlinking) {
                needRepaint = true;
                ArrayList<Integer> localList = new ArrayList<Integer>();
                Object object = this._syncObject;
                synchronized (object) {
                    localList.addAll(this._blinkingLabelsList);
                }
                for (int i2 = 0; i2 < localList.size(); ++i2) {
                    CommonLabel label;
                    int index = (Integer)localList.get(i2);
                    if (!this._blinkingLabelsMap.containsKey(index) || null == (label = this._blinkingLabelsMap.get(index))) continue;
                    label.setText(this._labelText);
                }
            }
        }
        return needRepaint;
    }

    protected void setReactionTime() {
        String reactionTimeValueString = this._timerModel.getReactionTimeValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":ReactionTime = " + reactionTimeValueString));
        if (!reactionTimeValueString.equals(TIMER_READY)) {
            Double reactionTimeValue = new Double(reactionTimeValueString);
            if (reactionTimeValue == 2.54) {
                this._reactionTimeValueLabel.setText(TIMER_READY);
                this.registerForBlinking(0);
            } else {
                this.unregisterForBlinking(0);
                if (reactionTimeValue == 2.52 && this._isMY16Vehicle) {
                    this._reactionTimeValueLabel.setText(TIMER_ACTIVE);
                } else if (reactionTimeValue == 2.53 || reactionTimeValue > 2.54) {
                    this._reactionTimeValueLabel.setText(TIMER_READY);
                } else {
                    double offsetReactionTimeValue = reactionTimeValue - 1.26;
                    DecimalFormat reactionTimeFormat = new DecimalFormat("#0.00");
                    String offsetReactionTimeString = reactionTimeFormat.format(offsetReactionTimeValue);
                    this._logger.debug((Object)(this._timerModel.toString() + ":ConvertedReactionTime = " + offsetReactionTimeString));
                    this._reactionTimeValueLabel.setText(offsetReactionTimeString);
                }
            }
        }
    }

    protected void setZeroToSixtyValue() {
        String zeroToSixtyValueString = this._timerModel.getZeroToSixtyValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":0-60 Time = " + zeroToSixtyValueString));
        if (!zeroToSixtyValueString.equals(TIMER_READY)) {
            Double zeroToSixtyValue = new Double(zeroToSixtyValueString);
            if (zeroToSixtyValue == 25.4) {
                this._zeroToSixtyValueLabel.setText(TIMER_READY);
                this.registerForBlinking(1);
            } else {
                this.unregisterForBlinking(1);
                if (zeroToSixtyValue == 25.2 && this._isMY16Vehicle) {
                    this._zeroToSixtyValueLabel.setText(TIMER_ACTIVE);
                } else if (zeroToSixtyValue == 25.3 || zeroToSixtyValue > 25.4) {
                    this._zeroToSixtyValueLabel.setText(TIMER_READY);
                } else {
                    this._zeroToSixtyValueLabel.setText(zeroToSixtyValueString);
                }
            }
        }
    }

    protected void setZeroToHunderedValue() {
        String zeroToHundredValueString = this._timerModel.getZeroToHundredValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":0-100 Time = " + zeroToHundredValueString));
        if (!zeroToHundredValueString.equals(TIMER_READY)) {
            Double zeroToHundredValue = new Double(zeroToHundredValueString);
            if (zeroToHundredValue == 25.4) {
                this._zeroToHundredValueLabel.setText(TIMER_READY);
                this.registerForBlinking(2);
            } else {
                this.unregisterForBlinking(2);
                if (zeroToHundredValue == 25.2 && this._isMY16Vehicle) {
                    this._zeroToHundredValueLabel.setText(TIMER_ACTIVE);
                } else if (zeroToHundredValue == 25.3 || zeroToHundredValue > 25.4) {
                    this._zeroToHundredValueLabel.setText(TIMER_READY);
                } else {
                    this._zeroToHundredValueLabel.setText(zeroToHundredValueString);
                }
            }
        }
    }

    protected void setEigthValue() {
        String eighthEValueString = this._timerModel.getEighthEValue();
        String eighthMphValueString = this._timerModel.getEighthMphValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":Eighth Time = " + eighthEValueString));
        this._logger.debug((Object)(this._timerModel.toString() + ":Eighth Speed = " + eighthMphValueString));
        if (!eighthEValueString.equals(TIMER_READY)) {
            Double eighthEValue = new Double(eighthEValueString);
            if (eighthEValue == 25.4) {
                this._eighthEValueLabel.setText(TIMER_READY);
                this._eighthMphValueLabel.setText(TIMER_READY);
                this.registerForBlinking(5);
                this.registerForBlinking(6);
            } else {
                this.unregisterForBlinking(5);
                this.unregisterForBlinking(6);
                if (eighthEValue == 25.2 && this._isMY16Vehicle) {
                    this._eighthEValueLabel.setText(TIMER_ACTIVE);
                } else if (eighthEValue == 25.3 || eighthEValue > 25.4) {
                    this._eighthEValueLabel.setText(TIMER_READY);
                } else {
                    this._eighthEValueLabel.setText(eighthEValueString);
                }
                if (!eighthMphValueString.equals(TIMER_READY)) {
                    int eighthMphValue = Integer.parseInt(eighthMphValueString);
                    if (eighthMphValue == 252 && this._isMY16Vehicle) {
                        this._eighthMphValueLabel.setText(TIMER_ACTIVE);
                    } else if (eighthMphValue != 254) {
                        if (eighthMphValue == 253 || eighthMphValue > 254) {
                            this._eighthMphValueLabel.setText(TIMER_READY);
                        } else {
                            this._eighthMphValueLabel.setText(eighthMphValueString);
                        }
                    }
                }
            }
        }
    }

    protected void setQuarterValue() {
        String quarterEtValueString = this._timerModel.getQuarterEtValue();
        String quarterMphValueString = this._timerModel.getQuarterMphValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":Quarter Time = " + quarterEtValueString));
        this._logger.debug((Object)(this._timerModel.toString() + ":Quarter Speed = " + quarterMphValueString));
        if (!quarterEtValueString.equals(TIMER_READY)) {
            Double quaterEtValue = new Double(quarterEtValueString);
            if (quaterEtValue == 25.4) {
                this._quarterEtValueLabel.setText(TIMER_READY);
                this._quarterMphValueLabel.setText(TIMER_READY);
                this.registerForBlinking(4);
                this.registerForBlinking(3);
            } else {
                this.unregisterForBlinking(4);
                this.unregisterForBlinking(3);
                if (quaterEtValue == 25.2 && this._isMY16Vehicle) {
                    this._quarterEtValueLabel.setText(TIMER_ACTIVE);
                } else if (quaterEtValue == 25.3 || quaterEtValue > 25.4) {
                    this._quarterEtValueLabel.setText(TIMER_READY);
                } else {
                    this._quarterEtValueLabel.setText(quarterEtValueString);
                }
                if (!quarterMphValueString.equals(TIMER_READY)) {
                    Integer quaterMphValue = Integer.parseInt(quarterMphValueString);
                    if (quaterMphValue == 252 && this._isMY16Vehicle) {
                        this._quarterMphValueLabel.setText(TIMER_ACTIVE);
                    } else if (quaterMphValue != 254) {
                        if (quaterMphValue == 253 || quaterMphValue > 254) {
                            this._quarterMphValueLabel.setText(TIMER_READY);
                        } else {
                            this._quarterMphValueLabel.setText(quarterMphValueString);
                        }
                    }
                }
            }
        }
    }

    protected void setSixtyFeetValue() {
        String sixtyFeetValueString = this._timerModel.getSixtyFeetValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":60 Ft Time = " + sixtyFeetValueString));
        if (!sixtyFeetValueString.equals(TIMER_READY)) {
            Double sixtyFeetValue = new Double(sixtyFeetValueString);
            if (sixtyFeetValue == 5.1) {
                this._sixtyFeetValueLabel.setText(TIMER_READY);
                this.registerForBlinking(7);
            } else {
                this.unregisterForBlinking(7);
                if (sixtyFeetValue == 5.08 && this._isMY16Vehicle) {
                    this._sixtyFeetValueLabel.setText(TIMER_ACTIVE);
                } else if (sixtyFeetValue >= 5.01 && sixtyFeetValue <= 5.07 || sixtyFeetValue == 5.09 || sixtyFeetValue > 5.1) {
                    this._sixtyFeetValueLabel.setText(TIMER_READY);
                } else {
                    this._sixtyFeetValueLabel.setText(sixtyFeetValueString);
                }
            }
        }
    }

    protected void setBrakeDistance() {
        String brakeDistValueString = this._timerModel.getBrakeDistValue();
        String brakeSpeedValueString = this._timerModel.getBrakeSpeedValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":Braking Distance = " + brakeDistValueString));
        this._logger.debug((Object)(this._timerModel.toString() + ":Braking Speed = " + brakeSpeedValueString));
        if (!brakeDistValueString.equals(TIMER_READY)) {
            Integer brakeDistValue = Integer.parseInt(brakeDistValueString);
            if (brakeDistValue == 254) {
                this._brakeDistValueLabel.setText(TIMER_READY);
                this._brakeSpeedValueLabel.setText(TIMER_READY);
                this.registerForBlinking(8);
                this.registerForBlinking(9);
            } else {
                this.unregisterForBlinking(8);
                this.unregisterForBlinking(9);
                if (brakeDistValue == 252 && this._isMY16Vehicle) {
                    this._brakeDistValueLabel.setText(TIMER_ACTIVE);
                } else if (brakeDistValue == 253 || brakeDistValue > 254) {
                    this._brakeDistValueLabel.setText(TIMER_READY);
                } else if (DistanceUnitEnum.MILES == GSkillsStateManager.getInstance().getDistanceUnit()) {
                    this._brakeDistValueLabel.setText(Integer.toString(brakeDistValue * 3));
                } else {
                    this._brakeDistValueLabel.setText(brakeDistValueString);
                }
                if (!brakeSpeedValueString.equals(TIMER_READY)) {
                    Integer brakeSpeedValue = Integer.parseInt(brakeSpeedValueString);
                    if (brakeSpeedValue == 252 && this._isMY16Vehicle) {
                        this._brakeSpeedValueLabel.setText(TIMER_ACTIVE);
                    } else if (brakeSpeedValue != 254) {
                        if (brakeSpeedValue == 253 || brakeSpeedValue > 254) {
                            this._brakeSpeedValueLabel.setText(TIMER_READY);
                        } else {
                            this._brakeSpeedValueLabel.setText(brakeSpeedValueString);
                        }
                    }
                }
            }
        }
    }
}

