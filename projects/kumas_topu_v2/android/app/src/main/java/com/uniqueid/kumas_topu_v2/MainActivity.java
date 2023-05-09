package com.uniqueid.kumas_topu_v2;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.text.format.Formatter;
import android.util.Log;
import android.view.KeyEvent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


import com.symbol.emdk.barcode.ScannerException;
import com.uniqueid.kumas_topu_v2.chainway.ChainwayReaderSDK;
import com.uniqueid.kumas_topu_v2.enums.BarcodeModes;
import com.uniqueid.kumas_topu_v2.enums.RFIDModes;
import com.uniqueid.kumas_topu_v2.enums.ReaderModes;

import com.uniqueid.kumas_topu_v2.enums.TriggerModes;
import com.zebra.rfid.api3.InvalidUsageException;
import com.zebra.rfid.api3.OperationFailureException;

import java.util.Locale;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "MainActivity";


    //Zebra
    ZebraReaderSDK zebraReaderSDK = null;
    CustomBarcodeManager customBarcodeManager = null;

    //Chainway
    ChainwayReaderSDK chainwayReaderSDK = null;

    //CurrentResult
    public MethodChannel.Result currentResult;


    //Flutter
    public static MethodCall currentCall;
    public static MethodCall listenCurrentCall;
    public static EventChannel.EventSink currentEventSink;
    public EventChannel.EventSink currentInventoryEventSink;
    public EventChannel.EventSink currentSingleInventoryEventSink;

    //All attribute
    public AllAttributeMode allAttributeMode = new AllAttributeMode();


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initializeDynamicReader();
    }


    /**
     * Uygulama başladığı zaman zebraysa zebra initiliaze chanway ise cahinway
     * initialize edildiği bölümdür.
     */
    private void initializeDynamicReader() {

        if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
            customBarcodeManager = new CustomBarcodeManager();
            customBarcodeManager.onCreateBarcodeManager(this);

            zebraReaderSDK = new ZebraReaderSDK();
            zebraReaderSDK.onCreate(this);
        } else if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "CHAINWAY")) {
            chainwayReaderSDK = new ChainwayReaderSDK();
            chainwayReaderSDK.onCreate(this);

        }

        Log.i(TAG, "initializeDynamicReader: initializing...");
    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Constants.mainChannel)
                .setMethodCallHandler(
                        this::FlutterActions
                );


        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),
                Constants.mainSupportChannel)
                .setMethodCallHandler(
                        this::supportFlutterActions
                );


        //Write listen channel
        new EventChannel(flutterEngine.getDartExecutor(), Constants.eventChannel).setStreamHandler(
                new EventChannel.StreamHandler() {

                    @Override
                    public void onListen(Object listening, EventChannel.EventSink eventSink) {
                        currentEventSink = eventSink;
                        allAttributeMode.currentReadMode = ReaderModes.WRITE_MODE;
                        Log.i(TAG, "onListen: TRIGGERED!");
                    }

                    @Override
                    public void onCancel(Object listening) {
                    }

                }
        );


        new EventChannel(flutterEngine.getDartExecutor(), Constants.singleInventoryEventChannel).setStreamHandler(
                new EventChannel.StreamHandler() {

                    @Override
                    public void onListen(Object listening, EventChannel.EventSink eventSink)
                    {
                        currentSingleInventoryEventSink = eventSink;
                        allAttributeMode.currentReadMode = ReaderModes.SINGLE_MODE;

                    }

                    @Override
                    public void onCancel(Object listening) {}

                }
        );


        new EventChannel(flutterEngine.getDartExecutor(), Constants.inventoryEventChannel).setStreamHandler(
                new EventChannel.StreamHandler() {

                    @Override
                    public void onListen(Object listening, EventChannel.EventSink eventSink) {
                        Log.i(TAG, "onListen: Listening...xxx");
                        currentInventoryEventSink = eventSink;
                        allAttributeMode.currentReadMode = ReaderModes.INVENTORY_MODE;
                        if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                            zebraReaderSDK.initializeInventory(currentInventoryEventSink);
                        } else {
                            chainwayReaderSDK.initializeInventory(currentInventoryEventSink);
                        }

                    }

                    @Override
                    public void onCancel(Object listening) {
                        Log.i(TAG, "onCancel: Cancel listen!");
                    }

                }
        );


    }

    /**
     *
     */

    private void supportFlutterActions(MethodCall call, MethodChannel.Result result) {
        if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
            zebraReaderSDK.initializeChannelsMethodForFlutter(result);
        } else {
            chainwayReaderSDK.initializeChannelsMethodForFlutter(result);
        }
        currentCall = call;
        switch (call.method) {
            case Constants.scanBarcodeButton:
                try {
                    if (Objects.equals(Build.BRAND, "ZEBRA")) {
                        customBarcodeManager.scanBarcode(result);
                    } else {
                        if (chainwayReaderSDK.barcodeDecoder != null &&
                                chainwayReaderSDK.getCurrentBarcodeMode() != BarcodeModes.SCANNING)
                        {
                            chainwayReaderSDK.scanBarcode(currentResult);
                        }
                    }
                } catch (ScannerException e) {
                    e.printStackTrace();
                }
                break;
            case Constants.writeEpc:
                allAttributeMode.currentReadMode = ReaderModes.WRITE_MODE;
                String generatedEpc = call.argument("epc");
                Log.i(TAG, "OLUŞTURULACAK OLAN EPC!:" + generatedEpc);


                if (Objects.equals(Build.BRAND, "ZEBRA")) {
                    zebraReaderSDK.writeData(generatedEpc);
                } else {
                    chainwayReaderSDK.writeData(generatedEpc);
                }


                break;
            case Constants.barcodeModeOn:
                allAttributeMode.currentReadMode = ReaderModes.BARCODE_MODE;
                break;

        }
    }

    private void FlutterActions(MethodCall call, MethodChannel.Result result) {
        currentResult = result;

        switch (call.method) {

            case Constants.init:
                allAttributeMode.barcodeModes = BarcodeModes.IDLE;
                if (Objects.equals(Build.BRAND, "ZEBRA")) {
                    if (zebraReaderSDK.isReaderConnected()) {
                        currentResult.success(
                                Constants.methodChannelResultConnected);
                    } else {
                        currentResult.success(
                                Constants.methodChannelResultFailed);
                    }
                } else {
                    chainwayReaderSDK.initUHF(currentResult);

                }
                break;
            case Constants.barcodeModeOn:
                allAttributeMode.currentReadMode = ReaderModes.BARCODE_MODE;
                if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                    if (customBarcodeManager.getScannerReady()) {
                        Log.i(TAG, "configureFlutterEngine: READY!");
                        currentResult.success(
                                Constants.methodChannelResultConnected);
                    } else {
                        Log.e(TAG, "configureFlutterEngine: FAILED");
                        currentResult.success(
                                Constants.methodChannelResultFailed);
                    }
                    currentResult = null;
                } else {


                    if (chainwayReaderSDK.scannerIsReady) {
                        currentResult.success(
                                Constants.methodChannelResultConnected);
                    } else {
                        currentResult.success(
                                Constants.methodChannelResultFailed);
                    }
                }
                break;
            case Constants.scanBarcode:
                allAttributeMode.currentReadMode = ReaderModes.BARCODE_MODE;
                Log.i(TAG, "configureFlutterEngine: waiting... barcode!!");
                break;
            case Constants.writeEpc:
                allAttributeMode.currentReadMode = ReaderModes.WRITE_MODE;
                listenCurrentCall = call;
                currentResult.success(
                        Constants.methodChannelResultOk);
                currentResult = null;
                break;
            case Constants.initializeInventory:
                if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                    zebraReaderSDK.initializeInventory(currentInventoryEventSink);
                } else {
                    chainwayReaderSDK.initializeInventory(currentInventoryEventSink);
                }
                break;
            case Constants.startInventory:
                Log.i(TAG, "configureFlutterEngine: Start Inventory...");
                Log.i(TAG, "FlutterActions:"+allAttributeMode.rfidModes.name());
                allAttributeMode.rfidModes = RFIDModes.INVENTORY;
                if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                    zebraReaderSDK.performInventory();
                } else {
                    chainwayReaderSDK.startInventory();
                }
                if (currentInventoryEventSink != null) {
                    currentInventoryEventSink.success("1");
                }
                break;
            case Constants.clearInventory:
                Log.i(TAG, "configureFlutterEngine: clearInventory...");
                if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                    zebraReaderSDK.clearTempTags();
                } else {
                    chainwayReaderSDK.clearTempTags();
                }

                break;
            case Constants.stopInventory:
                Log.i(TAG, "configureFlutterEngine: Stop Inventory...");
                if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                    zebraReaderSDK.stopInventory();
                } else {
                    chainwayReaderSDK.stopInventory();
                }

                allAttributeMode.rfidModes = RFIDModes.STOPPED_INVENTORY;
                if (currentInventoryEventSink != null) {
                    currentInventoryEventSink.success("-1");
                }
                break;
            case Constants.singleInventory:


                if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                    //zebraReaderSDK.singleInventory();
                } else {
                    chainwayReaderSDK.singleInventory();
                }



                break;
            case Constants.playSound:
                successSoundPlay();
                break;
            case Constants.getPower:
                try {
                    int power = 0;
                    if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                        power = zebraReaderSDK.getPower();
                    } else {
                        power = chainwayReaderSDK.getPower();
                    }


                    result.success(String.valueOf(power));
                } catch (OperationFailureException | InvalidUsageException e) {
                    e.printStackTrace();
                }

                break;
            case Constants.setPower:
                String value = call.argument("powerValue");
                assert value != null;
                int powerValue = Integer.parseInt(value);
                try {
                    if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                        zebraReaderSDK.setPower(powerValue);
                    } else {
                        chainwayReaderSDK.setPower(powerValue);
                    }

                } catch (OperationFailureException | InvalidUsageException e) {
                    e.printStackTrace();
                }
                result.success(Constants.methodChannelResultOk);
                break;

        }
    }


    public EventChannel.EventSink getCurrentInventoryEventSink() {
        return currentInventoryEventSink;
    }


    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (
                allAttributeMode.currentReadMode == ReaderModes.BARCODE_MODE
                        && (keyCode == 102 || (keyCode > 290 && keyCode < 300)) &&
                        allAttributeMode.currentTriggerMode != TriggerModes.PRESSING) {

            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;

            if (!Build.BRAND.toUpperCase(Locale.ROOT).equals("ZEBRA")) {

                if (chainwayReaderSDK.barcodeDecoder != null && chainwayReaderSDK.getCurrentBarcodeMode() != BarcodeModes.SCANNING) {
                    chainwayReaderSDK.scanBarcode(currentResult);
                } else {
                    Log.e(TAG, "onKeyUp: NULL");
                }
            }

        } else if (allAttributeMode.currentReadMode == ReaderModes.WRITE_MODE
                && (keyCode == 102 || (keyCode > 290 && keyCode < 300)) && allAttributeMode.currentTriggerMode != TriggerModes.PRESSING) {
            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;
            if (currentEventSink != null) {
                currentEventSink.success(TriggerModes.PRESSING.name());
            }
            Log.i(TAG, "onKeyUp(WRITE_DATA): WRITING...");

            if (listenCurrentCall != null) {
                String generatedEpc = listenCurrentCall.argument("epc");
                Log.i(TAG, "onKeyUp(WRITE_DATA_GENERATED_EPC):" + generatedEpc);
                if(Build.BRAND.toUpperCase(Locale.ROOT).equals("ZEBRA")){
                    zebraReaderSDK.writeData(generatedEpc);
                }else {
                    chainwayReaderSDK.writeData(generatedEpc);
                }
            }
        }else if(allAttributeMode.currentReadMode == ReaderModes.SINGLE_MODE
                && (keyCode == 102 || (keyCode > 290 && keyCode < 300)) &&
                allAttributeMode.currentTriggerMode != TriggerModes.PRESSING){

            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;
            if (Build.BRAND.toUpperCase(Locale.ROOT).equals("ZEBRA"))
            {
                //zebraReaderSDK.stopInventory();
            } else {
                chainwayReaderSDK.singleInventory();
            }
        }


        else if (allAttributeMode.currentReadMode == ReaderModes.INVENTORY_MODE
                && (keyCode == 102 || (keyCode > 290 && keyCode < 300)) &&
                allAttributeMode.currentTriggerMode != TriggerModes.PRESSING) {

            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;

            Log.i(TAG, "onKeyUpRFIDMODES: " + allAttributeMode.rfidModes.name());

            if (allAttributeMode.rfidModes == RFIDModes.INVENTORY) {
                Log.i(TAG, "onKeyUp: INVENTORY MODE!");

                currentInventoryEventSink.success("-1");

                if (Build.BRAND.toUpperCase(Locale.ROOT).equals("ZEBRA")) {
                    zebraReaderSDK.stopInventory();
                } else {
                    chainwayReaderSDK.stopInventory();
                }

                allAttributeMode.rfidModes = RFIDModes.STOPPED_INVENTORY;

            }
            else {
                Log.i(TAG, "onKeyUp: NOT INVENTORY MODE!");
                currentInventoryEventSink.success("1");
                if (Build.BRAND.toUpperCase(Locale.ROOT).equals("ZEBRA")) {
                    zebraReaderSDK.performInventory();
                } else {
                    chainwayReaderSDK.startInventory();
                }

                allAttributeMode.rfidModes = RFIDModes.INVENTORY;
            }
        }

        Log.i(TAG, "onKeyUp: TRIGGERED!" + allAttributeMode.currentReadMode.name());
        Log.i(TAG, "onKeyUp: TRIGGERED!" + allAttributeMode.currentTriggerMode.name());
        Log.i(TAG, "onKeyUp: TRIGGERED!" + keyCode);


        return super.onKeyUp(keyCode, event);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        allAttributeMode.currentTriggerMode = TriggerModes.STOPPED;
        if (allAttributeMode.currentReadMode == ReaderModes.BARCODE_MODE) {
            Log.i(TAG, "onKeyDown(Barcode):" + allAttributeMode.currentTriggerMode);
        }

        allAttributeMode.currentTriggerMode = TriggerModes.IDLE;
        return super.onKeyDown(keyCode, event);
    }


    public void successSoundPlay() {
        MediaPlayer.create(this, R.raw.barcodebeep).start();
        currentResult.success("playaed");
    }

}
