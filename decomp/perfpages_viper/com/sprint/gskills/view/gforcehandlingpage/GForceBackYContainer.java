/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.geom.Dimension
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.gforcehandlingpage;

import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sun.lwuit.Container;
import com.sun.lwuit.geom.Dimension;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

class GForceBackYContainer
extends Container {
    private Logger logger = LoggerFactory.getLogger(GForceBackYContainer.class);
    private String gforceFrontRearImageName = "image_gindicator_active.png";

    public GForceBackYContainer() {
        this.setPreferredSize(new Dimension(439, 250));
        this.getStyle().setBgTransparency(0);
    }

    protected void initView() {
        this.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile(this.gforceFrontRearImageName));
    }

    protected void updateViewOnDataChanged(String imageName) {
        if (this.gforceFrontRearImageName != imageName) {
            this.gforceFrontRearImageName = imageName;
            this.getStyle().setBgImage(CommonViewResourceManager.getInstance().getImgFromCommonResFile(this.gforceFrontRearImageName));
            this.repaint();
        }
    }
}

