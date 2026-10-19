/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Graphics
 *  com.sun.lwuit.Label
 *  com.sun.lwuit.plaf.UIManager
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.view.common.CommonLabel;
import com.sun.lwuit.Font;
import com.sun.lwuit.Graphics;
import com.sun.lwuit.Label;
import com.sun.lwuit.plaf.UIManager;

public class FastNumberLabel
extends CommonLabel {
    private String text = "";

    public FastNumberLabel(String string) {
        super(string);
    }

    public FastNumberLabel() {
    }

    public FastNumberLabel(int color, int alignment, Font font) {
        super(color, alignment, font);
    }

    public void setText(String textValue) {
        this.text = textValue;
    }

    public String getText() {
        return this.text;
    }

    public void paint(Graphics g2) {
        UIManager.getInstance().getLookAndFeel().drawLabel(g2, (Label)this);
    }
}

