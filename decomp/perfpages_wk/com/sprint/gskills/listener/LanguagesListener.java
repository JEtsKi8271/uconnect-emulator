/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.platform.LocaleChangeListener
 */
package com.sprint.gskills.listener;

import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import java.util.Locale;
import kona.platform.LocaleChangeListener;

public class LanguagesListener
implements LocaleChangeListener {
    private static final LanguagesListener INSTANCE = new LanguagesListener();

    private LanguagesListener() {
    }

    public static LanguagesListener getInstance() {
        return INSTANCE;
    }

    public void onLocaleChange(Locale locale) {
        this.setNewLocale(locale);
        GSkillsViewController.getInstance().localizeGSkillPages();
    }

    public void setNewLocale(Locale locale) {
        String localeName = null == locale ? "en_US" : locale.toString();
        GSkillsResourceManager.getInstance().setCurrentLocale(localeName);
    }
}

