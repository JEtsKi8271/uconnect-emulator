/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Display
 *  com.sun.lwuit.Form
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BorderLayout
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.mainview;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.TimersDisplayStatusEnum;
import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.util.GSkillsXletProperties;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Display;
import com.sun.lwuit.Form;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BorderLayout;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class MainView {
    private Logger logger = LoggerFactory.getLogger(MainView.class);
    private Form form = null;
    private Container mainViewContainer = null;
    private Container backgroundImgContainer = null;
    private GSkillsViewBuildFactory viewFactory = null;
    private Container lineContainer;
    private int currentBgImgIndex = -1;
    private final int mainPageComponentIndex = 0;
    private final int centerScreenComponentIndex = 1;
    private CommonUtils readWriteFromRMS;
    private GSkillsFontsStyleFactory fontStyleFactory = null;

    public MainView(GSkillsViewBuildFactory gskillsViewBuildFactory) {
        this.viewFactory = gskillsViewBuildFactory;
        this.fontStyleFactory = GSkillsFontsStyleFactory.getInstance();
        Display.getInstance().callSerially(new Runnable(){

            public void run() {
                MainView.this.initialzeMainView();
                MainView.this.refreshUI();
            }
        });
    }

    private Container getSplashContainer() {
        Container splashContainer = new Container();
        splashContainer.setPreferredSize(new Dimension(617, 275));
        splashContainer.setLayout((Layout)new CoordinateLayout(new Dimension(617, 275)));
        splashContainer.getStyle().setMargin(0, 5);
        splashContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile("splash_SRT.png"));
        Container swVersionContainer = new Container();
        swVersionContainer.setX(525);
        swVersionContainer.setY(250);
        CommonLabel swVersionLabel = new CommonLabel(0xFFFFFF, 1, this.fontStyleFactory.getNimbusSanTOTFontWithSize16());
        swVersionLabel.setPreferredSize(new Dimension(500, 25));
        int vehicleLine = GSkillsStateManager.getInstance().getVehicleLine();
        if (1 == vehicleLine || 43 == vehicleLine) {
            swVersionLabel.setText("v" + GSkillsXletProperties.getXletVersion());
        } else {
            swVersionLabel.setText("Unsupported");
        }
        swVersionContainer.addComponent((Component)swVersionLabel);
        splashContainer.addComponent((Component)swVersionContainer);
        return splashContainer;
    }

    private void initialzeMainView() {
        this.form = new Form();
        this.form.getStyle().setPadding(44, 0, 11, 12);
        this.form.getStyle().setBgColor(0);
        this.form.setScrollable(false);
        this.form.addComponent(0, (Component)this.getSplashContainer());
    }

    public void showUI() {
        this.form.show();
    }

    private void intialBorderLines() {
        this.lineContainer = new Container();
        this.lineContainer.setPreferredSize(new Dimension(617, 275));
        this.lineContainer.setLayout((Layout)new BoxLayout(1));
        this.lineContainer.getStyle().setBgTransparency(0);
        Image westLineImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("modal_srt_west.png");
        Image eastLineImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("modal_srt_east.png");
        Image northLineImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("modal_srt_north.png");
        Image southLineImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("modal_srt_south.png");
        Container westContainer = new Container();
        westContainer.getStyle().setBgImage(westLineImage);
        westContainer.setPreferredSize(new Dimension(westLineImage.getWidth(), westLineImage.getHeight()));
        Container eastContainer = new Container();
        eastContainer.getStyle().setBgImage(eastLineImage);
        eastContainer.setPreferredSize(new Dimension(eastLineImage.getWidth(), eastLineImage.getHeight()));
        Container northContainer = new Container();
        northContainer.getStyle().setBgImage(northLineImage);
        northContainer.setPreferredSize(new Dimension(northLineImage.getWidth(), northLineImage.getHeight()));
        Container southContainer = new Container();
        southContainer.getStyle().setBgImage(southLineImage);
        southContainer.setPreferredSize(new Dimension(southLineImage.getWidth(), southLineImage.getHeight()));
        Container eastSuperContainer = new Container();
        eastSuperContainer.setLayout((Layout)new BorderLayout());
        eastSuperContainer.getStyle().setBgTransparency(0);
        eastSuperContainer.setPreferredSize(new Dimension(617 - westLineImage.getWidth(), 275));
        eastSuperContainer.addComponent((Object)"North", (Component)northContainer);
        eastSuperContainer.addComponent((Object)"South", (Component)southContainer);
        eastSuperContainer.addComponent((Object)"East", (Component)eastContainer);
        this.lineContainer.addComponent((Component)westContainer);
        this.lineContainer.addComponent((Component)eastSuperContainer);
        this.lineContainer.setVisible(true);
    }

    private void setHomeImageByThemeIndex() {
        if (this.currentBgImgIndex != this.readWriteFromRMS.getHomeBackGroundImageInRMS()) {
            this.currentBgImgIndex = this.readWriteFromRMS.getHomeBackGroundImageInRMS();
            String homeImage = String.valueOf(this.currentBgImgIndex + 1);
            this.backgroundImgContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("bg_options_" + homeImage + ".png"));
        }
    }

    private void refreshUI() {
        this.form.show();
    }

    public void updateViewOnSelectedMenuChanged(int currentView) {
        try {
            if (currentView == 0) {
                this.setHomeImageByThemeIndex();
                this.backgroundImgContainer.setVisible(true);
            } else {
                this.backgroundImgContainer.setVisible(false);
            }
            this.mainViewContainer.replaceAndWait(this.mainViewContainer.getComponentAt(1), (Component)this.viewFactory.getViewByCode(currentView), null);
            this.refreshUI();
        }
        catch (Exception ex) {
            this.logger.error((Object)"update View On Selected Menu Changed error : ", (Throwable)ex);
        }
    }

    public void updateRightScreen(TimersDisplayStatusEnum timerType) {
        Container nextScreen = this.viewFactory.getTimerContainer(GSkillsStateManager.getInstance().getCurrentUnit(), timerType);
        this.mainViewContainer.replaceAndWait(this.mainViewContainer.getComponentAt(1), (Component)nextScreen, null);
        this.refreshUI();
    }

    public void updateRightScreen(TimerSaveOptionsEnum timerSaveOption) {
        Container nextScreen = this.viewFactory.getTimerContainer(timerSaveOption);
        this.mainViewContainer.replaceAndWait(this.mainViewContainer.getComponentAt(1), (Component)nextScreen, null);
        this.refreshUI();
    }

    public void initializeHomePage(CommonUtils readWriteFromRMS) {
        this.readWriteFromRMS = readWriteFromRMS;
        Container superViewContainer = new Container();
        superViewContainer.setLayout((Layout)new CoordinateLayout(new Dimension(617, 275)));
        superViewContainer.setPreferredSize(new Dimension(617, 275));
        superViewContainer.getStyle().setBgTransparency(0);
        superViewContainer.getStyle().setMargin(0, 5);
        this.intialBorderLines();
        superViewContainer.addComponent((Component)this.lineContainer);
        this.backgroundImgContainer = new Container();
        this.backgroundImgContainer.setPreferredSize(new Dimension(614, 271));
        this.backgroundImgContainer.setX(2);
        this.backgroundImgContainer.setY(2);
        superViewContainer.addComponent((Component)this.backgroundImgContainer);
        this.mainViewContainer = new Container();
        this.mainViewContainer.setLayout((Layout)new BoxLayout(1));
        this.mainViewContainer.getStyle().setBgTransparency(0);
        this.mainViewContainer.setX(2);
        this.mainViewContainer.setY(2);
        superViewContainer.addComponent((Component)this.mainViewContainer);
        Container formContent = this.form.getContentPane();
        formContent.replace(formContent.getComponentAt(0), (Component)this.viewFactory.getMainTitleView(), null);
        this.form.addComponent((Component)superViewContainer);
        this.setHomeImageByThemeIndex();
        this.backgroundImgContainer.setVisible(true);
        this.mainViewContainer.addComponent((Component)this.viewFactory.getMainMenuView());
        this.mainViewContainer.addComponent(1, (Component)this.viewFactory.getViewByCode(GSkillsStateManager.getInstance().getCurrentView()));
        this.refreshUI();
    }
}

