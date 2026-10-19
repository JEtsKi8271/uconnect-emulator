/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.impl;

import com.airbiquity.sdp.common.EventHandle;
import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import com.wirelesscar.ngtp.dspt.api.Timestamp;
import java.util.Date;

public final class EventHandleImpl
implements EventHandle {
    private static final long serialVersionUID = 2166393245978297076L;
    private Date creationDate;
    private boolean isEventBackendInitiated;
    private int serviceTypeInt;

    public static EventHandleImpl getEventHandle(Date creationDate, Boolean isEventBackendInitiated, int serviceType) {
        return new EventHandleImpl(creationDate, isEventBackendInitiated, serviceType);
    }

    private EventHandleImpl(Date creationDate, boolean isEventBackendInitiated, int serviceTypeInt) {
        this.creationDate = creationDate;
        this.serviceTypeInt = serviceTypeInt;
        this.isEventBackendInitiated = isEventBackendInitiated;
    }

    public static EventHandleImpl getEventHandle(DsptMessage dsptMessage) {
        return new EventHandleImpl(dsptMessage);
    }

    private EventHandleImpl(DsptMessage dsptMessage) {
        this.isEventBackendInitiated = dsptMessage.isEventBackendInitiated();
        this.creationDate = dsptMessage.getEventCreationTime().getDate();
        this.serviceTypeInt = dsptMessage.getServiceType();
    }

    public int getServiceType() {
        return this.serviceTypeInt;
    }

    public boolean isEventBackendInitiated() {
        return this.isEventBackendInitiated;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Service type: ");
        sb.append(this.serviceTypeInt);
        sb.append("; Creation date: ");
        sb.append(this.creationDate);
        sb.append("; SI initated: ");
        sb.append(this.isEventBackendInitiated());
        return sb.toString();
    }

    public Date getDate() {
        return this.creationDate;
    }

    public Timestamp getTimestamp() {
        return Timestamp.fromDate(this.creationDate);
    }

    public boolean equals(Object o2) {
        if (!(o2 instanceof EventHandleImpl)) {
            return false;
        }
        EventHandleImpl eh = (EventHandleImpl)o2;
        boolean areEqual = this.creationDate.equals(eh.getDate()) && this.isEventBackendInitiated() == eh.isEventBackendInitiated() && this.serviceTypeInt == eh.getServiceType();
        return areEqual;
    }

    public int hashCode() {
        int hDate = this.creationDate.hashCode();
        int hSt = this.serviceTypeInt;
        return hDate + hSt;
    }
}

