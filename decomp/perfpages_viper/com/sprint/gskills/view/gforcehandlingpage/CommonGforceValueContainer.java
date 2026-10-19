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
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.gforcehandlingpage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

class CommonGforceValueContainer
extends Container {
    private Logger logger = Log.createLogger((String)((Object)((Object)this)).getClass().getName());
    private CommonLabel valueLabel = null;
    private CommonLabel unitLabel = null;
    private Font fontSize14;

    public CommonGforceValueContainer(Font labelFont) {
        Container gforceValueContainer = new Container();
        gforceValueContainer.setLayout((Layout)new BoxLayout(1));
        this.getStyle().setMargin(2, 5);
        int labelWidth = labelFont.stringWidth("0.00");
        int labelHeight = labelFont.getHeight();
        this.valueLabel = new CommonLabel(0x4A4A4A, 3, labelFont);
        this.valueLabel.setPreferredSize(new Dimension(labelWidth + 10, labelHeight));
        this.setValueLabel("--");
        this.fontSize14 = GSkillsFontsStyleFactory.getInstance().getFontSize14();
        this.unitLabel = new CommonLabel(0x4A4A4A, 1, this.fontSize14);
        this.unitLabel.setPreferredSize(new Dimension(this.fontSize14.stringWidth("g"), this.fontSize14.getHeight()));
        this.unitLabel.getStyle().setMargin(1, 2);
        gforceValueContainer.addComponent((Component)this.valueLabel);
        gforceValueContainer.addComponent((Component)this.unitLabel);
        this.addComponent((Component)gforceValueContainer);
    }

    protected void setUnitText(String str) {
        this.unitLabel.setText(str);
    }

    protected void setValueLabel(String value) {
        this.valueLabel.setText(value);
    }
}

