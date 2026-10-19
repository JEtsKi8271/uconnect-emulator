/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.view.common.CommonLabel;
import com.sun.lwuit.Container;

public class CommonViewComponents
extends Container {

    public class CommonBlackRightLabel
    extends CommonLabel {
        public CommonBlackRightLabel() {
            this.getStyle().setFgColor(0);
            this.setAlignment(3);
        }

        public CommonBlackRightLabel(String text) {
            super(text);
            this.getStyle().setFgColor(0);
            this.setAlignment(3);
        }
    }

    public class CommonRedLeftLabel
    extends CommonLabel {
        public CommonRedLeftLabel() {
            this.getStyle().setFgColor(0xFF0000);
            this.setAlignment(1);
        }

        public CommonRedLeftLabel(String text) {
            super(text);
            this.getStyle().setFgColor(0xFF0000);
            this.setAlignment(1);
        }
    }

    public class CommonBlackLabel
    extends CommonLabel {
        public CommonBlackLabel() {
            this.getStyle().setFgColor(0);
        }

        public CommonBlackLabel(String text) {
            super(text);
            this.getStyle().setFgColor(0);
        }
    }
}

