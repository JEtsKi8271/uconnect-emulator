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
 *  kona.platform.PlatformException
 *  kona.platform.PlatformInfo
 */
package com.sprint.gskills.view.timers;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.controller.savetimerrun.TimerSavingData;
import com.sprint.gskills.controller.savetimerrun.UploadTimerRunController;
import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.model.timers.CommonTimerModel;
import com.sprint.gskills.model.timers.PerformanceSRTAttributesEnum;
import com.sprint.gskills.unit.SpeedUnitEnum;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.FastNumberLabel;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsView;
import com.sprint.gskills.view.timers.components.CommonTimerButtonsContainer;
import com.sprint.gskills.view.timers.components.TimerTypeButtonsContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Display;
import com.sun.lwuit.Font;
import com.sun.lwuit.TextArea;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import kona.platform.PlatformException;
import kona.platform.PlatformInfo;

public abstract class CommonTimerView
extends GSkillsView {
    private TimersDisplayStatusEnum _timerType;
    private final int CONTAINER_W = 280;
    private CommonLabel _websiteLabel;
    private CommonLabel _runTitleLabel;
    private CommonLabel _timerTrialsTitleLabel;
    private CommonLabel _linesLabel;
    private CommonLabel _reactionTimeLabel;
    private CommonLabel _zeroToSixtyLabel;
    private CommonLabel _zeroToHundredLabel;
    private CommonLabel _eighthEtLabel;
    private CommonLabel _eighthMphLabel;
    private CommonLabel _quarterEtLabel;
    private CommonLabel _quarterMphLabel;
    private CommonLabel _sixtyFeetLabel;
    private CommonLabel _brakeDistLabel;
    private CommonLabel _brakeSpeedLabel;
    protected FastNumberLabel _reactionTimeValueLabel;
    protected FastNumberLabel _zeroToSixtyValueLabel;
    protected FastNumberLabel _zeroToHundredValueLabel;
    protected FastNumberLabel _eighthEValueLabel;
    protected FastNumberLabel _eighthMphValueLabel;
    protected FastNumberLabel _quarterEtValueLabel;
    protected FastNumberLabel _quarterMphValueLabel;
    protected FastNumberLabel _sixtyFeetValueLabel;
    protected FastNumberLabel _brakeDistValueLabel;
    protected FastNumberLabel _brakeSpeedValueLabel;
    protected CommonLabel _reactionTimeUnitLabel;
    protected CommonLabel _zeroToSixtyUnitLabel;
    protected CommonLabel _zeroToHundredUnitLabel;
    protected CommonLabel _eighthEUnitLabel;
    protected CommonLabel _eighthMphUnitLabel;
    protected CommonLabel _quarterEtUnitLabel;
    protected CommonLabel _quarterMphUnitLabel;
    protected CommonLabel _sixtyFeetUnitLabel;
    protected CommonLabel _brakeDistUnitLabel;
    protected CommonLabel _brakeSpeedUnitLabel;
    private Container _centerTimerContainer = null;
    private Container _timerSummaryContainer = null;
    private Container _centerDownDialogContainer = null;
    private Container _saveStatusContainer = null;
    private TextArea _dialog;
    private final int _buttonContainerIndex = 1;
    private final int _centerDownComponentIndex = 1;
    private CommonTimerButtonsContainer _timerTypeButtonContainer = null;
    protected CommonTimerModel _timerModel = null;
    private GSkillsResourceManager _resourceManager = GSkillsResourceManager.getInstance();
    private GSkillsFontsStyleFactory _fontFactory = GSkillsFontsStyleFactory.getInstance();
    protected boolean _is60ftTimerAvailable = false;
    private int _saveStatus;
    private TextArea _saveStatusTextArea;
    private TextArea _saveInfoTextArea;
    private TimerSaveOptionsEnum _timerSaveOption;
    private UploadTimerRunController _uploadTimerRunController = null;
    protected static final String SNA_STRING = "--";

    public CommonTimerView(TimersDisplayStatusEnum timerType) {
        this._timerType = timerType;
        this.setTimerModel();
        if (!GSkillsStateManager.getInstance().isLSeriesVehicle()) {
            this._is60ftTimerAvailable = true;
        }
    }

    protected abstract void setTimerModel();

    protected void initializeTimerContainer() {
        this.setLayout((Layout)new BoxLayout(1));
        this.getStyle().setMargin(0, 5);
        this.getStyle().setMargin(1, 23);
        this._centerTimerContainer = this.initCenterTimerContainer();
        this._timerSummaryContainer = this.initCenterDownTimerContainer();
        this._centerTimerContainer.addComponent((Component)this.initCenterTopTimerContainer());
        this._centerTimerContainer.addComponent(1, (Component)this._timerSummaryContainer);
        this._timerTypeButtonContainer = new TimerTypeButtonsContainer();
        this._timerTypeButtonContainer.initView(this._timerType);
        this.addComponent((Component)this._centerTimerContainer);
        this.addComponent(1, (Component)((Container)this._timerTypeButtonContainer));
        this._centerDownDialogContainer = this.getCenterDownContainer();
        this.updateDialogContainer(this._centerDownDialogContainer);
        this._saveStatusContainer = this.getCenterDownContainer();
        this._saveStatusContainer.setLayout((Layout)new CoordinateLayout(new Dimension(280, 183)));
        this.setPreferredSize(new Dimension(468, 280));
    }

    private Container initCenterDownTimerContainer() {
        Container summaryDisplayContainer = this.getCenterDownContainer();
        this.addTimerSummaryRows(summaryDisplayContainer);
        return summaryDisplayContainer;
    }

    private Container getCenterDownContainer() {
        Container container = new Container();
        container.setPreferredSize(new Dimension(280, 230));
        return container;
    }

    private Container initCenterTopTimerContainer() {
        this._websiteLabel = this.initializeLabel();
        this._websiteLabel.setPreferredSize(new Dimension(280, 14));
        this._websiteLabel.getStyle().setFont(this._fontFactory.getFontSize14());
        this._websiteLabel.getStyle().setFgColor(0x4A4A4A);
        this._runTitleLabel = this.initializeLabel();
        this._runTitleLabel.getStyle().setFgColor(this._timerType.getFontColor());
        this._runTitleLabel.setPreferredSize(new Dimension(280, 33));
        this._runTitleLabel.getStyle().setFont(this._fontFactory.getFontSize28());
        this._runTitleLabel.getStyle().setPadding(4, 0, 0, 0);
        this._timerTrialsTitleLabel = this.initializeLabel();
        this._linesLabel = this.initializeLabel();
        this._linesLabel.setPreferredH(4);
        this._linesLabel.getStyle().setFont(this._fontFactory.getFontSize18());
        if (VehicleTrimEnum.RT == GSkillsStateManager.getInstance().getVehicleTrim()) {
            this._linesLabel.setText("---------------------------------------");
        } else {
            this._linesLabel.setText("---------------------------------");
        }
        Container centerUpContainer = new Container();
        centerUpContainer.addComponent(this.addPadding(3));
        centerUpContainer.addComponent((Component)this._websiteLabel);
        centerUpContainer.addComponent((Component)this._runTitleLabel);
        centerUpContainer.addComponent((Component)this._linesLabel);
        centerUpContainer.setPreferredH(56);
        return centerUpContainer;
    }

    private CommonLabel initializeLabel() {
        CommonLabel timerLabel = new CommonLabel();
        timerLabel.getStyle().setFgColor(0);
        timerLabel.setAlignment(4);
        timerLabel.setPreferredSize(new Dimension(280, 18));
        timerLabel.getStyle().setFont(this._fontFactory.getFont(2));
        return timerLabel;
    }

    private void updateDialogContainer(Container centerDownDialogContainer) {
        this._dialog = this.getDialogTextArea(183, this._fontFactory.getFont(9));
        centerDownDialogContainer.addComponent((Component)this._dialog);
    }

    private TextArea getDialogTextArea(int height, Font fontStyle) {
        TextArea dialog = new TextArea();
        dialog.setPreferredSize(new Dimension(280, height));
        dialog.getStyle().setFgColor(0);
        dialog.getStyle().setFont(fontStyle);
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

    private Container addTimerSummaryRows(Container downLeftContainer) {
        Font centerDownTimerContainerFontStyle = this._fontFactory.getFont(2);
        Container reactionTimeContainer = this.initializeCenterDownContainerRows();
        this._reactionTimeLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this._reactionTimeValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle, 1144581);
        this._reactionTimeUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        reactionTimeContainer.addComponent((Component)this._reactionTimeLabel);
        reactionTimeContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        reactionTimeContainer.addComponent((Component)this._reactionTimeValueLabel);
        reactionTimeContainer.addComponent((Component)this._reactionTimeUnitLabel);
        Container zeroToSixtyContainer = this.initializeCenterDownContainerRows();
        this._zeroToSixtyLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this._zeroToSixtyValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this._zeroToSixtyUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        zeroToSixtyContainer.addComponent((Component)this._zeroToSixtyLabel);
        zeroToSixtyContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        zeroToSixtyContainer.addComponent((Component)this._zeroToSixtyValueLabel);
        zeroToSixtyContainer.addComponent((Component)this._zeroToSixtyUnitLabel);
        Container zeroToHundredContainer = this.initializeCenterDownContainerRows();
        this._zeroToHundredLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this._zeroToHundredValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this._zeroToHundredUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        zeroToHundredContainer.addComponent((Component)this._zeroToHundredLabel);
        zeroToHundredContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        zeroToHundredContainer.addComponent((Component)this._zeroToHundredValueLabel);
        zeroToHundredContainer.addComponent((Component)this._zeroToHundredUnitLabel);
        Container eighthEtContainer = this.initializeCenterDownContainerRows();
        this._eighthEtLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this._eighthEValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this._eighthEUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        eighthEtContainer.addComponent((Component)this._eighthEtLabel);
        eighthEtContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        eighthEtContainer.addComponent((Component)this._eighthEValueLabel);
        eighthEtContainer.addComponent((Component)this._eighthEUnitLabel);
        Container eighthMphContainer = this.initializeCenterDownContainerRows();
        this._eighthMphLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this._eighthMphValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this._eighthMphUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        eighthMphContainer.addComponent((Component)this._eighthMphLabel);
        eighthMphContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        eighthMphContainer.addComponent((Component)this._eighthMphValueLabel);
        eighthMphContainer.addComponent((Component)this._eighthMphUnitLabel);
        Container quarterEtContainer = this.initializeCenterDownContainerRows();
        this._quarterEtLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this._quarterEtValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this._quarterEtUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        quarterEtContainer.addComponent((Component)this._quarterEtLabel);
        quarterEtContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        quarterEtContainer.addComponent((Component)this._quarterEtValueLabel);
        quarterEtContainer.addComponent((Component)this._quarterEtUnitLabel);
        Container quarterMphContainer = this.initializeCenterDownContainerRows();
        this._quarterMphLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
        this._quarterMphValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        this._quarterMphUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
        quarterMphContainer.addComponent((Component)this._quarterMphLabel);
        quarterMphContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
        quarterMphContainer.addComponent((Component)this._quarterMphValueLabel);
        quarterMphContainer.addComponent((Component)this._quarterMphUnitLabel);
        downLeftContainer.addComponent((Component)reactionTimeContainer);
        downLeftContainer.addComponent(this.addPadding(7));
        downLeftContainer.addComponent((Component)zeroToSixtyContainer);
        downLeftContainer.addComponent((Component)zeroToHundredContainer);
        downLeftContainer.addComponent(this.addPadding(7));
        downLeftContainer.addComponent((Component)eighthEtContainer);
        downLeftContainer.addComponent((Component)eighthMphContainer);
        downLeftContainer.addComponent(this.addPadding(7));
        downLeftContainer.addComponent((Component)quarterEtContainer);
        downLeftContainer.addComponent((Component)quarterMphContainer);
        downLeftContainer.addComponent(this.addPadding(7));
        if (this._is60ftTimerAvailable) {
            Container sixtyFeetContainer = this.initializeCenterDownContainerRows();
            this._sixtyFeetLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
            this._sixtyFeetValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            this._sixtyFeetUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            sixtyFeetContainer.addComponent((Component)this._sixtyFeetLabel);
            sixtyFeetContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
            sixtyFeetContainer.addComponent((Component)this._sixtyFeetValueLabel);
            sixtyFeetContainer.addComponent((Component)this._sixtyFeetUnitLabel);
            downLeftContainer.addComponent((Component)sixtyFeetContainer);
        }
        if (TimersDisplayStatusEnum.BEST != this._timerType) {
            Container brakeDistContainer = this.initializeCenterDownContainerRows();
            this._brakeDistLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
            this._brakeDistValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            this._brakeDistUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            brakeDistContainer.addComponent((Component)this._brakeDistLabel);
            brakeDistContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
            brakeDistContainer.addComponent((Component)this._brakeDistValueLabel);
            brakeDistContainer.addComponent((Component)this._brakeDistUnitLabel);
            Container brakeSpeedContainer = this.initializeCenterDownContainerRows();
            this._brakeSpeedLabel = this.initializeCenterDownLabels(centerDownTimerContainerFontStyle);
            this._brakeSpeedValueLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            this._brakeSpeedUnitLabel = this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle);
            brakeSpeedContainer.addComponent((Component)this._brakeSpeedLabel);
            brakeSpeedContainer.addComponent(this.getHyphenLabel(centerDownTimerContainerFontStyle));
            brakeSpeedContainer.addComponent((Component)this._brakeSpeedValueLabel);
            brakeSpeedContainer.addComponent((Component)this._brakeSpeedUnitLabel);
            downLeftContainer.addComponent(this.addPadding(5));
            downLeftContainer.addComponent((Component)brakeDistContainer);
            downLeftContainer.addComponent((Component)brakeSpeedContainer);
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
        centerDownContainerRows.setPreferredSize(new Dimension(280, 18));
        return centerDownContainerRows;
    }

    private FastNumberLabel initializeCenterDownLabelValues(Font centerDownTimerContainerFontStyle, int color) {
        FastNumberLabel timerLabelValue = new FastNumberLabel();
        timerLabelValue.setLabelStyle(color, new Dimension(101, 18), 1);
        timerLabelValue.getStyle().setPadding(1, 5);
        timerLabelValue.getStyle().setFont(centerDownTimerContainerFontStyle);
        timerLabelValue.setText(SNA_STRING);
        return timerLabelValue;
    }

    private FastNumberLabel initializeCenterDownLabelValues(Font centerDownTimerContainerFontStyle) {
        return this.initializeCenterDownLabelValues(centerDownTimerContainerFontStyle, 0xE10000);
    }

    private CommonLabel initializeCenterDownLabels(Font centerDownTimerContainerFontStyle) {
        CommonLabel timerLabel = new CommonLabel();
        timerLabel.setLabelStyle(0, new Dimension(200, 18), 1);
        timerLabel.getStyle().setPadding(1, 25);
        timerLabel.getStyle().setFont(centerDownTimerContainerFontStyle);
        timerLabel.getStyle().setBgColor(0xEE9009);
        return timerLabel;
    }

    private Container initCenterTimerContainer() {
        Container centerTimerContainer = new Container();
        centerTimerContainer.setPreferredSize(new Dimension(342, 280));
        centerTimerContainer.getStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage("image_timeslip.png"));
        centerTimerContainer.setLayout((Layout)new BoxLayout(2));
        centerTimerContainer.getStyle().setBgTransparency(0);
        centerTimerContainer.getStyle().setBackgroundAlignment((byte)-93);
        return centerTimerContainer;
    }

    public void updateDialogAndButtons(TimerSaveOptionsEnum timerSaveOption) {
        Date date = new Date();
        if (timerSaveOption == TimerSaveOptionsEnum.SAVE) {
            this._centerTimerContainer.replaceAndWait(this._centerTimerContainer.getComponentAt(1), (Component)this._centerDownDialogContainer, null);
            this.replaceButtonContainer((Container)GSkillsViewBuildFactory.getInstance().getTimerSaveButtonContainer());
        } else if (timerSaveOption == TimerSaveOptionsEnum.CANCEL || timerSaveOption == TimerSaveOptionsEnum.OK) {
            this._centerTimerContainer.replaceAndWait(this._centerTimerContainer.getComponentAt(1), (Component)this._timerSummaryContainer, null);
            this.replaceButtonContainer((Container)this._timerTypeButtonContainer);
            if (this._uploadTimerRunController != null) {
                this._uploadTimerRunController.cancelUploadTask();
                this._uploadTimerRunController = null;
            }
        } else if (timerSaveOption == TimerSaveOptionsEnum.UCONNECT) {
            this.updateViewWithSaveStatus(15, timerSaveOption);
            this._centerTimerContainer.replaceAndWait(this._centerTimerContainer.getComponentAt(1), (Component)this._saveStatusContainer, null);
            this.replaceButtonContainer((Container)GSkillsViewBuildFactory.getInstance().getTimerCancelButtonContainer());
            this._uploadTimerRunController = UploadTimerRunController.getInstance();
            this._uploadTimerRunController.submitUploadTask(this.convertDataToHtml(date), this.toString(date), this);
        } else {
            int saveStatus = TimerSavingData.getInstance().saveDataTo(timerSaveOption, this.convertDataToHtml(date), this.toString(date));
            this.updateViewWithSaveStatus(saveStatus, timerSaveOption);
            this._centerTimerContainer.replaceAndWait(this._centerTimerContainer.getComponentAt(1), (Component)this._saveStatusContainer, null);
            this.replaceButtonContainer((Container)GSkillsViewBuildFactory.getInstance().getTimerOkButtonContainer());
        }
    }

    private void replaceButtonContainer(Container newConatiner) {
        this.replaceAndWait(this.getComponentAt(1), (Component)newConatiner, null);
    }

    private String toString(Date date) {
        SimpleDateFormat dateFormat;
        StringBuffer fileName = new StringBuffer();
        fileName.append(this.replaceTimerType(this._resourceManager.getLanguageResByKey("timer_state_" + this._timerType.toString()), "|", "i"));
        fileName.append("_");
        try {
            dateFormat = new SimpleDateFormat("ddMMMMMyyyy_hhmma", PlatformInfo.getPlatformInfo().getCurrentLocale());
        }
        catch (PlatformException e2) {
            dateFormat = new SimpleDateFormat("ddMMMMMyyyy_hhmma");
        }
        fileName.append(dateFormat.format(date));
        fileName.append("_");
        fileName.append(GSkillsStateManager.getInstance().getVehicleLine().getDisplayName());
        return fileName.toString();
    }

    private void updateViewWithSaveStatus(int saveStatus, TimerSaveOptionsEnum timerSaveOption) {
        this._saveStatusContainer.removeAll();
        this._saveStatus = saveStatus;
        this._timerSaveOption = timerSaveOption;
        this._saveStatusTextArea = this.getDialogTextArea(65, this._fontFactory.getFont(9));
        this._saveInfoTextArea = this.getDialogTextArea(110, this._fontFactory.getFont(2));
        this.setTextWithSaveStatus();
        Container infoContainer = this.getCenterDownContainer();
        infoContainer.addComponent((Component)this._saveStatusTextArea);
        infoContainer.addComponent((Component)this._saveInfoTextArea);
        this._saveStatusContainer.addComponent((Component)infoContainer);
    }

    private void setTextWithSaveStatus() {
        switch (this._saveStatus) {
            case 13: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_succeed"));
                break;
            }
            case 14: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_succeed"));
                this._saveInfoTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_info_viewOnLine"));
                break;
            }
            case 23: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_error_cannotSave"));
                this._saveInfoTextArea.setText(this.replaceTimerType(this._resourceManager.getLanguageResByKey("timer_mes_info_NotFound"), "[type]", this._resourceManager.getLanguageResByKey(this._timerSaveOption.getTitleName())));
                break;
            }
            case 24: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_error_cannotSave"));
                this._saveInfoTextArea.setText(this.replaceTimerType(this._resourceManager.getLanguageResByKey("timer_mes_info_full"), "[type]", this._resourceManager.getLanguageResByKey(this._timerSaveOption.getTitleName())));
                break;
            }
            case 15: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_saving_to_website"));
                this._saveInfoTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_please_wait"));
                break;
            }
            case 33: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_error_networkError"));
                this._saveInfoTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_info_cannotUpload"));
                break;
            }
            case 22: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_error_networkError"));
                this._saveInfoTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_info_cannotUpload"));
                break;
            }
            case 34: {
                this._saveStatusTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_error_noID"));
                this._saveInfoTextArea.setText(this._resourceManager.getLanguageResByKey("timer_mes_info_needId"));
                break;
            }
        }
    }

    private String convertDataToHtml(Date date) {
        SimpleDateFormat df = new SimpleDateFormat("MM/d/yy h:mm a");
        String timersTrial = df.format(date);
        String timezone = "UTC" + df.getTimeZone().getDisplayName().substring(3);
        StringBuilder ds = new StringBuilder();
        ds.append("<html>");
        ds.append("<head> <title>" + this._resourceManager.getLanguageResByKey("timer_save_file_title") + "</title>");
        ds.append("<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"></meta>");
        ds.append("</head><body>");
        ds.append("<h2>" + timersTrial + SNA_STRING + timezone + "</h2>");
        ds.append("<table  border=\"1\" frame = \"border\">");
        ds.append("<tr><td>" + this._resourceManager.getLanguageResByKey("timer_save_column_timer") + "</td><td>" + "" + "</td></tr>");
        ds.append("<tr><td>" + this._reactionTimeLabel.getText() + "</td><td>" + this._reactionTimeValueLabel.getText() + " " + this._reactionTimeUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this._zeroToSixtyLabel.getText() + "</td><td>" + this._zeroToSixtyValueLabel.getText() + " " + this._zeroToSixtyUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this._zeroToHundredLabel.getText() + "</td><td>" + this._zeroToHundredValueLabel.getText() + " " + this._zeroToHundredUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this._eighthEtLabel.getText() + "</td><td>" + this._eighthEValueLabel.getText() + " " + this._eighthEUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this._eighthMphLabel.getText() + "</td><td>" + this._eighthMphValueLabel.getText() + " " + this._eighthMphUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this._quarterEtLabel.getText() + "</td><td>" + this._quarterEtValueLabel.getText() + " " + this._quarterEtUnitLabel.getText() + "</td></tr>");
        ds.append("<tr><td>" + this._quarterMphLabel.getText() + "</td><td>" + this._quarterMphValueLabel.getText() + " " + this._quarterMphUnitLabel.getText() + "</td></tr>");
        if (this._is60ftTimerAvailable) {
            ds.append("<tr><td>" + this._sixtyFeetLabel.getText() + "</td><td>" + this._sixtyFeetValueLabel.getText() + " " + this._sixtyFeetUnitLabel.getText() + "</td></tr>");
        }
        if (this._brakeDistLabel != null) {
            ds.append("<tr><td>" + this._brakeDistLabel.getText() + "</td><td>" + this._brakeDistValueLabel.getText() + " " + this._brakeDistUnitLabel.getText() + "</td></tr>");
            ds.append("<tr><td>" + this._brakeSpeedLabel.getText() + "</td><td>" + this._brakeSpeedValueLabel.getText() + " " + this._brakeSpeedUnitLabel.getText() + "</td></tr>");
        }
        ds.append("</table>");
        ds.append("</body>");
        ds.append("</html>");
        return this.replaceTimerType(ds.toString(), "|", "i");
    }

    public void notifyStatus(int remoteError) {
        this._uploadTimerRunController = null;
        Display.getInstance().callSerially((Runnable)new UpdateSaveStatusDialog("UpdateSaveStatusDialogThread", remoteError));
    }

    public void updateTimerValueLabels() {
        this.setReactionTime();
        this.setZeroToSixtyValue();
        this.setZeroToHunderedValue();
        this.setEigthValue();
        this.setQuarterValue();
        if (this._is60ftTimerAvailable) {
            this.setSixtyFeetValue();
        }
        if (TimersDisplayStatusEnum.BEST != this._timerType) {
            this.setBrakeDistance();
        }
    }

    protected void setReactionTime() {
        Double reactionTimeValue;
        String reactionTimeValueString = this._timerModel.getReactionTimeValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":ReactionTime = " + reactionTimeValueString));
        if (!reactionTimeValueString.equals(SNA_STRING) && (reactionTimeValue = new Double(reactionTimeValueString)) != 2.53 && reactionTimeValue != 2.54) {
            if (reactionTimeValue == 2.55) {
                this._reactionTimeValueLabel.setText(SNA_STRING);
            } else {
                double offsetReactionTimeValue = reactionTimeValue - 1.26;
                DecimalFormat reactionTimeFormat = new DecimalFormat("#0.00");
                String offsetReactionTimeString = reactionTimeFormat.format(offsetReactionTimeValue);
                this._logger.debug((Object)(this._timerModel.toString() + ":ConvertedReactionTime = " + offsetReactionTimeString));
                this._reactionTimeValueLabel.setText(offsetReactionTimeString);
            }
        }
    }

    protected void setZeroToSixtyValue() {
        Double zeroToSixtyValue;
        String zeroToSixtyValueString = this._timerModel.getZeroToSixtyValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":0-60 Time = " + zeroToSixtyValueString));
        if (!zeroToSixtyValueString.equals(SNA_STRING) && (zeroToSixtyValue = new Double(zeroToSixtyValueString)) != 25.3 && zeroToSixtyValue != 25.4) {
            if (zeroToSixtyValue == 25.5) {
                this._zeroToSixtyValueLabel.setText(SNA_STRING);
            } else {
                this._zeroToSixtyValueLabel.setText(zeroToSixtyValueString);
            }
        }
    }

    protected void setZeroToHunderedValue() {
        Double zeroToHundredValue;
        String zeroToHundredValueString = this._timerModel.getZeroToHundredValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":0-100 Time = " + zeroToHundredValueString));
        if (!zeroToHundredValueString.equals(SNA_STRING) && (zeroToHundredValue = new Double(zeroToHundredValueString)) != 25.3 && zeroToHundredValue != 25.4) {
            if (zeroToHundredValue == 25.5) {
                this._zeroToHundredValueLabel.setText(SNA_STRING);
            } else {
                this._zeroToHundredValueLabel.setText(zeroToHundredValueString);
            }
        }
    }

    protected void setEigthValue() {
        int eighthMphValue;
        Double eighthEValue;
        String eighthEValueString = this._timerModel.getEighthEValue();
        String eighthMphValueString = this._timerModel.getEighthMphValue();
        this._logger.debug((Object)"Setting eighth mile speed and time");
        this._logger.debug((Object)(this._timerModel.toString() + ":Eighth Time = " + eighthEValueString));
        this._logger.debug((Object)(this._timerModel.toString() + ":Eighth Speed = " + eighthMphValueString));
        if (!eighthEValueString.equals(SNA_STRING) && (eighthEValue = new Double(eighthEValueString)) != 25.3 && eighthEValue != 25.4) {
            if (eighthEValue == 25.5) {
                this._eighthEValueLabel.setText(SNA_STRING);
            } else {
                this._eighthEValueLabel.setText(eighthEValueString);
            }
        }
        if (!eighthMphValueString.equals(SNA_STRING) && (eighthMphValue = Integer.parseInt(eighthMphValueString)) != 253 && eighthMphValue != 254) {
            if (eighthMphValue == 255) {
                this._eighthMphValueLabel.setText(SNA_STRING);
            } else {
                this._eighthMphValueLabel.setText(eighthMphValueString);
            }
        }
    }

    protected void setQuarterValue() {
        Integer quarterMphValue;
        Double quarterEtValue;
        String quarterEtValueString = this._timerModel.getQuarterEtValue();
        String quarterMphValueString = this._timerModel.getQuarterMphValue();
        this._logger.debug((Object)"Setting quarter mile speed and time");
        this._logger.debug((Object)(this._timerModel.toString() + ":Quarter Time = " + quarterEtValueString));
        this._logger.debug((Object)(this._timerModel.toString() + ":Quarter Speed = " + quarterMphValueString));
        if (!quarterEtValueString.equals(SNA_STRING) && (quarterEtValue = new Double(quarterEtValueString)) != 25.3 && quarterEtValue != 25.4) {
            if (quarterEtValue == 25.5) {
                this._quarterEtValueLabel.setText(SNA_STRING);
            } else {
                this._quarterEtValueLabel.setText(quarterEtValueString);
            }
        }
        if (!quarterMphValueString.equals(SNA_STRING) && (quarterMphValue = Integer.valueOf(Integer.parseInt(quarterMphValueString))) != 253 && quarterMphValue != 254) {
            if (quarterMphValue == 255) {
                this._quarterMphValueLabel.setText(SNA_STRING);
            } else {
                this._quarterMphValueLabel.setText(quarterMphValueString);
            }
        }
    }

    protected void setSixtyFeetValue() {
        Double sixtyFeetValue;
        String sixtyFeetValueString = this._timerModel.getSixtyFeetValue();
        this._logger.debug((Object)(this._timerModel.toString() + ":60 Ft Time = " + sixtyFeetValueString));
        if (!sixtyFeetValueString.equals(SNA_STRING) && (sixtyFeetValue = new Double(sixtyFeetValueString)) != 2.53 && sixtyFeetValue != 2.54) {
            if (sixtyFeetValue == 2.55) {
                this._sixtyFeetValueLabel.setText(SNA_STRING);
            } else {
                this._sixtyFeetValueLabel.setText(sixtyFeetValueString);
            }
        }
    }

    protected void setBrakeDistance() {
        String brakeDistValueString = this._timerModel.getBrakeDistValue();
        String brakeSpeedValueString = this._timerModel.getBrakeSpeedValue();
        this._logger.debug((Object)"Setting Brake speed and distance");
        this._logger.debug((Object)(this._timerModel.toString() + ":Braking Distance = " + brakeDistValueString));
        this._logger.debug((Object)(this._timerModel.toString() + ":Braking Speed = " + brakeSpeedValueString));
        if (!brakeDistValueString.equals(SNA_STRING)) {
            Integer brakeSpeedValue;
            Integer brakeDistValue = Integer.parseInt(brakeDistValueString);
            if (brakeDistValue != 253 && brakeDistValue != 254) {
                if (brakeDistValue == 255) {
                    this._brakeDistValueLabel.setText(SNA_STRING);
                } else if (SpeedUnitEnum.MPH == GSkillsStateManager.getInstance().getSpeedUnit()) {
                    this._brakeDistValueLabel.setText(Integer.toString(brakeDistValue * 3));
                } else {
                    this._brakeDistValueLabel.setText(brakeDistValueString);
                }
            }
            if (!brakeSpeedValueString.equals(SNA_STRING) && (brakeSpeedValue = Integer.valueOf(Integer.parseInt(brakeSpeedValueString))) != 254 && brakeSpeedValue != 253) {
                if (brakeSpeedValue == 255) {
                    this._brakeSpeedValueLabel.setText(SNA_STRING);
                } else {
                    this._brakeSpeedValueLabel.setText(brakeSpeedValueString);
                }
            }
        }
    }

    public boolean animate() {
        boolean needRepaint;
        boolean bl2 = needRepaint = this._unitChanged || this._languageChanged;
        if (this._timerModel.hasTimerValueChanged()) {
            this.updateTimerValueLabels();
            needRepaint = true;
        }
        this._unitChanged = false;
        this._languageChanged = false;
        this._timerModel.resetChangeFlag();
        return needRepaint;
    }

    public void notifyUnitChanged() {
        this._logger.debug((Object)"CommonTimerView::updateViewOnUnitChange called");
        if (SpeedUnitEnum.MPH == GSkillsStateManager.getInstance().getSpeedUnit()) {
            this._reactionTimeLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_REACTION_TIME.getTimerPageTitle()));
            this._zeroToSixtyLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_60MPHTM_US.getTimerPageTitle()));
            this._zeroToHundredLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_100MPHTM_US.getTimerPageTitle()));
            this._eighthEtLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_EIGHTHTM_US.getTimerPageTitle()));
            this._eighthMphLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_ETHSPD_US.getTimerPageTitle()));
            this._quarterEtLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QUARTERTM_US.getTimerPageTitle()));
            this._quarterMphLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QRTSPD_US.getTimerPageTitle()));
            if (this._is60ftTimerAvailable) {
                this._sixtyFeetLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_60FTTM.getTimerPageTitle()));
            }
            this._eighthMphUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_US_Speed"));
            this._quarterMphUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_US_Speed"));
            if (TimersDisplayStatusEnum.BEST != this._timerType) {
                this._brakeDistLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_BRKDIST_US.getTimerPageTitle()));
                this._brakeSpeedLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_BRKSPD_US.getTimerPageTitle()));
                this._brakeDistUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_US_BrakeDistance"));
                this._brakeSpeedUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_US_Speed"));
            }
        } else {
            this._reactionTimeLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_REACTION_TIME.getTimerPageTitle()));
            this._zeroToSixtyLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_60MPHTM_M.getTimerPageTitle()));
            this._zeroToHundredLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_100MPHTM_M.getTimerPageTitle()));
            this._eighthEtLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_EIGHTHTM_M.getTimerPageTitle()));
            this._eighthMphLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_ETHSPD_M.getTimerPageTitle()));
            this._quarterEtLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QUARTERTM_M.getTimerPageTitle()));
            this._quarterMphLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_QRTSPD_M.getTimerPageTitle()));
            if (this._is60ftTimerAvailable) {
                this._sixtyFeetLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_60FTTM.getTimerPageTitle()));
            }
            this._eighthMphUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_M_Speed"));
            this._quarterMphUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_M_Speed"));
            if (TimersDisplayStatusEnum.BEST != this._timerType) {
                this._brakeDistLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_BRKDIST_M.getTimerPageTitle()));
                this._brakeSpeedLabel.setText(this._resourceManager.getLanguageResByKey(PerformanceSRTAttributesEnum.SRT_BRKSPD_M.getTimerPageTitle()));
                this._brakeDistUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_M_BrakeDistance"));
                this._brakeSpeedUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_M_Speed"));
            }
        }
        this._unitChanged = true;
    }

    public void notifyLanguageChanged() {
        this._websiteLabel.setText(ResKeyPropertiesFactory.getBrandWebSite());
        this._runTitleLabel.setText(this._resourceManager.getLanguageResByKey("timer_state_" + this._timerType.toString()));
        this._timerTrialsTitleLabel.setText(this._resourceManager.getLanguageResByKey("timer_title_timerTrials"));
        this._timerTypeButtonContainer.updateOnLanguageChanged();
        GSkillsViewBuildFactory.getInstance().getTimerOkButtonContainer().updateOnLanguageChanged();
        GSkillsViewBuildFactory.getInstance().getTimerCancelButtonContainer().updateOnLanguageChanged();
        GSkillsViewBuildFactory.getInstance().getTimerSaveButtonContainer().updateOnLanguageChanged();
        this._dialog.setText(this.replaceTimerType(this._resourceManager.getLanguageResByKey("timer_mes_downloadLacation"), "[type]", this._resourceManager.getLanguageResByKey("timer_state_" + this._timerType.toString())));
        this._reactionTimeUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_Timer"));
        this._zeroToHundredUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_Timer"));
        this._zeroToSixtyUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_Timer"));
        this._eighthEUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_Timer"));
        this._quarterEtUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_Timer"));
        if (this._is60ftTimerAvailable) {
            this._sixtyFeetUnitLabel.setText(this._resourceManager.getLanguageResByKey("unit_Timer"));
        }
        this.setTextWithSaveStatus();
        this._languageChanged = true;
    }

    private class UpdateSaveStatusDialog
    extends GSkillsRunnable {
        int _saveDialogInt;

        public UpdateSaveStatusDialog(String name, int saveDialogInt) {
            super(name);
            this._saveDialogInt = saveDialogInt;
        }

        public void run() {
            CommonTimerView.this.updateViewWithSaveStatus(this._saveDialogInt, null);
            CommonTimerView.this._centerTimerContainer.replace(CommonTimerView.this._centerTimerContainer.getComponentAt(1), (Component)CommonTimerView.this._saveStatusContainer, null);
            CommonTimerView.this._centerTimerContainer.revalidate();
            CommonTimerView.this.replaceButtonContainer((Container)GSkillsViewBuildFactory.getInstance().getTimerOkButtonContainer());
        }
    }
}

