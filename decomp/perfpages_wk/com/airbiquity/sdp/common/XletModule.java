/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common;

import com.airbiquity.sdp.common.SDPClientException;

public interface XletModule {
    public void initModule() throws SDPClientException;

    public void destroyModule();

    public void startModule() throws SDPClientException;

    public void pauseModule();
}

