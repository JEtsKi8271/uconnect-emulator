/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Button
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.geom.Dimension
 */
package com.sprint.gskills.view.common;

import com.sun.lwuit.Button;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;

public class CommonButtonContainer
extends Button {
    public CommonButtonContainer(Font f2, Dimension d2) {
        this.getStyle().setBgTransparency(0);
        this.getStyle().setFont(f2);
        this.getStyle().setBorder(null);
        this.getStyle().setMargin(0, 0, 0, 0);
        this.getStyle().setPadding(0, 0, 0, 0);
        this.getStyle().setFgColor(0xFFFFFF);
        this.getPressedStyle().setFont(f2);
        this.getPressedStyle().setBorder(null);
        this.getPressedStyle().setMargin(0, 0, 0, 0);
        this.getPressedStyle().setPadding(0, 0, 0, 0);
        this.getPressedStyle().setFgColor(0xFFFFFF);
        this.getSelectedStyle().setFont(f2);
        this.getSelectedStyle().setBorder(null);
        this.getSelectedStyle().setMargin(0, 0, 0, 0);
        this.getSelectedStyle().setPadding(0, 0, 0, 0);
        this.getSelectedStyle().setFgColor(0xFFFFFF);
        this.getUnselectedStyle().setFont(f2);
        this.getUnselectedStyle().setBorder(null);
        this.getUnselectedStyle().setMargin(0, 0, 0, 0);
        this.getUnselectedStyle().setPadding(0, 0, 0, 0);
        this.getUnselectedStyle().setFgColor(0xFFFFFF);
        this.setAlignment(4);
        this.setTickerEnabled(false);
        this.setPreferredSize(d2);
    }
}

