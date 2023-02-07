package com.uniqueid.iconnectMobile.RfidReader;

import android.util.Log;

public class RfidReaderFactory {
    private static final String TAG = "RfidReaderFactory";
    public RfidReader getRfidReader(String readerType) throws RfidReaderException{
        if(readerType == null){
            return null;
        }
        /*
        if(readerType.equalsIgnoreCase("IMPINJ")){
            return new com.uniqueid.rfidreader.ImpinjReader();
        }
        if (readerType.equalsIgnoreCase("THINGMAGIC")) {
            return new com.uniqueid.rfidreader.ThingMagicReader();
        }
        if (readerType.equalsIgnoreCase("RRU1861")) {
            return new com.uniqueid.rfidreader.RRU1861Reader();
        }

         */

        if (readerType.equalsIgnoreCase("CHAINWAY")) {
            return new ChainwayReader();
        }
        if (readerType.equalsIgnoreCase("I-READ_4")) {
            return new ChainwayReader();
        }
        Log.i(TAG, "getRfidReader:"+readerType);
        if (readerType.equalsIgnoreCase("TEST")) {
            return new TestReader();
        }


        throw new RfidReaderException("Reader type not exist.");

    }
}
