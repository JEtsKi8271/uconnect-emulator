/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.optionspage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.optionspage.CommonSelecter;
import com.sprint.gskills.view.optionspage.OptionSettingContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class HomeBgImgSettingContainer
extends OptionSettingContainer {
    private Logger logger = LoggerFactory.getLogger(HomeBgImgSettingContainer.class);
    private CommonLabel homePictureLabel;
    private Container homePictureContainer;
    private CommonSelecter homePictureSelectContainer;
    private CommonUtils readWriteToRMS;

    public HomeBgImgSettingContainer(CommonUtils readWriteToRMS) {
        this.readWriteToRMS = readWriteToRMS;
        this.getStyle().setBgTransparency(0);
        this.setLayout((Layout)new BoxLayout(2));
        Font f18 = GSkillsFontsStyleFactory.getInstance().getFontSize18();
        this.homePictureLabel = new CommonLabel();
        this.homePictureLabel.getStyle().setFont(f18);
        this.homePictureLabel.setLabelStyle(0xFFFFFF, new Dimension(216, f18.getHeight()), 4);
        this.homePictureLabel.getStyle().setMargin(7, 13, 0, 25);
        this.homePictureContainer = new Container();
        this.homePictureContainer.setPreferredSize(new Dimension(226, 136));
        this.homePictureContainer.getStyle().setMargin(7, 14, 0, 0);
        int homePictureCount = 0;
        homePictureCount = 43 == GSkillsStateManager.getInstance().getVehicleLine() ? 5 : 7;
        this.homePictureSelectContainer = new CommonSelecter(homePictureCount, readWriteToRMS.getHomeBackGroundImageInRMS());
        this.homePictureSelectContainer.addObserver(this);
        this.updateUI(readWriteToRMS.getHomeBackGroundImageInRMS());
        this.initView();
    }

    private void initView() {
        this.homePictureSelectContainer.initView();
        this.addComponent((Component)this.homePictureLabel);
        this.addComponent((Component)this.homePictureContainer);
        this.addComponent((Component)this.homePictureSelectContainer);
        this.updateViewOnLanguageChanged();
    }

    protected void updateViewOnLanguageChanged() {
        this.homePictureSelectContainer.updateViewOnLanguageChanged("options_btn_Accept");
        this.homePictureLabel.setText(CommonViewResourceManager.getInstance().getLanguageResByKey("options_title_wallPaper"));
    }

    protected void updateUI(int currentIndex) {
        this.homePictureContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("options_homepic_" + String.valueOf(currentIndex + 1) + ".png"));
        this.homePictureContainer.repaint();
    }

    protected void saveSetting(int currentBgImgIndex) {
        this.readWriteToRMS.saveHomeImageToRms(currentBgImgIndex);
    }
}

