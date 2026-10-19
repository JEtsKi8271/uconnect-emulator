/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.impl;

import java.util.HashMap;

public class LanguageEnum {
    private static HashMap OBJ_TO_STR = new HashMap();
    private static HashMap OBJ_TO_INT = new HashMap();
    public static final LanguageEnum GERMAN_0 = new LanguageEnum("de_DE", 0);
    public static final LanguageEnum US_ENGLISH_1 = new LanguageEnum("en_US", 1);
    public static final LanguageEnum FRENCH_CA_2 = new LanguageEnum("fr_CA", 2);
    public static final LanguageEnum FRENCH_3 = new LanguageEnum("fr_FR", 3);
    public static final LanguageEnum ITALIAN_4 = new LanguageEnum("it_IT", 4);
    public static final LanguageEnum SPANISH_NA_5 = new LanguageEnum("es_MX", 5);
    public static final LanguageEnum SPANISH_6 = new LanguageEnum("es_ES", 6);
    public static final LanguageEnum JAPANESE_7 = new LanguageEnum("ja_JP", 7);
    public static final LanguageEnum PORTUGUESE_8 = new LanguageEnum("pt_PT", 8);
    public static final LanguageEnum DUTCH_9 = new LanguageEnum("nl_NL", 9);
    public static final LanguageEnum UK_ENGLISH_10 = new LanguageEnum("en_GB", 10);
    public static final LanguageEnum MANDARIN_11 = new LanguageEnum("zh_CN", 11);
    public static final LanguageEnum RUSSIAN_12 = new LanguageEnum("ru_RU", 12);
    public static final LanguageEnum KOREAN_13 = new LanguageEnum("ko_KR", 13);
    public static final LanguageEnum BRASILIAN_14 = new LanguageEnum("pt_BR", 14);
    public static final LanguageEnum POLISH_15 = new LanguageEnum("pl_PL", 15);
    public static final LanguageEnum TURKISH_16 = new LanguageEnum("tr_TR", 16);
    public static final LanguageEnum ARABIC_17 = new LanguageEnum("ar_AE", 17);
    public static final LanguageEnum HINDI_18 = new LanguageEnum("hi_IN", 18);
    private String harmanString;
    private int wCarInt;

    private LanguageEnum(String harmanString, int wCarInt) {
        this.harmanString = harmanString;
        this.wCarInt = wCarInt;
        OBJ_TO_STR.put(harmanString, this);
        OBJ_TO_INT.put(wCarInt, this);
    }

    public int getInt() {
        return this.wCarInt;
    }

    public String getString() {
        return this.harmanString;
    }

    public String toString() {
        return this.harmanString + " " + this.wCarInt;
    }

    public static LanguageEnum getForInt(int intValue) {
        return (LanguageEnum)OBJ_TO_INT.get(intValue);
    }

    public static LanguageEnum getForString(String strValue) {
        return (LanguageEnum)OBJ_TO_STR.get(strValue);
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof LanguageEnum)) {
            return false;
        }
        LanguageEnum leObj = (LanguageEnum)obj;
        return this.wCarInt == leObj.getInt() && this.harmanString.equals(leObj.getString());
    }

    public int hashCode() {
        return this.harmanString.hashCode() * 13 + this.wCarInt * 101;
    }
}

