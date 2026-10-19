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
 *  com.sun.lwuit.layouts.Layout
 *  kona.beep.BeepException
 *  kona.beep.BeepManager
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.optionspage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.view.common.CommonButtonContainer;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.optionspage.OptionSettingContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.Image;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import kona.beep.BeepException;
import kona.beep.BeepManager;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class CommonSelecter
extends Container {
    private Logger logger = LoggerFactory.getLogger(CommonSelecter.class);
    private OptionSettingContainer settingContainer = null;
    private CommonButtonContainer leftButton;
    private Container leftDividerContainer;
    private CommonButtonContainer acceptButton;
    private Container rightDividerContainer;
    private CommonButtonContainer rightButton;
    private int currentIndex = 0;
    private int maxIndex = 0;
    ActionListener leftListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonSelecter.this.getBeepOnClick();
            CommonSelecter.this.currentIndex = CommonSelecter.this.currentIndex == 0 ? CommonSelecter.this.maxIndex : CommonSelecter.this.currentIndex - 1;
            CommonSelecter.this.notifyObserver(CommonSelecter.this.currentIndex);
        }
    };
    ActionListener centerListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonSelecter.this.getBeepOnClick();
            CommonSelecter.this.notifyObserverSave(CommonSelecter.this.currentIndex);
        }
    };
    ActionListener rightListener = new ActionListener(){

        public void actionPerformed(ActionEvent event) {
            CommonSelecter.this.getBeepOnClick();
            CommonSelecter.this.currentIndex = CommonSelecter.this.currentIndex == CommonSelecter.this.maxIndex ? 0 : CommonSelecter.this.currentIndex + 1;
            CommonSelecter.this.notifyObserver(CommonSelecter.this.currentIndex);
        }
    };

    public CommonSelecter(int maxIndex, int currentIndex) {
        this.maxIndex = maxIndex;
        this.currentIndex = currentIndex;
        this.setPreferredSize(new Dimension(223, 36));
        Font f18 = GSkillsFontsStyleFactory.getInstance().getFontSize18();
        this.leftButton = new CommonButtonContainer(f18, new Dimension(57, 36));
        this.leftDividerContainer = new Container();
        this.leftDividerContainer.setPreferredSize(new Dimension(3, 36));
        this.acceptButton = new CommonButtonContainer(f18, new Dimension(103, 36));
        this.rightDividerContainer = new Container();
        this.rightDividerContainer.setPreferredSize(new Dimension(3, 36));
        this.rightButton = new CommonButtonContainer(f18, new Dimension(57, 36));
        this.leftButton.addActionListener(this.leftListener);
        this.acceptButton.addActionListener(this.centerListener);
        this.rightButton.addActionListener(this.rightListener);
    }

    protected void initView() {
        this.setDefaultButtonStyle();
        this.setLayout((Layout)new BoxLayout(1));
        this.addComponent((Component)this.leftButton);
        this.addComponent((Component)this.leftDividerContainer);
        this.addComponent((Component)this.acceptButton);
        this.addComponent((Component)this.rightDividerContainer);
        this.addComponent((Component)this.rightButton);
    }

    private void setDefaultButtonStyle() {
        this.leftButton.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_optionleft_active.png"));
        this.leftButton.getPressedStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_optionleft_pressed.png"));
        this.leftButton.setIcon(CommonViewResourceManager.getInstance().getImgFromCommonResFile("ico_options_arrow_l.png"));
        Image dividerImage = CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_options_divider_.png");
        this.leftDividerContainer.getStyle().setBgImage(dividerImage);
        this.acceptButton.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_optioncenter_active.png"));
        this.acceptButton.getPressedStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_optioncenter_pressed.png"));
        this.rightDividerContainer.getStyle().setBgImage(dividerImage);
        this.rightButton.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_optionright_active.png"));
        this.rightButton.getPressedStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile("btn_optionright_pressed.png"));
        this.rightButton.setIcon(CommonViewResourceManager.getInstance().getImgFromCommonResFile("ico_options_arrow_r.png"));
    }

    protected void updateViewOnLanguageChanged(String strAccept) {
        this.acceptButton.setText(strAccept);
    }

    protected void addObserver(OptionSettingContainer settingContainer) {
        this.settingContainer = settingContainer;
    }

    private void notifyObserver(int index) {
        this.settingContainer.updateUI(index);
    }

    private void notifyObserverSave(int currentIndex) {
        this.settingContainer.saveSetting(currentIndex);
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

