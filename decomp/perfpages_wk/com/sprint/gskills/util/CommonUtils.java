/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.beep.BeepManager
 *  kona.platform.PlatformInfo
 *  konax.rms.RecordStore
 *  konax.sensors.Data
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.util;

import com.sprint.gskills.constants.SensorConnectionEnum;
import kona.beep.BeepManager;
import kona.platform.PlatformInfo;
import konax.rms.RecordStore;
import konax.sensors.Data;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public final class CommonUtils {
    private int _homeBackGroundImageInRMS = 1;
    public static final int INVALID_INT_VAL = -111111;
    public static final double INVALID_DBL_VAL = -111111.111111;
    private static final CommonUtils INSTANCE = new CommonUtils();
    private static Logger _logger = LoggerFactory.getLogger((String)CommonUtils.class.getName());

    public static CommonUtils getInstance() {
        return INSTANCE;
    }

    private CommonUtils() {
        this.init();
    }

    public int getHomeBackGroundImageInRMS() {
        return this._homeBackGroundImageInRMS;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void saveHomeImageToRms(int homeImageIndex) {
        if (this._homeBackGroundImageInRMS != homeImageIndex) {
            RecordStore recordstore = null;
            try {
                recordstore = RecordStore.openRecordStore((String)"GSkillsHomePageImage", (boolean)true);
                if (recordstore.getNumRecords() > 0) {
                    this._homeBackGroundImageInRMS = homeImageIndex;
                    recordstore.setRecord(recordstore.getNextRecordID() - 1, Integer.toString(homeImageIndex).getBytes(), 0, Integer.toString(homeImageIndex).length());
                }
            }
            catch (Exception e2) {
                e2.printStackTrace();
            }
            finally {
                try {
                    if (null != recordstore) {
                        recordstore.closeRecordStore();
                    }
                }
                catch (Exception e3) {
                    e3.printStackTrace();
                }
            }
        }
    }

    private void readHomePageImageFromRMS() {
        RecordStore recordstore = null;
        try {
            recordstore = RecordStore.openRecordStore((String)"GSkillsHomePageImage", (boolean)true);
            if (recordstore.getNumRecords() > 0) {
                this._homeBackGroundImageInRMS = Integer.parseInt(new String(recordstore.getRecord(recordstore.getNextRecordID() - 1)));
            } else {
                String strDefaultHomePageImageIndex = Integer.toString(this._homeBackGroundImageInRMS);
                recordstore.addRecord(strDefaultHomePageImageIndex.getBytes(), 0, strDefaultHomePageImageIndex.length());
            }
        }
        catch (Exception e2) {
            e2.printStackTrace();
        }
        finally {
            try {
                if (null != recordstore) {
                    recordstore.closeRecordStore();
                }
            }
            catch (Exception e3) {
                e3.printStackTrace();
            }
        }
    }

    private void init() {
        this.readHomePageImageFromRMS();
    }

    public void beepOnClick() {
        if (!PlatformInfo.isRunningInEmulator()) {
            try {
                BeepManager.getBeep().requestBeep("CONF_1");
            }
            catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }

    public static boolean compareDbl(double val1, double val2) {
        return Math.abs(val1 - val2) > 1.0E-5;
    }

    public static int getSensorIntValue(SensorConnectionEnum sensorEnum) {
        int sensorValue = -111111;
        try {
            SensorConnection sensorConnection = sensorEnum.getSensorConnection();
            Data[] data = sensorConnection.getData(1);
            if (data != null) {
                sensorValue = data[0].getIntValues()[0];
                _logger.debug((Object)(sensorEnum.toString() + ":" + sensorValue));
            }
            sensorEnum.closeSensorConnection();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return sensorValue;
    }

    public static double getSensorDblValue(SensorConnectionEnum sensorEnum) {
        double sensorValue = -111111.111111;
        try {
            SensorConnection sensorConnection = sensorEnum.getSensorConnection();
            Data[] data = sensorConnection.getData(1);
            if (data != null) {
                sensorValue = data[0].getDoubleValues()[0];
                _logger.debug((Object)(sensorEnum.toString() + ":" + sensorValue));
            }
            sensorEnum.closeSensorConnection();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return sensorValue;
    }
}

