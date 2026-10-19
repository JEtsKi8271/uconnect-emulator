/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Display
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.TextArea
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.logger.Log
 *  kona.platform.PlatformException
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.controller.savetimerrun.UploadTimerRunController;
import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.model.PerformanceSRTAttributesEnum;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.view.timerview.TimerButtonsContainer;
import com.sprint.gskills.view.timerview.TimerOkButtonContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Display;
import com.sun.lwuit.Font;
import com.sun.lwuit.TextArea;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import edu.emory.mathcs.backport.java.util.concurrent.Executors;
import edu.emory.mathcs.backport.java.util.concurrent.ScheduledFuture;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import kona.logger.Log;
import kona.platform.PlatformException;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;

public abstract class CommonTimerViewContainer
extends Container
implements GSkillsViewDataListener {
    Logger logger = Log.createLogger((String)this.getClass().getName());
    private TimersDisplayStatusEnum timerType;
    private final int containerWidth = 280;
    private CommonLabel runTitleLabel;
    private CommonLabel timersTrialTitleLabel;
    private CommonLabel linesLabel;
    private CommonLabel zeroToSixtyLabel;
    private CommonLabel eighthEtLabel;
    private CommonLabel eighthMphLabel;
    private CommonLabel quaterEtLabel;
    private CommonLabel quaterMphLabel;
    private CommonLabel brakeDistLabel;
    private CommonLabel brakeSpeedLabel;
    protected Container zeroToSixtyContainer;
    protected Container eighthEtContainer;
    protected Container eighthMphContainer;
    protected Container quarterEtContainer;
    protected Container quarterMphContainer;
    protected Container brakeDistContainer;
    protected Container brakeSpeedContainer;
    protected CommonLabel zeroToSixtyValueLabel;
    protected CommonLabel eighthEValueLabel;
    protected CommonLabel eighthMphValueLabel;
    protected CommonLabel quarterEtValueLabel;
    protected CommonLabel quarterMphValueLabel;
    protected CommonLabel brakeDistValueLabel;
    protected CommonLabel brakeSpeedValueLabel;
    protected CommonLabel zeroToSixtyValueUnitLabel;
    protected CommonLabel eighthEValueUnitLabel;
    protected CommonLabel eighthMphValueUnitLabel;
    protected CommonLabel quarterEtValueUnitLabel;
    protected CommonLabel quarterMphValueUnitLabel;
    protected CommonLabel brakeDistValueUnitLabel;
    protected CommonLabel brakeSpeedValueUnitLabel;
    private String zeroToSixtyValue = "--";
    private String eighthEValue = "--";
    private String eighthMphValue = "--";
    private String quaterEtValue = "--";
    private String quaterMphValue = "--";
    private String brakeDistValue = "--";
    private String brakeSpeedValue = "--";
    private Container centerTimerContainer = null;
    private final int centerDownComponentIndex = 1;
    private Container timerSummaryContainer = null;
    private Container centerDownDialogContainer = null;
    private TextArea dialog;
    private Container saveStatusContainer = null;
    private final int buttonContainerIndex = 1;
    private TimerButtonsContainer timerTypeButtonConatiner = null;
    private TimerButtonsContainer saveOptionsButtonConatiner = null;
    private TimerButtonsContainer okButtonConatiner = null;
    private TimerButtonsContainer timerCancelButtonContainer = null;
    private final Object syncObject = new Object();
    private ScheduledFuture timerBlinkFuture = null;
    protected TimerLabelBlinkHandler timerLabelBlinkHandler = new TimerLabelBlinkHandler();
    private CommonViewResourceManager resourceManager = CommonViewResourceManager.getInstance();
    private GSkillsFontsStyleFactory fontFactory = GSkillsFontsStyleFactory.getInstance();
    private int saveStatus;
    private TextArea saveStatusTextArea;
    private TextArea saveInfoTextArea;
    private TimerSaveOptionsEnum timerSaveOption;
    private UploadTimerRunController uploadTimerRunController = null;
    boolean languageFlag;
    public static final int ZERO_TO_SIXTY_LABEL = 1;
    public static final int EIGHTH_MILE_TM_LABEL = 2;
    public static final int EIGHTH_MILE_SPD_LABEL = 3;
    public static final int QRTR_MILE_TM_LABEL = 4;
    public static final int QRTR_MILE_SPD_LABEL = 5;
    public static final int BRAKING_DIST_LABEL = 6;
    public static final int BRAKING_SPD_LABEL = 7;

    protected void setZeroToSixtyValue(String zeroToSixtyValue) {
        this.zeroToSixtyValue = zeroToSixtyValue;
    }

    protected void setEighthEValue(String eighthEValue) {
        this.eighthEValue = eighthEValue;
    }

    protected void setEighthMphValue(String eighthMphValue) {
        this.eighthMphValue = eighthMphValue;
    }

    protected void setQuaterEtValue(String quaterEtValue) {
        this.quaterEtValue = quaterEtValue;
    }

    protected void setQuaterMphValue(String quaterMphValue) {
        this.quaterMphValue = quaterMphValue;
    }

    protected void setBrakeDistValue(String brakeDistValue) {
        this.brakeDistValue = brakeDistValue;
    }

    protected void setBrakeSpeedValue(String brakeSpeedValue) {
        this.brakeSpeedValue = brakeSpeedValue;
    }

    protected void initializeTimerContainer(TimersDisplayStatusEnum timersDisplayStatusEnum, int metricUnit, TimerButtonsContainer timebuttonscontainer, TimerButtonsContainer savebuttonscontainer, TimerButtonsContainer timerOkButtonContainer, TimerOkButtonContainer timerCancelButtonContainer, boolean addBrakeLabel) {
        this.setLayout((Layout)new BoxLayout(1));
        this.getStyle().setMargin(1, 23);
        this.timerType = timersDisplayStatusEnum;
        this.centerTimerContainer = this.initializecenterTimerContainer();
        this.centerTimerContainer.addComponent((Component)this.initializeCenterUpTimerContainer(timersDisplayStatusEnum));
        this.timerSummaryContainer = this.initializeCenterDownTimerContainer(metricUnit, addBrakeLabel);
        this.centerTimerContainer.addComponent(1, (Component)this.timerSummaryContainer);
        this.timerTypeButtonConatiner = timebuttonscontainer;
        this.timerTypeButtonConatiner.initView(timersDisplayStatusEnum);
        this.addComponent((Component)this.centerTimerContainer);
        this.addComponent(1, (Component)((Container)this.timerTypeButtonConatiner));
        this.centerDownDialogContainer = this.getCenterDownContainer();
        this.updateDialogContainer(this.centerDownDialogContainer, timersDisplayStatusEnum);
        this.saveStatusContainer = this.getCenterDownContainer();
        this.saveStatusContainer.setLayout((Layout)new CoordinateLayout(new Dimension(280, 183)));
        this.saveOptionsButtonConatiner = savebuttonscontainer;
        this.timerCancelButtonContainer = timerCancelButtonContainer;
        this.okButtonConatiner = timerOkButtonContainer;
        this.setPreferredSize(new Dimension(468, 279));
    }

    private Container initializeCenterDownTimerContainer(int metricUnit, boolean addBrakeLabel) {
        Container summaryDisplayContainer = this.getCenterDownContainer();
        this.addUSTimerSummaryRows(summaryDisplayContainer, addBrakeLabel);
        return summaryDisplayContainer;
    }

    private Container getCenterDownContainer() {
        Container container = new Container();
        container.setPreferredSize(new Dimension(280, 200));
        return container;
    }

    private Container initializeCenterUpTimerContainer(TimersDisplayStatusEnum timersDisplayStatusEnum) {
        Container centerUpContainer = new Container();
        this.runTitleLabel = this.initializeLabel();
        this.runTitleLabel.getStyle().setFgColor(timersDisplayStatusEnum.getFontColor());
        this.runTitleLabel.setPreferredSize(new Dimension(280, 25));
        this.runTitleLabel.getStyle().setFont(this.fontFactory.getFontSize28());
        this.timersTrialTitleLabel = this.initializeLabel();
        this.linesLabel = this.initializeLabel();
        this.linesLabel.setPreferredH(5);
        this.linesLabel.setAlignment(4);
        this.linesLabel.getStyle().setFont(this.fontFactory.getFontSize18());
        this.linesLabel.setText("-----------------------");
        centerUpContainer.addComponent(this.addPadding(6));
        centerUpContainer.addComponent((Component)this.runTitleLabel);
        centerUpContainer.addComponent((Component)this.timersTrialTitleLabel);
        centerUpContainer.addComponent((Component)this.linesLabel);
        return centerUpContainer;
    }

    private CommonLabel initializeLabel() {
        CommonLabel timerLabel = new CommonLabel();
        timerLabel.getStyle().setFgColor(0);
        timerLabel.setAlignment(4);
        timerLabel.setPreferredSize(new Dimension(280, 18));
        timerLabel.getStyle().setFont(this.fontFactory.getFontSize18());
        return timerLabel;
    }

    private void updateDialogContainer(Container centerDownDialogContainer, TimersDisplayStatusEnum timersDisplayStatusEnum) {
        this.dialog = this.getDialogTextArea(183, this.fontFactory.getFontSize22());
        centerDownDialogContainer.addComponent((Component)this.dialog);
    }

    private TextArea getDialogTextArea(int height, Font fontStyle) {
        TextArea dialog = new TextArea();
        dialog.setPreferredSize(new Dimension(280, height));
        dialog.getStyle().setFgColor(0);
        dialog.getUnselectedStyle().setFont(fontStyle);
        dialog.getSelectedStyle().setFont(fontStyle);
        dialog.setAlignment(4);
        dialog.setEditable(false);
        dialog.setFocusable(false);
        dialog.getStyle().setBorder(null);
        dialog.getStyle().setPadding(0, 0, 20, 20);
        dialog.getStyle().setBgTransparency(0);
        return dialog;
    }

    private String replaceTimerType(String source, String pattern, String replacementSubString) {
        if (source.indexOf(pattern) == -1) {
            return source;
        }
        String temString = source.substring(0, source.lastIndexOf(pattern)) + replacementSubString + source.substring(source.lastIndexOf(pattern) + pattern.length(), source.length());
        return this.replaceTimerType(temString, pattern, replacementSubString);
    }

    private Container addUSTimerSummaryRows(Container downLeftContainer, boolean addBrakeLabel) {
        Font centerDownTimerContainerFontStyle = this.fontFactory.getFontSize18();
        this.zeroToSixtyContainer = this.initializeCenterDownContainerRows();
        this.zeroToSixtyLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this.zeroToSixtyValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.zeroToSixtyValueUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.zeroToSixtyContainer.addComponent((Component)this.zeroToSixtyLabel);
        this.zeroToSixtyContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        this.zeroToSixtyContainer.addComponent((Component)this.zeroToSixtyValueLabel);
        this.zeroToSixtyContainer.addComponent((Component)this.zeroToSixtyValueUnitLabel);
        this.eighthEtContainer = this.initializeCenterDownContainerRows();
        this.eighthEtLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this.eighthEValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.eighthEValueUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.eighthEtContainer.addComponent((Component)this.eighthEtLabel);
        this.eighthEtContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        this.eighthEtContainer.addComponent((Component)this.eighthEValueLabel);
        this.eighthEtContainer.addComponent((Component)this.eighthEValueUnitLabel);
        this.eighthMphContainer = this.initializeCenterDownContainerRows();
        this.eighthMphLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this.eighthMphValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.eighthMphValueUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.eighthMphContainer.addComponent((Component)this.eighthMphLabel);
        this.eighthMphContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        this.eighthMphContainer.addComponent((Component)this.eighthMphValueLabel);
        this.eighthMphContainer.addComponent((Component)this.eighthMphValueUnitLabel);
        this.quarterEtContainer = this.initializeCenterDownContainerRows();
        this.quaterEtLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this.quarterEtValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.quarterEtValueUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.quarterEtContainer.addComponent((Component)this.quaterEtLabel);
        this.quarterEtContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        this.quarterEtContainer.addComponent((Component)this.quarterEtValueLabel);
        this.quarterEtContainer.addComponent((Component)this.quarterEtValueUnitLabel);
        this.quarterMphContainer = this.initializeCenterDownContainerRows();
        this.quaterMphLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this.quarterMphValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.quarterMphValueUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this.quarterMphContainer.addComponent((Component)this.quaterMphLabel);
        this.quarterMphContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        this.quarterMphContainer.addComponent((Component)this.quarterMphValueLabel);
        this.quarterMphContainer.addComponent((Component)this.quarterMphValueUnitLabel);
        downLeftContainer.addComponent((Component)this.zeroToSixtyContainer);
        downLeftContainer.addComponent(this.addPadding(4));
        downLeftContainer.addComponent((Component)this.eighthEtContainer);
        downLeftContainer.addComponent((Component)this.eighthMphContainer);
        downLeftContainer.addComponent(this.addPadding(4));
        downLeftContainer.addComponent((Component)this.quarterEtContainer);
        downLeftContainer.addComponent((Component)this.quarterMphContainer);
        if (addBrakeLabel) {
            this.brakeDistContainer = this.initializeCenterDownContainerRows();
            this.brakeDistLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
            this.brakeDistValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            this.brakeDistValueUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            this.brakeDistContainer.addComponent((Component)this.brakeDistLabel);
            this.brakeDistContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
            this.brakeDistContainer.addComponent((Component)this.brakeDistValueLabel);
            this.brakeDistContainer.addComponent((Component)this.brakeDistValueUnitLabel);
            this.brakeSpeedContainer = this.initializeCenterDownContainerRows();
            this.brakeSpeedLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
            this.brakeSpeedValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            this.brakeSpeedValueUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            this.brakeSpeedContainer.addComponent((Component)this.brakeSpeedLabel);
            this.brakeSpeedContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
            this.brakeSpeedContainer.addComponent((Component)this.brakeSpeedValueLabel);
            this.brakeSpeedContainer.addComponent((Component)this.brakeSpeedValueUnitLabel);
            downLeftContainer.addComponent(this.addPadding(4));
            downLeftContainer.addComponent((Component)this.brakeDistContainer);
            downLeftContainer.addComponent((Component)this.brakeSpeedContainer);
        }
        return downLeftContainer;
    }

    private Component getHyphenLabel(Font centerDownTimerContainerFontStyle) {
        CommonLabel hyphenLabel = new CommonLabel("-");
        hyphenLabel.setLabelStyle(0, new Dimension(15, 16), 1);
        hyphenLabel.getStyle().setPadding(1, 4);
        hyphenLabel.getStyle().setFont(centerDownTimerContainerFontStyle);
        return hyphenLabel;
    }

    private Component addPadding(int height) {
        CommonLabel addPadding = new CommonLabel();
        addPadding.setPreferredSize(new Dimension(280, height));
        return addPadding;
    }

    private Container initializeCenterDownContainerRows() {
        Container centerDownContainerRows = new Container();
        centerDownContainerRows.setLayout((Layout)new BoxLayout(1));
        centerDownContainerRows.setPreferredSize(new Dimension(280, 20));
        return centerDownContainerRows;
    }

    private CommonLabel initializeCenterDownLabelValues(Font centerDownTimerContainerFontStyle) {
        CommonLabel timerLabelValue = new CommonLabel();
        timerLabelValue.setLabelStyle(0xE10000, new Dimension(101, 20), 1);
        timerLabelValue.getStyle().setFont(centerDownTimerContainerFontStyle);
        timerLabelValue.setText("--");
        return timerLabelValue;
    }

    private CommonLabel initializeCenterDownLabels(Font centerDownTimerContainerFontStyle) {
        CommonLabel timerLabel = new CommonLabel();
        timerLabel.setLabelStyle(0, new Dimension(180, 20), 3);
        timerLabel.getStyle().setFont(centerDownTimerContainerFontStyle);
        timerLabel.getStyle().setBgColor(0xEE9009);
        return timerLabel;
    }

    private Container initializecenterTimerContainer() {
        Container centerTimerContainer = new Container();
        centerTimerContainer.setPreferredSize(new Dimension(342, 279));
        centerTimerContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_timeslip.png"));
        centerTimerContainer.setLayout((Layout)new BoxLayout(2));
        centerTimerContainer.getStyle().setBgTransparency(0);
        centerTimerContainer.getStyle().setBackgroundAlignment((byte)-93);
        return centerTimerContainer;
    }

    public void updateViewOnDataChanged() {
        this.logger.error((Object)"updateViewOnDataChanged: unimplemented method");
    }

    protected void updateViewOnLanguageChanged(TimersDisplayStatusEnum timersDisplayStatusEnum, int unit, boolean hasBrakeLabel) {
        this.runTitleLabel.setText(this.resourceManager.getLanguageResByKey("timer_state_" + timersDisplayStatusEnum.getTitleName()));
        this.timersTrialTitleLabel.setText(this.resourceManager.getLanguageResByKey("timer_title_timerTrials"));
        this.timerTypeButtonConatiner.updateOnLanguageChanged();
        this.okButtonConatiner.updateOnLanguageChanged();
        this.timerCancelButtonContainer.updateOnLanguageChanged();
        this.saveOptionsButtonConatiner.updateOnLanguageChanged();
        this.dialog.setText(this.replaceTimerType(this.resourceManager.getLanguageResByKey("timer_mes_downloadLacation"), "[type]", this.resourceManager.getLanguageResByKey("timer_state_" + timersDisplayStatusEnum.getTitleName())));
        if (unit == 0) {
            this.zeroToSixtyLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_60MPHTM_US.getTimerPageTitle()));
            this.eighthEtLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_EIGHTHTM_US.getTimerPageTitle()));
            this.eighthMphLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_ETHSPD_US.getTimerPageTitle()));
            this.quaterEtLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QUARTERTM_US.getTimerPageTitle()));
            this.quaterMphLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QRTSPD_US.getTimerPageTitle()));
            this.zeroToSixtyValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_Timer"));
            this.eighthEValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_Timer"));
            this.eighthMphValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_US_Speed"));
            this.quarterEtValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_Timer"));
            this.quarterMphValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_US_Speed"));
            if (hasBrakeLabel) {
                this.brakeDistLabel.setText(this.resourceManager.getLanguageResByKey("timer_title_BrakeDis"));
                this.brakeSpeedLabel.setText(this.resourceManager.getLanguageResByKey("timer_title_BrakeSpeed"));
                this.brakeDistValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_US_BrakeDistance"));
                this.brakeSpeedValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_US_Speed"));
            }
        } else {
            this.zeroToSixtyLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_60MPHTM_M.getTimerPageTitle()));
            this.eighthEtLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_EIGHTHTM_M.getTimerPageTitle()));
            this.eighthMphLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_ETHSPD_M.getTimerPageTitle()));
            this.quaterEtLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QUARTERTM_M.getTimerPageTitle()));
            this.quaterMphLabel.setText(this.resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QRTSPD_M.getTimerPageTitle()));
            this.zeroToSixtyValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_Timer"));
            this.eighthEValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_Timer"));
            this.eighthMphValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_M_Speed"));
            this.quarterEtValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_Timer"));
            this.quarterMphValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_M_Speed"));
            if (hasBrakeLabel) {
                this.brakeDistLabel.setText(this.resourceManager.getLanguageResByKey("timer_title_BrakeDis_M"));
                this.brakeSpeedLabel.setText(this.resourceManager.getLanguageResByKey("timer_title_BrakeSpeed_M"));
                this.brakeDistValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_M_BrakeDistance"));
                this.brakeSpeedValueUnitLabel.setText(this.resourceManager.getLanguageResByKey("unit_M_Speed"));
            }
        }
        this.setTextWithSaveStatus();
    }

    public void updateViewOnUnitChanged() {
    }

    protected void updateDialogAndButtons(TimerSaveOptionsEnum timerSaveOption) {
        Date date = new Date();
        if (timerSaveOption == TimerSaveOptionsEnum.SAVE) {
            this.centerTimerContainer.replaceAndWait(this.centerTimerContainer.getComponentAt(1), (Component)this.centerDownDialogContainer, null);
            this.replaceButtonContainer((Container)this.saveOptionsButtonConatiner);
        } else if (timerSaveOption == TimerSaveOptionsEnum.CANCEL || timerSaveOption == TimerSaveOptionsEnum.OK) {
            this.centerTimerContainer.replaceAndWait(this.centerTimerContainer.getComponentAt(1), (Component)this.timerSummaryContainer, null);
            this.replaceButtonContainer((Container)this.timerTypeButtonConatiner);
            if (this.uploadTimerRunController != null) {
                this.uploadTimerRunController.cancelUploadTask();
                this.uploadTimerRunController = null;
            }
        } else if (timerSaveOption == TimerSaveOptionsEnum.uConnect) {
            this.updateViewWithSaveStatus(15, timerSaveOption);
            this.centerTimerContainer.replaceAndWait(this.centerTimerContainer.getComponentAt(1), (Component)this.saveStatusContainer, null);
            this.replaceButtonContainer((Container)this.timerCancelButtonContainer);
            this.uploadTimerRunController = UploadTimerRunController.getInstance();
            this.uploadTimerRunController.submitUploadTask(this.convertDataToHtml(date), this.getFileName(date), this);
        } else {
            int saveStatus = GSkillsProjectFactory.getTimerSavingData().saveDataTo(timerSaveOption, this.convertDataToHtml(date), this.getFileName(date));
            this.updateViewWithSaveStatus(saveStatus, timerSaveOption);
            this.centerTimerContainer.replaceAndWait(this.centerTimerContainer.getComponentAt(1), (Component)this.saveStatusContainer, null);
            this.replaceButtonContainer((Container)this.okButtonConatiner);
        }
    }

    private void replaceButtonContainer(Container newConatiner) {
        this.replaceAndWait(this.getComponentAt(1), (Component)newConatiner, null);
    }

    private String getFileName(Date date) {
        SimpleDateFormat dateFormat;
        StringBuffer fileName = new StringBuffer();
        fileName.append(this.replaceTimerType(this.resourceManager.getLanguageResByKey("timer_state_" + this.timerType.getTitleName()), "|", "i"));
        fileName.append("_");
        try {
            dateFormat = new SimpleDateFormat("ddMMMMMyyyy_hhmma", PlatformInfo.getPlatformInfo().getCurrentLocale());
        }
        catch (PlatformException e2) {
            dateFormat = new SimpleDateFormat("ddMMMMMyyyy_hhmma");
        }
        fileName.append(dateFormat.format(date));
        fileName.append("_");
        fileName.append(ResKeyPropertiesFactory.getVehicleLineName(GSkillsStateManager.getInstance().getVehicleLine()));
        return fileName.toString();
    }

    private void updateViewWithSaveStatus(int saveStatus, TimerSaveOptionsEnum timerSaveOption) {
        this.saveStatusContainer.removeAll();
        this.saveStatus = saveStatus;
        this.timerSaveOption = timerSaveOption;
        this.saveStatusTextArea = this.getDialogTextArea(50, this.fontFactory.getFontSize22());
        this.saveInfoTextArea = this.getDialogTextArea(110, this.fontFactory.getFontSize18());
        this.setTextWithSaveStatus();
        Container infoContainer = this.getCenterDownContainer();
        infoContainer.addComponent((Component)this.saveStatusTextArea);
        infoContainer.addComponent((Component)this.saveInfoTextArea);
        this.saveStatusContainer.addComponent((Component)infoContainer);
    }

    private void setTextWithSaveStatus() {
        switch (this.saveStatus) {
            case 13: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_succeed"));
                break;
            }
            case 14: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_succeed"));
                this.saveInfoTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_info_viewOnLine"));
                break;
            }
            case 23: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_error_cannotSave"));
                this.saveInfoTextArea.setText(this.replaceTimerType(this.resourceManager.getLanguageResByKey("timer_mes_info_NotFound"), "[type]", this.resourceManager.getLanguageResByKey(this.timerSaveOption.getTitleName())));
                break;
            }
            case 24: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_error_cannotSave"));
                this.saveInfoTextArea.setText(this.replaceTimerType(this.resourceManager.getLanguageResByKey("timer_mes_info_full"), "[type]", this.resourceManager.getLanguageResByKey(this.timerSaveOption.getTitleName())));
                break;
            }
            case 15: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_saving_to_website"));
                this.saveInfoTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_please_wait"));
                break;
            }
            case 33: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_error_networkError"));
                this.saveInfoTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_info_cannotUpload"));
                break;
            }
            case 22: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_error_networkError"));
                this.saveInfoTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_info_cannotUpload"));
                break;
            }
            case 34: {
                this.saveStatusTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_error_noID"));
                this.saveInfoTextArea.setText(this.resourceManager.getLanguageResByKey("timer_mes_info_needId"));
            }
        }
    }

    private String convertDataToHtml(Date date) {
        SimpleDateFormat df = new SimpleDateFormat("MM/d/yy h:mm a");
        String timersTrial = df.format(date);
        String timezone = "UTC" + df.getTimeZone().getDisplayName().substring(3);
        StringBuilder ds = new StringBuilder();
        ds.append("<html>");
        ds.append("<head> <title>" + this.resourceManager.getLanguageResByKey("timer_save_file_title") + "</title>");
        ds.append("<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"></meta>");
        ds.append("</head><body>");
        ds.append("<h2>" + timersTrial + "--" + timezone + "</h2>");
        ds.append("<table  border=\"1\" frame = \"border\">");
        ds.append("<tr><td>" + this.resourceManager.getLanguageResByKey("timer_save_column_timer") + "</td><td>" + "" + "</td></tr>");
        ds.append("<tr><td>" + this.zeroToSixtyLabel.getText() + "</td><td>" + this.zeroToSixtyValueLabel.getText() + " " + this.zeroToSixtyValueUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this.eighthEtLabel.getText() + "</td><td>" + this.eighthEValueLabel.getText() + " " + this.eighthEValueUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this.eighthMphLabel.getText() + "</td><td>" + this.eighthMphValueLabel.getText() + " " + this.eighthMphValueUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this.quaterEtLabel.getText() + "</td><td>" + this.quarterEtValueLabel.getText() + " " + this.quarterEtValueUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this.quaterMphLabel.getText() + "</td><td>" + this.quarterMphValueLabel.getText() + " " + this.quarterMphValueUnitLabel.getText() + "</td></tr>");
        if (this.brakeDistLabel != null) {
            ds.append("<tr><td>" + this.brakeDistLabel.getText() + "</td><td>" + this.brakeDistValueLabel.getText() + " " + this.brakeDistValueUnitLabel.getText() + "</td></tr>");
            ds.append("<tr><td>" + this.brakeSpeedLabel.getText() + "</td><td>" + this.brakeSpeedValueLabel.getText() + " " + this.brakeSpeedValueUnitLabel.getText() + "</td></tr>");
        }
        ds.append("</table>");
        ds.append("</body>");
        ds.append("</html>");
        return this.replaceTimerType(ds.toString(), "|", "i");
    }

    public void notifyStatus(int remoteError) {
        this.uploadTimerRunController = null;
        Display.getInstance().callSerially((Runnable)new UpdateSaveStatusDialog(remoteError));
    }

    public void startTimersBlinkThread() {
        if (null == this.timerBlinkFuture) {
            this.logger.debug((Object)"Starting the Timer blink thread.");
            this.timerBlinkFuture = Executors.newSingleThreadScheduledExecutor().scheduleAtFixedRate(this.timerLabelBlinkHandler, 0L, 500L, TimeUnit.MILLISECONDS);
        }
    }

    public void stopTimerBlinkThread() {
        if (null != this.timerBlinkFuture) {
            this.logger.debug((Object)"Shutting down the Timer blink thread.");
            this.timerBlinkFuture.cancel(true);
            this.timerBlinkFuture = null;
        }
    }

    class TimerLabelBlinkHandler
    implements Runnable {
        private ArrayList<Integer> blinkingLabelsList = new ArrayList();
        private HashMap<Integer, CommonLabel> blinkingLabelsMap = new HashMap();
        private boolean drawDash = true;
        private long time = System.currentTimeMillis();
        private boolean repaintRequired = false;
        private String labelText = "";

        public void initLabelMap() {
            this.blinkingLabelsMap.put(1, CommonTimerViewContainer.this.zeroToSixtyValueLabel);
            this.blinkingLabelsMap.put(4, CommonTimerViewContainer.this.quarterEtValueLabel);
            this.blinkingLabelsMap.put(5, CommonTimerViewContainer.this.quarterMphValueLabel);
            this.blinkingLabelsMap.put(2, CommonTimerViewContainer.this.eighthEValueLabel);
            this.blinkingLabelsMap.put(3, CommonTimerViewContainer.this.eighthMphValueLabel);
            this.blinkingLabelsMap.put(6, CommonTimerViewContainer.this.brakeDistValueLabel);
            this.blinkingLabelsMap.put(7, CommonTimerViewContainer.this.brakeSpeedValueLabel);
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public void registerForBlinking(int labelIndex) {
            Object object = CommonTimerViewContainer.this.syncObject;
            synchronized (object) {
                if (!this.blinkingLabelsList.contains(labelIndex)) {
                    this.blinkingLabelsList.add(labelIndex);
                }
            }
        }

        /*
         * WARNING - Removed try catching itself - possible behaviour change.
         */
        public void unregisterForBlinking(int labelIndex) {
            Object object = CommonTimerViewContainer.this.syncObject;
            synchronized (object) {
                if (this.blinkingLabelsList.contains(labelIndex)) {
                    this.blinkingLabelsList.remove(this.blinkingLabelsList.indexOf(labelIndex));
                }
            }
        }

        public void run() {
            long currentTime = System.currentTimeMillis();
            if (this.drawDash) {
                if (currentTime - this.time > 1000L) {
                    this.time = currentTime;
                    this.repaintRequired = true;
                    this.labelText = "";
                    this.drawDash = false;
                }
            } else if (currentTime - this.time > 500L) {
                this.repaintRequired = true;
                this.labelText = "--";
                this.drawDash = true;
            }
            if (this.repaintRequired) {
                Display.getInstance().callSerially(new Runnable(){

                    /*
                     * WARNING - Removed try catching itself - possible behaviour change.
                     */
                    public void run() {
                        ArrayList localList = new ArrayList();
                        Object object = CommonTimerViewContainer.this.syncObject;
                        synchronized (object) {
                            localList.addAll(TimerLabelBlinkHandler.this.blinkingLabelsList);
                        }
                        for (int i2 = 0; i2 < localList.size(); ++i2) {
                            CommonLabel label;
                            int index = (Integer)localList.get(i2);
                            if (!TimerLabelBlinkHandler.this.blinkingLabelsMap.containsKey(index) || null == (label = (CommonLabel)((Object)TimerLabelBlinkHandler.this.blinkingLabelsMap.get(index)))) continue;
                            label.setText(TimerLabelBlinkHandler.this.labelText);
                        }
                    }
                });
                this.repaintRequired = false;
            }
        }
    }

    private class UpdateSaveStatusDialog
    implements Runnable {
        int saveDialogInt;

        public UpdateSaveStatusDialog(int saveDialogInt) {
            this.saveDialogInt = saveDialogInt;
        }

        public void run() {
            CommonTimerViewContainer.this.updateViewWithSaveStatus(this.saveDialogInt, null);
            CommonTimerViewContainer.this.centerTimerContainer.replace(CommonTimerViewContainer.this.centerTimerContainer.getComponentAt(1), (Component)CommonTimerViewContainer.this.saveStatusContainer, null);
            CommonTimerViewContainer.this.centerTimerContainer.revalidate();
            CommonTimerViewContainer.this.replaceButtonContainer((Container)CommonTimerViewContainer.this.okButtonConatiner);
        }
    }

    protected class RefreshCenterDownTimerContainer
    implements Runnable {
        protected RefreshCenterDownTimerContainer() {
        }

        public void run() {
            CommonTimerViewContainer.this.zeroToSixtyValueLabel.setText(CommonTimerViewContainer.this.zeroToSixtyValue);
            CommonTimerViewContainer.this.eighthEValueLabel.setText(CommonTimerViewContainer.this.eighthEValue);
            CommonTimerViewContainer.this.eighthMphValueLabel.setText(CommonTimerViewContainer.this.eighthMphValue);
            CommonTimerViewContainer.this.quarterEtValueLabel.setText(CommonTimerViewContainer.this.quaterEtValue);
            CommonTimerViewContainer.this.quarterMphValueLabel.setText(CommonTimerViewContainer.this.quaterMphValue);
            if (CommonTimerViewContainer.this.brakeDistValueLabel != null) {
                CommonTimerViewContainer.this.brakeDistValueLabel.setText(CommonTimerViewContainer.this.brakeDistValue);
                CommonTimerViewContainer.this.brakeSpeedValueLabel.setText(CommonTimerViewContainer.this.brakeSpeedValue);
            }
        }
    }
}

