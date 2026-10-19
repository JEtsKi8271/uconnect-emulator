/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Button
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.geom.Dimension
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.timers.components;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sun.lwuit.Button;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

class TimersButtonContainer
extends Button {
    Logger _logger = Log.createLogger((String)((Object)((Object)this)).getClass().getName());

    public TimersButtonContainer() {
        Font f18 = GSkillsFontsStyleFactory.getInstance().getFontSize18();
        this.setPreferredSize(new Dimension(126, 46));
        this.getStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage("btn_srt_active.png"));
        this.getStyle().setFont(f18);
        this.getPressedStyle().setFont(f18);
        this.getSelectedStyle().setFont(f18);
        this.getSelectedStyle().setBgTransparency(0);
        this.getSelectedStyle().setBorder(null);
        this.getSelectedStyle().setFgColor(0xFFFFFF);
        this.setPreferredSize(new Dimension(126, 46));
        this.getPressedStyle().setBgTransparency(0);
        this.getStyle().setBgTransparency(0);
        this.getStyle().setBorder(null);
        this.getPressedStyle().setBorder(null);
        this.getStyle().setFgColor(0xFFFFFF);
        this.getPressedStyle().setFgColor(0xFFFFFF);
        this.setAlignment(4);
        this.getStyle().setPadding(0, 8, 0, 5);
        this.getPressedStyle().setPadding(0, 8, 0, 5);
        this.getSelectedStyle().setPadding(0, 8, 0, 5);
        this.getPressedStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage("btn_srt_pressed.png"));
        this.getSelectedStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage("btn_srt_pressed.png"));
    }
}

