/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.beep.BeepException
 *  kona.beep.BeepManager
 *  kona.platform.PlatformInfo
 *  konax.rms.RecordStore
 *  konax.rms.RecordStoreException
 *  konax.rms.RecordStoreFullException
 *  konax.rms.RecordStoreNotFoundException
 *  konax.rms.RecordStoreNotOpenException
 */
package com.sprint.gskills.util;

import kona.beep.BeepException;
import kona.beep.BeepManager;
import kona.platform.PlatformInfo;
import konax.rms.RecordStore;
import konax.rms.RecordStoreException;
import konax.rms.RecordStoreFullException;
import konax.rms.RecordStoreNotFoundException;
import konax.rms.RecordStoreNotOpenException;

public final class CommonUtils {
    private int _homeBackGroundImageInRMS = 1;
    private static final CommonUtils INSTANCE = new CommonUtils();

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
            catch (RecordStoreFullException e2) {
                e2.printStackTrace();
            }
            catch (RecordStoreNotFoundException e3) {
                e3.printStackTrace();
            }
            catch (RecordStoreException e4) {
                e4.printStackTrace();
            }
            finally {
                try {
                    if (null != recordstore) {
                        recordstore.closeRecordStore();
                    }
                }
                catch (RecordStoreNotOpenException e5) {
                    e5.printStackTrace();
                }
                catch (RecordStoreException e6) {
                    e6.printStackTrace();
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
        catch (RecordStoreFullException e2) {
            e2.printStackTrace();
        }
        catch (RecordStoreNotFoundException e3) {
            e3.printStackTrace();
        }
        catch (RecordStoreException e4) {
            e4.printStackTrace();
        }
        finally {
            try {
                if (null != recordstore) {
                    recordstore.closeRecordStore();
                }
            }
            catch (RecordStoreNotOpenException e5) {
                e5.printStackTrace();
            }
            catch (RecordStoreException e6) {
                e6.printStackTrace();
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
            catch (BeepException e2) {
                e2.printStackTrace();
            }
        }
    }

    public static boolean compareDbl(double val1, double val2) {
        return Math.abs(val1 - val2) > 1.0E-5;
    }
}

