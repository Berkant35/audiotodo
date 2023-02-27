package com.uniqueid.kumas_topu_v2.chainway;

import android.media.MediaPlayer;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.RequiresApi;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.rscja.barcode.BarcodeDecoder;
import com.rscja.barcode.BarcodeFactory;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.BarcodeEntity;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.interfaces.ConnectionStatus;
import com.uniqueid.kumas_topu_v2.Constants;
import com.uniqueid.kumas_topu_v2.MainActivity;
import com.uniqueid.kumas_topu_v2.R;
import com.uniqueid.kumas_topu_v2.enums.BarcodeModes;
import com.uniqueid.kumas_topu_v2.enums.RFIDModes;
import com.uniqueid.kumas_topu_v2.enums.ReaderModes;
import com.uniqueid.kumas_topu_v2.enums.TriggerModes;
import com.uniqueid.kumas_topu_v2.enums.WriteErrors;
import com.zebra.rfid.api3.Antennas;
import com.zebra.rfid.api3.InvalidUsageException;
import com.zebra.rfid.api3.OperationFailureException;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class ChainwayReaderSDK {

    private static final String TAG = "ChainwayReaderSDK";

    private MainActivity context = null;

    HashMap<String, String> barcodeEntitiy = new HashMap<String, String>();

    public BarcodeDecoder barcodeDecoder;

    public int MAX_VALUE = 30;

    public MethodChannel.Result mainSupportResultChannel = null;

    public MethodChannel.Result mainMethodChannelResult = null;


    private BarcodeModes barcodeScanStatus = BarcodeModes.IDLE;


    public RFIDWithUHFUART mReader;

    private static EventChannel.EventSink mainEventChannelSink;

    static ArrayList<String> tempTags = new ArrayList<String>();


    public boolean scannerIsReady = false;

    public void onCreate(MainActivity activity) {
        Log.i(TAG, "onCreate: Zebra SDK initializing...");
        context = activity;

    }

    public void start() {

        stop();
        barcodeScanStatus = BarcodeModes.STOPPED;
        barcodeDecoder.startScan();


    }


    public BarcodeModes getCurrentBarcodeMode() {
        return this.barcodeScanStatus;
    }


    public void open() {


        barcodeDecoder.setDecodeCallback(new BarcodeDecoder.DecodeCallback() {
            @Override
            public void onDecodeComplete(BarcodeEntity barcodeEntity) {

                Log.i("Result_Code", String.valueOf(barcodeEntity.getResultCode()));

                if (barcodeEntity.getResultCode() == BarcodeDecoder.DECODE_SUCCESS) {
                    MediaPlayer.create(context, R.raw.barcodebeep).start();

                    Log.i("BARCODE_DATA", barcodeEntity.getBarcodeData());


                    barcodeEntitiy.put("barcodeInfo", barcodeEntity.getBarcodeData());
                    barcodeEntitiy.put("barcodeType", barcodeEntity.getBarcodeName());
                    barcodeEntitiy.put("barcodeErrorCode", String.valueOf(barcodeEntity.getErrCode()));

                    //result.success(new JSONObject(barcodeEntitiy).toString());


                    if (context.currentResult != null) {
                        context.currentResult.success(barcodeEntity.getBarcodeData());
                        context.currentResult = null;
                    } else if (mainMethodChannelResult != null) {
                        mainMethodChannelResult.success(barcodeEntity.getBarcodeData());
                    }


                } else {
                    Log.w("NOT_FOUND", "Not founded!");

                }
                stop();
            }
        });
    }

    private void stop() {
        barcodeScanStatus = BarcodeModes.STOPPED;
        barcodeDecoder.stopScan();
    }

    synchronized public void initializeInventory(EventChannel.EventSink eventSink) {
        mainEventChannelSink = eventSink;
        tempTags.clear();
    }

    public void initUHF(MethodChannel.Result result) {

        try {

            barcodeDecoder = BarcodeFactory.getInstance().getBarcodeDecoder();
            scannerIsReady = barcodeDecoder.open(context);


            if (mReader != null)
            {

                mReader.free();

            }

            mReader = RFIDWithUHFUART.getInstance();
            mReader.init();


            ConnectionStatus connectionStatus = mReader.getConnectStatus();

            if (connectionStatus != ConnectionStatus.DISCONNECTED) {

                result.success(Constants.methodChannelResultConnected);
            } else {
                result.success(Constants.methodChannelResultFailed);
            }

        } catch (Exception ex) {

            Log.e("CHAINWAY_ERROR", ex.toString());

        }
    }


    synchronized public void stopInventory() {
        try {
            if (context.allAttributeMode.rfidModes != RFIDModes.STOPPED_INVENTORY) {
                mReader.stopInventory();
                tempTags.clear();
            }
        } catch (Exception e) {
            Log.e(TAG, "stopInventory:" + e);
        }
    }

    public void setPower(int value) throws OperationFailureException, InvalidUsageException {


        Log.i(TAG, "setPower(VALUE):" + value);


        try {
            mReader.setPower(value);
        } catch (Exception e) {
            Log.e(TAG, "setPower: " + e);
        }
        MAX_VALUE = value;

    }

    public int getPower() throws OperationFailureException, InvalidUsageException {

        Log.i(TAG, "getPower:" + mReader.getPower());

        return mReader.getPower();
    }


    synchronized public void clearTempTags() {
        if (tempTags != null) {
            tempTags.clear();
        }
    }

    public void startInventory() {

        try {
            setPower(MAX_VALUE);
        } catch (Exception e) {
            Log.e(TAG, "startInventory(Set Power):" + e);
        }


        if (context.allAttributeMode.currentReadMode == ReaderModes.INVENTORY_MODE
                && context.currentInventoryEventSink != null) {
            new InventoryThread().start();
        } else {
            Log.e(
                    TAG,
                    "startInventory:" +
                            context.allAttributeMode.currentReadMode.name() +
                            "- or -" +
                            (context.currentInventoryEventSink != null)
            );
        }


    }

    public void initializeChannelsMethodForFlutter(MethodChannel.Result methodChannelResult) {

        mainSupportResultChannel = methodChannelResult;
    }


    public void scanBarcode(MethodChannel.Result result) {

        if (barcodeScanStatus == BarcodeModes.IDLE || barcodeScanStatus == BarcodeModes.STOPPED) {
            mainSupportResultChannel = result;
            start();
            barcodeScanStatus = BarcodeModes.SCANNING;
            open();
        }

    }


    public void writeData(String generatedEpc) {

        try {
            final String[] tid = {"null"};


            Log.i(TAG, "writeData(EPC):" + generatedEpc);
            //Dinlediğimiz tüm tag array listesini sil
            tempTags.clear();

            //Gücü 5'e düşür
            mReader.setPower(5);

            //Inventory başla
            mReader.startInventoryTag();

            ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();
            executor.scheduleAtFixedRate(new Runnable() {
                @Override
                public void run() {
                    UHFTAGInfo uhftagInfo = mReader.readTagFromBuffer();
                    if (uhftagInfo != null) {
                        if (!tempTags.contains(uhftagInfo.getEPC())) {
                            tid[0] = uhftagInfo.getTid();
                            tempTags.add(uhftagInfo.getEPC());
                            Log.i(TAG, "run:" + tempTags.toString());
                        }
                    }
                }
            }, 0, 15, TimeUnit.MILLISECONDS);

            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            //Timer kapat
            executor.shutdown();

            mReader.stopInventory();

            //Yazmak için gücü 30'a çıkarıyoruz
            mReader.setPower(30);

            if (tempTags.size() == 1) {

                Log.i(TAG, "writeData:" + (generatedEpc.length() / 4) * 16);


                boolean isWrote = mReader.writeData(
                        Constants.password,
                        RFIDWithUHFUART.Bank_EPC,
                        32,
                        (tempTags.get(0).length() / 4) * 16,
                        tempTags.get(0),
                        RFIDWithUHFUART.Bank_EPC,
                        1,
                        9,
                        "4000" + generatedEpc);


                Log.i(TAG, "writeData: isWorte:" + isWrote);


                tempTags.clear();


                //Yazılan tag'i bulmak için inventory başlıyoruz

                mReader.startInventoryTag();

                ScheduledExecutorService executor2 = Executors.newSingleThreadScheduledExecutor();
                executor2.scheduleAtFixedRate(new Runnable() {
                    @Override
                    public void run() {
                        UHFTAGInfo uhftagInfo = mReader.readTagFromBuffer();
                        if (uhftagInfo != null) {
                            if (!tempTags.contains(uhftagInfo.getEPC())) {
                                tid[0] = uhftagInfo.getTid();
                                tempTags.add(uhftagInfo.getEPC());
                                Log.i(TAG, "run2:" + tempTags.toString());
                            }

                        }
                    }
                }, 0, 15, TimeUnit.MILLISECONDS);

                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                executor2.shutdown();

                mReader.stopInventory();

                if (isWrote && tempTags.contains(generatedEpc)) {

                    HashMap<String, Object> resultOKObject = new HashMap<String, Object>();

                    resultOKObject.put("tid", tid[0]);
                    resultOKObject.put("status", Constants.methodChannelResultOk);
                    Gson gson = new GsonBuilder().create();
                    String jsonString = gson.toJson(resultOKObject);

                    MediaPlayer.create(context, R.raw.barcodebeep).start();

                    if (mainMethodChannelResult != null) {
                        mainMethodChannelResult.success(jsonString);
                        mainMethodChannelResult = null;
                    } else if (context.currentEventSink != null) {
                        context.currentEventSink.success(jsonString);
                    } else {
                        if (context.currentResult != null) {
                            context.currentResult.success(jsonString);
                            context.currentResult = null;
                        }
                    }
                } else {
                    HashMap<String, Object> resultFailedObject = new HashMap<String, Object>();

                    resultFailedObject.put("tid", "");
                    resultFailedObject.put("status", Constants.methodChannelResultFailed);
                    Gson gson = new GsonBuilder().create();
                    String jsonString = gson.toJson(resultFailedObject);


                    MediaPlayer.create(context, R.raw.serror).start();

                    if (mainMethodChannelResult != null) {
                        mainMethodChannelResult.success(jsonString);
                        mainMethodChannelResult = null;
                    } else if (context.currentEventSink != null) {
                        context.currentEventSink.success(jsonString);
                    } else {
                        if (context.currentResult != null) {
                            context.currentResult.success(jsonString);
                            context.currentResult = null;
                        }
                    }
                }


            } else if (tempTags.size() == 0) {
                HashMap<String, Object> resultNotFoundTagObject = new HashMap<String, Object>();

                resultNotFoundTagObject.put("tid", "");
                resultNotFoundTagObject.put("status", WriteErrors.NOT_FOUND_TAG.name());


                Gson gson = new GsonBuilder().create();
                String jsonString = gson.toJson(resultNotFoundTagObject);
                MediaPlayer.create(context, R.raw.serror).start();
                if (mainMethodChannelResult != null) {
                    mainMethodChannelResult.success(jsonString);
                    mainMethodChannelResult = null;
                } else if (context.currentEventSink != null) {
                    context.currentEventSink.success(jsonString);
                } else {
                    if (context.currentResult != null) {
                        context.currentResult.success(jsonString);
                        context.currentResult = null;
                    }
                }
            } else {
                HashMap<String, Object> resultTooManyTagObject = new HashMap<String, Object>();

                resultTooManyTagObject.put("tid", "");
                resultTooManyTagObject.put("status", WriteErrors.TOO_MANY_TAG.name());
                //Error Code 1: 1'den fazla etiket
                Gson gson = new GsonBuilder().create();
                String jsonString = gson.toJson(resultTooManyTagObject);
                MediaPlayer.create(context, R.raw.serror).start();

                if (mainMethodChannelResult != null) {
                    mainMethodChannelResult.success(jsonString);
                    mainMethodChannelResult = null;
                } else if (context.currentEventSink != null) {
                    context.currentEventSink.success(jsonString);
                } else {
                    if (context.currentResult != null) {
                        context.currentResult.success(jsonString);
                        context.currentResult = null;
                    }
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
            HashMap<String, Object> resultSomethingWentWrongObject = new HashMap<String, Object>();

            resultSomethingWentWrongObject.put("tid", "");
            resultSomethingWentWrongObject.put("status", WriteErrors.SOMETHING_WENT_WRONG.name());


            Toast.makeText(context, "-:RESULT:-", Toast.LENGTH_LONG).show();

            Gson gson = new GsonBuilder().create();
            String jsonString = gson.toJson(resultSomethingWentWrongObject);

            MediaPlayer.create(context, R.raw.serror).start();
            if (mainMethodChannelResult != null) {
                mainMethodChannelResult.success(jsonString);
                mainMethodChannelResult = null;
            } else if (context.currentEventSink != null) {
                context.currentEventSink.success(jsonString);
            } else {
                if (context.currentResult != null) {
                    context.currentResult.success(jsonString);
                    context.currentResult = null;
                }
            }
        } finally {
            if (context.currentEventSink != null) {
                context.currentEventSink.success(TriggerModes.IDLE.name());
            }
        }


    }

    public void singleInventory() {

        if (mReader != null) {
            UHFTAGInfo uhftagInfo = mReader.inventorySingleTag();
            if(uhftagInfo != null){
                String epcValue = uhftagInfo.getEPC();
                Log.i(TAG, "singleInventory:EPC" + epcValue);
                if (context.currentSingleInventoryEventSink != null) {
                    context.currentSingleInventoryEventSink.success(epcValue);
                } else if(context.currentResult != null){
                    context.currentResult.success(epcValue);
                }
            }else{
                if (context.currentSingleInventoryEventSink != null) {
                    context.currentSingleInventoryEventSink.success("failed");
                } else if(context.currentResult != null){
                    context.currentResult.success("failed");
                }
            }
        }
    }

    class InventoryThread extends Thread {

        @RequiresApi(api = Build.VERSION_CODES.N)
        public void run() {
            mReader.startInventoryTag();

            while (context.allAttributeMode.rfidModes == RFIDModes.INVENTORY) {
                UHFTAGInfo uhftagInfo = mReader.readTagFromBuffer();

                if (uhftagInfo != null && !tempTags.contains(uhftagInfo.getEPC())) {
                    Log.i("EPC", uhftagInfo.getEPC());

                    tempTags.add(uhftagInfo.getEPC());

                    context.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {

                            context.currentInventoryEventSink
                                    .success(uhftagInfo.getEPC());

                        }
                    });
                }
            }


        }
    }

    public boolean isReaderConnected() {
        return mReader != null && mReader.getConnectStatus() == ConnectionStatus.CONNECTED;
    }


}
