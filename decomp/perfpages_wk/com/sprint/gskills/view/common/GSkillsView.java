/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.model.sensordata.SensorPollManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.UpdatableContainer;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import java.util.ArrayList;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public abstract class GSkillsView
extends Container {
    protected Logger _logger = Log.createLogger((String)((Object)((Object)this)).getClass().getName());
    protected boolean _languageChanged = true;
    protected boolean _unitChanged = true;
    protected ArrayList<UpdatableContainer> _viewContainerList = new ArrayList();

    public GSkillsView() {
        this._logger.debug((Object)("Initializing " + this.toString()));
    }

    protected final void initView() {
        this._logger.debug((Object)("Forcing all units to change for " + this.toString()));
        GSkillsStateManager.getInstance().forceUpdateAllUnits();
        this.notifyUnitChanged();
        this.notifyLanguageChanged();
    }

    public void notifyLanguageChanged() {
        this._logger.debug((Object)"-----------------------------------------------------------");
        this._logger.debug((Object)("Updating " + this.toString() + " on language change"));
        this._logger.debug((Object)"-----------------------------------------------------------");
        this._languageChanged = true;
        for (int i2 = 0; i2 < this._viewContainerList.size(); ++i2) {
            UpdatableContainer c2 = this._viewContainerList.get(i2);
            this._logger.debug((Object)("Updating " + c2.toString() + " on language change"));
            c2.updateViewOnLanguageChange();
        }
    }

    public void notifyUnitChanged() {
        this._logger.debug((Object)"-----------------------------------------------------------");
        this._logger.debug((Object)("Updating " + this.toString() + " on unit change"));
        this._logger.debug((Object)"-----------------------------------------------------------");
        this._unitChanged = true;
        for (int i2 = 0; i2 < this._viewContainerList.size(); ++i2) {
            UpdatableContainer c2 = this._viewContainerList.get(i2);
            this._logger.debug((Object)("Updating " + c2.toString() + " on unit change"));
            c2.updateViewOnUnitChange();
        }
    }

    public boolean animate() {
        SensorPollManager.getInstance().pollSensors();
        boolean needRepaint = this._unitChanged || this._languageChanged;
        for (int i2 = 0; i2 < this._viewContainerList.size(); ++i2) {
            boolean u2 = this._viewContainerList.get(i2).updateViewOnDataChange(this._unitChanged);
            needRepaint = needRepaint || u2;
        }
        this._unitChanged = false;
        this._languageChanged = false;
        return needRepaint;
    }

    protected void initContainer(UpdatableContainer c2) {
        if (null != c2) {
            this.addComponent((Component)c2);
            this._viewContainerList.add(c2);
        }
    }

    public String toString() {
        String str = ((Object)((Object)this)).getClass().getName();
        return str.substring(str.lastIndexOf(46) + 1, str.length());
    }
}

