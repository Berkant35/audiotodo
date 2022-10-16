package com.uniqueid.cross_point;

import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.interfaces.ConnectionStatus;

import java.util.HashMap;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    /**
     * Reader ile ilgili tüm fonksiyonlara ulaşmamızı sağlayan nesne.
     */
    public RFIDWithUHFUART mReader;

    public EventChannel.EventSink channelFirstSink;

    public HashMap<String, UHFTAGInfo> readedTags;


    public InventoryStatus inventoryStatus = InventoryStatus.STOPING_INVENTORY;



    Gson defaultPowerValues = new GsonBuilder().create();

    Handler handler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        readedTags = new HashMap();

        //handler = new Handler(Looper.getMainLooper());

    }
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),Constants.mainChannel)
                .setMethodCallHandler(
                (call,result) -> {
                    if(Constants.init.equals(call.method)){
                        initUHF(result);
                    }else if(Constants.clearInventory.equals(call.method)){
                        inventoryStatus  = InventoryStatus.STOPING_INVENTORY;
                        readedTags.clear();

                    }
                    else if(Constants.stopInventory.equals(call.method)){
                        inventoryStatus  = InventoryStatus.STOPING_INVENTORY;
                    }else if(Constants.continueInventory.equals(call.method)){
                        inventoryStatus  = InventoryStatus.RUNING_INVENTORY;
                        InventoryThread inventoryThread = new InventoryThread();
                        inventoryThread.start();
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor(), Constants.eventChannel).setStreamHandler(
                new EventChannel.StreamHandler() {

                    @Override
                    public void onListen(Object listening, EventChannel.EventSink eventSink) {
                        channelFirstSink = eventSink;
                    }

                    @Override
                    public void onCancel(Object listening) {
                    }

                }
        );

    }

   class InventoryThread extends  Thread{

        @RequiresApi(api = Build.VERSION_CODES.N)
        public  void run(){
            mReader.startInventoryTag();
            while (inventoryStatus == InventoryStatus.RUNING_INVENTORY){
                UHFTAGInfo uhftagInfo = mReader.readTagFromBuffer();
                if(uhftagInfo != null && !readedTags.containsKey(uhftagInfo.getEPC())){
                    Log.i("EPC",uhftagInfo.getEPC());
                    readedTags.putIfAbsent(uhftagInfo.getTid(),uhftagInfo);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channelFirstSink.success(uhftagInfo.getEPC());
                        }
                    });
                }


            }
            mReader.stopInventory();

        }
   }



    public void initUHF(MethodChannel.Result result) {

        try {

            if (mReader != null) {

                mReader.free();

                mReader = RFIDWithUHFUART.getInstance();

                mReader.init();

            }else{

                mReader = RFIDWithUHFUART.getInstance();

                mReader.init();
            }



            ConnectionStatus connectionStatus = mReader.getConnectStatus();

            if(connectionStatus != ConnectionStatus.DISCONNECTED){
                result.success(Constants.methodChannelResultConnected);
            }else{
                result.success(Constants.methodChannelResultFailed);
            }

        } catch (Exception ex) {

            Log.e("GET_INSTANCE", ex.toString());

        }



    }


    /*
    public void checkUHF(MethodChannel.Result result) {
        try {
            if (mReader.getConnectStatus() == ConnectionStatus.CONNECTED) {

                result.success(ConnectionStatus.CONNECTED.toString());



            } else {
                initUHF();
                result.success(ConnectionStatus.DISCONNECTED.toString());
            }
        } catch (Exception ex) {
            Log.e("EXCEPTION", ex.toString());
        }
    }*/
}
