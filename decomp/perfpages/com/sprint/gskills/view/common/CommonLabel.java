/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Label
 *  com.sun.lwuit.geom.Dimension
 */
package com.sprint.gskills.view.common;

import com.sun.lwuit.Font;
import com.sun.lwuit.Label;
import com.sun.lwuit.geom.Dimension;

public class CommonLabel
extends Label {
    private String _text = "";

    public CommonLabel() {
        this.setAlignment(4);
        this.getStyle().setFgColor(0xFFFFFF);
        this.initializeLabel();
    }

    private void initializeLabel() {
        this.getStyle().setBgTransparency(0);
        this.getStyle().setMargin(0, 0, 0, 0);
        this.getStyle().setPadding(0, 0, 0, 0);
    }

    public CommonLabel(String text) {
        super(text);
        this._text = text;
        this.setAlignment(4);
        this.getStyle().setFgColor(0xFFFFFF);
        this.initializeLabel();
    }

    public CommonLabel(Font font) {
        this.setAlignment(4);
        this.getStyle().setFgColor(0xFFFFFF);
        this.getStyle().setFont(font);
        this.initializeLabel();
    }

    public CommonLabel(int fnColor, int aligment, Font font) {
        this.setAlignment(aligment);
        this.getStyle().setFgColor(fnColor);
        this.getStyle().setFont(font);
        this.initializeLabel();
    }

    public void setLabelStyle(int fnColor, Dimension dimension, int alignment) {
        this.getStyle().setFgColor(fnColor);
        this.setAlignment(alignment);
        this.setPreferredSize(dimension);
    }

    public void setText(String textValue) {
        if (textValue == null) {
            super.setText("--");
            this._text = "--";
        } else if (!this._text.equals(textValue)) {
            super.setText(textValue);
            this._text = textValue;
        }
    }
}

