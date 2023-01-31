package com.uniqueid.kumas_topu_v2.chainway;

import android.util.Log;

import com.rscja.barcode.BarcodeDecoder;
import com.rscja.barcode.BarcodeFactory;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.interfaces.ConnectionStatus;
import com.uniqueid.kumas_topu_v2.Constants;
import com.uniqueid.kumas_topu_v2.MainActivity;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class ChainwayReaderSDK {

    private static final String TAG = "ChainwayReaderSDK";

    public static MainActivity context;

    HashMap<String, String> barcodeEntitiy = new HashMap<String, String>();

    private BarcodeDecoder barcodeDecoder;

    public RFIDWithUHFUART mReader;

    private static EventChannel.EventSink mainEventChannelSink;

    static ArrayList<String> tempTags = new ArrayList<String>();


    public boolean scannerIsReady = false;

    public void onCreate(MainActivity activity) {
        Log.i(TAG, "onCreate: Zebra SDK initializing...");
        context = activity;

    }


    synchronized public void initializeInventory(EventChannel.EventSink eventSink) {
        mainEventChannelSink = eventSink;
        tempTags.clear();
    }

    public void initUHF(MethodChannel.Result result) {

        try {
            barcodeDecoder = BarcodeFactory.getInstance().getBarcodeDecoder();
            scannerIsReady = barcodeDecoder.open(context);


            if (mReader != null) {

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


    public void startInventory()
    {

    }


    public boolean isReaderConnected() {
        return mReader != null && mReader.getConnectStatus() == ConnectionStatus.CONNECTED;
    }


}
