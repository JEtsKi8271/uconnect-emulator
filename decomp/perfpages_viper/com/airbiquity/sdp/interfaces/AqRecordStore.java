/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.rms.InvalidRecordIDException
 *  konax.rms.RecordComparator
 *  konax.rms.RecordEnumeration
 *  konax.rms.RecordFilter
 *  konax.rms.RecordStoreException
 *  konax.rms.RecordStoreFullException
 *  konax.rms.RecordStoreNotFoundException
 *  konax.rms.RecordStoreNotOpenException
 */
package com.airbiquity.sdp.interfaces;

import konax.rms.InvalidRecordIDException;
import konax.rms.RecordComparator;
import konax.rms.RecordEnumeration;
import konax.rms.RecordFilter;
import konax.rms.RecordStoreException;
import konax.rms.RecordStoreFullException;
import konax.rms.RecordStoreNotFoundException;
import konax.rms.RecordStoreNotOpenException;

public interface AqRecordStore {
    public void openRecordStore(boolean var1) throws RecordStoreNotFoundException, RecordStoreException, RecordStoreFullException;

    public int addRecord(byte[] var1, int var2, int var3) throws RecordStoreNotOpenException, RecordStoreException, RecordStoreFullException;

    public void closeRecordStore() throws RecordStoreNotOpenException, RecordStoreException;

    public void deleteRecordStore(String var1) throws RecordStoreException;

    public byte[] getRecord(int var1) throws RecordStoreNotOpenException, InvalidRecordIDException, RecordStoreException;

    public int getNumRecords() throws RecordStoreNotOpenException;

    public int getSize() throws RecordStoreException;

    public int getSizeAvailable() throws RecordStoreNotOpenException;

    public void deleteRecord(int var1) throws RecordStoreNotOpenException, InvalidRecordIDException, RecordStoreException;

    public int getRecordSize(int var1) throws RecordStoreNotOpenException, InvalidRecordIDException, RecordStoreException;

    public RecordEnumeration enumerateRecords(RecordFilter var1, RecordComparator var2, boolean var3) throws RecordStoreNotOpenException;

    public String[] listRecordSores();

    public void setRecord(int var1, byte[] var2, int var3, int var4) throws RecordStoreNotOpenException, InvalidRecordIDException, RecordStoreException, RecordStoreFullException;
}

