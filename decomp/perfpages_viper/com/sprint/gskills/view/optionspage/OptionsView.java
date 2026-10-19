/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.optionspage;

import com.sprint.gskills.model.GSkillsDataModel;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.view.optionspage.CarThemeSettingContainer;
import com.sprint.gskills.view.optionspage.HomeBgImgSettingContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class OptionsView
extends Container
implements GSkillsViewDataListener {
    private Logger logger = LoggerFactory.getLogger(OptionsView.class);
    private HomeBgImgSettingContainer backGroundSettingContainer;
    private CarThemeSettingContainer carThemeSettingContainer;

    public OptionsView(CommonUtils readWriteToRMS) {
        this.setUIID("OptionsView UIID");
        this.getStyle().setBgTransparency(0);
        this.getStyle().setMargin(15, 0, 20, 20);
        this.backGroundSettingContainer = new HomeBgImgSettingContainer(readWriteToRMS);
        this.carThemeSettingContainer = new CarThemeSettingContainer(readWriteToRMS);
        this.initView();
    }

    private void initView() {
        this.setLayout((Layout)new BoxLayout(1));
        this.addComponent((Component)this.backGroundSettingContainer);
        this.addComponent((Component)this.carThemeSettingContainer);
        this.updateViewOnLanguageChanged();
    }

    public void updateViewOnLanguageChanged() {
        this.backGroundSettingContainer.updateViewOnLanguageChanged();
        this.carThemeSettingContainer.updateViewOnLanguageChanged();
    }

    public void updateViewOnUnitChanged() {
        this.logger.error((Object)"Not yet implement");
    }

    public void updateViewOnDataChanged() {
        this.logger.error((Object)"Not yet implement");
    }

    public void onNotifyDataChange(GSkillsDataModel gskillsDataModel) {
        this.logger.error((Object)"Not yet implement");
    }

    public void notifyStatus(int remoteError) {
        this.logger.error((Object)"Not yet implement");
    }
}

