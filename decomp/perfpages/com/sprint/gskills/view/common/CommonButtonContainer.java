/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Button
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.plaf.Style
 */
package com.sprint.gskills.view.common;

import com.sun.lwuit.Button;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.plaf.Style;

public class CommonButtonContainer
extends Button {
    private final Font _font;

    public CommonButtonContainer(Font f2, Dimension d2) {
        this._font = f2;
        this.setStyleProperties(this.getStyle());
        this.setStyleProperties(this.getPressedStyle());
        this.setStyleProperties(this.getSelectedStyle());
        this.setStyleProperties(this.getUnselectedStyle());
        this.getStyle().setBgTransparency(0);
        this.setAlignment(4);
        this.setTickerEnabled(false);
        this.setPreferredSize(d2);
    }

    private void setStyleProperties(Style style) {
        style.setFont(this._font);
        style.setBorder(null);
        style.setMargin(0, 0, 0, 0);
        style.setPadding(0, 0, 0, 0);
        style.setFgColor(0xFFFFFF);
    }
}

