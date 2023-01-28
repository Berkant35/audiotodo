package com.uniqueid.kumas_topu_v2;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.AsyncTask;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

import com.uniqueid.kumas_topu_v2.enums.ReaderModes;
import com.uniqueid.kumas_topu_v2.enums.TriggerModes;
import com.uniqueid.kumas_topu_v2.enums.WriteErrors;
import com.zebra.rfid.api3.*;
import com.zebra.rfid.api3.ACCESS_OPERATION_CODE;
import com.zebra.rfid.api3.ACCESS_OPERATION_STATUS;
import com.zebra.rfid.api3.Antennas;
import com.zebra.rfid.api3.ENUM_TRIGGER_MODE;
import com.zebra.rfid.api3.INVENTORY_STATE;
import com.zebra.rfid.api3.InvalidUsageException;
import com.zebra.rfid.api3.OperationFailureException;
import com.zebra.rfid.api3.RFIDReader;
import com.zebra.rfid.api3.ReaderDevice;
import com.zebra.rfid.api3.Readers;
import com.zebra.rfid.api3.RfidEventsListener;
import com.zebra.rfid.api3.RfidReadEvents;
import com.zebra.rfid.api3.RfidStatusEvents;
import com.zebra.rfid.api3.SESSION;
import com.zebra.rfid.api3.SL_FLAG;
import com.zebra.rfid.api3.START_TRIGGER_TYPE;
import com.zebra.rfid.api3.STOP_TRIGGER_TYPE;
import com.zebra.rfid.api3.TagData;
import com.zebra.rfid.api3.TriggerInfo;

