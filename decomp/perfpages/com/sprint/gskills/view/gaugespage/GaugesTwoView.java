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
import com.sprint.gskills.view.gaugespage.AirFuelRatioDashboardView;
import com.sprint.gskills.view.gaugespage.BatteryDashboardView;
import com.sprint.gskills.view.gaugespage.BoostPressureDashboardView;
import com.sprint.gskills.view.gaugespage.CoolantTempICDashboardView;
import com.sprint.gskills.view.gaugespage.IntakeAirTempDashboardView;
import com.sprint.gskills.view.gaugespage.TransTempDashboardView;
import com.sun.lwuit.Component;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;

public class GaugesTwoView
extends GSkillsView {
    private final int CONTAINER_H = 285;
    private final int CONTAINER_W = 526;
    private static final GaugesTwoView INSTANCE = new GaugesTwoView();

    public static GaugesTwoView getInstance() {
        return INSTANCE;
    }

    private GaugesTwoView() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(526, 285)));
        this.setPreferredSize(new Dimension(526, 285));
        this.initGaugesTwoViewSensorList();
        this.initGaugesTwoLayout();
        GSkillsViewBuildFactory.getInstance().addToUnitList(ViewEnum.GAUGESTWO_VIEW);
        GSkillsViewBuildFactory.getInstance().addToLanguageList(ViewEnum.GAUGESTWO_VIEW);
        this.initView();
    }

    private void initGaugesTwoLayout() {
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        VehicleTrimEnum vehicleTrim = stateManager.getVehicleTrim();
        if (stateManager.isLSeriesVehicle()) {
            if (VehicleTrimEnum.HELLCAT == vehicleTrim) {
                this.initLSeriesHellcatLayout();
            } else {
                this.initLSeriesRTSRTLayout();
            }
        } else {
            this.initJeepViperLayout();
        }
    }

    private void initGaugesTwoViewSensorList() {
        TransmissionTypeEnum transmissionType = GSkillsStateManager.getInstance().getTransType();
        VehicleTrimEnum vehTrim = GSkillsStateManager.getInstance().getVehicleTrim();
        if (VehicleTrimEnum.HELLCAT == vehTrim) {
            this._viewContainerList.add(BoostPressureDashboardView.getInstance());
            this._viewContainerList.add(AirFuelRatioDashboardView.getInstance());
            this._viewContainerList.add(CoolantTempICDashboardView.getInstance());
            this._viewContainerList.add(IntakeAirTempDashboardView.getInstance());
        } else {
            this._viewContainerList.add(BatteryDashboardView.getInstance());
            this._viewContainerList.add(IntakeAirTempDashboardView.getInstance());
            if (TransmissionTypeEnum.AUTO == transmissionType) {
                this._viewContainerList.add(TransTempDashboardView.getInstance());
            }
        }
    }

    private void initLSeriesRTSRTLayout() {
        TransmissionTypeEnum transmissionType = GSkillsStateManager.getInstance().getTransType();
        if (TransmissionTypeEnum.AUTO == transmissionType) {
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setX(7);
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setY(60);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() - 3);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setY(60);
            ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + ((UpdatableContainer)((Object)this._viewContainerList.get(1))).getPreferredW() - 16);
            ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setY(60);
            this.addComponent((Component)this._viewContainerList.get(0));
            this.addComponent((Component)this._viewContainerList.get(1));
            this.addComponent((Component)this._viewContainerList.get(2));
        } else {
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setX(77);
            ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setY(60);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + 77);
            ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setY(60);
            this.addComponent((Component)this._viewContainerList.get(0));
            this.addComponent((Component)this._viewContainerList.get(1));
        }
    }

    private void initLSeriesHellcatLayout() {
        ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setX(17);
        ((UpdatableContainer)((Object)this._viewContainerList.get(0))).setY(-5);
        ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + 47);
        ((UpdatableContainer)((Object)this._viewContainerList.get(1))).setY(-5);
        ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() - 58);
        ((UpdatableContainer)((Object)this._viewContainerList.get(2))).setY(133);
        ((UpdatableContainer)((Object)this._viewContainerList.get(3))).setX(((UpdatableContainer)((Object)this._viewContainerList.get(0))).getPreferredW() + ((UpdatableContainer)((Object)this._viewContainerList.get(1))).getPreferredW() - 28);
        ((UpdatableContainer)((Object)this._viewContainerList.get(3))).setY(133);
        this.addComponent((Component)this._viewContainerList.get(0));
        this.addComponent((Component)this._viewContainerList.get(1));
        this.addComponent((Component)this._viewContainerList.get(2));
        this.addComponent((Component)this._viewContainerList.get(3));
    }

    private void initJeepViperLayout() {
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

