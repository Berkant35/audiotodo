package com.uniqueid.kumas_topu_v2;


import android.content.Context;
import android.util.Log;

import com.symbol.emdk.EMDKManager;
import com.symbol.emdk.EMDKResults;
import com.symbol.emdk.EMDKManager.EMDKListener;
import com.symbol.emdk.EMDKManager.FEATURE_TYPE;
import com.symbol.emdk.EMDKResults.STATUS_CODE;
import com.symbol.emdk.barcode.BarcodeManager;
import com.symbol.emdk.barcode.ScanDataCollection;
import com.symbol.emdk.barcode.Scanner;
import com.symbol.emdk.barcode.ScannerConfig;
import com.symbol.emdk.barcode.ScannerException;
import com.symbol.emdk.barcode.ScannerInfo;
import com.symbol.emdk.barcode.ScannerResults;
import com.symbol.emdk.barcode.StatusData;
import com.symbol.emdk.barcode.BarcodeManager.ConnectionState;
import com.symbol.emdk.barcode.BarcodeManager.DeviceIdentifier;
import com.symbol.emdk.barcode.BarcodeManager.ScannerConnectionListener;
import com.symbol.emdk.barcode.ScanDataCollection.ScanData;
import com.symbol.emdk.barcode.Scanner.DataListener;
import com.symbol.emdk.barcode.Scanner.StatusListener;
import com.symbol.emdk.barcode.Scanner.TriggerType;
import com.symbol.emdk.barcode.StatusData.ScannerStates;

import java.util.ArrayList;
import java.util.Iterator;

import io.flutter.plugin.common.MethodChannel;

public class CustomBarcodeManager implements EMDKListener, StatusListener, DataListener, ScannerConnectionListener {
    private static final String TAG = "CustomBarcodeManager";
    public String currentStatus;
    public String barcodeTag;
    public MethodChannel.Result mainSupportResultChannel = null;
    private BarcodeManager barcodeManager = null;
    private Scanner scanner = null;
    private MainActivity mainActivity = null;
    private EMDKManager emdkManager = null;
    private int scannerIndex = 0;
    private int defaultIndex = 0;
    private int dataLength = 0;
    private String statusString = "";
    private boolean bSoftTriggerSelected = false;
    private boolean bDecoderSettingsChanged = false;
    private boolean bExtScannerDisconnected = false;
    private boolean scannerIsReady = false;
    private final Object lock = new Object();


    public void onCreateBarcodeManager(MainActivity context) {
        try {
            mainActivity = context;
            EMDKResults results = EMDKManager.getEMDKManager(context.getApplicationContext(), this);
            Log.i("CustomBarcodeManager", "STATUS_CODE" + results.statusCode.name());
            if (results.statusCode != STATUS_CODE.SUCCESS) {
                this.updateStatus("EMDKManager object request failed!");
                Log.i("CustomBarcodeManager", "currentStatus: " + this.currentStatus);
                Log.e("CustomBarcodeManager", "currentStatusError: " + results.statusCode.name());
            } else {
                this.updateStatus("EMDKManager object initialization is   in   progress.......");
                Log.i("CustomBarcodeManager", "currentStatus: " + this.currentStatus);
            }
        } catch (Exception var3) {
            Log.e("CustomBarcodeManager", "onCreateBarcodeManager: " + var3);
        }

    }

    private void initBarcodeManager() {
        this.barcodeManager = (BarcodeManager) this.emdkManager.getInstance(FEATURE_TYPE.BARCODE);
        if (this.barcodeManager == null) {
            this.updateStatus("ERROR");
            Log.e("CustomBarcodeManager", "initBarcodeManager: NULL");
        } else {
            this.initScanner();
        }

    }


    public boolean getScannerReady() {
        return scannerIsReady;
    }

    private void initScanner() {
        if (this.scanner == null) {
            this.scanner = this.barcodeManager.getDevice(DeviceIdentifier.DEFAULT);
            if (this.scanner != null) {
                Log.i("CustomBarcodeManager", "initScanner: SCANNER NOT NULL!!!!!!");
                scannerIsReady = true;
                this.scanner.addDataListener(this);
                this.scanner.addStatusListener(this);
                this.scanner.triggerType = TriggerType.HARD;

                try {
                    this.scanner.enable();
                } catch (ScannerException var2) {
                    this.updateStatus(var2.getMessage());
                    Log.e("CustomBarcodeManager", "ScannerException: " + var2);
                    this.deInitScanner();
                }
            } else {
                this.updateStatus("Failed to   initialize the scanner device.");
                Log.e("CustomBarcodeManager", "initScanner:" + this.currentStatus);
            }
        }

    }

