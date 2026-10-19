/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.performancesrt.PerformanceException
 *  kona.performancesrt.PerformanceSRTData
 *  kona.performancesrt.PerformanceSRTListener
 */
package com.airbiquity.sdp.interfaces;

import kona.performancesrt.PerformanceException;
import kona.performancesrt.PerformanceSRTData;
import kona.performancesrt.PerformanceSRTListener;

public interface AqPerformanceSRTManager {
    public String getPerformanceAttributeName(int var1);

    public void registerAllWithPerformanceSRTListener(PerformanceSRTListener var1) throws PerformanceException;

    public void registerPerformanceSRTListener(int var1, PerformanceSRTListener var2) throws PerformanceException;

    public void removeALLPerformanceSRTListeners();

    public void removePerformanceSRTListener(int var1);

    public PerformanceSRTData getPerformanceData(int var1) throws PerformanceException, IllegalArgumentException;

    public PerformanceSRTData createPerformanceData(int var1, int var2);

    public PerformanceSRTData createPerformanceData(int var1, double var2);
}

