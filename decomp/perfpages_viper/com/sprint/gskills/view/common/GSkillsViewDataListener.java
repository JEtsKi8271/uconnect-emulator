/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.model.GSkillsDataModel;

public interface GSkillsViewDataListener {
    public void updateViewOnDataChanged();

    public void updateViewOnLanguageChanged();

    public void updateViewOnUnitChanged();

    public void onNotifyDataChange(GSkillsDataModel var1);

    public void notifyStatus(int var1);
}

