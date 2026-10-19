/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Image
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sun.lwuit.Container;
import com.sun.lwuit.Image;

public class EngineTorqueContainer
extends Container {
    private int torqueImageNumber = 1;
    private final int maxTorqueContainerWidth = 419;
    private final int torqueContainerHight = 57;

    public EngineTorqueContainer() {
        this.getStyle().setBgTransparency(0);
    }

    protected void initView() {
        Image defaultImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_torquegauge_1.png");
        this.setX(-(419 - defaultImage.getWidth()));
        this.setY(-57);
        this.getStyle().setBgImage(defaultImage);
    }

    protected boolean updateViewOnDataChanged(int newTorqueImageNumber) {
        if (newTorqueImageNumber != this.torqueImageNumber) {
            this.torqueImageNumber = newTorqueImageNumber;
            Image torqueImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_torquegauge_" + this.torqueImageNumber + ".png");
            this.setX(-(419 - torqueImage.getWidth()));
            this.setY(-57);
            this.getStyle().setBgImage(torqueImage);
            return true;
        }
        return false;
    }
}

