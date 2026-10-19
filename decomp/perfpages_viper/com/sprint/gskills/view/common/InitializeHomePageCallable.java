/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.util.CommonUtils;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;

class InitializeHomePageCallable
implements Callable {
    InitializeHomePageCallable() {
    }

    public Object call() throws Exception {
        CommonUtils commonUtils = CommonUtils.getInstance();
        commonUtils.readHomePageImageFromRMS();
        return commonUtils;
    }
}

