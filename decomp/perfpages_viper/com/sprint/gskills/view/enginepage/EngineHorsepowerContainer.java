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

public class EngineHorsepowerContainer
extends Container {
    private int horsePowerImageNumber = 1;
    private final int maxHpContainerWidth = 421;
    private final int hpContainerHight = 57;

    public EngineHorsepowerContainer() {
        this.getStyle().setBgTransparency(0);
    }

    protected void initView() {
        Image defaultImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_hpgauge_1.png");
        this.setX(-(421 - defaultImage.getWidth()));
        this.setY(-57);
        this.getStyle().setBgImage(defaultImage);
    }

    protected boolean updateViewOnDataChanged(int newhorsePowerImageNumber) {
        if (newhorsePowerImageNumber != this.horsePowerImageNumber) {
            this.horsePowerImageNumber = newhorsePowerImageNumber;
            Image hpImage = CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_hpgauge_" + this.horsePowerImageNumber + ".png");
            this.setX(-(421 - hpImage.getWidth()));
            this.setY(-57);
            this.getStyle().setBgImage(hpImage);
            return true;
        }
        return false;
    }
}

