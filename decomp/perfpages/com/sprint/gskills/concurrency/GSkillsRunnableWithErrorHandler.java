/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.concurrency;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsRunnableWithErrorHandler
extends GSkillsRunnable {
    private Logger logger = Log.createLogger((String)this.getClass().getName());
    private GSkillsRunnable _runObj;

    public GSkillsRunnableWithErrorHandler(GSkillsRunnable runObj) {
        super(runObj.toString());
        this._runObj = runObj;
    }

    public void run() {
        try {
            this._runObj.run();
        }
        catch (Throwable e2) {
            this.logger.error((Object)"******************************************************************************");
            this.logger.error((Object)("Thread " + this._threadName + " threw exception " + e2.getMessage()));
            this.logger.error((Object)"******************************************************************************");
            e2.printStackTrace();
        }
    }
}

