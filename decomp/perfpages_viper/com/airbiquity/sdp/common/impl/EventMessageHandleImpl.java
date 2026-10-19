/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.impl;

import com.airbiquity.sdp.common.EventHandle;
import com.airbiquity.sdp.common.EventMessageHandle;

public abstract class EventMessageHandleImpl
implements EventMessageHandle {
    private static final long serialVersionUID = 1671261371583301183L;
    private EventHandle eventHandle;

    public EventMessageHandleImpl(EventHandle eventHandle) {
        this.eventHandle = eventHandle;
    }

    public EventHandle getEventHandle() {
        return this.eventHandle;
    }
}

