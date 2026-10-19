/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.gforcehandlingpage;

import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Container;
import java.util.HashMap;
import java.util.Map;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

class GForceCarMoveContainer
extends Container {
    private Logger logger = LoggerFactory.getLogger(GForceCarMoveContainer.class);
    private int carPositionIndex;
    private Map<Integer, String> carImages = new HashMap<Integer, String>();
    private final String carBrand = 1 == GSkillsStateManager.getInstance().getVehicleLine() ? "jeep_" : "viper_";

    public GForceCarMoveContainer(int carColorIndex) {
        this.updateViewOnThemeChanged(carColorIndex);
    }

    private void loadImageByThemeIndex(int themeIndex) {
        try {
            String themePath = ResKeyPropertiesFactory.getThemeKey(themeIndex);
            String carImagePath = this.carBrand + themePath + "_mid.png";
            String leftOneCarImagePath = this.carBrand + themePath + "_l1.png";
            String leftTwoCarImagePath = this.carBrand + themePath + "_l2.png";
            String leftThreeCarImagePath = this.carBrand + themePath + "_l3.png";
            String rightCarImagePath = this.carBrand + themePath + "_r1.png";
            String rightTwoCarImagePath = this.carBrand + themePath + "_r2.png";
            String rightThreeCarImagePath = this.carBrand + themePath + "_r3.png";
            this.carImages.put(-3, leftThreeCarImagePath);
            this.carImages.put(-2, leftTwoCarImagePath);
            this.carImages.put(-1, leftOneCarImagePath);
            this.carImages.put(0, carImagePath);
            this.carImages.put(1, rightThreeCarImagePath);
            this.carImages.put(2, rightTwoCarImagePath);
            this.carImages.put(3, rightCarImagePath);
        }
        catch (Exception e2) {
            this.logger.error((Object)"Error : (create images) ", (Throwable)e2);
        }
    }

    protected void updateViewOnThemeChanged(int carColorIndex) {
        this.loadImageByThemeIndex(carColorIndex);
        this.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile(this.carImages.get(this.carPositionIndex)));
    }

    protected void updateViewOnDataChanged(int newCarPositionIndex) {
        if (this.carPositionIndex != newCarPositionIndex) {
            this.carPositionIndex = newCarPositionIndex;
            try {
                this.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromBrandSpecificResFile(this.carImages.get(this.carPositionIndex)));
                this.repaint();
            }
            catch (Exception ex) {
                this.logger.error((Object)"update view on data change error : ", (Throwable)ex);
            }
        }
    }
}

