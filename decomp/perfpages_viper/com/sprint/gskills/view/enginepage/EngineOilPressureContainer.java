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

public class EngineOilPressureContainer
extends Container {
    private int oilPressureImageNumber = 1;
    private final int maxOilContainerWidth = 343;
    private final int oilContainerHight = 57;

    public EngineOilPressureContainer() {
        this.getStyle().setBgTransparency(0);
    }

    protected void initView() {
        Image defaultImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_oilgauge_1.png");
        this.setX(-(343 - defaultImage.getWidth()));
        this.setY(-57);
        this.getStyle().setBgImage(defaultImage);
    }

    protected boolean updateViewOnDataChanged(int newOilPressureImageNumber) {
        if (newOilPressureImageNumber != this.oilPressureImageNumber) {
            this.oilPressureImageNumber = newOilPressureImageNumber;
            Image oilImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_oilgauge_" + this.oilPressureImageNumber + ".png");
            this.setX(-(343 - oilImage.getWidth()));
            this.setY(-57);
            this.getStyle().setBgImage(oilImage);
            return true;
        }
        return false;
    }
}

