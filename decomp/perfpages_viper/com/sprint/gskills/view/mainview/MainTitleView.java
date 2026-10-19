/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.mainview;

import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class MainTitleView
extends Container {
    private Logger logger = LoggerFactory.getLogger(MainTitleView.class);
    private final int CONTAINER_WIDTH = 630;
    private final int BREADCRUMB_HEIGHT = 51;

    public MainTitleView() {
        Container topBurstContainer = new Container();
        Container centerTitleImageContainer = new Container();
        Container bottomBurstContainer = new Container();
        this.setPreferredSize(new Dimension(630, 51));
        this.setLayout((Layout)new BoxLayout(2));
        Image burstTopImg = CommonViewResourceManager.getInstance().getImgFromCommonResFile("white_burst_top.png");
        topBurstContainer.getStyle().setBgImage(burstTopImg);
        topBurstContainer.getStyle().setBackgroundType((byte)5);
        topBurstContainer.setPreferredH(burstTopImg.getHeight());
        centerTitleImageContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile("image_srt_breadcrumb.png"));
        centerTitleImageContainer.getStyle().setBackgroundType((byte)5);
        centerTitleImageContainer.getStyle().setBackgroundAlignment((byte)-91);
        centerTitleImageContainer.setPreferredH(49);
        bottomBurstContainer.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile("white_burst_btm.png"));
        bottomBurstContainer.getStyle().setBackgroundType((byte)5);
        bottomBurstContainer.setPreferredH(burstTopImg.getHeight());
        this.addComponent((Component)topBurstContainer);
        this.addComponent((Component)centerTitleImageContainer);
        this.addComponent((Component)bottomBurstContainer);
    }
}

