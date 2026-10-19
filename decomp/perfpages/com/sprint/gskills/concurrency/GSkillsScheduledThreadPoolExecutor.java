/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.concurrency;

import com.sprint.gskills.concurrency.GSkillsThreadFactory;
import edu.emory.mathcs.backport.java.util.concurrent.ScheduledThreadPoolExecutor;
import edu.emory.mathcs.backport.java.util.concurrent.ThreadFactory;

public class GSkillsScheduledThreadPoolExecutor
extends ScheduledThreadPoolExecutor {
    private static volatile int threadCount = 0;
    private static final GSkillsScheduledThreadPoolExecutor INSTANCE = new GSkillsScheduledThreadPoolExecutor(1, new GSkillsThreadFactory("GSkillsPeriodicThreadPool"));

    private GSkillsScheduledThreadPoolExecutor(int paramInt, ThreadFactory paramThreadFactory) {
        super(paramInt, paramThreadFactory);
    }

    public static GSkillsScheduledThreadPoolExecutor getInstance() {
        return INSTANCE;
    }

    public int getCalculatedTaskCount() {
        return threadCount;
    }
}

