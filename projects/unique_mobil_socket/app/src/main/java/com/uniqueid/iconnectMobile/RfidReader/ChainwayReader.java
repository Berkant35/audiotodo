package com.uniqueid.iconnectMobile.RfidReader;



//import com.google.common.primitives.Bytes;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.interfaces.ConnectionStatus;

import java.io.BufferedInputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.*;

/*
a5 5a 00 0c 20 01 40 fd 53 c3 0d 0a set gen2
a5 5a 00 09 21 01 29 0d 0a result


a5 5a 00 08 22 2a 0d 0a get gen2
a5 5a 00 10 23 01 40 fd 53 00 00 00 00 dc 0d 0a result

0000 0001 0100 0000 1111 1101 0101 0011
0    1    4    0    F    D    5    3




 */

public class ChainwayReader extends RfidReader {


    private boolean isInventoryRunning;
    RFIDWithUHFUART reader;

    Thread inventoryHandler;




    private TagReadListener tagReadListener;

    public ChainwayReader() throws RfidReaderException {

        this.readerType = "Chainway";
        this.features = new RfidReaderFeatures();
        this.features.brand = "Chainway";
        this.settings = new RfidReaderSettings();


        this.isInventoryRunning = false;

        this.tagReadListener = new TagReadListener(this);


    }

    @Override
    public Boolean connect() throws RfidReaderException {


        try {

            reader =  RFIDWithUHFUART.getInstance();
            boolean isInit = reader.init();

            if(isInit){
                if(reader.getConnectStatus() == ConnectionStatus.CONNECTED){
                    this.isConnected = true;
                }
            }






            //this.stop();

            //this.applySettings();


        } catch (Exception e) {
            this.isConnected = false;
            System.out.println("Exception1:" + e.getMessage());
            throw (new RfidReaderException(e.getMessage()));
        }

        this.isConnected = true;


        return true;
    }

    @Override
    public Boolean disconnect() throws RfidReaderException {
        //this.stop();
        reader.free();
        this.isConnected = false;



        return true;
    }

    @Override
    public void populateFeatures() throws RfidReaderException {

        try {

/*
            if (sendCommand(CMD_GET_FW_VERSION, null)) {
                byte[] res = getResponse(CMD_GET_FW_VERSION);
                this.features.firmwareVersion = "" + res[0] + "." + res[1] + "." + res[2];


            } else {
                System.out.println("RRU command failed");
                throw new RfidReaderException("RRU command failed");
            }

            this.features.model = "UR4";

            if (sendCommand(CMD_GET_MODULE_ID, null)) {
                byte[] res = getResponse(CMD_GET_MODULE_ID);
                this.features.serialNumber = String.valueOf(res[0] << 24 | res[1] << 16 | res[2] << 8 | res[3]);

            }

 */


            this.features.antennaCount = 1;
            this.features.gpiCount = 2;
            this.features.gpoCount = 2;
            this.features.gpioCount = 0;
            this.features.readModes = new ArrayList<>();
            this.features.readModes.add("Default");
            this.features.readPowers = new ArrayList<>();
            this.features.writePowers = new ArrayList<>();
            for (Double i = 1.0; i <= 30.0; i = i + 1.0) {
                this.features.readPowers.add(i);
                this.features.writePowers.add(i);
            }

            this.features.rxSensitivities = new ArrayList<>();

            this.features.rxSensitivities.add(0.0);

            this.features.searchModes = new ArrayList<>();

            this.features.searchModes.add("A");
            this.features.searchModes.add("B");


            this.features.sessions = new ArrayList<>();

            this.features.sessions.add(0);
            this.features.sessions.add(1);
            this.features.sessions.add(2);
            this.features.sessions.add(3);

            this.features.regions = new ArrayList<>();

            this.features.regions.add("Europe");
            this.features.regions.add("China2");
            this.features.regions.add("Korea");
            this.features.regions.add("US");
            this.features.regions.add("User");


        } catch (Exception ex) {
            System.out.println(ex.getMessage());
            throw (new RfidReaderException(ex.getMessage()));
        }

    }

    public void startIntervalQuery() {
        TimerTask repeatedTask = new TimerTask() {

            public void run() {
                System.out.println("Task performed on " + new Date());
                tagReadListener.tagRead(null, null, (short) 0, null);
            }
        };
        this.readerTagQueryTimer = new Timer("Timer");

        long delay = this.settings.tagReportInterval;
        long period = this.settings.tagReportInterval;
        this.readerTagQueryTimer.scheduleAtFixedRate(repeatedTask, delay, period);
    }

