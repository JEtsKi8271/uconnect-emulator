/*
 * Decompiled with CFR 0.152.
 */
package com.sprint.gskills.concurrency;

public abstract class GSkillsRunnable
implements Runnable {
    protected String _threadName = "";

    public GSkillsRunnable(String name) {
        this._threadName = name;
    }

    public GSkillsRunnable() {
        this._threadName = this.getClass().getName();
    }

    public String toString() {
        return this._threadName;
    }
}

