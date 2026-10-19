/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.LocaleChangeListener
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.listener;

import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.listener.UnitListener;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.ExecutorService;
import java.util.Locale;
import kona.platform.LocaleChangeListener;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class LanguagesListener
implements LocaleChangeListener {
    private Logger logger = LoggerFactory.getLogger(UnitListener.class);
    private static final ExecutorService dataListenerExecutor = GSkillsProjectFactory.getDataListenersExecutor();

    public void onLocaleChange(Locale newLocal) {
        try {
            this.logger.debug((Object)"LanguagesListener.onLocaleChange()");
            dataListenerExecutor.submit(new NotifyLanguageChanged(newLocal));
        }
        catch (Throwable e2) {
            this.logger.debug((Object)"ignoring Harman language data ", e2);
        }
    }

    private class NotifyLanguageChanged
    implements Callable {
        Locale localData;

        public NotifyLanguageChanged(Locale newLocal) {
            this.localData = newLocal;
        }

        public Object call() throws Exception {
            try {
                LanguagesListener.this.logger.debug((Object)"LanguagesListener.NotifyLanguageChanged.call()");
                String languageName = this.localData.getLanguage() + "_" + this.localData.getCountry().toUpperCase();
                LanguagesListener.this.logger.debug((Object)("locale changed to " + languageName));
                GSkillsViewController.getInstance().notifyLanguageChanged(languageName);
            }
            catch (Exception ex) {
                LanguagesListener.this.logger.error((Object)("Languge changed error:" + ex));
            }
            return null;
        }
    }
}

