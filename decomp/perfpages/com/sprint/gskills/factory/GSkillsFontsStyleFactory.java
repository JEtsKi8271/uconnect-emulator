/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Font
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.factory;

import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.factory.GSkillsAlignmentFactory;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Font;
import java.util.HashMap;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsFontsStyleFactory {
    Logger _logger = Log.createLogger((String)this.getClass().getName());
    private String _defaultFont = "";
    private static final String FONT11 = "_11";
    private static final String FONT14 = "_14";
    private static final String FONT18 = "_18";
    private static final String FONT16 = "_16";
    private static final String FONT22 = "_22";
    private static final String FONT24 = "_24";
    private static final String FONT28 = "_28";
    private static final String FONT35 = "_35";
    private static final String FONT42 = "_42";
    private static final String FONT46 = "_46";
    private static final String FONT52 = "_52";
    private String KEY_FONT11 = "";
    private String KEY_FONT14 = "";
    private String KEY_FONT18 = "";
    private String KEY_FONT22 = "";
    private String KEY_FONT24 = "";
    private String KEY_FONT28 = "";
    private String KEY_FONT35 = "";
    private String KEY_FONT42 = "";
    private String KEY_FONT46 = "";
    private final String KEY_FONT_NimbusSanTOT_16 = "NimbusSanTOT_16";
    private Font _font11 = null;
    private Font _font14 = null;
    private Font _font18 = null;
    private Font _font22 = null;
    private Font _font24 = null;
    private Font _font28 = null;
    private Font _font35 = null;
    private Font _font42 = null;
    private Font _font46 = null;
    private GSkillsResourceManager _resourceManager = GSkillsResourceManager.getInstance();
    private static final GSkillsFontsStyleFactory INSTANCE = new GSkillsFontsStyleFactory();
    private HashMap<Integer, String> _fontMap = null;

    public static GSkillsFontsStyleFactory getInstance() {
        return INSTANCE;
    }

    private GSkillsFontsStyleFactory() {
        this.setDefaultFont();
        this.initializeFonts();
        this.initFontMap();
        GSkillsAlignmentFactory.getInstance().setGSkillsAlignmentProperties();
    }

    private void initializeFonts() {
        this.KEY_FONT11 = this._defaultFont + FONT11;
        this.KEY_FONT14 = this._defaultFont + FONT14;
        this.KEY_FONT18 = this._defaultFont + FONT18;
        this.KEY_FONT22 = this._defaultFont + FONT22;
        this.KEY_FONT24 = this._defaultFont + FONT24;
        this.KEY_FONT28 = this._defaultFont + FONT28;
        this.KEY_FONT35 = this._defaultFont + FONT35;
        this.KEY_FONT42 = this._defaultFont + FONT42;
        this.KEY_FONT46 = this._defaultFont + FONT46;
    }

    private void initFontMap() {
        this._fontMap = new HashMap();
        this._fontMap.put(2, "Avenir_18");
        this._fontMap.put(3, "Avenir_14");
        this._fontMap.put(9, "Avenir_22");
        VehicleLineEnum vehicleLine = GSkillsStateManager.getInstance().getVehicleLine();
        VehicleTrimEnum vehicleTrim = GSkillsStateManager.getInstance().getVehicleTrim();
        if (VehicleTrimEnum.RT == vehicleTrim) {
            if (VehicleLineEnum.LA == vehicleLine) {
                this._fontMap.put(4, "NesobriteBold_28");
                this._fontMap.put(5, "NesobriteBold_14");
                this._fontMap.put(8, "NesobriteBold_52");
                this._fontMap.put(7, "Avenir_14");
            } else {
                this._fontMap.put(4, "Avenir_22");
                this._fontMap.put(5, "Avenir_11");
                this._fontMap.put(7, "Avenir_14");
                if (VehicleLineEnum.LD == vehicleLine) {
                    this._fontMap.put(8, "Avenir_35");
                } else if (VehicleLineEnum.LX == vehicleLine) {
                    this._fontMap.put(8, "Avenir_46");
                }
            }
        } else if (VehicleLineEnum.LX == vehicleLine) {
            this._fontMap.put(4, "Avenir_22");
            this._fontMap.put(5, "Avenir_11");
            this._fontMap.put(8, "Serpentine_46");
            this._fontMap.put(7, "Serpentine_14");
        } else if (VehicleLineEnum.WK == vehicleLine) {
            this._fontMap.put(4, "Avenir_22");
            this._fontMap.put(5, "Avenir_16");
            this._fontMap.put(8, "Serpentine_35");
            this._fontMap.put(7, "Serpentine_14");
        } else {
            this._fontMap.put(4, "Serpentine_22");
            this._fontMap.put(5, "Serpentine_11");
            this._fontMap.put(8, "Serpentine_46");
            this._fontMap.put(7, "Serpentine_14");
        }
    }

    public Font getFontSize11() {
        if (this._font11 == null) {
            this._font11 = this._resourceManager.getFontByKey(this.KEY_FONT11);
        }
        return this._font11;
    }

    public Font getFontSize14() {
        if (this._font14 == null) {
            this._font14 = this._resourceManager.getFontByKey(this.KEY_FONT14);
        }
        return this._font14;
    }

    public Font getFontSize18() {
        if (this._font18 == null) {
            this._font18 = this._resourceManager.getFontByKey(this.KEY_FONT18);
        }
        return this._font18;
    }

    public Font getFontSize22() {
        if (this._font22 == null) {
            this._font22 = this._resourceManager.getFontByKey(this.KEY_FONT22);
        }
        return this._font22;
    }

    public Font getFontSize24() {
        if (this._font24 == null) {
            this._font24 = this._resourceManager.getFontByKey(this.KEY_FONT24);
        }
        return this._font24;
    }

    public Font getFontSize28() {
        if (this._font28 == null) {
            this._font28 = this._resourceManager.getFontByKey(this.KEY_FONT28);
        }
        return this._font28;
    }

    public Font getFontSize35() {
        if (this._font35 == null) {
            this._font35 = this._resourceManager.getFontByKey(this.KEY_FONT35);
        }
        return this._font35;
    }

    public Font getFontSize42() {
        if (this._font42 == null) {
            this._font42 = this._resourceManager.getFontByKey(this.KEY_FONT42);
        }
        return this._font42;
    }

    public Font getFontSize46() {
        if (this._font46 == null) {
            this._font46 = this._resourceManager.getFontByKey(this.KEY_FONT46);
        }
        return this._font46;
    }

    public Font getNimbusSanTOTFontWithSize16() {
        return this._resourceManager.getFontByKey("NimbusSanTOT_16");
    }

    public Font getFont(int fontConstant) {
        String fontName = this._fontMap.get(fontConstant);
        return this.getFontByName(fontName);
    }

    public Font getFontByName(String fontName) {
        return this._resourceManager.getFontByKey(fontName);
    }

    public String getDefaultFont() {
        return this._defaultFont;
    }

    private void setDefaultFont() {
        VehicleTrimEnum vehTrim = GSkillsStateManager.getInstance().getVehicleTrim();
        this._defaultFont = VehicleTrimEnum.RT == vehTrim ? "Avenir" : "Serpentine";
    }
}

