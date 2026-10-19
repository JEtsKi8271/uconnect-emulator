/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.rms.RecordStore
 *  konax.rms.RecordStoreException
 *  konax.rms.RecordStoreFullException
 *  konax.rms.RecordStoreNotFoundException
 *  konax.rms.RecordStoreNotOpenException
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.util;

import konax.rms.RecordStore;
import konax.rms.RecordStoreException;
import konax.rms.RecordStoreFullException;
import konax.rms.RecordStoreNotFoundException;
import konax.rms.RecordStoreNotOpenException;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class CommonUtils {
    private Logger logger = LoggerFactory.getLogger(CommonUtils.class);
    private int homeBackGroundImageInRMS = 1;
    private int carThemeInRMS = 0;
    private static final CommonUtils INSTANCE = new CommonUtils();

    private CommonUtils() {
    }

    public static CommonUtils getInstance() {
        return INSTANCE;
    }

    public int getHomeBackGroundImageInRMS() {
        return this.homeBackGroundImageInRMS;
    }

    public int getCarThemeInRMS() {
        return this.carThemeInRMS;
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void saveCarThemeSettingToRms(int carThemeIndex) {
        if (this.carThemeInRMS != carThemeIndex) {
            RecordStore recordstore = null;
            try {
                recordstore = RecordStore.openRecordStore((String)"GSkillsCarThemeColor", (boolean)true);
                if (recordstore.getNumRecords() > 0) {
                    this.carThemeInRMS = carThemeIndex;
                    recordstore.setRecord(recordstore.getNextRecordID() - 1, Integer.toString(carThemeIndex).getBytes(), 0, Integer.toString(carThemeIndex).length());
                    this.logger.error((Object)("***VPS*** - Saving car theme in RMS with value " + this.carThemeInRMS));
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

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    public void saveHomeImageToRms(int homeImageIndex) {
        if (this.homeBackGroundImageInRMS != homeImageIndex) {
            RecordStore recordstore = null;
            try {
                recordstore = RecordStore.openRecordStore((String)"GSkillsHomePageImage", (boolean)true);
                if (recordstore.getNumRecords() > 0) {
                    this.homeBackGroundImageInRMS = homeImageIndex;
                    recordstore.setRecord(recordstore.getNextRecordID() - 1, Integer.toString(homeImageIndex).getBytes(), 0, Integer.toString(homeImageIndex).length());
                    this.logger.error((Object)("***VPS*** - Saving home page image in RMS with value " + this.homeBackGroundImageInRMS));
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

    public void readHomePageImageFromRMS() {
        RecordStore recordstore = null;
        try {
            recordstore = RecordStore.openRecordStore((String)"GSkillsHomePageImage", (boolean)true);
            if (recordstore.getNumRecords() > 0) {
                this.homeBackGroundImageInRMS = Integer.parseInt(new String(recordstore.getRecord(recordstore.getNextRecordID() - 1)));
                this.logger.error((Object)("***VPS*** - readHomePageImageFromRMS() - Home page image value in RMS is " + this.homeBackGroundImageInRMS));
            } else {
                String strDefaultHomePageImageIndex = Integer.toString(this.homeBackGroundImageInRMS);
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

    public void readCarThemeFromRMS() {
        RecordStore recordstore = null;
        try {
            recordstore = RecordStore.openRecordStore((String)"GSkillsCarThemeColor", (boolean)true);
            if (recordstore.getNumRecords() > 0) {
                this.carThemeInRMS = Integer.parseInt(new String(recordstore.getRecord(recordstore.getNextRecordID() - 1)));
                this.logger.error((Object)("***VPS*** - readCarThemeFromRMS() - Car theme value in RMS is " + this.carThemeInRMS));
            } else {
                String strDefaultHomePageImageIndex = Integer.toString(this.carThemeInRMS);
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
        catch (Exception e5) {
            e5.printStackTrace();
        }
        finally {
            try {
                if (null != recordstore) {
                    recordstore.closeRecordStore();
                }
            }
            catch (RecordStoreNotOpenException e6) {
                e6.printStackTrace();
            }
            catch (RecordStoreException e7) {
                e7.printStackTrace();
            }
            catch (Exception e8) {
                e8.printStackTrace();
            }
        }
    }
}

