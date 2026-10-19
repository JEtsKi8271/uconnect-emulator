/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import com.airbiquity.sdp.common.EventHandle;
import com.airbiquity.sdp.common.EventHandlerListener;
import java.rmi.RemoteException;

public interface EventHandlerListenerExtended
extends EventHandlerListener {
    public void notifyOfSuccess(EventHandle var1) throws RemoteException;
}