    public void stopIntervalQuery() {
        this.readerTagQueryTimer.cancel();
    }

    public void inventoryListener(){

        while (true ){
            UHFTAGInfo uhftagInfo = reader.readTagFromBuffer();

            if(uhftagInfo != null)
                tagReadListener.tagRead(uhftagInfo.getPc(), uhftagInfo.getEPC(), (short)1, Double.parseDouble(uhftagInfo.getRssi()));
            else{
                if (!isInventoryRunning) break;
            }
        }
    }



    @Override
    public Boolean start() throws RfidReaderException {


        try {

            reader.startInventoryTag();

            isInventoryRunning = true;

            this.inventoryHandler = new Thread(this::inventoryListener);

            inventoryHandler.start();


            switch (this.settings.tagReportMode){
                case "individual":
                    break;
                case "onstop":
                    break;
                case "interval":
                    startIntervalQuery();
                    break;

            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
            throw (new RfidReaderException(ex.getMessage()));
        }


        this.isActive = true;
        return true;
    }

    @Override
    public Boolean writeData(int antenna, int filterBank, int filterAddress, int filterLen, byte[] filterData,
                             int targetBank, int targetAddress, int targetLen, byte[] targetData) throws RfidReaderException{



        return  false;



    }

    @Override
    public Boolean stop() throws RfidReaderException {
        try {


            reader.stopInventory();

            isInventoryRunning = false;
            this.inventoryHandler.join();
            switch (this.settings.tagReportMode) {
                case "individual":
                    break;
                case "onstop":
                    tagReadListener.tagRead( null, null, (short) 0, null);
                    break;
                case "interval":
                    stopIntervalQuery();
                    tagReadListener.tagRead(null, null, (short) 0, null);
                    break;
            }
            this.isActive = false;
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
            throw (new RfidReaderException(ex.getMessage()));
        }

        return true;
    }



    public void setSessionAndTargetParams(int session, int target)throws RfidReaderException{
return;


    }


    @Override
    public Boolean applySettings() throws RfidReaderException {
/*
        sendCommand(CMD_FACTORY_RESET, null);
        if (!this.isSerial){
            getResponse(CMD_FACTORY_RESET);
        }

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        // settings str is not available for RRU

        // apply individual settings


        if (this.settings.tagReportInterval <= 0) {
            this.settings.tagReportInterval = 1000L;
        }
*/
        // power

        if (null != this.settings.session && null != this.settings.searchMode && Arrays.asList(0, 1, 2, 3).contains(this.settings.session) && Arrays.asList("A", "B", "SingleTarget").contains(this.settings.searchMode)){
            this.setSessionAndTargetParams(Integer.valueOf(this.settings.session), ((this.settings.searchMode.equals("A") || (this.settings.searchMode.equals("SingleTarget"))? 0:1) ));
        }

        if ((null != this.settings.useCommonPowerSettings)  && (this.settings.useCommonPowerSettings) && (this.settings.commonReadPower != null)){
            //this.settings.commonReadPower

            reader.setPower(this.settings.commonReadPower.intValue());

        }





        /*

        if (false){ // check here
            ArrayList<Byte> data = new ArrayList<>();
            data.add((byte) 0x07); //dont save
            data.add((byte) 0x00); //antennas 9-16 is not avail

            if (sendCommand(CMD_SET_BEEP, data)) {
                byte[] res = getResponse(CMD_SET_BEEP);
            }

        }



 */



    /*
        if (this.settings.commonReadPower != null) {
            setPower(this.settings.commonReadPower);
        }

        if (this.settings.inventoryOnTime == null || this.settings.inventoryOnTime < 300 || this.settings.inventoryOnTime > 25500 ) {
            this.settings.inventoryOnTime = 25500;
        }

        if (this.settings.inventoryOffTime == null || this.settings.inventoryOffTime < 50 || this.settings.inventoryOffTime > 300 ) {
            this.settings.inventoryOffTime = 300;
        }

        if (!this.settings.region.isEmpty() ) {
            setRegion(this.settings.region);
        }*/


        /*try {
            setRegion("china2");
            setPower(21);
        } catch (Exception e) {
            throw new RfidReaderException(e.getMessage());
        }*/

        return true;
    }


    @Override
    public Boolean setAntennaPower() throws RfidReaderException {
        return  null;
    }

    @Override
    public ArrayList<BridgeGpioPort> getGpioModes() throws RfidReaderException {
        return null;
    }

    @Override
    public Boolean setGpioModes(ArrayList<BridgeGpioPort> ports) throws RfidReaderException {
        return null;
    }

    @Override
    public ArrayList<BridgeGpioPort> getGpis() throws RfidReaderException {
        return null;
    }

    @Override
    public Boolean setGpos(ArrayList<BridgeGpioPort> gpos) throws RfidReaderException {
        return null;
    }

    private int getChecksum(byte[] buffer){
        int checksum = 0x00;
        for (int j = 2; j < buffer.length; j++ ){
            checksum =  (checksum ^ buffer[j]) & 0xFF;
        }
        return  checksum;
    }
/*
    public class TagReadListener {


        private final RfidReader bridgeReader;
        private HashMap<String, Tag> reportedTags;

        TagReadListener(RfidReader bridgeReader) {
            this.bridgeReader = bridgeReader;
            this.reportedTags = new HashMap<>();
        }

    }
*/








    byte int2byte(int s) {
        return (byte) (s & 0xFF);
    }

    int byte2int(byte b){
        return  (int) (b & 0xFF);
    }

    public static String toHexString(byte[] bytes) {
        char[] hexArray = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
        char[] hexChars = new char[bytes.length * 2];
        int v;
        for ( int j = 0; j < bytes.length; j++ ) {
            v = bytes[j] & 0xFF;
            hexChars[j*2] = hexArray[v/16];
            hexChars[j*2 + 1] = hexArray[v%16];
        }
        return new String(hexChars);
    }


    // TO DO implement                     tagReadListener.tagRead(pc_str, epc_str, antenna, (double) rssi);

    public class TagReadListener {

        private final RfidReader bridgeReader;
        private HashMap<String, Tag> reportedTags;

        TagReadListener(RfidReader bridgeReader) {
            this.bridgeReader = bridgeReader;
            this.reportedTags = new HashMap<>();
        }

        public void tagRead(String pc, String epc, short antenna, Double rssi){

            if (epc != null){
                System.out.println("TAG READ" + epc );
                Tag tag = new Tag();

                if (reportedTags.containsKey(epc+"-"+antenna)){
                    tag.readerId = this.bridgeReader.id;
                    tag.epc = epc;
                    tag.rssi = rssi;
                    tag.antennaPort = antenna;
                    tag.seenCount = ++reportedTags.get(epc+"-"+antenna).seenCount;
                    tag.firstSeenTime = reportedTags.get(epc+"-"+antenna).firstSeenTime;
                    tag.lastSeenTime = System.currentTimeMillis();
                } else {
                    tag.readerId = this.bridgeReader.id;
                    tag.epc = epc;
                    tag.antennaPort = antenna;
                    tag.seenCount = 1;
                    tag.firstSeenTime = System.currentTimeMillis();
                    tag.lastSeenTime = System.currentTimeMillis();
                }

                if(bridgeReader.settings.tagReportMode.equals("individual")){//onstop, interval
                    bridgeReader.onTagReported(new ArrayList<> (Arrays.asList(tag)));
                } else{
                    reportedTags.put(tag.epc+"-"+tag.antennaPort, tag);

                }
            } else {
                System.out.println("TAG REPORT");
                bridgeReader.onTagReported( new ArrayList<> (reportedTags.values()));
                reportedTags.clear();
            }



        }
    }

    private class ReaderResponse{
        byte command;
        byte[] payload;
    }


    public static String convertByteToHexadecimal(byte[] byteArray)
    {
        String hex = "";

        // Iterating through each byte in the array
        for (byte i : byteArray) {
            hex += String.format("%02X ", i);
        }

        return hex;
    }

    public static boolean isValidIPv4(final String str) {
        String PATTERN = "^((0|1\\d?\\d?|2[0-4]?\\d?|25[0-5]?|[3-9]\\d?)\\.){3}(0|1\\d?\\d?|2[0-4]?\\d?|25[0-5]?|[3-9]\\d?)$";

        return str.matches(PATTERN);
    }



}
