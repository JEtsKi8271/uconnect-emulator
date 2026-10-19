/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.concurrency;

import edu.emory.mathcs.backport.java.util.concurrent.Callable;

public abstract class GSkillsCallable
implements Callable {
    protected String threadName = "";

    public GSkillsCallable(String name) {
        this.threadName = name;
    }

    public String toString() {
        return this.threadName;
    }
}

