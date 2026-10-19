/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Container
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.gforcepage;

import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Container;
import java.util.HashMap;
import java.util.Map;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

class GForceCarMoveContainer
extends Container {
    private Logger _logger = LoggerFactory.getLogger(GForceCarMoveContainer.class);
    private int _carPositionIndex;
    private final String _carBrand;
    private Map<Integer, String> _mapCarImages = new HashMap<Integer, String>();

    public GForceCarMoveContainer() {
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        this._carBrand = stateManager.getVehicleLine().toString() + "_" + stateManager.getVehicleTrim().toString();
        this.updateCarImage();
    }

    private void loadImageByThemeIndex() {
        try {
            this._mapCarImages.put(-7, this._carBrand + "_l7.png");
            this._mapCarImages.put(-6, this._carBrand + "_l6.png");
            this._mapCarImages.put(-5, this._carBrand + "_l5.png");
            this._mapCarImages.put(-4, this._carBrand + "_l4.png");
            this._mapCarImages.put(-3, this._carBrand + "_l3.png");
            this._mapCarImages.put(-2, this._carBrand + "_l2.png");
            this._mapCarImages.put(-1, this._carBrand + "_l1.png");
            this._mapCarImages.put(0, this._carBrand + "_mid.png");
            this._mapCarImages.put(1, this._carBrand + "_r7.png");
            this._mapCarImages.put(2, this._carBrand + "_r6.png");
            this._mapCarImages.put(3, this._carBrand + "_r5.png");
            this._mapCarImages.put(4, this._carBrand + "_r4.png");
            this._mapCarImages.put(5, this._carBrand + "_r3.png");
            this._mapCarImages.put(6, this._carBrand + "_r2.png");
            this._mapCarImages.put(7, this._carBrand + "_r1.png");
        }
        catch (Exception e2) {
            this._logger.error((Object)"Error : (create images) ", (Throwable)e2);
        }
    }

    private void updateCarImage() {
        this.loadImageByThemeIndex();
        this.getStyle().setBgImage(GSkillsResourceManager.getInstance().getTrimSpecificImage(this._mapCarImages.get(this._carPositionIndex)));
    }

    protected boolean updateViewOnDataChanged(int newCarPositionIndex) {
        boolean hasViewChanged = false;
        if (this._carPositionIndex != newCarPositionIndex) {
            hasViewChanged = true;
            this._carPositionIndex = newCarPositionIndex;
            try {
                this.getStyle().setBgImage(GSkillsResourceManager.getInstance().getTrimSpecificImage(this._mapCarImages.get(this._carPositionIndex)));
            }
            catch (Exception ex) {
                this._logger.error((Object)"update view on data change error : ", (Throwable)ex);
            }
        }
        return hasViewChanged;
    }
}

