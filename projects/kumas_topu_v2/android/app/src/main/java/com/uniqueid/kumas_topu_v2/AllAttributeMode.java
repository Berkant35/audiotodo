package com.uniqueid.kumas_topu_v2;


import com.uniqueid.kumas_topu_v2.enums.BarcodeModes;
import com.uniqueid.kumas_topu_v2.enums.RFIDModes;
import com.uniqueid.kumas_topu_v2.enums.ReaderModes;
import com.uniqueid.kumas_topu_v2.enums.ResponseToFlutterMethodMode;
import com.uniqueid.kumas_topu_v2.enums.TriggerModes;

public class AllAttributeMode {
    public ReaderModes currentReadMode;
    public BarcodeModes barcodeModes;
    public RFIDModes rfidModes;
    public ResponseToFlutterMethodMode responseToFlutterMethodMode;
    public TriggerModes currentTriggerMode;

    public AllAttributeMode() {
        this.currentReadMode = ReaderModes.IDLE;
        this.barcodeModes = BarcodeModes.IDLE;
        this.rfidModes = RFIDModes.IDLE;
        this.currentTriggerMode = TriggerModes.IDLE;
        this.responseToFlutterMethodMode = ResponseToFlutterMethodMode.METHOD_RESULT;
    }

    public ReaderModes getCurrentReadMode() {
        return this.currentReadMode;
    }

    public void setCurrentReadMode(ReaderModes currentReadMode) {
        this.currentReadMode = currentReadMode;
    }

    public BarcodeModes getBarcodeModes() {
        return this.barcodeModes;
    }

    public void setBarcodeModes(BarcodeModes barcodeModes) {
        this.barcodeModes = barcodeModes;
    }

    public RFIDModes getRfidModes() {
        return this.rfidModes;
    }

    public void setRfidModes(RFIDModes rfidModes) {
        this.rfidModes = rfidModes;
    }

    public ResponseToFlutterMethodMode getResponseToFlutterMethodMode() {
        return this.responseToFlutterMethodMode;
    }

    public void setResponseToFlutterMethodMode(ResponseToFlutterMethodMode responseToFlutterMethodMode) {
        this.responseToFlutterMethodMode = responseToFlutterMethodMode;
    }
}
