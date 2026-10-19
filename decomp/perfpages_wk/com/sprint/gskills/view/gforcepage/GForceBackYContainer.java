/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.geom.Dimension
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sun.lwuit.Container;
import com.sun.lwuit.geom.Dimension;
import java.util.HashMap;
import java.util.Map;

class GForceBackYContainer
extends Container {
    private String _gForceImageName = "image_gindicator_active.png";
    private final String _gForceImagePrefix = "image_gindicator_active";
    private Map<Integer, String> _leftRightBackgroundImgsPath = new HashMap<Integer, String>();

    public GForceBackYContainer() {
        this.setPreferredSize(new Dimension(439, 250));
        this.getStyle().setBgTransparency(0);
        this.initImageMap();
    }

    protected void initView() {
        this.getStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage(this._gForceImageName));
    }

    private void initImageMap() {
        this._leftRightBackgroundImgsPath.put(-7, "_r7.png");
        this._leftRightBackgroundImgsPath.put(-6, "_r6.png");
        this._leftRightBackgroundImgsPath.put(-5, "_r5.png");
        this._leftRightBackgroundImgsPath.put(-4, "_r4.png");
        this._leftRightBackgroundImgsPath.put(-3, "_r3.png");
        this._leftRightBackgroundImgsPath.put(-2, "_r2.png");
        this._leftRightBackgroundImgsPath.put(-1, "_r1.png");
        this._leftRightBackgroundImgsPath.put(0, ".png");
        this._leftRightBackgroundImgsPath.put(1, "_l7.png");
        this._leftRightBackgroundImgsPath.put(2, "_l6.png");
        this._leftRightBackgroundImgsPath.put(3, "_l5.png");
        this._leftRightBackgroundImgsPath.put(4, "_l4.png");
        this._leftRightBackgroundImgsPath.put(5, "_l3.png");
        this._leftRightBackgroundImgsPath.put(6, "_l2.png");
        this._leftRightBackgroundImgsPath.put(7, "_l1.png");
    }

    protected boolean updateViewOnDataChanged(int imgNumber) {
        boolean hasViewChanged = false;
        String imageName = this._gForceImageName;
        if (this._leftRightBackgroundImgsPath.containsKey(imgNumber)) {
            imageName = "image_gindicator_active" + this._leftRightBackgroundImgsPath.get(imgNumber);
        }
        if (!this._gForceImageName.equals(imageName)) {
            this._gForceImageName = imageName;
            this.getStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage(this._gForceImageName));
            hasViewChanged = true;
        }
        return hasViewChanged;
    }

    protected boolean updateViewOnDataChanged(String imageName) {
        boolean hasViewChanged = false;
        if (!this._gForceImageName.equals(imageName)) {
            this._gForceImageName = imageName;
            this.getStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage(this._gForceImageName));
            hasViewChanged = true;
        }
        return hasViewChanged;
    }
}

