/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.xlet.XletContext
 *  javax.microedition.xlet.ixc.IxcRegistry
 */
package com.sprint.gskills.factory;

import com.airbiquity.sdp.common.SDPClientException;
import com.sprint.gskills.GSkillsLifeCycleListener;
import com.sprint.gskills.controller.savetimerrun.TimerSavingData;
import com.sprint.gskills.factory.GSkillsProperties;
import com.sprint.gskills.factory.SendToWebsiteCallable;
import com.sprint.gskills.view.common.GSkillsViewDataListener;
import com.sprint.gskills.xlet.GSkillsModule;
import edu.emory.mathcs.backport.java.util.concurrent.ExecutorService;
import edu.emory.mathcs.backport.java.util.concurrent.Executors;
import edu.emory.mathcs.backport.java.util.concurrent.ScheduledThreadPoolExecutor;
import edu.emory.mathcs.backport.java.util.concurrent.SynchronousQueue;
import edu.emory.mathcs.backport.java.util.concurrent.ThreadPoolExecutor;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import java.rmi.AccessException;
import java.rmi.RemoteException;
import java.rmi.registry.Registry;
import javax.microedition.xlet.XletContext;
import javax.microedition.xlet.ixc.IxcRegistry;

public class GSkillsProjectFactory {
    private static final ThreadPoolExecutor dataListenersExecutor = new ThreadPoolExecutor(GSkillsProperties.getDataListenersThreadpoolSize(), GSkillsProperties.getDataListenersThreadpoolSize(), 0L, TimeUnit.SECONDS, new SynchronousQueue());
    private static final ThreadPoolExecutor viewChangeExecutor = new ThreadPoolExecutor(GSkillsProperties.getViewChangeThreadpoolSize(), GSkillsProperties.getViewChangeThreadpoolSize(), 0L, TimeUnit.SECONDS, new SynchronousQueue());
    private static final ExecutorService startApplicationExecutor = Executors.newFixedThreadPool(GSkillsProperties.getStartAppThreadpoolSize());
    private static ExecutorService sendDataToWebsiteExecutor = Executors.newFixedThreadPool(GSkillsProperties.getSendDataToWebsiteThreadpoolSize());
    private static final ScheduledThreadPoolExecutor regsiterTimerListenersExecutor = new ScheduledThreadPoolExecutor(GSkillsProperties.getRegisterTimerListenerThreadpoolSize());

    public static GSkillsModule getGSkillsModule(IxcRegistry registry, XletContext xletContext) throws SDPClientException {
        return new GSkillsModule((Registry)registry, xletContext);
    }

    public static GSkillsLifeCycleListener getGSkillsLifeCycleListener() throws AccessException, RemoteException {
        return new GSkillsLifeCycleListener();
    }

    public static TimerSavingData getTimerSavingData() {
        return new TimerSavingData();
    }

    public static ExecutorService getDataListenersExecutor() {
        return dataListenersExecutor;
    }

    public static ExecutorService getViewChangeExecutor() {
        return viewChangeExecutor;
    }

    public static void destroyViewChangeExecutor() {
        viewChangeExecutor.shutdownNow();
    }

    public static void destroyDataListenersExecutor() {
        dataListenersExecutor.shutdownNow();
    }

    public static ExecutorService getInitializeApplicationExecutor() {
        return startApplicationExecutor;
    }

    public static void destroyStartApplicationExecutor() {
        startApplicationExecutor.shutdownNow();
    }

    public static ExecutorService getSendDataToWebsiteExecutor() {
        return sendDataToWebsiteExecutor;
    }

    public static SendToWebsiteCallable getSendToWebsiteCallable(String htmlFileContent, String fileName, GSkillsViewDataListener commonTimerViewContainer) {
        return new SendToWebsiteCallable(htmlFileContent, fileName, commonTimerViewContainer);
    }

    public static void destroySendDataToWebsiteExecutor() {
        sendDataToWebsiteExecutor.shutdownNow();
    }

    public static ScheduledThreadPoolExecutor getRegisterTimerListener() {
        return regsiterTimerListenersExecutor;
    }
}

