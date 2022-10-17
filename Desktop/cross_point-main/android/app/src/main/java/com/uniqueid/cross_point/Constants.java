package com.uniqueid.cross_point;

public class Constants {
    static int buttonCode= 294;
    static String init = "init";
    static String stopInventory = "stopInventory";
    static String continueInventory = "continueInventory";
    static String clearInventory = "clearInventory";
    static String playSound = "playSound";
    static String mainChannel = "mainChannel";
    static String eventChannel = "eventChannel";
    static String methodChannelResultOk = "SUCCESS";
    static String methodChannelResultConnected = "CONNECTED";
    static String methodChannelResultFailed = "FAILED";

}
enum InventoryStatus {
    RUNING_INVENTORY,
    STOPING_INVENTORY
}