/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.beep.BeepException
 *  kona.beep.BeepManager
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.mainview;

import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.view.common.CommonButtonContainer;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.Image;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import kona.beep.BeepException;
import kona.beep.BeepManager;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class MainMenuView
extends Container {
    private Logger logger = LoggerFactory.getLogger(MainMenuView.class);
    private GSkillsViewController viewController = null;
    private GSkillsStateManager stateManager = null;
    private CommonButtonContainer homeGaugesTwoButton = null;
    private CommonButtonContainer midTopButton = null;
    private CommonButtonContainer midCenterButton = null;
    private CommonButtonContainer midBottomButton = null;
    private CommonButtonContainer pagesNavButton = null;
    private Container pagesNavImgCtn = null;
    private Container pagesNavBtnCtn = null;
    private boolean isFirstPage = true;
    private final String PATH_NAV_TOPONEBTN_ACTIVE = "btn_srtnav_1_active.png";
    private final String PATH_NAV_TOPONEBTN_PRESSED = "btn_srtnav_1_pressed.png";
    private final String PATH_NAV_CENTERBTNS_ACTIVE = "btn_srtnav_2_active.png";
    private final String PATH_NAV_CENTERBTNS_PRESSED = "btn_srtnav_2_pressed.png";
    private final String PATH_NAV_BOTTOMBTN_ACTIVE = "btn_srtnav_3_active.png";
    private final String PATH_NAV_BOTTOMBTN_PRESSED = "btn_srtnav_3_pressed.png";
    private final String PATH_NAV_MORE_BUTTON = "ico_more_down.png";
    private final String PATH_NAV_PREVIOUS_BUTTON = "ico_more_up.png";
    private Image topBtnActiveImage;
    private Image topBtnPressedImage;
    private Image centerBtnsActiveImage;
    private Image centerBtnsPressedImage;
    private Image bottomBtnActiveImage;
    private Image bottomBtnPressedImage;
    private Image moreBtnImage;
    private Image previousBtnImage;
    ActionListener topBtnListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            MainMenuView.this.getBeepOnClick();
            if (MainMenuView.this.isFirstPage) {
                if (MainMenuView.this.stateManager.getCurrentView() != 0) {
                    MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
                    MainMenuView.this.reSetMenuLabBackground(0);
                    MainMenuView.this.notifySelectedMenuChanged(0);
                }
            } else if (MainMenuView.this.stateManager.getCurrentView() != 4) {
                MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
                MainMenuView.this.reSetMenuLabBackground(4);
                MainMenuView.this.notifySelectedMenuChanged(4);
            }
        }
    };
    ActionListener midTopListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            MainMenuView.this.getBeepOnClick();
            if (MainMenuView.this.isFirstPage) {
                if (MainMenuView.this.stateManager.getCurrentView() != 1) {
                    MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
                    MainMenuView.this.reSetMenuLabBackground(1);
                    MainMenuView.this.notifySelectedMenuChanged(1);
                }
            } else if (MainMenuView.this.stateManager.getCurrentView() != 5) {
                MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
                MainMenuView.this.reSetMenuLabBackground(5);
                MainMenuView.this.notifySelectedMenuChanged(5);
            }
        }
    };
    ActionListener midCenterListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            MainMenuView.this.getBeepOnClick();
            if (MainMenuView.this.isFirstPage) {
                if (MainMenuView.this.stateManager.getCurrentView() != 2) {
                    MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
                    MainMenuView.this.reSetMenuLabBackground(2);
                    MainMenuView.this.notifySelectedMenuChanged(2);
                }
            } else if (MainMenuView.this.stateManager.getCurrentView() != 7) {
                MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
                MainMenuView.this.reSetMenuLabBackground(7);
                MainMenuView.this.notifySelectedMenuChanged(7);
            }
        }
    };
    ActionListener midBottomListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            MainMenuView.this.getBeepOnClick();
            if (MainMenuView.this.isFirstPage && MainMenuView.this.stateManager.getCurrentView() != 3) {
                MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
                MainMenuView.this.reSetMenuLabBackground(3);
                MainMenuView.this.notifySelectedMenuChanged(3);
            }
        }
    };
    ActionListener navPagesListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            MainMenuView.this.getBeepOnClick();
            MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this.stateManager.getCurrentView());
            if (MainMenuView.this.isFirstPage) {
                MainMenuView.this.pagesNavImgCtn.getStyle().setBgImage(MainMenuView.this.previousBtnImage);
                MainMenuView.this.midBottomButton.setEnabled(false);
                MainMenuView.this.isFirstPage = false;
            } else {
                MainMenuView.this.pagesNavImgCtn.getStyle().setBgImage(MainMenuView.this.moreBtnImage);
                MainMenuView.this.midBottomButton.setEnabled(true);
                MainMenuView.this.isFirstPage = true;
            }
            MainMenuView.this.reSetMenuLabText();
            MainMenuView.this.reSetMenuLabBackground(MainMenuView.this.stateManager.getCurrentView());
        }
    };

    public MainMenuView() {
        this.setLayout((Layout)new BoxLayout(2));
        this.stateManager = GSkillsStateManager.getInstance();
        Font f14 = GSkillsFontsStyleFactory.getInstance().getFontSize14();
        this.homeGaugesTwoButton = new CommonButtonContainer(f14, new Dimension(83, 54));
        this.homeGaugesTwoButton.addActionListener(this.topBtnListener);
        this.midTopButton = new CommonButtonContainer(f14, new Dimension(83, 54));
        this.midTopButton.addActionListener(this.midTopListener);
        this.midCenterButton = new CommonButtonContainer(f14, new Dimension(83, 54));
        this.midCenterButton.addActionListener(this.midCenterListener);
        this.midBottomButton = new CommonButtonContainer(f14, new Dimension(83, 54));
        this.midBottomButton.addActionListener(this.midBottomListener);
        this.pagesNavButton = new CommonButtonContainer(f14, new Dimension(83, 58));
        this.pagesNavButton.addActionListener(this.navPagesListener);
        this.pagesNavImgCtn = new Container();
        this.pagesNavImgCtn.setPreferredSize(new Dimension(83, 54));
        this.pagesNavBtnCtn = new Container((Layout)new CoordinateLayout(new Dimension(83, 58)));
        this.pagesNavBtnCtn.setPreferredSize(new Dimension(83, 58));
        this.viewController = GSkillsViewController.getInstance();
        this.loadMenuBgImage();
        this.initView();
    }

    private void loadMenuBgImage() {
        try {
            this.topBtnActiveImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_srtnav_1_active.png");
            this.topBtnPressedImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_srtnav_1_pressed.png");
            this.centerBtnsActiveImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_srtnav_2_active.png");
            this.centerBtnsPressedImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_srtnav_2_pressed.png");
            this.bottomBtnActiveImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_srtnav_3_active.png");
            this.bottomBtnPressedImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_srtnav_3_pressed.png");
            this.moreBtnImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("ico_more_down.png");
            this.previousBtnImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("ico_more_up.png");
        }
        catch (Exception e2) {
            this.logger.error((Object)"", (Throwable)e2);
        }
    }

    private void initView() {
        this.updateOnLanguageChanged();
        this.setDefaultMenuStyle();
        if (this.topBtnPressedImage != null) {
            this.homeGaugesTwoButton.getStyle().setBgImage(this.topBtnPressedImage);
        }
        this.pagesNavImgCtn.setY(2);
        this.pagesNavBtnCtn.addComponent((Component)this.pagesNavButton);
        this.pagesNavBtnCtn.addComponent((Component)this.pagesNavImgCtn);
        this.addComponent((Component)this.homeGaugesTwoButton);
        this.addComponent((Component)this.midTopButton);
        this.addComponent((Component)this.midCenterButton);
        this.addComponent((Component)this.midBottomButton);
        this.addComponent((Component)this.pagesNavBtnCtn);
    }

    public void updateOnLanguageChanged() {
        this.reSetMenuLabText();
    }

    private void reSetMenuLabText() {
        if (this.isFirstPage) {
            this.homeGaugesTwoButton.setText("menu_Home");
            this.midTopButton.setText("menu_Timers");
            this.midCenterButton.setText("menu_Gforce");
            this.midBottomButton.setText("menu_GaugesOne");
        } else {
            this.homeGaugesTwoButton.setText("menu_GaugesTwo");
            this.midTopButton.setText("menu_Engine");
            this.midCenterButton.setText("menu_Option");
            this.midBottomButton.setText("");
        }
    }

    private void setDefaultMenuStyle() {
        if (this.topBtnActiveImage != null) {
            this.homeGaugesTwoButton.getStyle().setBgImage(this.topBtnActiveImage);
        }
        if (this.centerBtnsActiveImage != null) {
            this.midTopButton.getStyle().setBgImage(this.centerBtnsActiveImage);
            this.midCenterButton.getStyle().setBgImage(this.centerBtnsActiveImage);
            this.midBottomButton.getStyle().setBgImage(this.centerBtnsActiveImage);
        }
        if (this.bottomBtnActiveImage != null) {
            this.pagesNavButton.getStyle().setBgImage(this.bottomBtnActiveImage);
        }
        try {
            this.homeGaugesTwoButton.getPressedStyle().setBgImage(this.topBtnPressedImage);
            this.midTopButton.getPressedStyle().setBgImage(this.centerBtnsPressedImage);
            this.midCenterButton.getPressedStyle().setBgImage(this.centerBtnsPressedImage);
            this.midBottomButton.getPressedStyle().setBgImage(this.centerBtnsPressedImage);
            this.pagesNavImgCtn.getStyle().setBgImage(this.moreBtnImage);
            this.pagesNavButton.getPressedStyle().setBgImage(this.bottomBtnPressedImage);
            this.homeGaugesTwoButton.getSelectedStyle().setBgImage(this.topBtnPressedImage);
            this.midTopButton.getSelectedStyle().setBgImage(this.centerBtnsPressedImage);
            this.midCenterButton.getSelectedStyle().setBgImage(this.centerBtnsPressedImage);
            this.midBottomButton.getSelectedStyle().setBgImage(this.centerBtnsPressedImage);
            this.pagesNavButton.getSelectedStyle().setBgImage(this.bottomBtnPressedImage);
        }
        catch (Exception ex) {
            this.logger.error((Object)"", (Throwable)ex);
        }
    }

    private void notifySelectedMenuChanged(int IntViewType) {
        this.viewController.notifyDisplayViewChanged(IntViewType);
    }

    private void cancelMenuPressedStyle(int oldView) {
        if (this.viewController.getRegUnregFuture() != null && !this.viewController.getRegUnregFuture().isDone()) {
            return;
        }
        switch (oldView) {
            case 0: 
            case 4: {
                this.homeGaugesTwoButton.getStyle().setBgImage(this.topBtnActiveImage);
                this.homeGaugesTwoButton.repaint();
                break;
            }
            case 1: 
            case 5: {
                this.midTopButton.getStyle().setBgImage(this.centerBtnsActiveImage);
                this.midTopButton.repaint();
                break;
            }
            case 2: 
            case 7: {
                this.midCenterButton.getStyle().setBgImage(this.centerBtnsActiveImage);
                this.midCenterButton.repaint();
                break;
            }
            case 3: {
                this.midBottomButton.getStyle().setBgImage(this.centerBtnsActiveImage);
                this.midBottomButton.repaint();
                break;
            }
            default: {
                this.logger.error((Object)("unknown selection " + oldView));
            }
        }
    }

    private void reSetMenuLabBackground(int currentView) {
        if (this.viewController.getRegUnregFuture() != null && !this.viewController.getRegUnregFuture().isDone()) {
            return;
        }
        if (this.isFirstPage) {
            switch (currentView) {
                case 0: {
                    this.homeGaugesTwoButton.getStyle().setBgImage(this.topBtnPressedImage);
                    this.homeGaugesTwoButton.repaint();
                    break;
                }
                case 1: {
                    this.midTopButton.getStyle().setBgImage(this.centerBtnsPressedImage);
                    this.midTopButton.repaint();
                    break;
                }
                case 2: {
                    this.midCenterButton.getStyle().setBgImage(this.centerBtnsPressedImage);
                    this.midCenterButton.repaint();
                    break;
                }
                case 3: {
                    this.midBottomButton.getStyle().setBgImage(this.centerBtnsPressedImage);
                    this.midBottomButton.repaint();
                    break;
                }
            }
        } else {
            switch (currentView) {
                case 4: {
                    this.homeGaugesTwoButton.getStyle().setBgImage(this.topBtnPressedImage);
                    this.homeGaugesTwoButton.repaint();
                    break;
                }
                case 5: {
                    this.midTopButton.getStyle().setBgImage(this.centerBtnsPressedImage);
                    this.midTopButton.repaint();
                    break;
                }
                case 7: {
                    this.midCenterButton.getStyle().setBgImage(this.centerBtnsPressedImage);
                    this.midCenterButton.repaint();
                    break;
                }
            }
        }
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

