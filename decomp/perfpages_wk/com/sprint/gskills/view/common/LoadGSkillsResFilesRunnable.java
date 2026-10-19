/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.PlatformException
 *  kona.platform.PlatformInfo
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.common;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.controller.RegisterUnregisterListeners;
import com.sprint.gskills.listener.LanguagesListener;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.mainview.MainMenuView;
import com.sprint.gskills.view.mainview.MainView;
import edu.emory.mathcs.backport.java.util.concurrent.CountDownLatch;
import java.util.Locale;
import kona.platform.PlatformException;
import kona.platform.PlatformInfo;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class LoadGSkillsResFilesRunnable
extends GSkillsRunnable {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private static final LoadGSkillsResFilesRunnable INSTANCE = new LoadGSkillsResFilesRunnable("LoadGSkillsResFilesThread");
    private CountDownLatch _resourceLoadCompleteLatch = new CountDownLatch(1);

    private LoadGSkillsResFilesRunnable(String name) {
        super(name);
    }

    public static LoadGSkillsResFilesRunnable getInstance() {
        return INSTANCE;
    }

    public void run() {
        this._logger.debug((Object)"INIT:Thread to initialize sensors and load res files started");
        RegisterUnregisterListeners.getInstance().initializeListenersList();
        GSkillsResourceManager.getInstance().loadFontResourceFile();
        GSkillsResourceManager.getInstance().loadLocalizationResourceFile();
        GSkillsResourceManager.getInstance().loadCommonGraphicsResFile();
        GSkillsResourceManager.getInstance().loadTrimSpecificGraphicsResFile();
        MainView.getInstance().initializeHomePage();
        this.setLocaleData();
        GSkillsResourceManager.getInstance().loadLineSpecificGraphicsResFile();
        this._resourceLoadCompleteLatch.countDown();
    }

    public void waitForResourcesToLoad() {
        try {
            long resLoadStartTimeStamp = System.currentTimeMillis();
            this._logger.debug((Object)"INIT:Waiting for graphic resources to be loaded");
            this._resourceLoadCompleteLatch.await();
            this._logger.debug((Object)("INIT:Resources loading complete. Took " + (System.currentTimeMillis() - resLoadStartTimeStamp) + " ms to load the res files"));
        }
        catch (InterruptedException e2) {
            e2.printStackTrace();
        }
    }

    private void setLocaleData() {
        Locale locale = null;
        try {
            locale = PlatformInfo.getPlatformInfo().getCurrentLocale();
        }
        catch (PlatformException e2) {
            this._logger.debug((Object)"PlatformException while attempting to retrieve locale information. Using default locale en_US instead");
            e2.printStackTrace();
        }
        finally {
            LanguagesListener.getInstance().setNewLocale(locale);
            MainMenuView.getInstance().updateOnLanguageChanged();
        }
    }
}

