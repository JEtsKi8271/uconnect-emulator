/*
 * Decompiled with CFR 0.152.
 */
package com.airbiquity.sdp.common.util;

import com.airbiquity.sdp.common.util.IntegerRange;
import java.util.HashSet;

public class EncodableString {
    private static final char SUBSTITUTE_CHAR = '?';
    private static HashSet SET_OF_LEGALS = new HashSet();
    private static final IntegerRange SPACE = new IntegerRange(32, 33);
    private static final IntegerRange PUNCTUATION1 = new IntegerRange(39, 42);
    private static final IntegerRange PUNCTUATION2 = new IntegerRange(43, 48);
    private static final IntegerRange DIGITS = new IntegerRange(48, 58);
    private static final IntegerRange COLON = new IntegerRange(58, 59);
    private static final IntegerRange EQUALS = new IntegerRange(61, 62);
    private static final IntegerRange QUESTIONMARK = new IntegerRange(63, 64);
    private static final IntegerRange LETTERS_CAP = new IntegerRange(65, 91);
    private static final IntegerRange LETTERS_SMALL = new IntegerRange(97, 123);
    private static final IntegerRange[] allRanges = new IntegerRange[]{SPACE, PUNCTUATION1, PUNCTUATION2, DIGITS, COLON, EQUALS, QUESTIONMARK, LETTERS_CAP, LETTERS_SMALL};

    private static void initSet() {
        for (int r2 = 0; r2 < allRanges.length; ++r2) {
            IntegerRange oneRange = allRanges[r2];
            for (int i2 = oneRange.getLow(); i2 < oneRange.getHigh(); ++i2) {
                SET_OF_LEGALS.add(i2);
            }
        }
    }

    public static String process(String in) {
        char[] inArray = in.toCharArray();
        for (int i2 = 0; i2 < inArray.length; ++i2) {
            char charint = inArray[i2];
            if (EncodableString.isLegal(charint)) continue;
            inArray[i2] = 63;
        }
        return new String(inArray);
    }

    public static boolean isLegal(int inChar) {
        return SET_OF_LEGALS.contains(inChar);
    }

    static {
        EncodableString.initSet();
    }
}

