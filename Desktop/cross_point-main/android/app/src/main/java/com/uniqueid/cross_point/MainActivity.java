package com.uniqueid.cross_point;

import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.KeyEvent;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.interfaces.ConnectionStatus;

import java.util.HashMap;
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

    private SoundPool soundPool;
    private float volumnRatio;
    private AudioManager am;

    public boolean isPressing = false;

    HashMap<Integer, Integer> soundMap = new HashMap<Integer, Integer>();

    public EventChannel.EventSink channelFirstSink;

    public HashMap<String, UHFTAGInfo> readedTags;


    public InventoryStatus inventoryStatus = InventoryStatus.STOPING_INVENTORY;


    Gson defaultPowerValues = new GsonBuilder().create();

    Handler handler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initSound();
        readedTags = new HashMap();

        //handler = new Handler(Looper.getMainLooper());

    }

    @Override
    protected void onDestroy() {
        Log.e("zz_pp", "onDestroy()");
        releaseSoundPool();
        if (mReader != null) {
            mReader.free();
        }
        super.onDestroy();
        android.os.Process.killProcess(android.os.Process.myPid());
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Constants.mainChannel)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (Constants.init.equals(call.method)) {
                                initUHF(result);
                            } else if (Constants.clearInventory.equals(call.method)) {
                                inventoryStatus = InventoryStatus.STOPING_INVENTORY;
                                readedTags.clear();
                            } else if (Constants.playSound.equals(call.method)) {
                                playSound(1);
                            } else if (Constants.stopInventory.equals(call.method)) {
                                inventoryStatus = InventoryStatus.STOPING_INVENTORY;

                            } else if (Constants.continueInventory.equals(call.method)) {
                                inventoryStatus = InventoryStatus.RUNING_INVENTORY;
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

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent ev) {
        Log.i("KEY_CODE_UP", String.valueOf(keyCode));

        if (keyCode == Constants.buttonCode) {
            isPressing = false;
        }

        return super.onKeyUp(keyCode, ev);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent ev) {
        Log.i("KEY_CODE_DOWN", String.valueOf(keyCode));


        if (keyCode == Constants.buttonCode && !isPressing) {
            isPressing = true;
            if (inventoryStatus == InventoryStatus.RUNING_INVENTORY)
            {
                inventoryStatus = InventoryStatus.STOPING_INVENTORY;
                Log.i("KEY_WORK","Stoped!");
                channelFirstSink.success("-1");
            } else {
                inventoryStatus = InventoryStatus.RUNING_INVENTORY;
                Log.i("KEY_WORK","Run!");
                new InventoryThread().start();
            }
        }

        return super.onKeyDown(keyCode, ev);
    }


    private void initSound() {
        soundPool = new SoundPool(10, AudioManager.STREAM_MUSIC, 5);
        soundMap.put(1, soundPool.load(this, R.raw.barcodebeep, 1));
        soundMap.put(2, soundPool.load(this, R.raw.serror, 1));
        am = (AudioManager) this.getSystemService(AUDIO_SERVICE);// 实例化AudioManager对象
    }

    private void releaseSoundPool() {
        if (soundPool != null) {
            soundPool.release();
            soundPool = null;
        }
    }

    public void playSound(int id) {
        float audioMaxVolume = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC); // 返回当前AudioManager对象的最大音量值
        float audioCurrentVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC);// 返回当前AudioManager对象的音量值
        volumnRatio = audioCurrentVolume / audioMaxVolume;
        try {
            soundPool.play(soundMap.get(id), volumnRatio, // 左声道音量
                    volumnRatio, // 右声道音量
                    1, // 优先级，0为最低
                    0, // 循环次数，0不循环，-1永远循环
                    1 // 回放速度 ，该值在0.5-2.0之间，1为正常速度
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    class InventoryThread extends Thread {

        @RequiresApi(api = Build.VERSION_CODES.N)
        public void run() {
            mReader.startInventoryTag();

            while (inventoryStatus == InventoryStatus.RUNING_INVENTORY)
            {
                UHFTAGInfo uhftagInfo = mReader.readTagFromBuffer();
                if (uhftagInfo != null && !readedTags.containsKey(uhftagInfo.getEPC())) {
                    Log.i("EPC", uhftagInfo.getEPC());
                    readedTags.putIfAbsent(uhftagInfo.getEPC(), uhftagInfo);

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

            } else {

                mReader = RFIDWithUHFUART.getInstance();

                mReader.init();
            }


            ConnectionStatus connectionStatus = mReader.getConnectStatus();

            if (connectionStatus != ConnectionStatus.DISCONNECTED) {
                result.success(Constants.methodChannelResultConnected);
            } else {
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
