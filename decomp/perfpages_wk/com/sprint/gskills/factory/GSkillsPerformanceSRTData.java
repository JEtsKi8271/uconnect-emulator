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
    private double _60ftPlaceValue = 5.11;
    private int _attribute;
    private static ArrayList<Integer> _hundredthsPlaceTimeAttributes = new ArrayList();
    private static ArrayList<Integer> _60ftTimeAttributes = new ArrayList();

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
        } else if (_60ftTimeAttributes.contains(attribute)) {
            this._60ftPlaceValue = doubleValue / 10.0;
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
        if (_60ftTimeAttributes.contains(this._attribute)) {
            return this._60ftPlaceValue;
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
        _60ftTimeAttributes.add(64);
        _60ftTimeAttributes.add(63);
        _60ftTimeAttributes.add(65);
        _60ftTimeAttributes.add(61);
        _60ftTimeAttributes.add(60);
        _60ftTimeAttributes.add(62);
    }
}

