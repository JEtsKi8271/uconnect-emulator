/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.SRTTimerManager;
import com.sprint.gskills.common.GSkillsException;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.CommonViewResourceManager;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import kona.logger.Log;

class StartGSkillsCallable
implements Callable {
    public Object call() throws GSkillsException {
        try {
            SRTTimerManager.getInstance().init();
            CommonViewResourceManager.getInstance().loadCommonResources();
            CommonViewResourceManager.getInstance().loadBrandSpecificResources();
            CommonUtils.getInstance().readCarThemeFromRMS();
            GSkillsViewBuildFactory.getInstance().init();
        }
        catch (Throwable e2) {
            Log.createLogger((String)"StartGSkillsCallable").error((Object)"", e2);
        }
        return null;
    }
}