    private void updateStatus(String status) {
        this.currentStatus = status;
    }

    public void onOpened(EMDKManager emdkManager) {
        Log.i("CustomBarcodeManager", "onOpenedEMDKManager: " + emdkManager.toString());
        this.emdkManager = emdkManager;
        this.initBarcodeManager();
    }

    public void onClosed() {
    }

    private void deInitScanner() {
        if (this.scanner != null) {
            try {
                this.scanner.disable();
            } catch (Exception var4) {
                this.updateStatus(var4.getMessage());
            }

            try {
                this.scanner.removeDataListener(this);
                this.scanner.removeStatusListener(this);
            } catch (Exception var3) {
                this.updateStatus(var3.getMessage());
            }

            try {
                this.scanner.release();
            } catch (Exception var2) {
                this.updateStatus(var2.getMessage());
            }

            this.scanner = null;
        }

    }

    public void onConnectionChange(ScannerInfo scannerInfo, ConnectionState connectionState) {
    }

    public void onData(ScanDataCollection scanDataCollection) {
        if (scanDataCollection != null && scanDataCollection.getResult() == ScannerResults.SUCCESS) {
            ArrayList<ScanData> scanData = scanDataCollection.getScanData();
            Iterator var3 = scanData.iterator();

            while (var3.hasNext()) {
                ScanData data = (ScanData) var3.next();

                barcodeTag = data.getData();

                if (mainActivity.currentResult != null) {
                    mainActivity.currentResult.success(barcodeTag);
                    mainActivity.currentResult = null;
                } else if (mainSupportResultChannel != null) {
                    mainSupportResultChannel.success(barcodeTag);
                }




                Log.i("CustomBarcodeManager", "onData: " + data.getData());
            }
        }

    }

    public void onStatus(StatusData statusData) {
        ScannerStates state = statusData.getState();
        switch (state) {
            case IDLE:
                this.statusString = statusData.getFriendlyName() + " is enabled and idle...";
                this.updateStatus(this.statusString);
                if (this.bSoftTriggerSelected) {
                    this.scanner.triggerType = TriggerType.SOFT_ONCE;
                    this.bSoftTriggerSelected = false;
                } else {
                    this.scanner.triggerType = TriggerType.HARD;
                }

                if (this.bDecoderSettingsChanged) {
                    this.setDecoders();
                    this.bDecoderSettingsChanged = false;
                }

                if (!this.scanner.isReadPending() && !this.bExtScannerDisconnected) {
                    try {
                        this.scanner.read();
                    } catch (ScannerException var4) {
                        this.updateStatus(var4.getMessage());
                    }
                }
                break;
            case WAITING:
                this.statusString = "Scanner is waiting for trigger press...";
                this.updateStatus(this.statusString);
                break;
            case SCANNING:
                this.statusString = "Scanning...";
                this.updateStatus(this.statusString);
                break;
            case DISABLED:
                this.statusString = statusData.getFriendlyName() + " is disabled.";
                this.updateStatus(this.statusString);
                break;
            case ERROR:
                this.statusString = "An error has occurred.";
                this.updateStatus(this.statusString);
        }


    }

    private void setDecoders() {
        if (this.scanner != null) {
            try {
                ScannerConfig config = this.scanner.getConfig();
                this.scanner.setConfig(config);
            } catch (ScannerException var2) {
                this.updateStatus(var2.getMessage());
            }
        }

    }

    public void initializeMainSupportResultChannel(MethodChannel.Result result){
        mainSupportResultChannel = result;
    }

    public void scanBarcode(MethodChannel.Result result) throws ScannerException {
        mainSupportResultChannel = result;
        if (this.scanner.isEnabled()) {
            Log.i("SCAN", "DO SCAN");
            this.scanner.cancelRead();
            this.scanner.triggerType = TriggerType.SOFT_ONCE;
            Log.i(TAG, "scanBarcode:" + statusString);
            scanner.read();
        } else {
            Log.e("CustomBarcodeManager", "scanBarcode: Reader not enabled!");
        }

    }

    private void cancelRead() {
        if (this.scanner != null && this.scanner.isReadPending()) {
            try {
                this.scanner.cancelRead();
            } catch (ScannerException var2) {
                this.updateStatus(var2.getMessage());
            }
        }

    }
}
