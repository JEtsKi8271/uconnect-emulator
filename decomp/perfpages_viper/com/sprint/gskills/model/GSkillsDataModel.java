/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.model;

import com.sprint.gskills.view.common.GSkillsViewDataListener;

public interface GSkillsDataModel {
    public void setListener(GSkillsViewDataListener var1);

    public boolean registerListenerForAttributes();

    public void removeViewListener();

    public void unregisterListenerForAttributes();
}

