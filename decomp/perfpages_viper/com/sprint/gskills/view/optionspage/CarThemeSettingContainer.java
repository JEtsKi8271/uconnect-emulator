/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.optionspage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.optionspage.CommonSelecter;
import com.sprint.gskills.view.optionspage.OptionSettingContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public class CarThemeSettingContainer
extends OptionSettingContainer {
    private CommonLabel vehicelColorLabel;
    private Container carViewContainer;
    private CommonUtils readWriteToRMS;
    private Container colorButtonContainer;
    private Container colorBarImageContainer;
    private Container colorSelectImageContainer;
    private CommonSelecter carColorSelectContainer;
    private Image colorBarImage = null;
    private Image colorBarSelectImage = null;
    private double selectColorWhiteBarWidth = 0.0;

    public CarThemeSettingContainer(CommonUtils readWriteToRMS) {
        this.readWriteToRMS = readWriteToRMS;
        this.setLayout((Layout)new BoxLayout(2));
        this.getStyle().setMargin(1, 22);
        this.getStyle().setBgTransparency(0);
        Font f18 = GSkillsFontsStyleFactory.getInstance().getFontSize18();
        this.vehicelColorLabel = new CommonLabel();
        this.vehicelColorLabel.getStyle().setFont(f18);
        this.vehicelColorLabel.setLabelStyle(0xFFFFFF, new Dimension(216, f18.getHeight()), 4);
        this.vehicelColorLabel.getStyle().setMargin(7, 13, 3, 3);
        this.carViewContainer = new Container();
        this.carViewContainer.setPreferredSize(new Dimension(196, 106));
        this.carViewContainer.getStyle().setMargin(8, 0, 13, 13);
        this.loadAllImages();
        int themeCount = 0;
        themeCount = 43 == GSkillsStateManager.getInstance().getVehicleLine() ? 6 : 3;
        this.selectColorWhiteBarWidth = this.colorBarImage.getWidth() / (themeCount + 1);
        this.colorButtonContainer = new Container();
        this.colorButtonContainer.setLayout((Layout)new CoordinateLayout(new Dimension(216, 25)));
        this.colorButtonContainer.setPreferredSize(new Dimension(216, 25));
        this.colorButtonContainer.getStyle().setMargin(8, 5, 3, 3);
        this.colorBarImageContainer = new Container();
        this.colorBarImageContainer.setPreferredSize(new Dimension(216, 17));
        this.colorBarImageContainer.setX(0);
        this.colorBarImageContainer.setY(4);
        this.colorSelectImageContainer = new Container();
        this.colorSelectImageContainer.setPreferredSize(new Dimension((int)Math.round(this.selectColorWhiteBarWidth), 25));
        this.colorSelectImageContainer.setX(0);
        this.colorButtonContainer.addComponent((Component)this.colorSelectImageContainer);
        this.colorButtonContainer.addComponent((Component)this.colorBarImageContainer);
        this.carColorSelectContainer = new CommonSelecter(themeCount, readWriteToRMS.getCarThemeInRMS());
        this.carColorSelectContainer.addObserver(this);
        this.initView(readWriteToRMS.getCarThemeInRMS());
    }

    private void initView(int carThemeIndex) {
        this.carColorSelectContainer.initView();
        this.carColorSelectContainer.getStyle().setMargin(0, 5);
        this.colorBarImageContainer.getStyle().setBgImage(this.colorBarImage);
        this.colorSelectImageContainer.getStyle().setBgImage(this.colorBarSelectImage);
        this.addComponent((Component)this.vehicelColorLabel);
        this.addComponent((Component)this.carViewContainer);
        this.addComponent((Component)this.colorButtonContainer);
        this.addComponent((Component)this.carColorSelectContainer);
        this.updateUI(carThemeIndex);
    }

    private void loadAllImages() {
        this.colorBarImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("image_colorbar.png");
        this.colorBarSelectImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_colorbar_selector.png");
    }

    protected void updateViewOnLanguageChanged() {
        this.carColorSelectContainer.updateViewOnLanguageChanged("options_btn_Accept");
        this.vehicelColorLabel.setText(CommonViewResourceManager.getInstance().getLanguageResByKey("options_title_vehColor"));
    }

    protected void updateUI(int currentIndex) {
        double offset = (double)currentIndex * this.selectColorWhiteBarWidth + (double)currentIndex;
        this.colorSelectImageContainer.setX((int)offset);
        String savedTheme = ResKeyPropertiesFactory.getThemeKey(currentIndex);
        this.carViewContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("color_options_" + savedTheme + ".png"));
        this.carViewContainer.repaint();
        this.colorButtonContainer.repaint();
    }

    protected void saveSetting(int currentCarThemeIndex) {
        this.readWriteToRMS.saveCarThemeSettingToRms(currentCarThemeIndex);
    }
}

