/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 */
package com.sprint.gskills.view.enginepage;

import com.sprint.gskills.unit.PowerUnitEnum;
import com.sprint.gskills.unit.TorqueUnitEnum;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Image;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import java.util.TreeMap;

public class EngineHPTorqueUnitContainer
extends UpdatableContainer {
    private CommonLabel _hpUnitImageLabel = null;
    private CommonLabel _torqueUnitImageLabel = null;
    private TreeMap<String, String> _hpUnitMap = null;
    private TreeMap<String, String> _torqueUnitMap = null;

    public EngineHPTorqueUnitContainer() {
        this.initView();
    }

    protected void initView() {
        this.setLayout((Layout)new CoordinateLayout(520, 280));
        this.setPreferredSize(new Dimension(520, 280));
        this.getStyle().setBackgroundType((byte)5);
        this.getStyle().setBackgroundAlignment((byte)-94);
        this.getStyle().setBgTransparency(0);
        this._hpUnitImageLabel = new CommonLabel();
        this._hpUnitImageLabel.setPreferredSize(new Dimension(25, 55));
        this._hpUnitImageLabel.getStyle().setBackgroundAlignment((byte)-95);
        this._hpUnitImageLabel.getStyle().setBgTransparency(0);
        this._hpUnitImageLabel.setX(77);
        this._hpUnitImageLabel.setY(206);
        this._torqueUnitImageLabel = new CommonLabel();
        this._torqueUnitImageLabel.setPreferredSize(new Dimension(35, 55));
        this._torqueUnitImageLabel.getStyle().setBackgroundAlignment((byte)-95);
        this._torqueUnitImageLabel.getStyle().setBgTransparency(0);
        this._torqueUnitImageLabel.setX(102);
        this._torqueUnitImageLabel.setY(206);
        this.addComponent((Component)this._hpUnitImageLabel);
        this.addComponent((Component)this._torqueUnitImageLabel);
        this.setHPUnitMap();
        this.setTorqueUnitMap();
    }

    public boolean updateViewOnDataChange(boolean forceUpdate) {
        return false;
    }

    public void updateViewOnLanguageChange() {
    }

    public void updateViewOnTorqueUnitChange() {
        TorqueUnitEnum torqueUnitEnum = this._stateManager.getTorqueUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on torque unit change to " + torqueUnitEnum.toString()));
        String currentLanguage = this._resourceManager.getCurrentLocale();
        Image centerTorqueUnitImage = null;
        centerTorqueUnitImage = TorqueUnitEnum.FT_LB == torqueUnitEnum ? this._resourceManager.getCommonImage("gaugelabel_torque_" + this._torqueUnitMap.get(currentLanguage) + ".png") : this._resourceManager.getCommonImage("gaugelabel_torque_Nm.png");
        this._torqueUnitImageLabel.getStyle().setBgImage(centerTorqueUnitImage);
    }

    public void updateViewOnPowerUnitChange() {
        PowerUnitEnum powerUnit = this._stateManager.getPowerUnit();
        this._logger.debug((Object)("Updating " + this.toString() + " on power unit change to " + powerUnit.toString()));
        String currentLanguage = this._resourceManager.getCurrentLocale();
        Image centerHPUnitImage = null;
        centerHPUnitImage = PowerUnitEnum.KW == powerUnit ? this._resourceManager.getCommonImage("gaugelabel_hp_KW.png") : this._resourceManager.getCommonImage("gaugelabel_hp_" + this._hpUnitMap.get(currentLanguage) + ".png");
        this._hpUnitImageLabel.getStyle().setBgImage(centerHPUnitImage);
    }

    private void setHPUnitMap() {
        this._hpUnitMap = new TreeMap();
        this._hpUnitMap.put("de", "PS");
        this._hpUnitMap.put("en_GB", "hp");
        this._hpUnitMap.put("en_US", "hp");
        this._hpUnitMap.put("es_MX", "cf");
        this._hpUnitMap.put("fr_CA", "cv");
        this._hpUnitMap.put("fr_FR", "cv");
        this._hpUnitMap.put("it_IT", "hp");
        this._hpUnitMap.put("nl_NL", "pk");
        this._hpUnitMap.put("pl_PL", "hp");
        this._hpUnitMap.put("pt_BR", "hp");
        this._hpUnitMap.put("pt_PT", "hp");
        this._hpUnitMap.put("ru_RU", "hp");
        this._hpUnitMap.put("tr_TR", "hp");
        this._hpUnitMap.put("zh_CN", "hp");
        this._hpUnitMap.put("ja_JP", "hp");
        this._hpUnitMap.put("ko_KO", "hp");
    }

    private void setTorqueUnitMap() {
        this._torqueUnitMap = new TreeMap();
        this._torqueUnitMap = new TreeMap();
        this._torqueUnitMap.put("de", "lb-ft");
        this._torqueUnitMap.put("en_GB", "lb-ft");
        this._torqueUnitMap.put("en_US", "lb-ft");
        this._torqueUnitMap.put("es_MX", "lb-ft");
        this._torqueUnitMap.put("fr_CA", "lb-pi");
        this._torqueUnitMap.put("fr_FR", "lb-pi");
        this._torqueUnitMap.put("it_IT", "lb-ft");
        this._torqueUnitMap.put("nl_NL", "lb-ft");
        this._torqueUnitMap.put("pl_PL", "lb-ft");
        this._torqueUnitMap.put("pt_BR", "pe-lb");
        this._torqueUnitMap.put("pt_PT", "lb-ft");
        this._torqueUnitMap.put("ru_RU", "lb-ft");
        this._torqueUnitMap.put("tr_TR", "lb-ft");
        this._torqueUnitMap.put("zh_CN", "lb-ft");
        this._torqueUnitMap.put("ja_JP", "lb-ft");
        this._torqueUnitMap.put("ko_KO", "lb-ft");
    }
}