import java.util.ArrayList;
import java.util.HashSet;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class ZebraReaderSDK implements Readers.RFIDReaderEventHandler {

    private static final String TAG = "ZebraReaderSDK";

    private static Readers readers;

    //Gönderme işlemi yaparken unique değerler gönder

    static ArrayList<String> tempTags = new ArrayList<String>();


    private static TagData[] myTags = new TagData[]{};

    private static ReaderDevice readerDevice;

    private static RFIDReader reader;

    private static MethodChannel.Result mainMethodChannelResult;

    private static EventChannel.EventSink mainEventChannelSink;

    public static MainActivity context;

    private int MAX_POWER = 270;

    private EventHandler eventHandler;


    private static ArrayList<ReaderDevice> availableRFIDReaderList;


    public void onCreate(MainActivity activity) {
        Log.i(TAG, "onCreate: Zebra SDK initializing...");
        context = activity;
        InitSDK();
    }


    @Override
    public void RFIDReaderAppeared(ReaderDevice readerDevice) {

    }

    @Override
    public void RFIDReaderDisappeared(ReaderDevice readerDevice) {

    }


    private void InitSDK() {

        if (readers == null) {
            new CreateInstanceTask().execute();
        }
    }


    private class CreateInstanceTask extends AsyncTask<Void, Void, Void> {
        @Override
        protected Void doInBackground(Void... voids) {
            Log.d("ZebraMain", "CreateInstanceTask");
            // Based on support available on host device choose the reader type
            InvalidUsageException invalidUsageException = null;
            readers = new Readers(context, ENUM_TRANSPORT.SERVICE_SERIAL);
            try {
                availableRFIDReaderList = readers.GetAvailableRFIDReaderList();

            } catch (InvalidUsageException e) {
                e.printStackTrace();
            }
            if (invalidUsageException != null) {
                readers.Dispose();
                readers = null;
                if (readers == null) {
                    readers = new Readers(context, ENUM_TRANSPORT.BLUETOOTH);
                }
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            new ConnectionTask().execute();

        }
    }

    @SuppressLint("StaticFieldLeak")
    private class ConnectionTask extends AsyncTask<Void, Void, String> {
        @Override
        protected String doInBackground(Void... voids) {

            GetAvailableReader();
            if (reader != null)

                return connect();
            return "Failed to find or connect reader";
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

        }
    }

    public void initializeChannelsMethodForFlutter(MethodChannel.Result methodChannelResult) {

        mainMethodChannelResult = methodChannelResult;
    }

    public void initializeChannelsSinkForFlutter(EventChannel.EventSink eventChannelSink) {

        mainEventChannelSink = eventChannelSink;
    }

    private synchronized void GetAvailableReader() {
        if (readers != null) {
            readers.attach(this);
            try {
                if (readers.GetAvailableRFIDReaderList() != null) {
                    availableRFIDReaderList = readers.GetAvailableRFIDReaderList();
                    if (availableRFIDReaderList.size() != 0) {
                        // if single reader is available then connect it
                        if (availableRFIDReaderList.size() == 1) {
                            readerDevice = availableRFIDReaderList.get(0);

                            reader = readerDevice.getRFIDReader();

                        } else {
                            // search reader specified by name
                            for (ReaderDevice device : availableRFIDReaderList) {

                                if (device.getName().equals(Build.MODEL) || device.getName().equals(Build.BRAND)) {
                                    readerDevice = device;
                                    reader = readerDevice.getRFIDReader();

                                }
                            }
                        }
                    }
                }
            } catch (InvalidUsageException ie) {
                Log.e("ERROR", ie.toString());
            }
        }
    }

    private synchronized String connect() {
        if (reader != null) {

            try {
                if (!reader.isConnected()) {
                    // Establish connection to the RFID Reader
                    reader.connect();
                    ConfigureReader();

                    return "Connected";
                } else {
                    Log.i(TAG, "connect: Reader connected!");
                }
            } catch (InvalidUsageException e) {
                e.printStackTrace();
            } catch (OperationFailureException e) {
                e.printStackTrace();

                String des = e.getResults().toString();
                return "Connection failed" + e.getVendorMessage() + " " + des;
            }

        }
        return "";
    }

    private void ConfigureReader() throws OperationFailureException, InvalidUsageException {
        Log.d("Zebra Main", "ConfigureReader " + reader.getHostName());
        if (reader.isConnected()) {


            TriggerInfo triggerInfo = new TriggerInfo();
            triggerInfo.StartTrigger.setTriggerType(START_TRIGGER_TYPE.START_TRIGGER_TYPE_IMMEDIATE);
            triggerInfo.StopTrigger.setTriggerType(STOP_TRIGGER_TYPE.STOP_TRIGGER_TYPE_IMMEDIATE);
            try {
                // receive events from reader
                if (eventHandler == null)
                    eventHandler = new EventHandler();
                reader.Events.addEventsListener(eventHandler);
                // HH event
                reader.Events.setHandheldEvent(true);
                // tag event with tag data
                reader.Events.setTagReadEvent(true);
                reader.Events.setAttachTagDataWithReadEvent(false);
                // set trigger mode as rfid so scanner beam will not come
                reader.Config.setTriggerMode(ENUM_TRIGGER_MODE.RFID_MODE, true);
                // set start and stop triggers
                reader.Config.setStartTrigger(triggerInfo.StartTrigger);
                reader.Config.setStopTrigger(triggerInfo.StopTrigger);
                // power levels are index based so maximum power supported get the last one
                MAX_POWER = reader.ReaderCapabilities.getTransmitPowerLevelValues().length - 1;
                // set antenna configurations
                Antennas.AntennaRfConfig config = reader.Config.Antennas.getAntennaRfConfig(1);
                config.setTransmitPowerIndex(MAX_POWER);
                config.setrfModeTableIndex(0);
                config.setTari(0);
                reader.Config.Antennas.setAntennaRfConfig(1, config);
                // Set the singulation control
                Antennas.SingulationControl s1_singulationControl = reader.Config.Antennas.getSingulationControl(1);
                s1_singulationControl.setSession(SESSION.SESSION_S0);
                s1_singulationControl.Action.setInventoryState(INVENTORY_STATE.INVENTORY_STATE_A);
                s1_singulationControl.Action.setSLFlag(SL_FLAG.SL_ALL);
                reader.Config.Antennas.setSingulationControl(1, s1_singulationControl);
                // delete any prefilters
                reader.Actions.PreFilters.deleteAll();

                Antennas.Config config1 = reader.Config.Antennas.getAntennaConfig(1);


                Log.i(TAG, "writeData(CurrentPower):" + config1.getTransmitPowerIndex());

                //
            } catch (InvalidUsageException | OperationFailureException e) {
                e.printStackTrace();
            }
        } else {
            Log.e(TAG, "ConfigureReader: READER_NULL");
        }
    }


    public static class EventHandler implements RfidEventsListener {


        // Read Event Notification
        public void eventReadNotify(RfidReadEvents e) {
            // Recommended to use new method getReadTagsEx for better performance in case of large tag population


            myTags = reader.Actions.getReadTags(100);

            if (myTags != null) {
                for (TagData tag : myTags) {
                    Log.d("ZEBRA_MAIN", "Tag ID " + tag.getTagID());
                    for (TagData myTag : myTags) {

                        String perTag = myTag.getTagID();

                        if (!tempTags.contains(perTag)) {
                            tempTags.add(perTag);
                            if (context.allAttributeMode.currentReadMode == ReaderModes.INVENTORY_MODE
                                    &&
                                    context.currentInventoryEventSink != null
                            ) {
                                context.currentInventoryEventSink.success(perTag);
                            }
                        }
                    }

                    if (tag.getOpCode() == ACCESS_OPERATION_CODE.ACCESS_OPERATION_READ &&
                            tag.getOpStatus() == ACCESS_OPERATION_STATUS.ACCESS_SUCCESS) {
                        if (tag.getMemoryBankData().length() > 0) {
                            Log.d("ZEBRA_MAIN", " Mem Bank Data " + tag.getMemoryBankData());
                        }
                    }
                    if (tag.isContainsLocationInfo()) {
                        short dist = tag.LocationInfo.getRelativeDistance();
                        Log.d("ZEBRA_MAIN", "Tag relative distance " + dist);
                    }
                }
            }
        }

        @Override
        public void eventStatusNotify(RfidStatusEvents rfidStatusEvents) {
            Log.i("EVENT_NOTIFY", rfidStatusEvents.StatusEventData.getStatusEventType().toString());
            Log.i("EVENT_NOTIFY2", rfidStatusEvents.StatusEventData.BatchModeEventData.get_BatchMode().toString());
        }
    }

    //"Synchronized metot, sadece bir iş parçacığı tarafından kullanılabilecek bir metottur.
    // Diğer iş parçacıkları metot serbest bırakılana kadar bekleyecektir. Metodu senkronize
    // olarak tanımlamak için ciddi nedenlerin olması gerekir çünkü bu tür metot üretkenliği
    // azaltır. Senkronized metot kullanımının klasik örneği, birden fazla iş parçacığının aynı
    // kaynakları kullanmasıdır. Örneğin, bazı nesnenin durumunu değiştirmek ve sadece bir iş
    // parçacığının bunu yapmasının garanti edilmesi gerektiği durumlar. Aynı zamanda,
    // senkronized metodu mümkün olan en küçük boyuta indirmek önemlidir, ideal olarak
    // sadece ortak kaynakları manipüle edebilecek işlemleri içermelidir."


    synchronized public void initializeInventory(EventChannel.EventSink eventSink)
    {
        Antennas.AntennaRfConfig antennaRfConfig = null;
        try {
            antennaRfConfig = reader.Config.Antennas.getAntennaRfConfig(1);
        } catch (InvalidUsageException | OperationFailureException e) {
            e.printStackTrace();
        }
        assert antennaRfConfig != null;
        antennaRfConfig.setrfModeTableIndex(0);
        antennaRfConfig.setTari(0);
        antennaRfConfig.setTransmitPowerIndex(300);
        mainEventChannelSink = eventSink;
        tempTags.clear();
    }


    synchronized public void performInventory() {
        // check reader connection
        if (!isReaderConnected())
            return;
        Log.i("READER_CONNECT_CHECK", "connected!");
        try {
            reader.Actions.Inventory.perform();
        } catch (InvalidUsageException | OperationFailureException e) {
            e.printStackTrace();
        }
    }

    synchronized public void writeData(String epc) {
        if (!isReaderConnected()) {
            Log.e(TAG, "writeData: Reader Not Connected!");
            return;
        }
        try {
            tempTags.clear();
            Antennas.AntennaRfConfig antennaRfConfig = reader.Config.Antennas.getAntennaRfConfig(1);
            antennaRfConfig.setrfModeTableIndex(0);
            antennaRfConfig.setTari(0);
            antennaRfConfig.setTransmitPowerIndex(50);
            // set the configuration



            reader.Config.Antennas.setAntennaRfConfig(1,antennaRfConfig);

            Log.i(TAG, "writeData PRE INVENTORY:"+reader.Config.Antennas.getAntennaConfig(1)
                    .getTransmitPowerIndex());;


            reader.Actions.Inventory.perform();

            Thread.sleep(2000);

            reader.Actions.Inventory.stop();

            antennaRfConfig.setrfModeTableIndex(0);
            antennaRfConfig.setTari(0);
            antennaRfConfig.setTransmitPowerIndex(300);

            reader.Config.Antennas.setAntennaRfConfig(1,antennaRfConfig);

            Log.i(TAG, "writeData AFTER INVENTORY:"+reader.Config.Antennas
                    .getAntennaConfig(1)
                    .getTransmitPowerIndex());;


            if (tempTags.size() == 1) {
                TagAccess tagAccess = new TagAccess();
                TagAccess.WriteAccessParams writeAccessParams = tagAccess.new WriteAccessParams();

                writeAccessParams.setAccessPassword(0);
                writeAccessParams.setMemoryBank(MEMORY_BANK.MEMORY_BANK_EPC);

                writeAccessParams.setOffset(2);


                if (epc != null) {
                    writeAccessParams.setWriteDataLength(Integer.parseInt(String.valueOf(epc.length() / 4)));
                    Log.i(TAG, "setWriteDataLength: " + (epc.length() / 4));
                    writeAccessParams.setWriteData(epc);
                    Log.i(TAG, "epc: " + epc);
                    writeAccessParams.setWriteRetries(3);
                    Log.i(TAG, "Last seen epc:" + tempTags.get(0));

                    reader.Actions.TagAccess.writeWait(tempTags.get(0), writeAccessParams, null, null);

                    MediaPlayer.create(context, R.raw.barcodebeep).start();

                    if (mainMethodChannelResult != null) {
                        mainMethodChannelResult.success(Constants.methodChannelResultOk);
                        mainMethodChannelResult = null;
                    } else if (context.currentEventSink != null) {
                        context.currentEventSink.success(Constants.methodChannelResultOk);
                    } else {
                        if (context.currentResult != null) {
                            context.currentResult.success(Constants.methodChannelResultOk);
                            context.currentResult = null;
                        }
                    }

                } else {
                    if (mainMethodChannelResult != null) {
                        mainMethodChannelResult.success(WriteErrors.SOMETHING_WENT_WRONG.name());
                        mainMethodChannelResult = null;
                    } else if (context.currentEventSink != null) {
                        context.currentEventSink.success(WriteErrors.SOMETHING_WENT_WRONG.name());
                    } else {
                        if (context.currentResult != null) {
                            context.currentResult.success(WriteErrors.SOMETHING_WENT_WRONG.name());
                            context.currentResult = null;
                        }
                    }
                }



                ///???????


            } else if (tempTags.size() == 0) {
                MediaPlayer.create(context, R.raw.serror).start();
                if (mainMethodChannelResult != null) {
                    mainMethodChannelResult.success(WriteErrors.NOT_FOUND_TAG.name());
                    mainMethodChannelResult = null;
                } else if (context.currentEventSink != null) {
                    context.currentEventSink.success(WriteErrors.NOT_FOUND_TAG.name());
                } else {
                    if (context.currentResult != null) {
                        context.currentResult.success(WriteErrors.NOT_FOUND_TAG.name());
                        context.currentResult = null;
                    }
                }
            } else {
                //Error Code 1: 1'den fazla etiket
                MediaPlayer.create(context, R.raw.serror).start();

                if (mainMethodChannelResult != null) {
                    mainMethodChannelResult.success(WriteErrors.TOO_MANY_TAG.name());
                    mainMethodChannelResult = null;
                } else if (context.currentEventSink != null) {
                    context.currentEventSink.success(WriteErrors.TOO_MANY_TAG.name());
                } else {
                    if (context.currentResult != null) {
                        context.currentResult.success(WriteErrors.TOO_MANY_TAG.name());
                        context.currentResult = null;
                    }
                }
            }
        } catch (OperationFailureException | InvalidUsageException | InterruptedException e) {
            e.printStackTrace();
            MediaPlayer.create(context, R.raw.serror).start();
            if (mainMethodChannelResult != null) {
                mainMethodChannelResult.success(WriteErrors.SOMETHING_WENT_WRONG.name());
                mainMethodChannelResult = null;
            } else if (context.currentEventSink != null) {
                context.currentEventSink.success(WriteErrors.SOMETHING_WENT_WRONG.name());
            } else {
                if (context.currentResult != null) {
                    context.currentResult.success(WriteErrors.SOMETHING_WENT_WRONG.name());
                    context.currentResult = null;
                }
            }
        } finally {
            //Yazma işlemi bitti eğer dinliyorsa idle çek onu
            if (context.currentEventSink != null) {
                context.currentEventSink.success(TriggerModes.IDLE.name());
            }
        }
    }


    synchronized public void getBarcodeNumber() {
        if (!isReaderConnected())
            return;
        Log.i("READER_CONNECT_CHECK", "connected!");
        try {
            reader.Config.setLedBlinkEnable(true);
            reader.Config.setTriggerMode(ENUM_TRIGGER_MODE.BARCODE_MODE, true);
        } catch (Exception e) {
            Log.i("BARCODE_MODE", "ERROR");
        }

    }


    public boolean isReaderConnected() {
        if (reader != null && reader.isConnected())
            return true;
        else {
            Log.d("READER_CONNECT_CHECK", "Reader is not connected");
            return false;
        }
    }

    synchronized public void stopInventory() {
        // check reader connection
        if (!isReaderConnected())

            return;
        try {
            reader.Actions.Inventory.stop();
            tempTags.clear();
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        }
    }
}


