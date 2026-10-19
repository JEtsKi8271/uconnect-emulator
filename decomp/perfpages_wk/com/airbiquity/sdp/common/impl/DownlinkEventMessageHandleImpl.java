/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.impl;

import com.airbiquity.sdp.common.DownlinkEventMessageHandle;
import com.airbiquity.sdp.common.EventHandle;
import com.airbiquity.sdp.common.impl.EventMessageHandleImpl;
import com.wirelesscar.ngtp.dspt.api.DsptMessage;

public final class DownlinkEventMessageHandleImpl
extends EventMessageHandleImpl
implements DownlinkEventMessageHandle {
    private static final long serialVersionUID = 1L;
    private long downlinkmessageId;

    private DownlinkEventMessageHandleImpl(EventHandle eventHandle, long downlinkMessageId) {
        super(eventHandle);
        this.downlinkmessageId = downlinkMessageId;
    }

    public long getDownlinkMessageId() {
        return this.downlinkmessageId;
    }

    public boolean equals(Object o2) {
        if (!(o2 instanceof DownlinkEventMessageHandleImpl)) {
            return false;
        }
        DownlinkEventMessageHandleImpl emh = (DownlinkEventMessageHandleImpl)o2;
        boolean areEqual = this.getEventHandle().equals(emh.getEventHandle()) && this.getDownlinkMessageId() == emh.getDownlinkMessageId();
        return areEqual;
    }

    public String toString() {
        return this.getEventHandle().toString() + "; downlink msg count: " + this.downlinkmessageId;
    }

    public int hashCode() {
        int hEh = this.getEventHandle().hashCode();
        return hEh + (int)this.getDownlinkMessageId();
    }

    public static DownlinkEventMessageHandleImpl createDownlinkMessageHandler(EventHandle eventHandle, DsptMessage dsptDownlinkMessage) {
        return new DownlinkEventMessageHandleImpl(eventHandle, dsptDownlinkMessage.getMessageCount().getDownlinkCount());
    }

    public static DownlinkEventMessageHandleImpl createDownlinkMessageHandler(EventHandle eventHandle, long downlinkMessageId) {
        return new DownlinkEventMessageHandleImpl(eventHandle, downlinkMessageId);
    }
}

