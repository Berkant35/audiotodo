package com.uniqueid.kumas_topu_v2;

import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


import com.symbol.emdk.barcode.ScannerException;
import com.uniqueid.kumas_topu_v2.enums.BarcodeModes;
import com.uniqueid.kumas_topu_v2.enums.RFIDModes;
import com.uniqueid.kumas_topu_v2.enums.ReaderModes;

import com.uniqueid.kumas_topu_v2.enums.TriggerModes;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "MainActivity";

    ZebraReaderSDK zebraReaderSDK = null;
    CustomBarcodeManager customBarcodeManager = null;
    MethodChannel.Result currentResult;

    MethodCall currentCall;
    MethodCall listenCurrentCall;
    EventChannel.EventSink currentEventSink;
    EventChannel.EventSink currentInventoryEventSink;
    AllAttributeMode allAttributeMode = new AllAttributeMode();

    //Reader Fonksiyonları

    //Flutter tarafından gelen komutlara göre handle etme süreçleri...


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        customBarcodeManager = new CustomBarcodeManager();
        customBarcodeManager.onCreateBarcodeManager(this);

        zebraReaderSDK = new ZebraReaderSDK();
        zebraReaderSDK.onCreate(this);
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

                                    if (zebraReaderSDK.isReaderConnected()) {
                                        currentResult.success(
                                                Constants.methodChannelResultConnected);
                                    } else {
                                        currentResult.success(
                                                Constants.methodChannelResultFailed);
                                    }
                                    currentResult = null;
                                    break;
                                case Constants.barcodeModeOn:
                                    allAttributeMode.currentReadMode = ReaderModes.BARCODE_MODE;

                                    if (customBarcodeManager.getScannerReady())
                                    {
                                        Log.i(TAG, "configureFlutterEngine: READY!");
                                        currentResult.success(
                                                Constants.methodChannelResultConnected);
                                    }
                                      else
                                    {
                                        Log.e(TAG, "configureFlutterEngine: FAILED");
                                        currentResult.success(
                                                Constants.methodChannelResultFailed);
                                    }
                                    currentResult = null;
                                    break;
                                case Constants.scanBarcode:
                                    allAttributeMode.currentReadMode = ReaderModes.BARCODE_MODE;
                                    Log.i(TAG, "configureFlutterEngine: waiting... barcode!!");
                                    break;
                                case Constants.writeEpc:
                                    allAttributeMode.currentReadMode = ReaderModes.WRITE_MODE;
                                    listenCurrentCall  = call;
                                    currentResult.success(
                                            Constants.methodChannelResultOk);
                                    currentResult = null;
                                    break;
                                case Constants.initializeInventory:
                                    zebraReaderSDK.initializeInventory(currentInventoryEventSink);
                                    break;
                                case Constants.startInventory:
                                    zebraReaderSDK.performInventory();
                                    break;
                                case Constants.stopInventory:
                                    zebraReaderSDK.stopInventory();
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
                                    Log.i(TAG, "OLUŞTURULACAK OLAN EPC!:"+generatedEpc);
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
                        allAttributeMode.currentReadMode = ReaderModes.INVENTORY_MODE;
                        currentInventoryEventSink = eventSink;
                        zebraReaderSDK.initializeInventory(currentInventoryEventSink);
                    }

                    @Override
                    public void onCancel(Object listening) {
                    }

                }
        );


    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (
                allAttributeMode.currentReadMode == ReaderModes.BARCODE_MODE
                        && keyCode == 102 && allAttributeMode.currentTriggerMode != TriggerModes.PRESSING) {
            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;


        }else if(allAttributeMode.currentReadMode == ReaderModes.WRITE_MODE
                && keyCode == 102 && allAttributeMode.currentTriggerMode != TriggerModes.PRESSING)
        {
            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;
            if(currentEventSink != null)
            {
                currentEventSink.success(TriggerModes.PRESSING.name());
            }
            Log.i(TAG, "onKeyUp(WRITE_DATA): WRITING...");

            if(  listenCurrentCall != null )
            {
                String generatedEpc = listenCurrentCall.argument("epc");
                Log.i(TAG, "onKeyUp(WRITE_DATA_GENERATED_EPC):"+generatedEpc);
                zebraReaderSDK.writeData(generatedEpc);
            }
        }else if(allAttributeMode.currentReadMode == ReaderModes.INVENTORY_MODE
                && keyCode == 102 && allAttributeMode.currentTriggerMode != TriggerModes.PRESSING){


            allAttributeMode.currentTriggerMode = TriggerModes.PRESSING;
            if(allAttributeMode.rfidModes == RFIDModes.INVENTORY){
                currentInventoryEventSink.success("-1");
                zebraReaderSDK.stopInventory();
            }else{
                currentInventoryEventSink.success("1");
                zebraReaderSDK.performInventory();
            }
        }
        Log.i(TAG, "onKeyUp: TRIGGERED!!!!!"+allAttributeMode.currentReadMode.name());
        Log.i(TAG, "onKeyUp: TRIGGERED!!!!!"+allAttributeMode.currentTriggerMode.name());
        Log.i(TAG, "onKeyUp: TRIGGERED!!!!!"+keyCode);


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


}
