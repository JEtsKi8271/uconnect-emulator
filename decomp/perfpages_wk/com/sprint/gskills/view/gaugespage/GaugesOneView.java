/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.gaugespage;

import com.sprint.gskills.constants.TransmissionTypeEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsView;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sprint.gskills.view.gaugespage.BatteryDashboardView;
import com.sprint.gskills.view.gaugespage.CoolantTempDashboardView;
import com.sprint.gskills.view.gaugespage.OilPressureDashboardView;
import com.sprint.gskills.view.gaugespage.OilTempDashboardView;
import com.sprint.gskills.view.gaugespage.TransTempDashboardView;
import com.sun.lwuit.Component;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public class GaugesOneView
extends GSkillsView {
    private final int CONTAINER_H = 285;
    private final int CONTAINER_W = 526;
    private static final GaugesOneView INSTANCE = new GaugesOneView();

    public static GaugesOneView getInstance() {
        return INSTANCE;
    }

    private GaugesOneView() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(526, 285)));
        this.setPreferredSize(new Dimension(526, 285));
        this.initGaugesOneViewSensorList();
        this.initGaugesOneLayout();
        GSkillsViewBuildFactory.getInstance().addToUnitList(ViewEnum.GAUGESONE_VIEW);
        GSkillsViewBuildFactory.getInstance().addToLanguageList(ViewEnum.GAUGESONE_VIEW);
        this.initView();
    }

    private void initGaugesOneLayout() {
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        VehicleTrimEnum vehicleTrim = stateManager.getVehicleTrim();
        if (stateManager.isLSeriesVehicle()) {
            if (VehicleTrimEnum.HELLCAT == vehicleTrim) {
                this.initLSeriesHellcatGaugeLayout();
            } else {
                this.initLSeriesBaseSRTGaugeLayout();
            }
        } else {
            this.initJeepViperGaugeLayout();
        }
    }

    private void initGaugesOneViewSensorList() {
        TransmissionTypeEnum transmissionType = GSkillsStateManager.getInstance().getTransType();
        VehicleTrimEnum vehTrim = GSkillsStateManager.getInstance().getVehicleTrim();
        if (VehicleTrimEnum.HELLCAT == vehTrim) {
            this._viewContainerList.add(OilTempDashboardView.getInstance());
            this._viewContainerList.add(OilPressureDashboardView.getInstance());
            this._viewContainerList.add(CoolantTempDashboardView.getInstance());
            this._viewContainerList.add(BatteryDashboardView.getInstance());
            if (TransmissionTypeEnum.AUTO == transmissionType) {
                this._viewContainerList.add(TransTempDashboardView.getInstance());
            }
        } else {
            this._viewContainerList.add(OilTempDashboardView.getInstance());
            this._viewContainerList.add(CoolantTempDashboardView.getInstance());
            this._viewContainerList.add(OilPressureDashboardView.getInstance());
        }
    }

    private void initLSeriesBaseSRTGaugeLayout() {
        ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() - 3);
        ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setY(60);
        ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setX(7);
        ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setY(60);
        ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + ((UpdatableContainer)((Object)this._viewContainerList.get(1))).getPreferredW() - 16);
        ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setY(60);
        this.addComponent((Component)this._viewContainerList.get(0));
        this.addComponent((Component)this._viewContainerList.get(1));
        this.addComponent((Component)this._viewContainerList.get(2));
    }

    private void initLSeriesHellcatGaugeLayout() {
        if (GSkillsStateManager.getInstance().getTransType() == TransmissionTypeEnum.AUTO) {
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setX(82);
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setY(-5);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + 97);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setY(-5);
            ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setX(0);
            ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setY(133);
            ((UpdatableContainer)((Object)this._viewContainerList.get(3))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() - 3);
            ((UpdatableContainer)((Object)this._viewContainerList.get(3))).setY(133);
            ((UpdatableContainer)((Object)this._viewContainerList.get(4))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + ((UpdatableContainer)((Object)this._viewContainerList.get(1))).getPreferredW() - 3);
            ((UpdatableContainer)((Object)this._viewContainerList.get(4))).setY(133);
            this.addComponent((Component)this._viewContainerList.get(0));
            this.addComponent((Component)this._viewContainerList.get(1));
            this.addComponent((Component)this._viewContainerList.get(2));
            this.addComponent((Component)this._viewContainerList.get(3));
            this.addComponent((Component)this._viewContainerList.get(4));
        } else {
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + 47);
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setY(-5);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + ((UpdatableContainer)((Object)this._viewContainerList.get(1))).getPreferredW() - 28);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setY(133);
            ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setX(17);
            ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setY(-5);
            ((UpdatableContainer)((Object)this._viewContainerList.get(3))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() - 58);
            ((UpdatableContainer)((Object)this._viewContainerList.get(3))).setY(133);
            this.addComponent((Component)this._viewContainerList.get(0));
            this.addComponent((Component)this._viewContainerList.get(1));
            this.addComponent((Component)this._viewContainerList.get(2));
            this.addComponent((Component)this._viewContainerList.get(3));
        }
    }

    private void initJeepViperGaugeLayout() {
        ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setX(173);
        ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setY(15);
        ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setX(36);
        ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setY(145);
        ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setX(296);
        ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setY(145);
        this.addComponent((Component)this._viewContainerList.get(0));
        this.addComponent((Component)this._viewContainerList.get(1));
        this.addComponent((Component)this._viewContainerList.get(2));
    }
}

