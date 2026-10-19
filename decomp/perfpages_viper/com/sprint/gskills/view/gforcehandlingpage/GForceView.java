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
 *  com.sun.lwuit.layouts.BorderLayout
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.gforcehandlingpage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.model.GSkillsDataModelFactory;
import com.sprint.gskills.model.sensordata.CommonSensorModel;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.view.gforcehandlingpage.CommonGforceValueContainer;
import com.sprint.gskills.view.gforcehandlingpage.GForceBackYContainer;
import com.sprint.gskills.view.gforcehandlingpage.GForceCarMoveContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Display;
import com.sun.lwuit.Font;
import com.sun.lwuit.TextArea;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BorderLayout;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GForceView
extends Container
implements GSkillsViewDataListener {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private GForceBackYContainer backGroundXImageContainer = null;
    private GForceBackYContainer backGroundYImageContainer = null;
    private Container speedValuesContainer = null;
    private Container steeringValuesContainer = null;
    private CommonLabel speedValuesLabel = null;
    private CommonLabel speedUnitLabel = null;
    private CommonLabel steeringValuesLabel = null;
    private TextArea steeringUnitLabel = null;
    private TextArea tit_SteeringAngelArea = null;
    private CommonGforceValueContainer leftGforceValueContainer = null;
    private CommonGforceValueContainer rightGforceValueContainer = null;
    private CommonGforceValueContainer topGforceValueContainer = null;
    private CommonGforceValueContainer bottomGforceValueContainer = null;
    private GForceCarMoveContainer carViewContainer = null;
    private final int containerW = 530;
    private final int containerH = 271;
    private int gforceCarImage;
    private CommonSensorModel dataModel = GSkillsDataModelFactory.getSensorDataModel();
    private int currentThemeIndex = 0;

    public GForceView(int carThemeIndex) {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(530, 271)));
        this.setPreferredSize(new Dimension(530, 271));
        this.getStyle().setMargin(0, 2);
        this.backGroundXImageContainer = new GForceBackYContainer();
        this.backGroundXImageContainer.setX(50);
        this.backGroundXImageContainer.setY(11);
        this.backGroundYImageContainer = new GForceBackYContainer();
        this.backGroundYImageContainer.setX(50);
        this.backGroundYImageContainer.setY(11);
        this.speedValuesContainer = new Container((Layout)new BoxLayout(1));
        this.speedValuesContainer.setPreferredSize(new Dimension(180, 34));
        this.steeringValuesContainer = new Container((Layout)new BoxLayout(1));
        this.steeringValuesContainer.setPreferredSize(new Dimension(185, 50));
        this.speedValuesLabel = new CommonLabel("0");
        this.speedValuesLabel.setLabelStyle(0xE1E1E1, new Dimension(96, 30), 3);
        this.speedUnitLabel = new CommonLabel();
        this.speedUnitLabel.setLabelStyle(0xFFFFFF, new Dimension(60, 15), 1);
        this.speedUnitLabel.getStyle().setMargin(1, 2);
        this.steeringValuesLabel = new CommonLabel("--");
        this.steeringValuesLabel.setLabelStyle(0xE1E1E1, new Dimension(70, 40), 3);
        this.steeringUnitLabel = new TextArea();
        this.steeringUnitLabel.getStyle().setFgColor(0xFFFFFF);
        this.steeringUnitLabel.setAlignment(1);
        this.steeringUnitLabel.setEditable(false);
        this.steeringUnitLabel.setFocusable(false);
        this.steeringUnitLabel.getStyle().setBorder(null);
        this.steeringUnitLabel.getStyle().setBgTransparency(0);
        this.steeringUnitLabel.getStyle().setPadding(0, 0, 0, 0);
        this.steeringUnitLabel.setPreferredSize(new Dimension(10, 40));
        this.tit_SteeringAngelArea = new TextArea();
        this.tit_SteeringAngelArea.getStyle().setFgColor(0xFFFFFF);
        this.tit_SteeringAngelArea.setAlignment(1);
        this.tit_SteeringAngelArea.setEditable(false);
        this.tit_SteeringAngelArea.setFocusable(false);
        this.tit_SteeringAngelArea.getStyle().setBorder(null);
        this.tit_SteeringAngelArea.getStyle().setBgTransparency(0);
        this.tit_SteeringAngelArea.getStyle().setPadding(0, 0, 0, 0);
        this.tit_SteeringAngelArea.setPreferredSize(new Dimension(105, 40));
        this.leftGforceValueContainer = new CommonGforceValueContainer(GSkillsFontsStyleFactory.getInstance().getFontSize28());
        this.leftGforceValueContainer.getStyle().setMargin(0, 70);
        this.rightGforceValueContainer = new CommonGforceValueContainer(GSkillsFontsStyleFactory.getInstance().getFontSize28());
        this.rightGforceValueContainer.getStyle().setMargin(3, 5);
        this.rightGforceValueContainer.getStyle().setMargin(0, 70);
        this.topGforceValueContainer = new CommonGforceValueContainer(GSkillsFontsStyleFactory.getInstance().getFontSize22());
        this.topGforceValueContainer.getStyle().setMargin(1, 233);
        this.bottomGforceValueContainer = new CommonGforceValueContainer(GSkillsFontsStyleFactory.getInstance().getFontSize28());
        this.bottomGforceValueContainer.getStyle().setMargin(1, 223);
        Container gforceValueContainer = new Container();
        gforceValueContainer.setPreferredSize(new Dimension(530, 271));
        gforceValueContainer.setLayout((Layout)new BorderLayout());
        gforceValueContainer.addComponent((Object)"West", (Component)this.leftGforceValueContainer);
        gforceValueContainer.addComponent((Object)"East", (Component)this.rightGforceValueContainer);
        gforceValueContainer.addComponent((Object)"North", (Component)this.topGforceValueContainer);
        gforceValueContainer.addComponent((Object)"South", (Component)this.bottomGforceValueContainer);
        this.carViewContainer = new GForceCarMoveContainer(carThemeIndex);
        this.carViewContainer.setPreferredSize(new Dimension(293, 238));
        this.carViewContainer.getStyle().setBgTransparency(0);
        this.initView(gforceValueContainer);
    }

    private void initView(Container gforceValueContainer) {
        this.setFontStyle();
        this.carViewContainer.setX(125);
        this.carViewContainer.setY(35);
        this.speedUnitLabel.getStyle().setMargin(2, 15);
        this.speedValuesContainer.addComponent((Component)this.speedValuesLabel);
        this.speedValuesContainer.addComponent((Component)this.speedUnitLabel);
        this.speedValuesContainer.setX(364);
        this.speedValuesContainer.setY(15);
        this.steeringValuesLabel.getStyle().setMargin(2, 5);
        this.steeringUnitLabel.getStyle().setMargin(0, 7);
        this.tit_SteeringAngelArea.getStyle().setMargin(0, 10);
        this.steeringValuesContainer.addComponent((Component)this.steeringValuesLabel);
        this.steeringValuesContainer.addComponent((Component)this.steeringUnitLabel);
        this.steeringValuesContainer.addComponent((Component)this.tit_SteeringAngelArea);
        this.steeringValuesContainer.setX(380);
        this.steeringValuesContainer.setY(52);
        this.backGroundXImageContainer.initView();
        this.backGroundYImageContainer.initView();
        this.addComponent((Component)this.backGroundXImageContainer);
        this.addComponent((Component)this.backGroundYImageContainer);
        this.addComponent((Component)this.carViewContainer);
        this.addComponent((Component)this.speedValuesContainer);
        this.addComponent((Component)this.steeringValuesContainer);
        this.addComponent((Component)gforceValueContainer);
        this.updateViewOnLanguageChanged();
    }

    private void setFontStyle() {
        GSkillsFontsStyleFactory fontFactory = GSkillsFontsStyleFactory.getInstance();
        Font f11 = fontFactory.getFontSize11();
        Font f14 = fontFactory.getFontSize14();
        Font f22 = fontFactory.getFontSize22();
        Font f35 = fontFactory.getFontSize35();
        this.steeringValuesLabel.getStyle().setFont(f22);
        this.speedUnitLabel.getStyle().setFont(f14);
        this.speedValuesLabel.getStyle().setFont(f35);
        this.steeringUnitLabel.getStyle().setFont(f11);
        this.tit_SteeringAngelArea.getUnselectedStyle().setFont(f11);
        this.tit_SteeringAngelArea.getSelectedStyle().setFont(f11);
    }

    public void updateViewOnLanguageChanged() {
        this.tit_SteeringAngelArea.setText(this.replaceRegaExp(CommonViewResourceManager.getInstance().getLanguageResByKey("Gforce_SteeringAngel"), "\n"));
        this.steeringUnitLabel.setText(CommonViewResourceManager.getInstance().getLanguageResByKey("Gforce_SteeringUnit"));
        this.speedUnitLabel.setText(CommonViewResourceManager.getInstance().getLanguageResByKey("unit_US_Speed"));
        this.updateUnitSymbol();
    }

    private String replaceRegaExp(String languageResByKey, String replacementSubString) {
        if (languageResByKey.indexOf("[]") == -1) {
            return languageResByKey;
        }
        String temString = languageResByKey.substring(0, languageResByKey.lastIndexOf("[]")) + replacementSubString + languageResByKey.substring(languageResByKey.lastIndexOf("[]") + 2, languageResByKey.length());
        return this.replaceRegaExp(temString, replacementSubString);
    }

    public void updateViewOnThemeChanged(int carThemeIndex) {
        if (this.currentThemeIndex != carThemeIndex) {
            this.currentThemeIndex = carThemeIndex;
            this.carViewContainer.updateViewOnThemeChanged(this.currentThemeIndex);
        }
    }

    public void updateViewOnUnitChanged() {
        this.updateUnitSymbol();
    }

    private void updateUnitSymbol() {
        String current_unit = GSkillsStateManager.getInstance().getCurrentUnit() == 0 ? "US" : "M";
        String gforceUnit = CommonViewResourceManager.getInstance().getLanguageResByKey("unit_" + current_unit + "_Gforce");
        this.leftGforceValueContainer.setUnitText(gforceUnit);
        this.rightGforceValueContainer.setUnitText(gforceUnit);
        this.topGforceValueContainer.setUnitText(gforceUnit);
        this.bottomGforceValueContainer.setUnitText(gforceUnit);
        this.speedUnitLabel.setText(this.dataModel.getSpeedUnit());
    }

    public void updateViewOnDataChanged() {
        if (this.dataModel.pollAndCheckVehAccelChange()) {
            final String topValue = this.dataModel.getTopGforceValue();
            final String bottomValue = this.dataModel.getBottomGforceValue();
            final String leftValue = this.dataModel.getLeftGforceValue();
            final String rightValue = this.dataModel.getRightGforceValue();
            this.gforceCarImage = this.dataModel.getGforceCarImageNumber();
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    try {
                        GForceView.this.bottomGforceValueContainer.setValueLabel(bottomValue);
                        GForceView.this.topGforceValueContainer.setValueLabel(topValue);
                        GForceView.this.backGroundYImageContainer.updateViewOnDataChanged(GForceView.this.dataModel.getGForceFrontRearImageName());
                        GForceView.this.leftGforceValueContainer.setValueLabel(leftValue);
                        GForceView.this.rightGforceValueContainer.setValueLabel(rightValue);
                        GForceView.this.carViewContainer.updateViewOnDataChanged(GForceView.this.gforceCarImage);
                        GForceView.this.backGroundXImageContainer.updateViewOnDataChanged(GForceView.this.dataModel.getGForceLeftRightImageName());
                    }
                    catch (Throwable ex) {
                        GForceView.this.logger.error((Object)"", ex);
                    }
                }
            });
        }
        if (this.dataModel.hasSpeedUnitChanged()) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    GForceView.this.speedUnitLabel.setText(GForceView.this.dataModel.getSpeedUnit());
                }
            });
        }
        if (this.dataModel.hasSpeedChangedPolling()) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    GForceView.this.speedValuesLabel.setText(GForceView.this.dataModel.getCurrentSpeedPolled());
                }
            });
        }
        if (this.dataModel.pollAndCheckSteeringWheelAngleChanged()) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    GForceView.this.steeringValuesLabel.setText(GForceView.this.dataModel.getSteeringAngle());
                }
            });
        }
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        this.logger.error((Object)"Not yet implement");
    }

    public void notifyStatus(int remoteError) {
        this.logger.error((Object)"Not yet implement");
    }
}

