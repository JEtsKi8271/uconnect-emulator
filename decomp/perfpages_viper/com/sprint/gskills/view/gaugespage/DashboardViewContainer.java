/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

class DashboardViewContainer
extends Container {
    private static Logger logger = LoggerFactory.getLogger(DashboardViewContainer.class);
    private CommonLabel titLabel = null;
    private CommonLabel mainLabel = null;
    private CommonLabel unitLabel = null;
    private CommonLabel middleLabel = null;
    private CommonLabel minLabel = null;
    private CommonLabel maxLabel = null;
    private Container imageContainer = null;
    private int currentImageIndex = 1;
    public static final int GAUGES_ONE = 1;
    public static final int GAUGES_TWO = 2;
    private int GAUGES_IMAGE_NUM;

    DashboardViewContainer(int gaugeType, boolean isUnitLabelNeeded) {
        int minMaxLabelY;
        int minMaxLabelW;
        int mainLabelW;
        int imageH;
        int mainLabelFontSize;
        int componentH;
        int componentW;
        int fontSize = 18;
        Font f18 = GSkillsFontsStyleFactory.getInstance().getFontSize18();
        this.middleLabel = new CommonLabel(0x7F7F7F, 4, f18);
        this.minLabel = new CommonLabel(0x7F7F7F, 1, f18);
        this.maxLabel = new CommonLabel(0x7F7F7F, 3, f18);
        this.titLabel = new CommonLabel(f18);
        this.unitLabel = new CommonLabel(f18);
        this.mainLabel = new CommonLabel("--");
        int titLabelH = fontSize + 4;
        int middleLabelY = titLabelH + 21;
        int middleLabelH = fontSize;
        int mainLabelY = middleLabelY + middleLabelH;
        int unitLabelY = 0;
        int unitLabelX = 0;
        if (gaugeType == 1) {
            this.GAUGES_IMAGE_NUM = 3;
            componentW = 222;
            componentH = 125;
            mainLabelFontSize = 42;
            imageH = 90;
            mainLabelW = 122;
            minMaxLabelW = 50;
            minMaxLabelY = mainLabelY + mainLabelFontSize;
            unitLabelY = mainLabelY + mainLabelFontSize;
            unitLabelX = minMaxLabelW;
            this.mainLabel.getStyle().setFont(GSkillsFontsStyleFactory.getInstance().getFontSize42());
            this.unitLabel.setPreferredSize(new Dimension(mainLabelW, fontSize + 4));
        } else {
            this.GAUGES_IMAGE_NUM = 5;
            componentW = 188;
            componentH = isUnitLabelNeeded ? 129 : 107;
            imageH = 76;
            mainLabelW = 100;
            minMaxLabelW = 44;
            if (1 == GSkillsStateManager.getInstance().getVehicleLine()) {
                mainLabelFontSize = 42;
                this.mainLabel.getStyle().setFont(GSkillsFontsStyleFactory.getInstance().getFontSize42());
                minMaxLabelY = mainLabelY + (mainLabelFontSize - fontSize);
            } else {
                mainLabelFontSize = 35;
                this.mainLabel.getStyle().setFont(GSkillsFontsStyleFactory.getInstance().getFontSize35());
                minMaxLabelY = mainLabelY + (mainLabelFontSize - fontSize) + 13;
            }
            if (isUnitLabelNeeded) {
                this.unitLabel.setPreferredSize(new Dimension(componentW, fontSize + 4));
                unitLabelY = minMaxLabelY + fontSize;
            }
        }
        this.setLayout((Layout)new CoordinateLayout(new Dimension(componentW, componentH)));
        this.setPreferredSize(new Dimension(componentW, componentH));
        this.titLabel.setPreferredSize(new Dimension(componentW, titLabelH));
        this.titLabel.setX(0);
        this.titLabel.setY(0);
        this.imageContainer = new Container();
        this.imageContainer.setPreferredSize(new Dimension(componentW, imageH));
        this.imageContainer.getStyle().setBackgroundType((byte)5);
        this.imageContainer.getStyle().setBackgroundAlignment((byte)-95);
        this.imageContainer.getStyle().setBgTransparency(0);
        this.imageContainer.setX(0);
        this.imageContainer.setY(titLabelH);
        this.imageContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_gauge1of" + this.GAUGES_IMAGE_NUM + "_1.png"));
        this.middleLabel.setPreferredSize(new Dimension(componentW, middleLabelH));
        this.middleLabel.setX(0);
        this.middleLabel.setY(middleLabelY);
        this.mainLabel.setPreferredSize(new Dimension(mainLabelW, mainLabelFontSize));
        this.mainLabel.setX(minMaxLabelW);
        this.mainLabel.setY(mainLabelY);
        this.minLabel.setPreferredSize(new Dimension(minMaxLabelW, fontSize));
        this.minLabel.getStyle().setPadding(1, 4);
        this.minLabel.setX(0);
        this.minLabel.setY(minMaxLabelY);
        this.maxLabel.setPreferredSize(new Dimension(minMaxLabelW, fontSize));
        this.maxLabel.getStyle().setPadding(3, 4);
        this.maxLabel.setX(minMaxLabelW + mainLabelW);
        this.maxLabel.setY(minMaxLabelY);
        this.unitLabel.setX(unitLabelX);
        this.unitLabel.setY(unitLabelY);
        this.initView();
    }

    private void initView() {
        this.addComponent((Component)this.middleLabel);
        this.addComponent((Component)this.imageContainer);
        this.addComponent((Component)this.minLabel);
        this.addComponent((Component)this.mainLabel);
        this.addComponent((Component)this.unitLabel);
        this.addComponent((Component)this.maxLabel);
        this.addComponent((Component)this.titLabel);
    }

    protected void setRangeValue(double minValue, double maxValue) {
        this.minLabel.setText(String.valueOf((int)minValue));
        this.middleLabel.setText(String.valueOf((int)(maxValue + minValue) / 2));
        this.maxLabel.setText(String.valueOf((int)maxValue));
    }

    protected void setTitle(String title) {
        this.titLabel.setText(title);
    }

    protected void setSymbol(String symbol) {
        this.unitLabel.setText(symbol);
    }

    protected void setGaugesValue(String strValue, int oilTempImageNumber) {
        try {
            if (strValue == null) {
                this.mainLabel.setText("--");
            } else {
                this.mainLabel.setText(strValue);
            }
            this.setImage(oilTempImageNumber);
        }
        catch (Exception ex) {
            logger.error((Object)"convert data error", (Throwable)ex);
        }
    }

    private void setImage(int imgIndex) {
        if (this.currentImageIndex != imgIndex) {
            this.currentImageIndex = imgIndex;
            this.imageContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_gauge1of" + this.GAUGES_IMAGE_NUM + "_" + this.currentImageIndex + ".png"));
            this.imageContainer.repaint();
        }
    }
}

