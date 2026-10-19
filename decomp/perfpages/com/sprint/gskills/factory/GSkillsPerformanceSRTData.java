/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.performancesrt.PerformanceSRTData
 */
package com.sprint.gskills.factory;

import java.io.Serializable;
import java.util.ArrayList;
import kona.performancesrt.PerformanceSRTData;

public class GSkillsPerformanceSRTData
implements PerformanceSRTData,
Serializable {
    private static final long serialVersionUID = 1L;
    private int _dataType;
    private int _intValue = 255;
    private double _doubleValue = 25.5;
    private double _hundrendthsPlaceValue = 2.55;
    private int _attribute;
    private static ArrayList<Integer> _hundredthsPlaceTimeAttributes = new ArrayList();

    private GSkillsPerformanceSRTData(int attribute, int intValue) {
        this._dataType = 0;
        this._intValue = intValue;
        this._attribute = attribute;
    }

    private GSkillsPerformanceSRTData(int attribute, double doubleValue) {
        this._dataType = 1;
        this._attribute = attribute;
        if (_hundredthsPlaceTimeAttributes.contains(attribute)) {
            this._hundrendthsPlaceValue = doubleValue;
        } else {
            this._doubleValue = doubleValue;
        }
    }

    public static GSkillsPerformanceSRTData createGSkillsPerformanceSRTData(int attribute, double doubleValue) {
        return new GSkillsPerformanceSRTData(attribute, doubleValue);
    }

    public static GSkillsPerformanceSRTData createGSkillsPerformanceSRTData(int attribute, int intValue) {
        return new GSkillsPerformanceSRTData(attribute, intValue);
    }

    private GSkillsPerformanceSRTData(int attribute) {
        this._attribute = attribute;
    }

    public static GSkillsPerformanceSRTData getDefaultPerformanceSRTData(int attribute) {
        return new GSkillsPerformanceSRTData(attribute);
    }

    public int getAttribute() {
        return this._attribute;
    }

    public int getDataType() {
        return this._dataType;
    }

    public double getDoubleValue() {
        if (_hundredthsPlaceTimeAttributes.contains(this._attribute)) {
            return this._hundrendthsPlaceValue;
        }
        return this._doubleValue;
    }

    public int getIntValue() {
        return this._intValue;
    }

    static {
        _hundredthsPlaceTimeAttributes.add(52);
        _hundredthsPlaceTimeAttributes.add(50);
        _hundredthsPlaceTimeAttributes.add(54);
        _hundredthsPlaceTimeAttributes.add(46);
        _hundredthsPlaceTimeAttributes.add(44);
        _hundredthsPlaceTimeAttributes.add(48);
        _hundredthsPlaceTimeAttributes.add(64);
        _hundredthsPlaceTimeAttributes.add(63);
        _hundredthsPlaceTimeAttributes.add(65);
        _hundredthsPlaceTimeAttributes.add(61);
        _hundredthsPlaceTimeAttributes.add(60);
        _hundredthsPlaceTimeAttributes.add(62);
    }
}

