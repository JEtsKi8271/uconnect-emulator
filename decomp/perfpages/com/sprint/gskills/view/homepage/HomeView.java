/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Button
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BorderLayout
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.homepage;

import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsView;
import com.sprint.gskills.view.mainview.MainView;
import com.sun.lwuit.Button;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Image;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BorderLayout;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class HomeView
extends GSkillsView {
    private Logger _logger = LoggerFactory.getLogger(HomeView.class);
    private static final HomeView INSTANCE = new HomeView();
    private final String HOME_IMAGE_PREFIX = "home_";
    private final String PATH_NAV_NEXT_OFF = "btn-home-next-off.png";
    private final String PATH_NAV_PREV_OFF = "btn-home-prev-off.png";
    private final String PATH_NAV_NEXT_ON = "btn-home-next-down.png";
    private final String PATH_NAV_PREV_ON = "btn-home-prev-down.png";
    private final Image NAV_NEXT_OFF_IMAGE = GSkillsResourceManager.getInstance().getCommonImage("btn-home-next-off.png");
    private final Image NAV_PREV_OFF_IMAGE = GSkillsResourceManager.getInstance().getCommonImage("btn-home-prev-off.png");
    private final Image NAV_PREV_ON_IMAGE = GSkillsResourceManager.getInstance().getCommonImage("btn-home-prev-down.png");
    private final Image NAV_NEXT_ON_IMAGE = GSkillsResourceManager.getInstance().getCommonImage("btn-home-next-down.png");
    private final Button _prevButton = new Button();
    private final Button _nextButton = new Button();
    private int _currentBgImgIndex = -1;

    public static HomeView getInstance() {
        return INSTANCE;
    }

    private HomeView() {
        this.getStyle().setBgTransparency(0);
        this.setLayout((Layout)new CoordinateLayout(new Dimension(new Dimension(528, 285))));
        this.setPreferredSize(new Dimension(528, 285));
        Container homeContainer = new Container();
        homeContainer.setPreferredSize(new Dimension(528, 285));
        homeContainer.setLayout((Layout)new BorderLayout());
        Container buttonContainer = new Container((Layout)new BoxLayout(1));
        buttonContainer.setPreferredSize(new Dimension(141, 35));
        buttonContainer.getStyle().setMargin(0, 0, 0, 0);
        buttonContainer.getStyle().setMargin(1, 528 - buttonContainer.getPreferredW());
        this.setButtonProperties(this._prevButton);
        this._prevButton.setPreferredW(81);
        this._prevButton.setPreferredH(35);
        this._prevButton.getStyle().setBgImage(this.NAV_PREV_OFF_IMAGE);
        this._prevButton.getStyle().setBgTransparency(1);
        buttonContainer.addComponent((Component)this._prevButton);
        this.setButtonProperties(this._nextButton);
        this._nextButton.setPreferredW(60);
        this._nextButton.setPreferredH(35);
        this._nextButton.getStyle().setBgImage(this.NAV_NEXT_OFF_IMAGE);
        this._nextButton.getStyle().setBgTransparency(1);
        buttonContainer.addComponent((Component)this._nextButton);
        homeContainer.addComponent((Object)"South", (Component)buttonContainer);
        this.setDefaultNavigationStyle();
        this.addComponent((Component)homeContainer);
        ActionListener prevListener = new ActionListener(){

            public void actionPerformed(ActionEvent event) {
                CommonUtils.getInstance().beepOnClick();
                int homePictureCount = 0;
                homePictureCount = 5;
                int rmsBgImgIndex = CommonUtils.getInstance().getHomeBackGroundImageInRMS();
                if (rmsBgImgIndex == 0) {
                    rmsBgImgIndex = homePictureCount + 1;
                }
                int currentBgImgIndex = rmsBgImgIndex - 1;
                CommonUtils.getInstance().saveHomeImageToRms(currentBgImgIndex);
                MainView mainview = MainView.getInstance();
                HomeView.this.setHomeImageByThemeIndex();
                mainview.showUI();
            }
        };
        ActionListener nextListener = new ActionListener(){

            public void actionPerformed(ActionEvent event) {
                CommonUtils.getInstance().beepOnClick();
                int homePictureCount = 0;
                homePictureCount = 5;
                int rmsBgImgIndex = CommonUtils.getInstance().getHomeBackGroundImageInRMS();
                if (rmsBgImgIndex == homePictureCount) {
                    rmsBgImgIndex = -1;
                }
                int currentBgImgIndex = rmsBgImgIndex + 1;
                CommonUtils.getInstance().saveHomeImageToRms(currentBgImgIndex);
                MainView mainview = MainView.getInstance();
                HomeView.this.setHomeImageByThemeIndex();
                mainview.showUI();
            }
        };
        this._prevButton.addActionListener(prevListener);
        this._nextButton.addActionListener(nextListener);
        this.setHomeImageByThemeIndex();
    }

    private void setDefaultNavigationStyle() {
        if (this.NAV_NEXT_OFF_IMAGE != null) {
            this._nextButton.getStyle().setBgImage(this.NAV_NEXT_OFF_IMAGE);
        }
        if (this.NAV_PREV_OFF_IMAGE != null) {
            this._prevButton.getStyle().setBgImage(this.NAV_PREV_OFF_IMAGE);
        }
        try {
            this._nextButton.getPressedStyle().setBgImage(this.NAV_NEXT_ON_IMAGE);
            this._prevButton.getPressedStyle().setBgImage(this.NAV_PREV_ON_IMAGE);
            this._nextButton.getSelectedStyle().setBgImage(this.NAV_NEXT_ON_IMAGE);
            this._prevButton.getSelectedStyle().setBgImage(this.NAV_PREV_ON_IMAGE);
        }
        catch (Exception ex) {
            this._logger.error((Object)"", (Throwable)ex);
        }
    }

    private void setButtonProperties(Button button) {
        button.getStyle().setBorder(null);
        button.getPressedStyle().setBorder(null);
        button.getSelectedStyle().setBorder(null);
        button.getStyle().setMargin(0, 0, 0, 0);
        button.getSelectedStyle().setMargin(0, 0, 0, 0);
        button.getPressedStyle().setMargin(0, 0, 0, 0);
        button.getStyle().setBgTransparency(0);
        button.getSelectedStyle().setBgTransparency(0);
        button.getPressedStyle().setBgTransparency(0);
    }

    public void setHomeImageByThemeIndex() {
        if (this._currentBgImgIndex != CommonUtils.getInstance().getHomeBackGroundImageInRMS()) {
            GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
            this._currentBgImgIndex = CommonUtils.getInstance().getHomeBackGroundImageInRMS();
            String homeImageIndex = String.valueOf(this._currentBgImgIndex + 1);
            String homePagePicturePath = "home_" + stateManager.getVehicleLine().toString() + "_" + stateManager.getVehicleTrim().getHomeImageSuffix() + "_" + homeImageIndex + ".png";
            this.getStyle().setBgImage(GSkillsResourceManager.getInstance().getTrimSpecificImage(homePagePicturePath));
        }
    }
}

