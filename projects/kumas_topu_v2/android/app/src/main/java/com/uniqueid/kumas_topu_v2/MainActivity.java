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


    MethodChannel.Result currentResult;


    //Flutter
    public static MethodCall currentCall;
    public static MethodCall listenCurrentCall;
    public static EventChannel.EventSink currentEventSink;
    public EventChannel.EventSink currentInventoryEventSink;


    AllAttributeMode allAttributeMode = new AllAttributeMode();


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        WifiManager wm = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        String ip = Formatter.formatIpAddress(wm.getConnectionInfo().getIpAddress());
        Log.i(TAG, "onCreate(IP):" + ip);

        if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
            customBarcodeManager = new CustomBarcodeManager();
            customBarcodeManager.onCreateBarcodeManager(this);

            zebraReaderSDK = new ZebraReaderSDK();
            zebraReaderSDK.onCreate(this);
        } else if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "CHAINWAY")) {
            chainwayReaderSDK = new ChainwayReaderSDK();

        }


        Log.i(TAG, "onCreate: ONCREATE!!!!");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Constants.mainChannel)
                .setMethodCallHandler(
                        (call, result) -> {
                            currentResult = result;

                            switch (call.method) {

                                case Constants.init:

                                    allAttributeMode.barcodeModes = BarcodeModes.IDLE;

                                    if (Objects.equals(Build.BRAND, "ZEBRA"))
                                    {
                                        if (zebraReaderSDK.isReaderConnected())
                                        {
                                            currentResult.success(
                                                    Constants.methodChannelResultConnected);
                                        }
                                         else
                                        {
                                            currentResult.success(
                                                    Constants.methodChannelResultFailed);
                                        }
                                    }
                                    else
                                    {
                                        chainwayReaderSDK.initUHF(currentResult);
                                        currentResult = null;
                                    }

                                    break;

                                case Constants.barcodeModeOn:
                                    allAttributeMode.currentReadMode = ReaderModes.BARCODE_MODE;
                                    if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA"))
                                    {
                                        if (customBarcodeManager.getScannerReady())
                                        {

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
                                    if (Objects.equals(Build.BRAND.toUpperCase(Locale.ROOT), "ZEBRA")) {
                                        zebraReaderSDK.performInventory();
                                    } else {
                                        chainwayReaderSDK.startInventory();
                                    }
                                    allAttributeMode.rfidModes = RFIDModes.INVENTORY;

                                    if (currentInventoryEventSink != null) {
                                        currentInventoryEventSink.success("1");
                                    }


                                    break;
                                case Constants.clearInventory:
                                    Log.i(TAG, "configureFlutterEngine: Start Inventory...");
                                    zebraReaderSDK.clearTempTags();

                                    break;
                                case Constants.stopInventory:
                                    Log.i(TAG, "configureFlutterEngine: Stop Inventory...");
                                    zebraReaderSDK.stopInventory();
                                    allAttributeMode.rfidModes = RFIDModes.STOPPED_INVENTORY;
                                    if (currentInventoryEventSink != null) {
                                        currentInventoryEventSink.success("-1");
                                    }
                                    break;
                                case Constants.playSound:
                                    successSoundPlay();
                                    break;
                                case Constants.getPower:
                                    try {
                                        int power = zebraReaderSDK.getPower();
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
                                        zebraReaderSDK.setPower(powerValue);
                                    } catch (OperationFailureException | InvalidUsageException e) {
                                        e.printStackTrace();
                                    }
                                    result.success(Constants.methodChannelResultOk);
                                    break;

                            }
                        }
                );


        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),
                Constants.mainSupportChannel)
                .setMethodCallHandler(
                        (call, result) -> {

                            zebraReaderSDK.initializeChannelsMethodForFlutter(result);
                            currentCall = call;
                            Log.i(TAG, "configureFlutterEngine: mainSupportChannel");
                            switch (call.method) {
                                case Constants.scanBarcodeButton:
                                    try {

                                        customBarcodeManager.scanBarcode(result);
                                    } catch (ScannerException e) {
                                        e.printStackTrace();
                                    }
                                    break;
                                case Constants.writeEpc:
                                    allAttributeMode.currentReadMode = ReaderModes.WRITE_MODE;

                                    String generatedEpc = call.argument("epc");
                                    Log.i(TAG, "OLUŞTURULACAK OLAN EPC!:" + generatedEpc);
                                    zebraReaderSDK.writeData(generatedEpc);
                                    break;
                                case Constants.barcodeModeOn:
                                    allAttributeMode.currentReadMode = ReaderModes.BARCODE_MODE;
                                    break;

                            }
                        }
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
        new EventChannel(flutterEngine.getDartExecutor(), Constants.inventoryEventChannel).setStreamHandler(
                new EventChannel.StreamHandler() {

                    @Override
                    public void onListen(Object listening, EventChannel.EventSink eventSink) {
                        Log.i(TAG, "onListen: Listening...xxx");
                        currentInventoryEventSink = eventSink;
                        allAttributeMode.currentReadMode = ReaderModes.INVENTORY_MODE;
                        zebraReaderSDK.initializeInventory(currentInventoryEventSink);

                    }

                    @Override
                    public void onCancel(Object listening) {
                        Log.i(TAG, "onCancel: Cancel listen!");
                    }

                }
        );


    }


    public EventChannel.EventSink getCurrentInventoryEventSink() {
        return currentInventoryEventSink;
    }


    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (
                allAttributeMode.currentReadMode == ReaderModes.BARCODE_MODE
                        && keyCode == 102 && allAttributeMode.currentTriggerMode != TriggerModes.PRESSING) {
            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;


        } else if (allAttributeMode.currentReadMode == ReaderModes.WRITE_MODE
                && keyCode == 102 && allAttributeMode.currentTriggerMode != TriggerModes.PRESSING) {
            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;
            if (currentEventSink != null) {
                currentEventSink.success(TriggerModes.PRESSING.name());
            }
            Log.i(TAG, "onKeyUp(WRITE_DATA): WRITING...");

            if (listenCurrentCall != null) {
                String generatedEpc = listenCurrentCall.argument("epc");
                Log.i(TAG, "onKeyUp(WRITE_DATA_GENERATED_EPC):" + generatedEpc);
                zebraReaderSDK.writeData(generatedEpc);
            }
        } else if (allAttributeMode.currentReadMode == ReaderModes.INVENTORY_MODE
                && keyCode == 102 && allAttributeMode.currentTriggerMode != TriggerModes.PRESSING) {

            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;

            Log.i(TAG, "onKeyUpRFIDMODES: " + allAttributeMode.rfidModes.name());

            if (allAttributeMode.rfidModes == RFIDModes.INVENTORY) {
                Log.i(TAG, "onKeyUp: INVENTORY MODE!");

                currentInventoryEventSink.success("-1");

                zebraReaderSDK.stopInventory();
                allAttributeMode.rfidModes = RFIDModes.STOPPED_INVENTORY;

            } else {
                Log.i(TAG, "onKeyUp: NOT INVENTORY MODE!");
                currentInventoryEventSink.success("1");
                zebraReaderSDK.performInventory();
                allAttributeMode.rfidModes = RFIDModes.INVENTORY;
            }
        }
        Log.i(TAG, "onKeyUp: TRIGGERED!!!!!" + allAttributeMode.currentReadMode.name());
        Log.i(TAG, "onKeyUp: TRIGGERED!!!!!" + allAttributeMode.currentTriggerMode.name());
        Log.i(TAG, "onKeyUp: TRIGGERED!!!!!" + keyCode);


        return super.onKeyUp(keyCode, event);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        allAttributeMode.currentTriggerMode = TriggerModes.STOPPED;
        if (allAttributeMode.currentReadMode == ReaderModes.BARCODE_MODE) {
            Log.i(TAG, "onKeyDown(Barcode):" + customBarcodeManager.barcodeTag);
        }
        allAttributeMode.currentTriggerMode = TriggerModes.IDLE;
        return super.onKeyDown(keyCode, event);
    }


    public void successSoundPlay() {
        MediaPlayer.create(this, R.raw.barcodebeep).start();
        currentResult.success("playaed");
    }

}
