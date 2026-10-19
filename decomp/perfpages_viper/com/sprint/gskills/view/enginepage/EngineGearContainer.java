/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;

public class EngineGearContainer
extends Container {
    private CommonLabel valueLabel;
    private CommonLabel unitLabel;
    private Container gearContainer;
    private GSkillsFontsStyleFactory fontFactory = null;

    public EngineGearContainer() {
        this.getStyle().setPadding(125, 0, 83, 0);
        this.getStyle().setBgTransparency(0);
        this.fontFactory = GSkillsFontsStyleFactory.getInstance();
        this.gearContainer = new Container();
        this.gearContainer.setPreferredSize(new Dimension(200, 100));
        this.gearContainer.setLayout((Layout)new BoxLayout(2));
        this.valueLabel = new CommonLabel("--");
        this.valueLabel.getStyle().setMargin(0, 10);
        this.valueLabel.setLabelStyle(0xFFFFFF, new Dimension(200, 40), 4);
        this.unitLabel = new CommonLabel();
        this.unitLabel.setLabelStyle(0xFFFFFF, new Dimension(200, 15), 4);
    }

    protected void initView() {
        this.valueLabel.getStyle().setFont(this.fontFactory.getFontSize46());
        this.unitLabel.getStyle().setFont(this.fontFactory.getFontSize14());
        this.gearContainer.addComponent((Component)this.valueLabel);
        this.gearContainer.addComponent((Component)this.unitLabel);
        this.addComponent((Component)this.gearContainer);
    }

    protected void updateViewOnLanguageChanged() {
        this.unitLabel.setText(CommonViewResourceManager.getInstance().getLanguageResByKey("engine_title_gear"));
    }

    protected void updateViewOnDataChanged(String str) {
        if (str == null) {
            if (!this.valueLabel.getText().equals("--")) {
                this.valueLabel.setText("--");
            }
        } else {
            this.valueLabel.setText(str);
        }
    }
}

