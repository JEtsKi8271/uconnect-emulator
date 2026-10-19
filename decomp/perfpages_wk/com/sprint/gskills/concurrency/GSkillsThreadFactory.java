/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.concurrency;

import edu.emory.mathcs.backport.java.util.concurrent.ThreadFactory;

public class GSkillsThreadFactory
implements ThreadFactory {
    private String threadName = "GSkillsThread";

    public GSkillsThreadFactory() {
    }

    public GSkillsThreadFactory(String threadName) {
        this.threadName = threadName;
    }

    public Thread newThread(Runnable runObject) {
        return new Thread(runObject, this.threadName);
    }
}

