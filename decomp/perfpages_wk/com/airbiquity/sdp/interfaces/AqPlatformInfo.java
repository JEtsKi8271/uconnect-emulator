/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.LocaleChangeListener
 *  kona.platform.PlatformException
 */
package com.airbiquity.sdp.interfaces;

import java.util.Locale;
import kona.platform.LocaleChangeListener;
import kona.platform.PlatformException;

public interface AqPlatformInfo {
    public Locale getCurrentLocale() throws PlatformException;

    public String getPlatformVariant() throws PlatformException;

    public void registerLocaleListener(LocaleChangeListener var1) throws NullPointerException, PlatformException;

    public void unregisterLocaleListener(LocaleChangeListener var1) throws PlatformException;
}

