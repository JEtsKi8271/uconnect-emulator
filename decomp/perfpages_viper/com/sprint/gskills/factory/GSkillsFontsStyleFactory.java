/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Font
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.view.common.CommonViewResourceManager;
import com.sun.lwuit.Font;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsFontsStyleFactory {
    Logger logger = Log.createLogger((String)"GSkillsFontsStyleFactory");
    private final String KEY_FONT11 = "Size_11";
    private final String KEY_FONT14 = "Size_14";
    private final String KEY_FONT18 = "Size_18";
    private final String KEY_FONT22 = "Size_22";
    private final String KEY_FONT28 = "Size_28";
    private final String KEY_FONT35 = "Size_35";
    private final String KEY_FONT42 = "Size_42";
    private final String KEY_FONT46 = "Size_46";
    private final String KEY_FONT_NimbusSanTOT_16 = "NimbusSanTOT_16";
    private Font font11 = null;
    private Font font14 = null;
    private Font font18 = null;
    private Font font22 = null;
    private Font font28 = null;
    private Font font35 = null;
    private Font font42 = null;
    private CommonViewResourceManager resourceManager = CommonViewResourceManager.getInstance();
    private static GSkillsFontsStyleFactory INSTANCE = null;

    public static GSkillsFontsStyleFactory getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new GSkillsFontsStyleFactory();
        }
        return INSTANCE;
    }

    private GSkillsFontsStyleFactory() {
    }

    public Font getFontSize11() {
        if (this.font11 == null) {
            this.font11 = this.resourceManager.getFontByKey("Size_11");
        }
        return this.font11;
    }

    public Font getFontSize14() {
        if (this.font14 == null) {
            this.font14 = this.resourceManager.getFontByKey("Size_14");
        }
        return this.font14;
    }

    public Font getFontSize18() {
        if (this.font18 == null) {
            this.font18 = this.resourceManager.getFontByKey("Size_18");
        }
        return this.font18;
    }

    public Font getFontSize22() {
        if (this.font22 == null) {
            this.font22 = this.resourceManager.getFontByKey("Size_22");
        }
        return this.font22;
    }

    public Font getFontSize28() {
        if (this.font28 == null) {
            this.font28 = this.resourceManager.getFontByKey("Size_28");
        }
        return this.font28;
    }

    public Font getFontSize35() {
        if (this.font35 == null) {
            this.font35 = this.resourceManager.getFontByKey("Size_35");
        }
        return this.font35;
    }

    public Font getFontSize42() {
        if (this.font42 == null) {
            this.font42 = this.resourceManager.getFontByKey("Size_42");
        }
        return this.font42;
    }

    public Font getFontSize46() {
        return this.resourceManager.getFontByKey("Size_46");
    }

    public Font getNimbusSanTOTFontWithSize16() {
        return this.resourceManager.getFontByKey("NimbusSanTOT_16");
    }
}

